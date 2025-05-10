<h1>ShopTrend - E-commerce Flutter App</h1>

<p>ShopTrend is a modern, user-friendly e-commerce mobile application built with Flutter. It provides a seamless shopping experience with a beautiful front page, product browsing, cart management, and user profile features. The app uses a clean, professional UI inspired by popular e-commerce platforms, with prices displayed in Indian Rupees (₹) and robust error handling for API data.</p>

<hr/>

<h2>🚀 Features</h2>

<h3>🏠 Modern Home Screen</h3>
<ul>
  <li>Hero banner carousel with promotional images.</li>
  <li>Category chips for filtering products.</li>
  <li>Three curated sections: Recent Products, Latest One, and New Arrivals.</li>
  <li>Horizontal scrollable product lists with hero animations.</li>
</ul>

<h3>🛍️ Product Detail Screen</h3>
<ul>
  <li>Detailed product view with image, title, price (₹), and description.</li>
  <li>Add-to-cart and buy-now (Razorpay integration) functionality.</li>
  <li>Smooth image transitions using Hero widgets.</li>
</ul>

<h3>🛒 Cart Screen</h3>
<ul>
  <li>Dynamic cart with quantity controls and item removal.</li>
  <li>Price calculations including subtotal, tax (8%), and shipping (₹499.17).</li>
  <li>Checkout button to clear the cart and confirm orders.</li>
</ul>

<h3>👤 Profile Screen</h3>
<ul>
  <li>User information display (name, email).</li>
  <li>Options for settings, order history, and logout.</li>
</ul>

<h3>🧠 State Management</h3>
<p>Uses Provider for cart state management across screens. Persistent cart data with real-time updates.</p>

<h3>💰 Currency</h3>
<p>Prices converted from USD to INR (1 USD = 83 INR). Consistent use of ₹ symbol for all price displays.</p>

<h3>🧭 Navigation</h3>
<p>Bottom navigation bar for easy access to Home, Cart, and Profile screens. Back navigation for Product Detail and Cart screens.</p>

<h3>🛠️ Error Handling</h3>
<p>Robust handling for API data (e.g., price type mismatches, null values). Image placeholders and user-friendly error messages for API failures.</p>

<hr/>

<h2>🖼️ Screenshots</h2>

<ul>
  <li><strong>Home Screen</strong><br/>home_screen.png</li>
  <li><strong>Product Detail Screen</strong><br/>product_detail_screen.png</li>
  <li><strong>Cart Screen</strong><br/>cart_screen.png</li>
  <li><strong>Profile Screen</strong><br/>profile_screen.png</li>
</ul>

<hr/>

<h2>⚙️ Setup Instructions</h2>

<h3>✅ Prerequisites</h3>
<ul>
  <li>Flutter SDK (version 3.0.0 or later)</li>
  <li>Dart (included with Flutter)</li>
  <li>IDE (e.g., VS Code, Android Studio)</li>
  <li>Emulator or physical device for testing</li>
</ul>

<h3>📥 Installation</h3>

<ol>
  <li><strong>Clone the Repository</strong>
    <pre><code>git clone &lt;repository-url&gt;
cd shoptrend</code></pre>
  </li>

  <li><strong>Install Dependencies</strong>
    <pre><code>flutter pub get</code></pre>
  </li>

  <li><strong>Configure API Service</strong><br/>
    Update <code>lib/services/api_service.dart</code> with your API endpoint.
  </li>

  <li><strong>Configure Razorpay</strong><br/>
    Update <code>lib/services/razorpay_service.dart</code> with your Razorpay API key and configuration.
  </li>

  <li><strong>Run the App</strong>
    <pre><code>flutter run</code></pre>
  </li>
</ol>

<hr/>

<h2>📁 Project Structure</h2>

<pre><code>
shoptrend/
├── lib/
│   ├── services/
│   │   ├── api_service.dart         
│   │   ├── razorpay_service.dart    
│   ├── cart_provider.dart           
│   ├── main.dart                    
│   ├── home_screen.dart             
│   ├── product_detail_screen.dart   
│   ├── cart_screen.dart             
│   ├── profile_screen.dart          
├── pubspec.yaml                     
├── README.md                        
├── home_screen.png
├── product_detail_screen.png
├── cart_screen.png
├── profile_screen.png
</code></pre>

<hr/>

<h2>🎨 Customization</h2>

<h3>🎯 Hero Banner</h3>
<pre><code>
final banners = [
  {'image': 'https://your-api.com/banners/sale.jpg', 'text': 'Mega Sale!'},
];
</code></pre>

<h3>🧩 Categories</h3>
<p>Update the categories list in <code>home_screen.dart</code> and implement category filtering logic.</p>

<h3>🔄 Product Sorting</h3>
<pre><code>
final recentProducts = allProducts.where((p) => /* your logic */).take(10).toList();
</code></pre>

<h3>🎨 Styling</h3>
<p>Modify colors and card dimensions in <code>main.dart</code> or individual widgets.</p>

<h3>🔗 API Integration</h3>
<p>Make sure <code>api_service.dart</code> handles your API's JSON format and fallback logic for null values.</p>

<hr/>

<h2>🧪 Troubleshooting</h2>

<h3>❌ FormatException</h3>
<pre><code>
print('Price type: ${product['price'].runtimeType}, value: ${product['price']}');
</code></pre>

<h3>❌ API Errors</h3>
<ul>
  <li>Ensure valid response with fields: <code>id</code>, <code>title</code>, <code>image</code>, <code>price</code></li>
  <li>Provide fallbacks using null-aware operators</li>
</ul>

<h3>🖼️ Screenshots</h3>
<p>Capture from emulator/device, save in root, and reference in README.</p>

<h3>💳 Razorpay Issues</h3>
<p>Validate API key and test in INR.</p>

<hr/>

<h2>📌 Notes</h2>

<ul>
  <li>If API provides INR prices directly, remove USD to INR conversion.</li>
  <li>The "Latest One" section picks the first product; change logic as needed.</li>
  <li>Screenshots are placeholders — replace with actual images.</li>
</ul>

<hr/>

<h2>📄 License</h2>
<p>This project is licensed under the <strong>MIT License</strong>.<br/>
See the <code>LICENSE</code> file for more details.</p>
