// OOP 4원칙을 적용한 언더테일 샌즈전 게임
import 'dart:io';

// 1. 추상화: 게임 엔티티의 기본 추상 클래스
abstract class GameEntity {
  late String _name;
  late int _hp;
  late int _maxHp;
  late int _attack;
  late int _defense;

  String get name => _name;
  int get hp => _hp;
  int get maxHp => _maxHp;
  int get attack => _attack;
  int get defense => _defense;

  bool get isAlive => _hp > 0;

  // 추상 메서드: 각 엔티티가 구현해야 함
  void takeDamage(int damage);
  void act();
  void displayStats();
}

// 2. 상속 & 캡슐화: 플레이어 클래스
class Player extends GameEntity {
  late int _exp;
  late int _level;

  int get exp => _exp;
  int get level => _level;

  Player({
    required String name,
    required int hp,
    required int attack,
    required int defense,
  }) {
    _name = name;
    _hp = hp;
    _maxHp = hp;
    _attack = attack;
    _defense = defense;
    _exp = 0;
    _level = 1;
  }

  @override
  void takeDamage(int damage) {
    int finalDamage = (damage - _defense).clamp(0, damage);
    _hp = (_hp - finalDamage).clamp(0, _maxHp);
    print('$_name이(가) $finalDamage의 데미지를 입었습니다!');
    print('남은 HP: $_hp/$_maxHp');
  }

  void performAttack(GameEntity target) {
    int baseDamage = _attack + (DateTime.now().millisecond % 10);
    print('\n[$_name]이(가) 공격을 시작합니다!');
    target.takeDamage(baseDamage);
  }

  void heal(int amount) {
    int oldHp = _hp;
    _hp = (_hp + amount).clamp(0, _maxHp);
    int healed = _hp - oldHp;
    print('\n[$_name]이(가) $healed의 HP를 회복했습니다!');
  }

  void gainExp(int expAmount) {
    _exp += expAmount;
    print('\n[$_name]이(가) $expAmount의 경험치를 획득했습니다!');
  }

  @override
  void act() {
    print('플레이어의 차례입니다.');
  }

  @override
  void displayStats() {
    print('\n═══ $_name 상태 ═══');
    print('Level: $_level');
    print('HP: $_hp/$_maxHp');
    print('공격력: $_attack');
    print('방어력: $_defense');
    print('경험치: $_exp');
  }
}

// 3. 다형성: 에너미 기본 클래스
abstract class Enemy extends GameEntity {
  late int _attackPattern;

  int get attackPattern => _attackPattern;

  Enemy({
    required String name,
    required int hp,
    required int attack,
    required int defense,
    required int attackPattern,
  }) {
    _name = name;
    _hp = hp;
    _maxHp = hp;
    _attack = attack;
    _defense = defense;
    _attackPattern = attackPattern;
  }

  @override
  void takeDamage(int damage) {
    int finalDamage = (damage - _defense).clamp(1, damage);
    _hp = (_hp - finalDamage).clamp(0, _maxHp);
    print('$_name이(가) $finalDamage의 데미지를 입었습니다!');
    print('남은 HP: $_hp/$_maxHp');
  }

  int executeAttackPattern();
}

// 4. 다형성: 샌즈 클래스 (Enemy 상속)
class Sans extends Enemy {
  late int _phase;
  late int _turnCount;

  int get phase => _phase;
  int get turnCount => _turnCount;

  Sans({int phase = 1})
    : super(
        name: '샌즈',
        hp: phase == 1 ? 200 : 300,
        attack: phase == 1 ? 25 : 40,
        defense: phase == 1 ? 15 : 25,
        attackPattern: 0,
      ) {
    _phase = phase;
    _turnCount = 0;
  }

  @override
  int executeAttackPattern() {
    _turnCount++;
    print('\n[샌즈]이(가) 턴을 시작합니다...');

    int damage = 0;

    switch (_attackPattern) {
      case 0: // 뼈 공격
        damage = _attack + 10;
        print('샌즈가 파란 뼈를 날린다!');
        break;
      case 1: // 무리한 뼈 공격
        damage = _attack + 20;
        print('샌즈가 검은 뼈를 무수히 날린다!');
        break;
      case 2: // 텔레포트 후 공격
        damage = _attack + 15;
        print('샌즈가 텔레포트하며 공격한다!');
        break;
      case 3: // 최종 공격
        damage = _attack + 30;
        print('샌즈의 눈이 푸르게 빛난다... 무엇인가 끔찍한 일이 일어날 것 같다!');
        break;
      default:
        damage = _attack;
    }

    // 페이즈에 따른 공격 패턴 변화
    if (_phase == 2 && _turnCount > 5) {
      damage = (damage * 1.3).toInt(); // 페이즈 2에서 더 강한 공격
      print('(페이즈 2: 공격력 증가!)');
    }

    return damage;
  }

