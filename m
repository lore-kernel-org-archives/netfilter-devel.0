From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 7/8] Netfilter:  Adrian Bunk's Cleanup Patches
Date: Tue, 11 Jan 2005 21:23:05 +1100
Message-ID: <1105438985.19331.34.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
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

Name: Adrian Bunk's Cleanup Patches
Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Adrian Bunk's cleanup patch, updated for after all the Rusty patches.

Date:	Wed, 15 Dec 2004 02:19:31 +0100
From: Adrian Bunk <bunk@stusta.de>
To: coreteam@netfilter.org
Cc: netfilter-devel@lists.netfilter.org, netdev@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: [2.6 patch] net/ipv4/netfilter/: misc possible cleanups
Message-ID: <20041215011931.GD12937@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6+20040907i
Sender: linux-kernel-owner@vger.kernel.org
Precedence: bulk
X-Mailing-List:	linux-kernel@vger.kernel.org
X-Evolution-Source: mbox:/var/spool/mail/rusty
Content-Transfer-Encoding: 8bit

The patch below contains the following possible cleanups:
- make some needlessly global code static
- remove the following unused global functions:
  - ip_conntrack_core.c: ip_conntrack_expect_find_get
  - ip_conntrack_core.c: ip_conntrack_unexpect_related
  - ip_nat_standalone.c: ip_nat_protocol_register
  - ip_nat_standalone.c: ip_nat_protocol_unregister
  - ip_nat_helper.c: ip_nat_find_helper
  - ipfwadm_core.c: ip_acct_ctl
- remove the following variables that never change their values:
  - ip_conntrack_ftp.c: ip_conntrack_ftp
  - ip_conntrack_irc.c: ip_conntrack_irc
- remove the following unneeded EXPORT_SYMBOL's:
  - ip_conntrack_standalone.c: ip_ct_find_helper
  - ip_conntrack_standalone.c: ip_conntrack_unexpect_related
  - ip_conntrack_standalone.c: ip_conntrack_expect_list
  - ip_conntrack_standalone.c: ip_conntrack_put
  - ip_nat_standalone.c: ip_nat_protocol_register
  - ip_nat_standalone.c: ip_nat_protocol_unregister
  - ip_nat_standalone.c: ip_nat_find_helper
- remove the following unneeded EXPORT_SYMBOL_GPL:
  - ip_conntrack_standalone.c: ip_conntrack_expect_find_get

Please comment on which of these changes are correct and which conflict
with pending patches.


diffstat output:
 include/linux/netfilter_ipv4/ip_conntrack.h        |    7 
 include/linux/netfilter_ipv4/ip_conntrack_helper.h |    4 
 include/linux/netfilter_ipv4/ip_nat_core.h         |    4 
 include/linux/netfilter_ipv4/ip_nat_helper.h       |    3 
 include/linux/netfilter_ipv4/ip_nat_protocol.h     |    4 
 include/linux/netfilter_ipv4/ipfwadm_core.h        |    9 -
 net/ipv4/netfilter/ip_conntrack_core.c             |   28 ---
 net/ipv4/netfilter/ip_conntrack_ftp.c              |    3 
 net/ipv4/netfilter/ip_conntrack_irc.c              |    8 
 net/ipv4/netfilter/ip_conntrack_proto_sctp.c       |   20 +-
 net/ipv4/netfilter/ip_conntrack_standalone.c       |    5 
 net/ipv4/netfilter/ip_nat_core.c                   |   94 +++++------
 net/ipv4/netfilter/ip_nat_helper.c                 |   14 -
 net/ipv4/netfilter/ip_nat_standalone.c             |   30 ---
 net/ipv4/netfilter/ipchains_core.c                 |   22 +-
 net/ipv4/netfilter/ipfwadm_core.c                  |  108 +++----------
 net/ipv4/netfilter/ipt_CLUSTERIP.c                 |    2 
 net/ipv4/netfilter/ipt_ULOG.c                      |    4 
 net/ipv4/netfilter/ipt_hashlimit.c                 |    2 
 net/ipv4/netfilter/ipt_recent.c                    |    2 
 20 files changed, 111 insertions(+), 262 deletions(-)



Index: linux-2.6.10-bk12-Netfilter/net/ipv4/netfilter/ip_nat_core.c
===================================================================
--- linux-2.6.10-bk12-Netfilter.orig/net/ipv4/netfilter/ip_nat_core.c	2005-01-11 14:43:43.458944128 +1100
+++ linux-2.6.10-bk12-Netfilter/net/ipv4/netfilter/ip_nat_core.c	2005-01-11 14:43:56.119019504 +1100
@@ -288,6 +288,31 @@
     [NF_IP_LOCAL_IN] = NF_IP_LOCAL_OUT,
 };
 
