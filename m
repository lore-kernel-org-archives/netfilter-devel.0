From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 1/8]: Add support for permanent expectations
Date: Tue, 06 Sep 2005 19:55:22 +0200
Message-ID: <431DD80A.2090408@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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

[NETFILTER]: Add support for permanent expectations

A permanent expectation exists until timeing out and can expect
multiple related connections.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d6d0e225ee3dd43d2a14fbd0aaded74bc7d45da1
tree d2d5560c285b21c956ade3088ef48027a46123ca
parent f505380ba7b98ec97bf25300c2a58aeae903530b
author Patrick McHardy <kaber@trash.net> Sun, 04 Sep 2005 17:29:19 +0200
committer Patrick McHardy <kaber@trash.net> Sun, 04 Sep 2005 17:29:19 +0200

 include/linux/netfilter_ipv4/ip_conntrack.h |    5 +++++
 net/ipv4/netfilter/ip_conntrack_amanda.c    |    1 +
 net/ipv4/netfilter/ip_conntrack_core.c      |   12 ++++++++----
 net/ipv4/netfilter/ip_conntrack_ftp.c       |    1 +
 net/ipv4/netfilter/ip_conntrack_irc.c       |    1 +
 net/ipv4/netfilter/ip_conntrack_netlink.c   |    1 +
 net/ipv4/netfilter/ip_conntrack_tftp.c      |    1 +
 7 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_conntrack.h b/include/linux/netfilter_ipv4/ip_conntrack.h
--- a/include/linux/netfilter_ipv4/ip_conntrack.h
+++ b/include/linux/netfilter_ipv4/ip_conntrack.h
@@ -263,6 +263,9 @@ struct ip_conntrack_expect
 	/* Unique ID */
 	unsigned int id;
 
+	/* Flags */
+	unsigned int flags;
+
 #ifdef CONFIG_IP_NF_NAT_NEEDED
 	/* This is the original per-proto part, used to map the
 	 * expected connection the way the recipient expects. */
@@ -272,6 +275,8 @@ struct ip_conntrack_expect
 #endif
 };
 
+#define IP_CT_EXPECT_PERMANENT	0x1
+
 static inline struct ip_conntrack *
 tuplehash_to_ctrack(const struct ip_conntrack_tuple_hash *hash)
 {
diff --git a/net/ipv4/netfilter/ip_conntrack_amanda.c b/net/ipv4/netfilter/ip_conntrack_amanda.c
--- a/net/ipv4/netfilter/ip_conntrack_amanda.c
+++ b/net/ipv4/netfilter/ip_conntrack_amanda.c
@@ -108,6 +108,7 @@ static int help(struct sk_buff **pskb,
 		}
 
 		exp->expectfn = NULL;
+		exp->flags = 0;
 
 		exp->tuple.src.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
 		exp->tuple.src.u.tcp.port = 0;
diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -264,10 +264,14 @@ find_expectation(const struct ip_conntra
 		   master ct never got confirmed, we'd hold a reference to it
 		   and weird things would happen to future packets). */
 		if (ip_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask)
-		    && is_confirmed(i->master)
-		    && del_timer(&i->timeout)) {
-			unlink_expect(i);
-			return i;
+		    && is_confirmed(i->master)) {
+			if (i->flags & IP_CT_EXPECT_PERMANENT) {
+				atomic_inc(&i->use);
+				return i;
+			} else if (del_timer(&i->timeout)) {
+				unlink_expect(i);
+				return i;
+			}
 		}
 	}
 	return NULL;
diff --git a/net/ipv4/netfilter/ip_conntrack_ftp.c b/net/ipv4/netfilter/ip_conntrack_ftp.c
--- a/net/ipv4/netfilter/ip_conntrack_ftp.c
+++ b/net/ipv4/netfilter/ip_conntrack_ftp.c
@@ -421,6 +421,7 @@ static int help(struct sk_buff **pskb,
 		  { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFF }});
 
 	exp->expectfn = NULL;
+	exp->flags = 0;
 
 	/* Now, NAT might want to mangle the packet, and register the
 	 * (possibly changed) expectation itself. */
diff --git a/net/ipv4/netfilter/ip_conntrack_irc.c b/net/ipv4/netfilter/ip_conntrack_irc.c
--- a/net/ipv4/netfilter/ip_conntrack_irc.c
+++ b/net/ipv4/netfilter/ip_conntrack_irc.c
@@ -221,6 +221,7 @@ static int help(struct sk_buff **pskb,
 				{ { 0, { 0 } },
 				  { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFF }});
 			exp->expectfn = NULL;
+			exp->flags = 0;
 			if (ip_nat_irc_hook)
 				ret = ip_nat_irc_hook(pskb, ctinfo, 
 						      addr_beg_p - ib_ptr,
diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -1413,6 +1413,7 @@ ctnetlink_create_expect(struct nfattr *c
 	}
 	
 	exp->expectfn = NULL;
+	exp->flags = 0;
 	exp->master = ct;
 	memcpy(&exp->tuple, &tuple, sizeof(struct ip_conntrack_tuple));
 	memcpy(&exp->mask, &mask, sizeof(struct ip_conntrack_tuple));
diff --git a/net/ipv4/netfilter/ip_conntrack_tftp.c b/net/ipv4/netfilter/ip_conntrack_tftp.c
--- a/net/ipv4/netfilter/ip_conntrack_tftp.c
+++ b/net/ipv4/netfilter/ip_conntrack_tftp.c
@@ -75,6 +75,7 @@ static int tftp_help(struct sk_buff **ps
 		exp->mask.dst.u.udp.port = 0xffff;
 		exp->mask.dst.protonum = 0xff;
 		exp->expectfn = NULL;
+		exp->flags = 0;
 
 		DEBUGP("expect: ");
 		DUMP_TUPLE(&exp->tuple);
