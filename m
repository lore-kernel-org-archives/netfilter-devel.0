From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 1/8]: pptp helper: propagate errors instead of using -EIO
 in init functions
Date: Fri, 16 Sep 2005 00:44:36 +0200
Message-ID: <4329F954.2090309@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Content-Disposition: inline;
 filename="01.diff"
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

[NETFILTER]: pptp helper: propagate errors instead of using -EIO in init functions

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit b806b1f4d971bfb3bd348a7d8d9029b6b5c9c23b
tree 66c4408681361eeefe21d43ccf27ec65a307753e
parent fb3d5fc64859ad4ebe99cff3c318f53cdf72b0e8
author Patrick McHardy <kaber@trash.net> Thu, 15 Sep 2005 22:26:07 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 15 Sep 2005 22:26:07 +0200

 net/ipv4/netfilter/ip_conntrack_helper_pptp.c |    2 +-
 net/ipv4/netfilter/ip_conntrack_proto_gre.c   |   10 +---------
 net/ipv4/netfilter/ip_nat_proto_gre.c         |    5 +----
 3 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
--- a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
@@ -777,7 +777,7 @@ static int __init init(void)
 		printk(KERN_ERR "Unable to register conntrack application "
 				"helper for pptp: %d\n", retcode);
 		ip_ct_proto_gre_fini();
-		return -EIO;
+		return retcode;
 	}
 
 	printk("ip_conntrack_pptp version %s loaded\n", IP_CT_PPTP_VERSION);
diff --git a/net/ipv4/netfilter/ip_conntrack_proto_gre.c b/net/ipv4/netfilter/ip_conntrack_proto_gre.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_gre.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_gre.c
@@ -323,15 +323,7 @@ static struct ip_conntrack_protocol gre 
 /* ip_conntrack_proto_gre initialization */
 int __init ip_ct_proto_gre_init(void)
 {
-	int retcode;
-
-	if ((retcode = ip_conntrack_protocol_register(&gre))) {
-		printk(KERN_ERR "Unable to register conntrack protocol "
-		       "helper for gre: %d\n", retcode);
-		return -EIO;
-	}
-
-	return 0;
+	return ip_conntrack_protocol_register(&gre);
 }
 
 void __exit ip_ct_proto_gre_fini(void)
diff --git a/net/ipv4/netfilter/ip_nat_proto_gre.c b/net/ipv4/netfilter/ip_nat_proto_gre.c
--- a/net/ipv4/netfilter/ip_nat_proto_gre.c
+++ b/net/ipv4/netfilter/ip_nat_proto_gre.c
@@ -204,10 +204,7 @@ static struct ip_nat_protocol gre = { 
 				  
 int __init ip_nat_proto_gre_init(void)
 {
-	if (ip_nat_protocol_register(&gre))
-		return -EIO;
-
-	return 0;
+	return ip_nat_protocol_register(&gre);
 }
 
 void __exit ip_nat_proto_gre_fini(void)
