From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 1/6]: Fix stack leakage in ip6tables
Date: Tue, 11 Jan 2005 13:49:49 +0100
Message-ID: <41E3CB6D.3000701@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060505070205080809060206"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------060505070205080809060206
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit



--------------060505070205080809060206
Content-Type: text/x-patch;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/01/11 03:41:31+01:00 kaber@coreworks.de 
#   [NETFILTER]: Fix stack leakage in ip6tables
#   
#   ip6tables version of Rusty's iptables fix.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6_tables.c
#   2005/01/11 03:41:24+01:00 kaber@coreworks.de +1 -1
#   [NETFILTER]: Fix stack leakage in ip6tables
#   
#   ip6tables version of Rusty's iptables fix.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
--- a/net/ipv6/netfilter/ip6_tables.c	2005-01-11 13:39:37 +01:00
+++ b/net/ipv6/netfilter/ip6_tables.c	2005-01-11 13:39:37 +01:00
@@ -1373,7 +1373,7 @@
 			       sizeof(info.underflow));
 			info.num_entries = t->private->number;
 			info.size = t->private->size;
-			strcpy(info.name, name);
+			memcpy(info.name, name, sizeof(info.name));
 
 			if (copy_to_user(user, &info, *len) != 0)
 				ret = -EFAULT;

--------------060505070205080809060206--