  void changeAttackPattern(int newPattern) {
    _attackPattern = newPattern;
  }

  void changePhase(int newPhase) {
    _phase = newPhase;
    print('\n!!!샌즈의 형태가 변한다!!!');
    print('샌즈: "우스개 같지 않나? 한번 더 해보려고 하지?"');
  }

  @override
  void act() {
    print('샌즈의 차례입니다...');
    _attackPattern = (_turnCount % 4);
  }

  @override
  void displayStats() {
    print('\n═══ $_name 상태 ═══');
    print('Phase: $_phase');
    print('HP: $_hp/$_maxHp');
    print('공격력: $_attack');
    print('방어력: $_defense');
    print('턴 수: $_turnCount');
  }
}

// 게임 매니저: 게임 흐름 관리 (캡슐화)
class GameManager {
  late Player _player;
  late Sans _boss;
  late int _turnCount;
  late bool _gameOver;
  late bool _playerWon;

  int get turnCount => _turnCount;
  bool get gameOver => _gameOver;
  bool get playerWon => _playerWon;

  GameManager({required Player player, required Sans boss}) {
    _player = player;
    _boss = boss;
    _turnCount = 0;
    _gameOver = false;
    _playerWon = false;
  }

  void displayBattleStatus() {
    print('\n╔════════════════════════════════════╗');
    print('║        언더테일 - 샌즈전 진행중     ║');
    print('╚════════════════════════════════════╝');
    _player.displayStats();
    print('');
    _boss.displayStats();
  }

  void playerTurn() {
    print('\n▶ [플레이어 턴]');
    print('1: 공격');
    print('2: 회복');
    print('선택 (1 또는 2): ');

    String? input = stdin.readLineSync();

    if (input == '1') {
      _player.performAttack(_boss);
    } else if (input == '2') {
      _player.heal(30);
    } else {
      print('잘못된 입력입니다. 공격을 수행합니다.');
      _player.performAttack(_boss);
    }

    if (!_boss.isAlive) {
      _playerWon = true;
      _gameOver = true;
    }
  }

  void bossTurn() {
    print('\n▶ [샌즈 턴]');

    // 보스의 체력이 일정 이하가 되면 페이즈 변경
    if (_boss.hp < _boss.maxHp ~/ 2 && _boss.phase == 1) {
      _boss.changePhase(2);
      _boss._hp = _boss._maxHp;
    }

    _boss.act();
    int damage = _boss.executeAttackPattern();
    _player.takeDamage(damage);

    if (!_player.isAlive) {
      _gameOver = true;
      _playerWon = false;
    }
  }

  void startBattle() {
    print('\n╔════════════════════════════════════╗');
    print('║      언더테일 - 최종 보스전 시작!   ║');
    print('╚════════════════════════════════════╝\n');

    print('${_player.name}: "...드디어 왔군"');
    print('샌즈: "우스갤 시간이다."');
    print('...전투가 시작된다!');

    while (!_gameOver) {
      _turnCount++;
      displayBattleStatus();

      playerTurn();
      if (_gameOver) break;

      bossTurn();
      if (_gameOver) break;
    }

    endBattle();
  }

  void endBattle() {
    print('\n╔════════════════════════════════════╗');
    if (_playerWon) {
      print('║          전투 승리!              ║');
      print('╚════════════════════════════════════╝');
      print('\n${_player.name}: "...결국 이겨버렸군."');
      print('샌즈: "...후... 잘했어."');
      _player.gainExp(1000);
    } else {
      print('║          전투 패배!              ║');
      print('╚════════════════════════════════════╝');
      print('\n${_player.name}: "...더는 안 되겠다..."');
      print('화면이 검어진다...');
    }

    _player.displayStats();
  }
}

void main() {
  // 플레이어 생성
  Player frisk = Player(name: '프리스크', hp: 100, attack: 20, defense: 10);

  // 샌즈 보스 생성 (페이즈 1)
  Sans sans = Sans(phase: 1);

  // 게임 매니저 생성 및 전투 시작
  GameManager game = GameManager(player: frisk, boss: sans);
  game.startBattle();
}
