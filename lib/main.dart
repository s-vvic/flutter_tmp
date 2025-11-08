import 'package:flutter/material.dart';

// 앱 실행
void main() {
  runApp(TradePlatformApp());
}

// 1. 거래 아이템을 위한 데이터 모델
class TradeItem {
  final String id;
  final String name;
  final String symbol; // Ticker (e.g., G-COIN)
  final double price;
  final double changePercent; // 24시간 변동률

  TradeItem({
    required this.id,
    required this.name,
    required this.symbol,
    required this.price,
    required this.changePercent,
  });
}

// 2. 전체 앱의 진입점 (Entry Point)
class TradePlatformApp extends StatelessWidget {
  const TradePlatformApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'G-Trade Platform',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark, // 다크 모드
        primaryColor: Colors.blueGrey[900],
        scaffoldBackgroundColor: Colors.grey[900],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey[800],
          elevation: 0,
        ),
        cardColor: Colors.blueGrey[800],
      ),
      home: HomePage(), // 시작 페이지
    );
  }
}

// 3. 메인 홈 페이지 (거래 아이템 목록)
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // --- 가상 데이터 (Mock Data) ---
  // 실제 앱에서는 이 부분이 API 호출로 대체됩니다.
  final List<TradeItem> tradeItems = [
    TradeItem(
      id: 'g-coin',
      name: 'Gemini Coin',
      symbol: 'G-COIN',
      price: 120.50,
      changePercent: 2.5,
    ),
    TradeItem(
      id: 'f-stock',
      name: 'Flutter Stock',
      symbol: 'FLT',
      price: 88.20,
      changePercent: -1.2,
    ),
    TradeItem(
      id: 'd-bond',
      name: 'Dart Bond',
      symbol: 'DRT',
      price: 105.00,
      changePercent: 0.8,
    ),
    TradeItem(
      id: 'w-token',
      name: 'Web Token',
      symbol: 'WEB',
      price: 15.75,
      changePercent: 10.3,
    ),
  ];
  // ---------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🚀 G-Trade Platform (Web)'),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          // 웹에서 화면이 너무 커지는 것을 방지
          constraints: BoxConstraints(maxWidth: 800),
          child: ListView.builder(
            itemCount: tradeItems.length,
            itemBuilder: (context, index) {
              final item = tradeItems[index];
              return TradeItemTile(item: item); // 각 아이템을 타일로 표시
            },
          ),
        ),
      ),
    );
  }
}

// 4. 목록의 각 아이템을 표시하는 위젯 (ListTile)
class TradeItemTile extends StatelessWidget {
  final TradeItem item;

  const TradeItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // 변동률에 따라 색상 변경
    final isPositive = item.changePercent >= 0;
    final color = isPositive ? Colors.greenAccent[400] : Colors.redAccent[400];
    final icon = isPositive ? Icons.trending_up : Icons.trending_down;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(item.name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(item.symbol),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${item.price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              '${isPositive ? '+' : ''}${item.changePercent.toStringAsFixed(1)}%',
              style: TextStyle(color: color, fontSize: 14),
            ),
          ],
        ),
        onTap: () {
          // 상세 페이지로 이동
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailPage(item: item)),
          );
        },
      ),
    );
  }
}

// 5. 상세 페이지 (매수/매도 버튼)
class DetailPage extends StatelessWidget {
  final TradeItem item;

  const DetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isPositive = item.changePercent >= 0;
    final color = isPositive ? Colors.greenAccent[400] : Colors.redAccent[400];

    return Scaffold(
      appBar: AppBar(title: Text(item.name)),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 가격 정보
                Text(
                  item.symbol,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${isPositive ? '+' : ''}${item.changePercent.toStringAsFixed(1)}% (24h)',
                  style: TextStyle(
                    color: color,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                Spacer(), // 공간 확보
                // 가상 차트 영역
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Price Chart (Placeholder)',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                ),

                Spacer(), // 공간 확보
                // 매수/매도 버튼
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          // 매수 버튼 클릭 시 로직 (스낵바 표시)
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${item.name} 매수 주문이 접수되었습니다.'),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Text('Buy', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          // 매도 버튼 클릭 시 로직 (스낵바 표시)
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${item.name} 매도 주문이 접수되었습니다.'),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Text('Sell', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
