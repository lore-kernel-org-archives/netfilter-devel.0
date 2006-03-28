From: "Daniel De Graaf" <danieldegraaf@gmail.com>
Subject: fix compile error in IPv6 versions of nth and random modules
Date: Tue, 28 Mar 2006 11:22:52 -0600
Message-ID: <427c54c0603280922x38225874wa300ab9f07fd8ddb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_9245_9635856.1143566572866"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

------=_Part_9245_9635856.1143566572866
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Content-Disposition: inline

V2hlbiBjb21waWxlZCBmb3IgSVB2NiwgdGhlIG50aCBhbmQgcmFuZG9tIG1vZHVsZXMgcHJvZHVj
ZSBjb21waWxlCmVycm9ycyBiZWNhdXNlIG9mIGEgY2hhbmdlIGluIHRoZSBpcDZ0X21hdGNoIHN0
cnVjdHVyZS4gVGhlc2UgcGF0Y2hlcwpmaXggdGhhdCBlcnJvciBhbmQgYSByZWxhdGVkIHdhcm5p
bmcgYWJvdXQgaW5jb21wYXRpYmxlIHR5cGVzLiBTaW5jZQp0aGUgcGF0Y2hlcyBhcmUgbmVhcmx5
IGlkZW50aWNhbCwgSSBhbSBwb3N0aW5nIHRoZW0gdG9nZXRoZXI7IHNvcnJ5IGlmCnRoaXMgaXMg
YSBwcm9ibGVtLgoKLSBEYW5pZWwgRGUgR3JhYWYK
------=_Part_9245_9635856.1143566572866
Content-Type: application/octet-stream; name=diff
Content-Transfer-Encoding: 7bit
X-Attachment-Id: f_elchtr7v
Content-Disposition: attachment; filename="diff"

Index: patchlets/nth/linux-2.6.10/net/ipv6/netfilter/ip6t_nth.c
===================================================================
--- patchlets/nth/linux-2.6.10/net/ipv6/netfilter/ip6t_nth.c	(revision 6560)
+++ patchlets/nth/linux-2.6.10/net/ipv6/netfilter/ip6t_nth.c	(working copy)
@@ -114,7 +114,7 @@
 
 static int
 ip6t_nth_checkentry(const char *tablename,
-		   const struct ip6t_ip6 *e,
+		   const void *ip,
 		   void *matchinfo,
 		   unsigned int matchsize,
 		   unsigned int hook_mask)
@@ -139,13 +139,12 @@
 	return 1;
 }
 
-static struct ip6t_match ip6t_nth_reg = { 
-	{NULL, NULL},
-	"nth",
-	ip6t_nth_match,
-	ip6t_nth_checkentry,
-	NULL,
-	THIS_MODULE };
+static struct ip6t_match ip6t_nth_reg = {
+	.name       = "nth",
+	.match      = &ip6t_nth_match,
+	.checkentry = &ip6t_nth_checkentry,
+	.me	    = THIS_MODULE,
+};
 
 static int __init init(void)
 {
Index: patchlets/random/linux-2.6/net/ipv6/netfilter/ip6t_random.c
===================================================================
--- patchlets/random/linux-2.6/net/ipv6/netfilter/ip6t_random.c	(revision 6560)
+++ patchlets/random/linux-2.6/net/ipv6/netfilter/ip6t_random.c	(working copy)
@@ -44,7 +44,7 @@
 
 static int
 ip6t_rand_checkentry(const char *tablename,
-		   const struct ip6t_ip6 *e,
+		   const void *ip,
 		   void *matchinfo,
 		   unsigned int matchsize,
 		   unsigned int hook_mask)
@@ -69,13 +69,12 @@
 	return 1;
 }
 
-static struct ip6t_match ip6t_rand_reg = { 
-	{NULL, NULL},
-	"random",
-	ip6t_rand_match,
-	ip6t_rand_checkentry,
-	NULL,
-	THIS_MODULE };
+static struct ip6t_match ip6t_rand_reg = {
+	.name       = "random",
+	.match      = &ip6t_rand_match,
+	.checkentry = &ip6t_rand_checkentry,
+	.me         = THIS_MODULE,
+};
 
 static int __init init(void)
 {


------=_Part_9245_9635856.1143566572866--
