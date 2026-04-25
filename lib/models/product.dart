class Product {
  final String id;
  final String name;
  final double price;   // in LKR
  final String image;
  final String category;
  final String description;
  final bool isNew;     // shows "New" badge on card

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.category,
    required this.description,
    this.isNew = false,
  });
}


// Categories: Saree, Batik, Casual, Kids, Sale
final List<Product> sampleProducts = [
  Product(
    id: '1',
    name: 'Handloom Saree',
    price: 4500,
    image: 'assets/image/Handloom_saree.jpg',
    category: 'Saree',
    description:
        'Beautiful handloom saree from Kandy. Traditional design with golden border. Perfect for Avurudu, weddings, and special occasions.',
    isNew: true,
  ),
  Product(
    id: '2',
    name: 'Silk Kandyan Saree',
    price: 8900,
    image: 'assets/image/silky_kandyan_saree.jpg',
    category: 'Saree',
    description:
        'Premium silk saree in the classic Kandyan style. Worn at traditional Sinhala ceremonies and Perahera events.',
  ),
  Product(
    id: '3',
    name: 'Batik Long Frock',
    price: 2800,
    image: 'https://picsum.photos/seed/batik3/400/300',
    category: 'Batik',
    description:
        'Comfortable batik long frock with traditional Sri Lankan patterns. Ideal for everyday wear and casual outings.',
    isNew: true,
  ),
  Product(
    id: '4',
    name: 'Batik Shirt — Amara',
    price: 1950,
    image: 'https://picsum.photos/seed/batik4/400/300',
    category: 'Batik',
    description:
        'Lightweight batik shirt for men. Named after Amara, popular across Colombo markets. Great for office and casual wear.',
  ),
  Product(
    id: '5',
    name: 'Casual Kurti — Dilani',
    price: 1600,
    image: 'https://picsum.photos/seed/kurti5/400/300',
    category: 'Casual',
    description:
        'Everyday cotton kurti in a modern Sri Lankan cut. Designed for comfort during warm Colombo afternoons.',
  ),
  Product(
    id: '6',
    name: 'Linen Trousers — Ruwan',
    price: 2200,
    image: 'https://picsum.photos/seed/trouser6/400/300',
    category: 'Casual',
    description:
        'Breathable linen trousers for the Sri Lankan climate. Suitable for office and outdoor use in Galle or Kandy.',
  ),
  Product(
    id: '7',
    name: 'Kids Osariya Set',
    price: 1200,
    image: 'https://picsum.photos/seed/kids7/400/300',
    category: 'Kids',
    description:
        'Cute traditional Osariya (half saree) set for young girls. Popular for school cultural events and Avurudu celebrations.',
    isNew: true,
  ),
  Product(
    id: '8',
    name: 'Boys National Dress',
    price: 1400,
    image: 'https://picsum.photos/seed/kids8/400/300',
    category: 'Kids',
    description:
        'Traditional white national dress set for boys. Includes shirt and cloth. Perfect for Independence Day and Vesak events.',
  ),
  Product(
    id: '9',
    name: 'Cotton Sarong — Nuwan',
    price: 850,
    image: 'https://picsum.photos/seed/sarong9/400/300',
    category: 'Sale',
    description:
        'Classic cotton sarong. Was LKR 1,500. Comfortable daily wear for Sri Lankan men, especially in coastal areas.',
  ),
  Product(
    id: '10',
    name: 'Printed Blouse — Sewwandi',
    price: 750,
    image: 'https://picsum.photos/seed/blouse10/400/300',
    category: 'Sale',
    description:
        'Bright printed blouse in a Sri Lankan tropical pattern. Was LKR 1,400. Limited stock!',
  ),
];
