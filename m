From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 2/6]: make ipt_helper depend on ip_conntrack again
Date: Sun, 26 Sep 2004 23:52:08 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <41573A08.7040105@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090609070602010908040503"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------090609070602010908040503
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

The "kill struct nf_ct_info" patch moved ip_conntrack_get
to ip_conntrack.h. Before this change ipt_helper depended
on ip_conntrack, this patch restores this behaviour. It
also removes the EXPORT_SYMBOL for ip_conntrack_get.



--------------090609070602010908040503
Content-Type: text/x-patch;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/09/26 23:14:34+02:00 kaber@coreworks.de 
#   [NETFILTER]: make ipt_helper depend on ipt_conntrack again
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ipt_helper.c
#   2004/09/26 23:14:10+02:00 kaber@coreworks.de +1 -0
#   [NETFILTER]: make ipt_helper depend on ipt_conntrack again
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_standalone.c
#   2004/09/26 23:14:10+02:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: make ipt_helper depend on ipt_conntrack again
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-09-26 23:22:27 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-09-26 23:22:27 +02:00
@@ -871,7 +871,6 @@
 EXPORT_SYMBOL(invert_tuplepr);
 EXPORT_SYMBOL(ip_conntrack_alter_reply);
 EXPORT_SYMBOL(ip_conntrack_destroyed);
-EXPORT_SYMBOL(ip_conntrack_get);
 EXPORT_SYMBOL(need_ip_conntrack);
 EXPORT_SYMBOL(ip_conntrack_helper_register);
 EXPORT_SYMBOL(ip_conntrack_helper_unregister);
diff -Nru a/net/ipv4/netfilter/ipt_helper.c b/net/ipv4/netfilter/ipt_helper.c
--- a/net/ipv4/netfilter/ipt_helper.c	2004-09-26 23:22:27 +02:00
+++ b/net/ipv4/netfilter/ipt_helper.c	2004-09-26 23:22:27 +02:00
@@ -107,6 +107,7 @@
 
 static int __init init(void)
 {
+	need_ip_conntrack();
 	return ipt_register_match(&helper_match);
 }
 

--------------090609070602010908040503--
