From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nft iptable-compat and TCPMSS target
Date: Tue, 3 Feb 2015 19:04:15 +0100
Message-ID: <20150203180415.GA14644@salvia>
References: <364870882.1567460.1420807001598.JavaMail.zimbra@tpip.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="J/dobhs11T7y2rNN"
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Andreas Schultz <aschultz@tpip.net>
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <364870882.1567460.1420807001598.JavaMail.zimbra@tpip.net>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 09, 2015 at 12:36:41PM +0000, Andreas Schultz wrote:
> Hi,
> 
> A few xt targets do check that the match condition is correct for them.
> xt_TCPMSS is one of them. Since nft_compat does not (and probably can
> not) pass the match condition into the target check, the target check
> will fail.
> 
> So all xt targets that perform checks on their match conditions are
> unusable with nft_compat.
> 
> Is this expected behavior or a bug?

It's known issue, see:

http://www.spinics.net/lists/netfilter-devel/msg23831.html

But we already resolved the problem for all of the extensions that
that email indicates.

The only two affected extensions so far I can track on the tree are
TCPMSS and CLUSTERIP.

CLUSTERIP is supersedes by xt_cluster, and it's known to have problems
with dynamic interfaces.

TCPMSS would be good to have access to it from nft_compat.

I'm attaching an untested patch to address this.

--J/dobhs11T7y2rNN
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-RFC-netfilter-fix-crash-in-CLUSTERIP-and-TCPMSS-when.patch"

>From 43c161caa656fb032fd4f12db2bda3e5083efd2b Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 3 Feb 2015 18:19:30 +0100
Subject: [PATCH] [RFC] netfilter: fix crash in CLUSTERIP and TCPMSS when used
 from nft_compat

Currently, we have two iptables extensions that cannot be used from the
xt over nft compat layer. The problem is that both need to real access
to the full blown ipt_entry to validate that the rule comes with the
right dependencies. This check was introduced to overcome the lack of
sufficient userspace dependency validation in iptables.

To resolve this problem, this patch introduces a new field to the
xt_tgchk_param structure that tell us if the target is executed from
nft_compat context.

The two affected extensions are:

1) CLUSTERIP, this target has been supersedes by xt_cluster. So just
   bail out by returning -EOPNOTSUPP.

2) TCPMSS. Relax the checking when used from nft_compat and make sure
   that we skip !syn packets in case userspace provides a wrong
   configuration. This allows us to use this feature from nft_compat.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/x_tables.h |    1 +
 net/ipv4/netfilter/ipt_CLUSTERIP.c |    5 +++++
 net/netfilter/nft_compat.c         |    1 +
 net/netfilter/xt_TCPMSS.c          |   26 +++++++++++++++++++-------
 4 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index a3e215b..a7bbfc4e 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -92,6 +92,7 @@ struct xt_tgchk_param {
 	void *targinfo;
 	unsigned int hook_mask;
 	u_int8_t family;
+	bool nft_compat;
 };
 
 /* Target destructor parameters */
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index e90f83a..f5ee75f 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -367,6 +367,11 @@ static int clusterip_tg_check(const struct xt_tgchk_param *par)
 	struct clusterip_config *config;
 	int ret;
 
+	if (par->nft_compat) {
+		pr_err("cannot use this target from nftables compat\n");
+		return -EOPNOTSUPP;
+	}
+
 	if (cipinfo->hash_mode != CLUSTERIP_HASHMODE_SIP &&
 	    cipinfo->hash_mode != CLUSTERIP_HASHMODE_SIP_SPT &&
 	    cipinfo->hash_mode != CLUSTERIP_HASHMODE_SIP_SPT_DPT) {
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 265e190..f463099 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -114,6 +114,7 @@ nft_target_set_tgchk_param(struct xt_tgchk_param *par,
 		par->hook_mask = 0;
 	}
 	par->family	= ctx->afi->family;
+	par->nft_compat = true;
 }
 
 static void target_compat_from_user(struct xt_target *t, void *in, void *out)
diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index e762de5..cb3b5c1 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -83,7 +83,7 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 		     unsigned int minlen)
 {
 	const struct xt_tcpmss_info *info = par->targinfo;
-	struct tcphdr *tcph;
+	struct tcphdr *tcph, _tcph;
 	int len, tcp_hdrlen;
 	unsigned int i;
 	__be16 oldval;
@@ -94,19 +94,22 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 	if (par->fragoff != 0)
 		return 0;
 
-	if (!skb_make_writable(skb, skb->len))
-		return -1;
+	tcph = skb_header_pointer(skb, tcphoff, sizeof(_tcph), &_tcph);
+	if (!tcph)
+		return 0;
 
-	len = skb->len - tcphoff;
-	if (len < (int)sizeof(struct tcphdr))
-		return -1;
+	if (unlikely(!tcph->syn))
+		return 0;
 
-	tcph = (struct tcphdr *)(skb_network_header(skb) + tcphoff);
 	tcp_hdrlen = tcph->doff * 4;
+	len = skb->len - tcphoff;
 
 	if (len < tcp_hdrlen)
 		return -1;
 
+	if (!skb_make_writable(skb, skb->len))
+		return -1;
+
 	if (info->mss == XT_TCPMSS_CLAMP_PMTU) {
 		struct net *net = dev_net(par->in ? par->in : par->out);
 		unsigned int in_mtu = tcpmss_reverse_mtu(net, skb, family);
@@ -277,6 +280,12 @@ static int tcpmss_tg4_check(const struct xt_tgchk_param *par)
 			"FORWARD, OUTPUT and POSTROUTING hooks\n");
 		return -EINVAL;
 	}
+	/* Don't care about rules without --syn from nftables compat. The
+	 * packet is safe, it just skips non-syn packets.
+	 */
+	if (par->nft_compat)
+		return 0;
+
 	xt_ematch_foreach(ematch, e)
 		if (find_syn_match(ematch))
 			return 0;
@@ -299,6 +308,9 @@ static int tcpmss_tg6_check(const struct xt_tgchk_param *par)
 			"FORWARD, OUTPUT and POSTROUTING hooks\n");
 		return -EINVAL;
 	}
+	if (par->nft_compat)
+		return 0;
+
 	xt_ematch_foreach(ematch, e)
 		if (find_syn_match(ematch))
 			return 0;
-- 
1.7.10.4


--J/dobhs11T7y2rNN--
