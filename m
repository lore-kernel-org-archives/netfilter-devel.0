From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.4 18/18]: Fix stack leakage in iptables/ip6_tables
Date: Mon, 20 Dec 2004 08:15:46 +0100
Message-ID: <41C67C22.10501@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000903090508030505010201"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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

This is a multi-part message in MIME format.
--------------000903090508030505010201
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Fix stack leakage in iptables/ip6_tables.


--------------000903090508030505010201
Content-Type: text/x-patch;
 name="18.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="18.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/12/05 23:49:26+01:00 kaber@coreworks.de 
#   [NETFILTER]: Fix stack leakage in iptables/ip6_tables
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6_tables.c
#   2004/12/05 23:49:24+01:00 kaber@coreworks.de +1 -1
#   [NETFILTER]: Fix stack leakage in iptables/ip6_tables
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_tables.c
#   2004/12/05 23:49:24+01:00 kaber@coreworks.de +1 -1
#   [NETFILTER]: Fix stack leakage in iptables/ip6_tables
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
--- a/net/ipv4/netfilter/ip_tables.c	2004-12-20 07:02:08 +01:00
+++ b/net/ipv4/netfilter/ip_tables.c	2004-12-20 07:02:08 +01:00
@@ -1274,7 +1274,7 @@
 			       sizeof(info.underflow));
 			info.num_entries = t->private->number;
 			info.size = t->private->size;
-			strcpy(info.name, name);
+			memcpy(info.name, name, sizeof(info.name));
 
 			if (copy_to_user(user, &info, *len) != 0)
 				ret = -EFAULT;
diff -Nru a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
--- a/net/ipv6/netfilter/ip6_tables.c	2004-12-20 07:02:08 +01:00
+++ b/net/ipv6/netfilter/ip6_tables.c	2004-12-20 07:02:08 +01:00
@@ -1343,7 +1343,7 @@
 			       sizeof(info.underflow));
 			info.num_entries = t->private->number;
 			info.size = t->private->size;
-			strcpy(info.name, name);
+			memcpy(info.name, name, sizeof(info.name));
 
 			if (copy_to_user(user, &info, *len) != 0)
 				ret = -EFAULT;

--------------000903090508030505010201--