+static void replace_in_hashes(struct ip_conntrack *conntrack,
+			      struct ip_nat_info *info)
+{
+	/* Source has changed, so replace in hashes. */
+	unsigned int srchash
+		= hash_by_src(&conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
+			      .tuple.src,
+			      conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
+			      .tuple.dst.protonum);
+	MUST_BE_WRITE_LOCKED(&ip_nat_lock);
+	list_move(&info->bysource, &bysource[srchash]);
+}
+
+static void place_in_hashes(struct ip_conntrack *conntrack,
+			    struct ip_nat_info *info)
+{
+	unsigned int srchash
+		= hash_by_src(&conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
+			      .tuple.src,
+			      conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
+			      .tuple.dst.protonum);
+	MUST_BE_WRITE_LOCKED(&ip_nat_lock);
+	list_add(&info->bysource, &bysource[srchash]);
+}
+
 unsigned int
 ip_nat_setup_info(struct ip_conntrack *conntrack,
 		  const struct ip_nat_range *range,
@@ -411,31 +436,6 @@
 	return NF_ACCEPT;
 }
 
-void replace_in_hashes(struct ip_conntrack *conntrack,
-		       struct ip_nat_info *info)
-{
-	/* Source has changed, so replace in hashes. */
-	unsigned int srchash
-		= hash_by_src(&conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
-			      .tuple.src,
-			      conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
-			      .tuple.dst.protonum);
-	MUST_BE_WRITE_LOCKED(&ip_nat_lock);
-	list_move(&info->bysource, &bysource[srchash]);
-}
-
-void place_in_hashes(struct ip_conntrack *conntrack,
-		     struct ip_nat_info *info)
-{
-	unsigned int srchash
-		= hash_by_src(&conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
-			      .tuple.src,
-			      conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
-			      .tuple.dst.protonum);
-	MUST_BE_WRITE_LOCKED(&ip_nat_lock);
-	list_add(&info->bysource, &bysource[srchash]);
-}
-
 /* Returns true if succeeded. */
 static int
 manip_pkt(u_int16_t proto,
Index: linux-2.6.10-bk12-Netfilter/net/ipv4/netfilter/ip_nat_helper.c
===================================================================
--- linux-2.6.10-bk12-Netfilter.orig/net/ipv4/netfilter/ip_nat_helper.c	2005-01-11 14:42:48.709267344 +1100
+++ linux-2.6.10-bk12-Netfilter/net/ipv4/netfilter/ip_nat_helper.c	2005-01-11 14:44:29.364965352 +1100
@@ -47,7 +47,7 @@
 #define DUMP_OFFSET(x)
 #endif
 
-DECLARE_LOCK(ip_nat_seqofs_lock);
+static DECLARE_LOCK(ip_nat_seqofs_lock);
 
 /* Setup TCP sequence correction given this change at this sequence */
 static inline void 
Index: linux-2.6.10-bk12-Netfilter/net/ipv4/netfilter/ip_conntrack_standalone.c
===================================================================
--- linux-2.6.10-bk12-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-01-11 14:42:48.710267192 +1100
+++ linux-2.6.10-bk12-Netfilter/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-01-11 14:43:56.120019352 +1100
@@ -905,7 +905,6 @@
 EXPORT_SYMBOL(ip_ct_refresh_acct);
 EXPORT_SYMBOL(ip_ct_protos);
 EXPORT_SYMBOL(ip_ct_find_proto);
-EXPORT_SYMBOL(ip_ct_find_helper);
 EXPORT_SYMBOL(ip_conntrack_expect_alloc);
 EXPORT_SYMBOL(ip_conntrack_expect_free);
 EXPORT_SYMBOL(ip_conntrack_expect_related);
Index: linux-2.6.10-bk12-Netfilter/net/ipv4/netfilter/ip_conntrack_ftp.c
===================================================================
--- linux-2.6.10-bk12-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-01-11 14:43:42.113148720 +1100
+++ linux-2.6.10-bk12-Netfilter/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-01-11 14:43:56.121019200 +1100
@@ -29,7 +29,6 @@
 static char ftp_buffer[65536];
 
 static DECLARE_LOCK(ip_ftp_lock);
-struct module *ip_conntrack_ftp = THIS_MODULE;
 
 #define MAX_PORTS 8
 static int ports[MAX_PORTS];
@@ -477,7 +476,7 @@
 		ftp[i].mask.dst.protonum = 0xFFFF;
 		ftp[i].max_expected = 1;
 		ftp[i].timeout = 5 * 60; /* 5 minutes */
-		ftp[i].me = ip_conntrack_ftp;
+		ftp[i].me = THIS_MODULE;
 		ftp[i].help = help;
 
 		tmpname = &ftp_names[i][0];
Index: linux-2.6.10-bk12-Netfilter/net/ipv4/netfilter/ip_nat_standalone.c
===================================================================
--- linux-2.6.10-bk12-Netfilter.orig/net/ipv4/netfilter/ip_nat_standalone.c	2005-01-11 14:22:03.982494576 +1100
+++ linux-2.6.10-bk12-Netfilter/net/ipv4/netfilter/ip_nat_standalone.c	2005-01-11 14:43:56.122019048 +1100
@@ -271,33 +271,6 @@
 	.priority	= NF_IP_PRI_NAT_SRC,
 };
 
