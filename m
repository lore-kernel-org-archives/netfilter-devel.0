From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [NETFILTER 01/03]: nf_conntrack: fix helper module unload races
Date: Sat, 09 Jun 2007 19:41:30 +0900 (JST)
Message-ID: <200706091041.l59AfV98029354@toshiba.co.jp>
References: <20070605133508.10309.36756.sendpatchset@localhost.localdomain>
	<20070605133509.10309.45032.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, davem@davemloft.net
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070605133509.10309.45032.sendpatchset@localhost.localdomain>
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


Hi, Patrick,

From: Patrick McHardy <kaber@trash.net>
Date: Tue,  5 Jun 2007 15:35:10 +0200 (MEST)

> [NETFILTER]: nf_conntrack: fix helper module unload races

nfct_help(ct) also needs to be protected because of the race between
nfctnetlink and helper. Sorry, I did not test the following patch because
I don't have SMP machine.

You might dislike this.  Other idea is to use call_rcu() in
nfctnetlink_change_helper(), but I need to study the way to use it more.


[NETFILTER]: nf_conntrack: Fixes race on changing helper

nfctnetlink may change the helper assigned to a conntrack and clear
private area in the conntrack. To fix the race, this exports spin locks
of helpers and nfctnetlink uses them. Some helpers do not need to grab
spin lock, because they do not store any state in the private area.

Other staff does not need to grab spin lock.
- unhelp() assigns NULL to conntrack, but it does not touch the private
  area.
- init_conntrack(), nf_conntrack_alter_reply(), and
  nfctnetlink_create_conntrack() assign a helper to a conntrack,
  but the conntrack is unconfirmed. No competitor exists.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
---
 include/net/netfilter/nf_conntrack_helper.h    |    5 +++++
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   21 +++++++++++++++++----
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   16 +++++++++++++---
 net/netfilter/nf_conntrack_ftp.c               |    3 +--
 net/netfilter/nf_conntrack_h323_main.c         |   20 ++++++--------------
 net/netfilter/nf_conntrack_irc.c               |    3 +--
 net/netfilter/nf_conntrack_netlink.c           |    6 ++++++
 net/netfilter/nf_conntrack_pptp.c              |    4 +---
 net/netfilter/nf_conntrack_sane.c              |    3 +--
 9 files changed, 51 insertions(+), 30 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 8c72ac9..5a2b811 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -10,6 +10,7 @@
 #ifndef _NF_CONNTRACK_HELPER_H
 #define _NF_CONNTRACK_HELPER_H
 #include <net/netfilter/nf_conntrack.h>
+#include <linux/spinlock_types.h>
 
 struct module;
 
@@ -37,6 +38,10 @@ struct nf_conntrack_helper
 	void (*destroy)(struct nf_conn *ct);
 
 	int (*to_nfattr)(struct sk_buff *skb, const struct nf_conn *ct);
