From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 1/5]: Fix removing invalid proc file
Date: Thu, 14 Oct 2004 02:18:40 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <416DC5E0.2080405@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030109030607080401010504"
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
--------------030109030607080401010504
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch fixes ip_conntrack leaving a stale proc file around.



--------------030109030607080401010504
Content-Type: text/x-patch;
 name="1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="1.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/10/14 00:55:09+02:00 pablo@eurodev.net 
#   [NETFILTER]: Fix removing invalid proc file
#   
#   Signed-off-by: Pablo Neira <pablo@eurodev.net>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_standalone.c
#   2004/10/14 00:54:41+02:00 pablo@eurodev.net +1 -1
#   [NETFILTER]: Fix removing invalid proc file
#   
#   Signed-off-by: Pablo Neira <pablo@eurodev.net>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-10-14 01:36:19 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-10-14 01:36:19 +02:00
@@ -816,7 +816,7 @@
 #ifdef CONFIG_PROC_FS
 	proc_net_remove("ip_conntrack_stat");
 cleanup_proc_exp:
-	proc_net_remove("ip_conntrack_exp");
+	proc_net_remove("ip_conntrack_expect");
  cleanup_proc:
 	proc_net_remove("ip_conntrack");
  cleanup_init:

--------------030109030607080401010504--
