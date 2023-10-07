import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'main.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
  }

  void _showProductDetail(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // To adjust bottom sheet size
            children: [
              Text(
                product.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Price: \$${product.price}'),
              Text('Rating: ${product.rating}'),
              Text('Type: ${product.productType}'),
              SizedBox(height: 8),
              if (product.productColors.isNotEmpty)
                Wrap(
                  spacing: 8,
                  children: product.productColors
                      .map((color) => CircleAvatar(
                            backgroundColor: Color(int.parse(color.hexValue)),
                          ))
                      .toList(),
                ),
              SizedBox(height: 8),
              CachedNetworkImage(
                imageUrl: product.imageLink,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Product product = snapshot.data![index];
                return ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: product.imageLink,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  title: Text(product.name),
                  subtitle: Text('\$${product.price}'),
                  onTap: () => _showProductDetail(context, product),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
