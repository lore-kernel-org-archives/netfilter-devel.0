From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 07/20]: nf_conntrack: add module aliases to IPv4
	conntrack names
Date: Sat,  2 Dec 2006 15:49:46 +0100 (MET)
Message-ID: <20061202145251.1381.21107.sendpatchset@localhost.localdomain>
References: <20061202145241.1381.88698.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061202145241.1381.88698.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: add module aliases to IPv4 conntrack names

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 970f82888147acc34d493064dfe66d4374063e90
tree faccd8e1da38a3324f5fe1a9a8e4c29881474775
parent 03143a9731c29b2c5bd72881d76471d9d68922d0
author Patrick McHardy <kaber@trash.net> Sat, 02 Dec 2006 15:33:59 +0100
committer Patrick McHardy <kaber@trash.net> Sat, 02 Dec 2006 15:33:59 +0100

 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    1 +
 net/netfilter/nf_conntrack_ftp.c               |    1 +
 net/netfilter/nf_conntrack_netlink.c           |    1 +
 net/netfilter/nf_conntrack_proto_sctp.c        |    1 +
 4 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 2b73e3e..653f57b 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -446,6 +446,7 @@ #endif
 };
 
 MODULE_ALIAS("nf_conntrack-" __stringify(AF_INET));
+MODULE_ALIAS("ip_conntrack");
 MODULE_LICENSE("GPL");
 
 static int __init nf_conntrack_l3proto_ipv4_init(void)
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index e96c41d..e299d65 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -34,6 +34,7 @@ #include <linux/netfilter/nf_conntrack_f
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Rusty Russell <rusty@rustcorp.com.au>");
 MODULE_DESCRIPTION("ftp connection tracking helper");
+MODULE_ALIAS("ip_conntrack_ftp");
 
 /* This is slow, but it's simple. --RR */
 static char *ftp_buffer;
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index acaef40..f9c8ddd 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1544,6 +1544,7 @@ static struct nfnetlink_subsystem ctnl_e
 	.cb				= ctnl_exp_cb,
 };
 
+MODULE_ALIAS("ip_conntrack_netlink");
 MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_CTNETLINK);
 MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_CTNETLINK_EXP);
 
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 02b9323..76e2636 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -716,3 +716,4 @@ module_exit(nf_conntrack_proto_sctp_fini
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Kiran Kumar Immidi");
 MODULE_DESCRIPTION("Netfilter connection tracking protocol helper for SCTP");
+MODULE_ALIAS("ip_conntrack_proto_sctp");