-/* Protocol registration. */
-int ip_nat_protocol_register(struct ip_nat_protocol *proto)
-{
-	int ret = 0;
-
-	WRITE_LOCK(&ip_nat_lock);
-	if (ip_nat_protos[proto->protonum] != &ip_nat_unknown_protocol) {
-		ret = -EBUSY;
-		goto out;
-	}
-	ip_nat_protos[proto->protonum] = proto;
- out:
-	WRITE_UNLOCK(&ip_nat_lock);
-	return ret;
-}
-
-/* Noone stores the protocol anywhere; simply delete it. */
-void ip_nat_protocol_unregister(struct ip_nat_protocol *proto)
-{
-	WRITE_LOCK(&ip_nat_lock);
-	ip_nat_protos[proto->protonum] = &ip_nat_unknown_protocol;
-	WRITE_UNLOCK(&ip_nat_lock);
-
-	/* Someone could be still looking at the proto in a bh. */
-	synchronize_net();
-}
-
 static int init_or_cleanup(int init)
 {
 	int ret = 0;
@@ -369,15 +342,12 @@
 module_exit(fini);
 
 EXPORT_SYMBOL(ip_nat_setup_info);
-EXPORT_SYMBOL(ip_nat_protocol_register);
-EXPORT_SYMBOL(ip_nat_protocol_unregister);
 EXPORT_SYMBOL(ip_nat_helper_register);
 EXPORT_SYMBOL(ip_nat_helper_unregister);
 EXPORT_SYMBOL(ip_nat_cheat_check);
 EXPORT_SYMBOL(ip_nat_mangle_tcp_packet);
 EXPORT_SYMBOL(ip_nat_mangle_udp_packet);
 EXPORT_SYMBOL(ip_nat_used_tuple);
-EXPORT_SYMBOL(ip_nat_find_helper);
 EXPORT_SYMBOL(__ip_nat_find_helper);
 EXPORT_SYMBOL(ip_nat_follow_master);
 MODULE_LICENSE("GPL");
Index: linux-2.6.10-bk12-Netfilter/net/ipv4/netfilter/ipt_CLUSTERIP.c
===================================================================
--- linux-2.6.10-bk12-Netfilter.orig/net/ipv4/netfilter/ipt_CLUSTERIP.c	2005-01-11 14:22:03.982494576 +1100
+++ linux-2.6.10-bk12-Netfilter/net/ipv4/netfilter/ipt_CLUSTERIP.c	2005-01-11 14:43:56.122019048 +1100
@@ -66,7 +66,7 @@
 
 /* clusterip_lock protects the clusterip_configs list _AND_ the configurable
  * data within all structurses (num_local_nodes, local_nodes[]) */
-DECLARE_RWLOCK(clusterip_lock);
+static DECLARE_RWLOCK(clusterip_lock);
 
 #ifdef CONFIG_PROC_FS
 static struct file_operations clusterip_proc_fops;
Index: linux-2.6.10-bk12-Netfilter/net/ipv4/netfilter/ip_conntrack_irc.c
===================================================================
--- linux-2.6.10-bk12-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_irc.c	2005-01-11 14:42:48.714266584 +1100
+++ linux-2.6.10-bk12-Netfilter/net/ipv4/netfilter/ip_conntrack_irc.c	2005-01-11 14:43:56.123018896 +1100
@@ -63,8 +63,6 @@
 static char *dccprotos[] = { "SEND ", "CHAT ", "MOVE ", "TSEND ", "SCHAT " };
 #define MINMATCHLEN	5
 
-struct module *ip_conntrack_irc = THIS_MODULE;
-
 #if 0
 #define DEBUGP(format, args...) printk(KERN_DEBUG "%s:%s:" format, \
                                        __FILE__, __FUNCTION__ , ## args)
@@ -270,7 +268,7 @@
 		hlpr->mask.dst.protonum = 0xFFFF;
 		hlpr->max_expected = max_dcc_channels;
 		hlpr->timeout = dcc_timeout;
-		hlpr->me = ip_conntrack_irc;
+		hlpr->me = THIS_MODULE;
 		hlpr->help = help;
 
 		tmpname = &irc_names[i][0];
Index: linux-2.6.10-bk12-Netfilter/include/linux/netfilter_ipv4/ip_nat_protocol.h
===================================================================
--- linux-2.6.10-bk12-Netfilter.orig/include/linux/netfilter_ipv4/ip_nat_protocol.h	2005-01-11 14:22:04.032486976 +1100
+++ linux-2.6.10-bk12-Netfilter/include/linux/netfilter_ipv4/ip_nat_protocol.h	2005-01-11 14:43:56.123018896 +1100
@@ -48,10 +48,6 @@
 #define MAX_IP_NAT_PROTO 256
 extern struct ip_nat_protocol *ip_nat_protos[MAX_IP_NAT_PROTO];
 
-/* Protocol registration. */
-extern int ip_nat_protocol_register(struct ip_nat_protocol *proto);
-extern void ip_nat_protocol_unregister(struct ip_nat_protocol *proto);
-
 static inline struct ip_nat_protocol *ip_nat_find_proto(u_int8_t protocol)
 {
 	return ip_nat_protos[protocol];
Index: linux-2.6.10-bk12-Netfilter/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
===================================================================
--- linux-2.6.10-bk12-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2005-01-11 14:22:03.982494576 +1100
+++ linux-2.6.10-bk12-Netfilter/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2005-01-11 14:43:56.123018896 +1100
@@ -58,13 +58,13 @@
 #define HOURS * 60 MINS
 #define DAYS  * 24 HOURS
 
-unsigned long ip_ct_sctp_timeout_closed            =  10 SECS;
-unsigned long ip_ct_sctp_timeout_cookie_wait       =   3 SECS;
-unsigned long ip_ct_sctp_timeout_cookie_echoed     =   3 SECS;
-unsigned long ip_ct_sctp_timeout_established       =   5 DAYS;
-unsigned long ip_ct_sctp_timeout_shutdown_sent     = 300 SECS / 1000;
-unsigned long ip_ct_sctp_timeout_shutdown_recd     = 300 SECS / 1000;
-unsigned long ip_ct_sctp_timeout_shutdown_ack_sent =   3 SECS;
+static unsigned long ip_ct_sctp_timeout_closed            =  10 SECS;
+static unsigned long ip_ct_sctp_timeout_cookie_wait       =   3 SECS;
+static unsigned long ip_ct_sctp_timeout_cookie_echoed     =   3 SECS;
+static unsigned long ip_ct_sctp_timeout_established       =   5 DAYS;
+static unsigned long ip_ct_sctp_timeout_shutdown_sent     = 300 SECS / 1000;
+static unsigned long ip_ct_sctp_timeout_shutdown_recd     = 300 SECS / 1000;
+static unsigned long ip_ct_sctp_timeout_shutdown_ack_sent =   3 SECS;
 
 static unsigned long * sctp_timeouts[]
 = { NULL,                                  /* SCTP_CONNTRACK_NONE  */
@@ -494,7 +494,7 @@
 	return 1;
 }
 
-struct ip_conntrack_protocol ip_conntrack_protocol_sctp = { 
+static struct ip_conntrack_protocol ip_conntrack_protocol_sctp = { 
 	.proto 		 = IPPROTO_SCTP, 
 	.name 		 = "sctp",
 	.pkt_to_tuple 	 = sctp_pkt_to_tuple, 
Index: linux-2.6.10-bk12-Netfilter/include/linux/netfilter_ipv4/ip_nat_core.h
===================================================================
--- linux-2.6.10-bk12-Netfilter.orig/include/linux/netfilter_ipv4/ip_nat_core.h	2005-01-11 14:22:04.032486976 +1100
+++ linux-2.6.10-bk12-Netfilter/include/linux/netfilter_ipv4/ip_nat_core.h	2005-01-11 14:43:56.124018744 +1100
@@ -19,9 +19,5 @@
 				  unsigned int hooknum,
 				  int dir);
 
-extern void replace_in_hashes(struct ip_conntrack *conntrack,
-			      struct ip_nat_info *info);
-extern void place_in_hashes(struct ip_conntrack *conntrack,
-			    struct ip_nat_info *info);
 
 #endif /* _IP_NAT_CORE_H */
Index: linux-2.6.10-bk12-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_helper.h
===================================================================
--- linux-2.6.10-bk12-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack_helper.h	2005-01-11 14:42:48.714266584 +1100
+++ linux-2.6.10-bk12-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_helper.h	2005-01-11 14:43:56.123018896 +1100
@@ -29,9 +29,6 @@
 extern int ip_conntrack_helper_register(struct ip_conntrack_helper *);
 extern void ip_conntrack_helper_unregister(struct ip_conntrack_helper *);
 
-extern struct ip_conntrack_helper *ip_ct_find_helper(const struct ip_conntrack_tuple *tuple);
-
-
 /* Allocate space for an expectation: this is mandatory before calling 
    ip_conntrack_expect_related. */
 extern struct ip_conntrack_expect *ip_conntrack_expect_alloc(void);
Index: linux-2.6.10-bk12-Netfilter/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- linux-2.6.10-bk12-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-11 14:43:42.114148568 +1100
+++ linux-2.6.10-bk12-Netfilter/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-11 14:43:56.125018592 +1100
@@ -78,7 +78,7 @@
 
 DEFINE_PER_CPU(struct ip_conntrack_stat, ip_conntrack_stat);
 
-inline void 
+void 
 ip_conntrack_put(struct ip_conntrack *ct)
 {
 	IP_NF_ASSERT(ct);
@@ -440,7 +440,7 @@
 	return ip_ct_tuple_mask_cmp(rtuple, &i->tuple, &i->mask);
 }
 
-struct ip_conntrack_helper *ip_ct_find_helper(const struct ip_conntrack_tuple *tuple)
+static struct ip_conntrack_helper *ip_ct_find_helper(const struct ip_conntrack_tuple *tuple)
 {
 	return LIST_FIND(&helpers, helper_cmp,
 			 struct ip_conntrack_helper *,
Index: linux-2.6.10-bk12-Netfilter/net/ipv4/netfilter/ipt_ULOG.c
===================================================================
--- linux-2.6.10-bk12-Netfilter.orig/net/ipv4/netfilter/ipt_ULOG.c	2005-01-11 14:22:03.982494576 +1100
+++ linux-2.6.10-bk12-Netfilter/net/ipv4/netfilter/ipt_ULOG.c	2005-01-11 14:43:56.125018592 +1100
@@ -100,7 +100,7 @@
 static ulog_buff_t ulog_buffers[ULOG_MAXNLGROUPS];	/* array of buffers */
 
 static struct sock *nflognl;	/* our socket */
-DECLARE_LOCK(ulog_lock);	/* spinlock */
+static DECLARE_LOCK(ulog_lock);	/* spinlock */
 
 /* send one ulog_buff_t to userspace */
 static void ulog_send(unsigned int nlgroupnum)
@@ -140,7 +140,7 @@
 	UNLOCK_BH(&ulog_lock);
 }
 
-struct sk_buff *ulog_alloc_skb(unsigned int size)
+static struct sk_buff *ulog_alloc_skb(unsigned int size)
 {
 	struct sk_buff *skb;
 
Index: linux-2.6.10-bk12-Netfilter/net/ipv4/netfilter/ipt_hashlimit.c
===================================================================
--- linux-2.6.10-bk12-Netfilter.orig/net/ipv4/netfilter/ipt_hashlimit.c	2005-01-11 14:22:03.982494576 +1100
+++ linux-2.6.10-bk12-Netfilter/net/ipv4/netfilter/ipt_hashlimit.c	2005-01-11 14:43:56.124018744 +1100
@@ -97,7 +97,7 @@
 	struct list_head hash[0];	/* hashtable itself */
 };
 
-DECLARE_RWLOCK(hashlimit_lock);		/* protects htables list */
+static DECLARE_RWLOCK(hashlimit_lock);	/* protects htables list */
 static LIST_HEAD(hashlimit_htables);
 static kmem_cache_t *hashlimit_cachep;
 
