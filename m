From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 2/12]: add sysctl to read out the number of current
	connections
Date: Tue, 21 Sep 2004 05:21:55 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <414F9E53.3090604@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080906060807020204020407"
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
--------------080906060807020204020407
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

This patch adds a sysctl to read out the number of current connections.
ip_conntrack_count is an atomic_t, but it is read out by proc_dointvec.
I have checked all arches, all use an int, but I'm not sure if it works
on all of them.


ChangeSet@1.1935.1.2, 2004-09-18 23:27:31+02:00, laforge@netfilter.org
  [NETFILTER]: add sysctl to read out the number of current connections
 
  Apparently a lot of scripts use a construct like
          "cat /proc/net/ip_conntrack | wc -l"
  which has a negative impact on system performance due to all the locking
  required.
 
  Signed-off-by: Harald Welte <laforge@netfilter.org>
  Signed-off-by: Patrick McHardy <kaber@trash.net>


--------------080906060807020204020407
Content-Type: text/x-patch;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/09/18 23:27:31+02:00 laforge@netfilter.org 
#   [NETFILTER]: add sysctl to read out the number of current connections
#   
#   Apparently a lot of scripts use a construct like
#           "cat /proc/net/ip_conntrack | wc -l"
#   which has a negative impact on system performance due to all the locking
#   required.
#   
#   Signed-off-by: Harald Welte <laforge@netfilter.org>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_standalone.c
#   2004/09/18 23:27:03+02:00 laforge@netfilter.org +8 -0
#   [NETFILTER]: add sysctl to read out the number of current connections
#   
#   Apparently a lot of scripts use a construct like
#           "cat /proc/net/ip_conntrack | wc -l"
#   which has a negative impact on system performance due to all the locking
#   required.
#   
#   Signed-off-by: Harald Welte <laforge@netfilter.org>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/sysctl.h
#   2004/09/18 23:27:03+02:00 laforge@netfilter.org +1 -0
#   [NETFILTER]: add sysctl to read out the number of current connections
#   
#   Apparently a lot of scripts use a construct like
#           "cat /proc/net/ip_conntrack | wc -l"
#   which has a negative impact on system performance due to all the locking
#   required.
#   
#   Signed-off-by: Harald Welte <laforge@netfilter.org>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/include/linux/sysctl.h b/include/linux/sysctl.h
--- a/include/linux/sysctl.h	2004-09-20 11:57:01 +02:00
+++ b/include/linux/sysctl.h	2004-09-20 11:57:01 +02:00
@@ -424,6 +424,7 @@
  	NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_SHUTDOWN_SENT=24,
  	NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_SHUTDOWN_RECD=25,
  	NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_SHUTDOWN_ACK_SENT=26,
+	NET_IPV4_NF_CONNTRACK_COUNT=27,
 };
  
 /* /proc/sys/net/ipv6 */
diff -Nru a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-09-20 11:57:01 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-09-20 11:57:01 +02:00
@@ -515,6 +515,14 @@
 		.proc_handler	= &proc_dointvec,
 	},
 	{
+		.ctl_name	= NET_IPV4_NF_CONNTRACK_COUNT,
+		.procname	= "ip_conntrack_count",
+		.data		= &ip_conntrack_count,
+		.maxlen		= sizeof(int),
+		.mode		= 0444,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
 		.ctl_name	= NET_IPV4_NF_CONNTRACK_BUCKETS,
 		.procname	= "ip_conntrack_buckets",
 		.data		= &ip_conntrack_htable_size,

--------------080906060807020204020407--