+
+	/* This protects the helper specific shared resource and
+	   the private area in a confirmed conntrack */
+	spinlock_t *lock;
 };
 
 extern struct nf_conntrack_helper *
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 6dc72a8..648b7fd 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -134,6 +134,7 @@ static unsigned int ipv4_conntrack_help(
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn_help *help;
 	struct nf_conntrack_helper *helper;
+	int ret;
 
 	/* This is where we call the helper: as the packet goes out. */
 	ct = nf_ct_get(*pskb, &ctinfo);
@@ -143,12 +144,24 @@ static unsigned int ipv4_conntrack_help(
 	help = nfct_help(ct);
 	if (!help)
 		return NF_ACCEPT;
+
+	if (helper->lock)
+		spin_lock_bh(helper->lock);
+
 	/* rcu_read_lock()ed by nf_hook_slow */
 	helper = rcu_dereference(help->helper);
-	if (!helper)
-		return NF_ACCEPT;
-	return helper->help(pskb, skb_network_offset(*pskb) + ip_hdrlen(*pskb),
-			    ct, ctinfo);
+	if (!helper) {
+		ret = NF_ACCEPT;
+		goto out;
+	}
+
+	ret = helper->help(pskb, skb_network_offset(*pskb) + ip_hdrlen(*pskb),
+			   ct, ctinfo);
+out:
+	if (helper->lock)
+		spin_unlock_bh(helper->lock);
+
+	return ret;
 }
 
 static unsigned int ipv4_conntrack_defrag(unsigned int hooknum,
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 1b1797f..0fa34a2 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -162,7 +162,8 @@ static unsigned int ipv6_confirm(unsigne
 	struct nf_conn_help *help;
 	struct nf_conntrack_helper *helper;
 	enum ip_conntrack_info ctinfo;
-	unsigned int ret, protoff;
+	unsigned int ret = NF_ACCEPT;
+	unsigned int protoff;
 	unsigned int extoff = (u8 *)(ipv6_hdr(*pskb) + 1) - (*pskb)->data;
 	unsigned char pnum = ipv6_hdr(*pskb)->nexthdr;
 
@@ -175,19 +176,28 @@ static unsigned int ipv6_confirm(unsigne
 	help = nfct_help(ct);
 	if (!help)
 		goto out;
+
+	if (helper->lock)
+		spin_lock_bh(helper->lock);
+
 	/* rcu_read_lock()ed by nf_hook_slow */
 	helper = rcu_dereference(help->helper);
 	if (!helper)
-		goto out;
+		goto out_unlock;
 
 	protoff = nf_ct_ipv6_skip_exthdr(*pskb, extoff, &pnum,
 					 (*pskb)->len - extoff);
 	if (protoff > (*pskb)->len || pnum == NEXTHDR_FRAGMENT) {
 		DEBUGP("proto header not found\n");
-		return NF_ACCEPT;
+		goto out_unlock;
 	}
 
 	ret = helper->help(pskb, protoff, ct, ctinfo);
+
+out_unlock:
+	if (helper->lock)
+		spin_unlock_bh(helper->lock);
+
 	if (ret != NF_ACCEPT)
 		return ret;
 out:
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 82db2aa..e9700f6 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -389,7 +389,6 @@ static int help(struct sk_buff **pskb,
 	}
 	datalen = (*pskb)->len - dataoff;
 
-	spin_lock_bh(&nf_ftp_lock);
 	fb_ptr = skb_header_pointer(*pskb, dataoff, datalen, ftp_buffer);
 	BUG_ON(fb_ptr == NULL);
 
@@ -538,7 +537,6 @@ out_update_nl:
 	if (ends_in_nl)
 		update_nl_seq(seq, ct_ftp_info, dir, *pskb);
  out:
-	spin_unlock_bh(&nf_ftp_lock);
 	return ret;
 }
 
@@ -591,6 +589,7 @@ static int __init nf_conntrack_ftp_init(
 			ftp[i][j].timeout = 5 * 60;	/* 5 Minutes */
 			ftp[i][j].me = THIS_MODULE;
 			ftp[i][j].help = help;
+			ftp[i][j].lock = &nf_ftp_lock;
 			tmpname = &ftp_names[i][j][0];
 			if (ports[i] == FTP_PORT)
 				sprintf(tmpname, "ftp");
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index a1b95ac..38ceda4 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -584,8 +584,6 @@ static int h245_help(struct sk_buff **ps
 	}
 	DEBUGP("nf_ct_h245: skblen = %u\n", (*pskb)->len);
 
-	spin_lock_bh(&nf_h323_lock);
-
 	/* Process each TPKT */
 	while (get_tpkt_data(pskb, protoff, ct, ctinfo,
 			     &data, &datalen, &dataoff)) {
@@ -609,11 +607,9 @@ static int h245_help(struct sk_buff **ps
 			goto drop;
 	}
 
-	spin_unlock_bh(&nf_h323_lock);
 	return NF_ACCEPT;
 
       drop:
-	spin_unlock_bh(&nf_h323_lock);
 	if (net_ratelimit())
 		printk("nf_ct_h245: packet dropped\n");
 	return NF_DROP;
@@ -1128,8 +1124,6 @@ static int q931_help(struct sk_buff **ps
 	}
 	DEBUGP("nf_ct_q931: skblen = %u\n", (*pskb)->len);
 
-	spin_lock_bh(&nf_h323_lock);
-
 	/* Process each TPKT */
 	while (get_tpkt_data(pskb, protoff, ct, ctinfo,
 			     &data, &datalen, &dataoff)) {
@@ -1152,11 +1146,9 @@ static int q931_help(struct sk_buff **ps
 			goto drop;
 	}
 
-	spin_unlock_bh(&nf_h323_lock);
 	return NF_ACCEPT;
 
       drop:
-	spin_unlock_bh(&nf_h323_lock);
 	if (net_ratelimit())
 		printk("nf_ct_q931: packet dropped\n");
 	return NF_DROP;
@@ -1176,7 +1168,8 @@ static struct nf_conntrack_helper nf_con
 		.mask.src.l3num		= 0xFFFF,
 		.mask.src.u.tcp.port	= __constant_htons(0xFFFF),
 		.mask.dst.protonum	= 0xFF,
-		.help			= q931_help
+		.help			= q931_help,
+		.lock			= &nf_h323_lock,
 	},
 	{
 		.name			= "Q.931",
@@ -1190,7 +1183,8 @@ static struct nf_conntrack_helper nf_con
 		.mask.src.l3num		= 0xFFFF,
 		.mask.src.u.tcp.port	= __constant_htons(0xFFFF),
 		.mask.dst.protonum	= 0xFF,
-		.help			= q931_help
+		.help			= q931_help,
+		.lock			= &nf_h323_lock,
 	},
 };
 
@@ -1708,8 +1702,6 @@ static int ras_help(struct sk_buff **psk
 
 	DEBUGP("nf_ct_ras: skblen = %u\n", (*pskb)->len);
 
-	spin_lock_bh(&nf_h323_lock);
-
 	/* Get UDP data */
 	data = get_udp_data(pskb, protoff, &datalen);
 	if (data == NULL)
@@ -1732,11 +1724,9 @@ static int ras_help(struct sk_buff **psk
 		goto drop;
 
       accept:
-	spin_unlock_bh(&nf_h323_lock);
 	return NF_ACCEPT;
 
       drop:
-	spin_unlock_bh(&nf_h323_lock);
 	if (net_ratelimit())
 		printk("nf_ct_ras: packet dropped\n");
 	return NF_DROP;
@@ -1756,6 +1746,7 @@ static struct nf_conntrack_helper nf_con
 		.mask.src.u.udp.port	= __constant_htons(0xFFFF),
 		.mask.dst.protonum	= 0xFF,
 		.help			= ras_help,
+		.lock			= &nf_h323_lock,
 	},
 	{
 		.name			= "RAS",
@@ -1769,6 +1760,7 @@ static struct nf_conntrack_helper nf_con
 		.mask.src.u.udp.port	= __constant_htons(0xFFFF),
 		.mask.dst.protonum	= 0xFF,
 		.help			= ras_help,
+		.lock			= &nf_h323_lock,
 	},
 };
 
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 43ccd0e..2e82fbc 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -130,7 +130,6 @@ static int help(struct sk_buff **pskb, u
 	if (dataoff >= (*pskb)->len)
 		return NF_ACCEPT;
 
-	spin_lock_bh(&irc_buffer_lock);
 	ib_ptr = skb_header_pointer(*pskb, dataoff, (*pskb)->len - dataoff,
 				    irc_buffer);
 	BUG_ON(ib_ptr == NULL);
@@ -208,7 +207,6 @@ static int help(struct sk_buff **pskb, u
 		}
 	}
  out:
-	spin_unlock_bh(&irc_buffer_lock);
 	return ret;
 }
 
@@ -246,6 +244,7 @@ static int __init nf_conntrack_irc_init(
 		irc[i].timeout = dcc_timeout;
 		irc[i].me = THIS_MODULE;
 		irc[i].help = help;
+		irc[i].lock = &irc_buffer_lock;
 
 		tmpname = &irc_names[i][0];
 		if (ports[i] == IRC_PORT)
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 3f73327..f604fff 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -872,10 +872,16 @@ ctnetlink_change_helper(struct nf_conn *
 		/* we had a helper before ... */
 		nf_ct_remove_expectations(ct);
 
+	if (help->helper->lock)
+		spin_lock_bh(help->helper->lock);
+
 	/* need to zero data of old helper */
 	memset(&help->help, 0, sizeof(help->help));
 	rcu_assign_pointer(help->helper, helper);
 
+	if (help->helper->lock)
+		spin_unlock_bh(help->helper->lock);
+
 	return 0;
 }
 
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index 115bcb5..08825f8 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -557,8 +557,6 @@ conntrack_pptp_help(struct sk_buff **psk
 	oldsstate = info->sstate;
 	oldcstate = info->cstate;
 
-	spin_lock_bh(&nf_pptp_lock);
-
 	/* FIXME: We just blindly assume that the control connection is always
 	 * established from PNS->PAC.  However, RFC makes no guarantee */
 	if (dir == IP_CT_DIR_ORIGINAL)
@@ -571,7 +569,6 @@ conntrack_pptp_help(struct sk_buff **psk
 				       ctinfo);
 	DEBUGP("sstate: %d->%d, cstate: %d->%d\n",
 		oldsstate, info->sstate, oldcstate, info->cstate);
-	spin_unlock_bh(&nf_pptp_lock);
 
 	return ret;
 }
@@ -590,6 +587,7 @@ static struct nf_conntrack_helper pptp _
 	.mask.dst.protonum	= 0xff,
 	.help			= conntrack_pptp_help,
 	.destroy		= pptp_destroy_siblings,
+	.lock			= &nf_pptp_lock,
 };
 
 static int __init nf_conntrack_pptp_init(void)
diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_conntrack_sane.c
index eb2d1dc..bcd5238 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -97,7 +97,6 @@ static int help(struct sk_buff **pskb,
 
 	datalen = (*pskb)->len - dataoff;
 
-	spin_lock_bh(&nf_sane_lock);
 	sb_ptr = skb_header_pointer(*pskb, dataoff, datalen, sane_buffer);
 	BUG_ON(sb_ptr == NULL);
 
@@ -164,7 +163,6 @@ static int help(struct sk_buff **pskb,
 	nf_conntrack_expect_put(exp);
 
 out:
-	spin_unlock_bh(&nf_sane_lock);
 	return ret;
 }
 
@@ -214,6 +212,7 @@ static int __init nf_conntrack_sane_init
 			sane[i][j].timeout = 5 * 60;	/* 5 Minutes */
 			sane[i][j].me = THIS_MODULE;
 			sane[i][j].help = help;
+			sane[i][j].lock = &nf_sane_lock;
 			tmpname = &sane_names[i][j][0];
 			if (ports[i] == SANE_PORT)
 				sprintf(tmpname, "sane");
-- 
1.4.4
