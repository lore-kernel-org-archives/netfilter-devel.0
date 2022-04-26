Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2ACEC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Apr 2022 21:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349204AbiDZVIW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Apr 2022 17:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355079AbiDZVIV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Apr 2022 17:08:21 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 905D2E0A8
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Apr 2022 14:05:10 -0700 (PDT)
Date:   Tue, 26 Apr 2022 23:05:06 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Topi Miettinen <toiwoton@gmail.com>
Cc:     Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_socket: socket expressions for GID & UID
Message-ID: <Ymheglo+kQ/Hr7oT@salvia>
References: <20220420185447.10199-1-toiwoton@gmail.com>
 <6s7r50n6-r8qs-2295-sq7p-p46qoop97ssn@vanv.qr>
 <42cc8c5d-5874-79a2-61b6-e238c5a1a18f@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="F6b6hJBIi1pt3n7M"
Content-Disposition: inline
In-Reply-To: <42cc8c5d-5874-79a2-61b6-e238c5a1a18f@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--F6b6hJBIi1pt3n7M
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Thu, Apr 21, 2022 at 07:35:06PM +0300, Topi Miettinen wrote:
> On 21.4.2022 0.15, Jan Engelhardt wrote:
> > 
> > On Wednesday 2022-04-20 20:54, Topi Miettinen wrote:
> > 
> > > Add socket expressions for checking GID or UID of the originating
> > > socket. These work also on input side, unlike meta skuid/skgid.
> > 
> > Why exactly is it that meta skuid does not work?
> > Because of the skb_to_full_sk() call in nft_meta_get_eval_skugid()?
> 
> I don't know the details, but early demux isn't reliable and filters aren't
> run after final demux. In my case, something like "ct state new meta skuid <
> 1000 drop" as part of input filter doesn't do anything. Making "meta skuid"
> 100% reliable would be of course preferable to adding a new expression.

Could you give a try to this kernel patch?

This patch adds a new socket hook for inet layer 4 protocols, it is
coming after the NF_LOCAL_IN hook, where the socket information is
available for all cases.

You also need a small patch for userspace nft.

--F6b6hJBIi1pt3n7M
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="kernel-socket-hook.patch"

diff --git a/include/linux/netfilter_socket.h b/include/linux/netfilter_socket.h
new file mode 100644
index 000000000000..7acdb5463e14
--- /dev/null
+++ b/include/linux/netfilter_socket.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _NETFILTER_SOCKET_H_
+#define _NETFILTER_SOCKET_H_
+
+#include <linux/netfilter.h>
+
+static inline bool nf_hook_socket_active(struct net *net, const struct sk_buff *skb)
+{
+#ifdef CONFIG_JUMP_LABEL
+	if (!static_key_false(&nf_hooks_needed[NFPROTO_INET][NF_INET_SOCKET]))
+		return false;
+#endif
+	return rcu_access_pointer(net->nf.hooks_socket[0]);
+}
+
+/* caller must hold rcu_read_lock */
+static inline int nf_hook_socket(struct net *net, struct sk_buff *skb)
+{
+	struct nf_hook_entries *e = rcu_dereference(net->nf.hooks_socket[0]);
+	struct nf_hook_state state;
+	int ret;
+
+	if (unlikely(!e))
+		return 0;
+
+	nf_hook_state_init(&state, NF_INET_SOCKET,
+			   NFPROTO_INET, skb->dev, NULL, NULL,
+			   dev_net(skb->dev), NULL);
+	ret = nf_hook_slow(skb, &state, e, 0);
+	if (ret == 0)
+		return -1;
+
+	return ret;
+}
+
+#else /* CONFIG_NETFILTER_SOCKET */
+static inline int nf_hook_socket_active(struct sk_buff *skb)
+{
+	return 0;
+}
+
+static inline int nf_hook_socket(struct sk_buff *skb)
+{
+	return 0;
+}
+#endif /* _NETFILTER_SOCKET_H_ */
diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 20af9d3557b9..790c073629e8 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -15,7 +15,7 @@
 #include <net/flow_offload.h>
 #include <net/netns/generic.h>
 
-#define NFT_MAX_HOOKS	(NF_INET_INGRESS + 1)
+#define NFT_MAX_HOOKS	(NF_INET_SOCKET + 1)
 
 struct module;
 
diff --git a/include/net/netns/netfilter.h b/include/net/netns/netfilter.h
index b593f95e9991..d65922f0d65a 100644
--- a/include/net/netns/netfilter.h
+++ b/include/net/netns/netfilter.h
@@ -18,6 +18,7 @@ struct netns_nf {
 #endif
 	struct nf_hook_entries __rcu *hooks_ipv4[NF_INET_NUMHOOKS];
 	struct nf_hook_entries __rcu *hooks_ipv6[NF_INET_NUMHOOKS];
+	struct nf_hook_entries __rcu *hooks_socket[1];
 #ifdef CONFIG_NETFILTER_FAMILY_ARP
 	struct nf_hook_entries __rcu *hooks_arp[NF_ARP_NUMHOOKS];
 #endif
diff --git a/include/net/sock.h b/include/net/sock.h
index c4b91fc19b9c..4e40823d2a43 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2907,4 +2907,7 @@ static inline bool sk_is_readable(struct sock *sk)
 		return sk->sk_prot->sock_is_readable(sk);
 	return false;
 }
+
+int sk_inet_filter(struct sock *sk, struct sk_buff *skb, unsigned int cap);
+
 #endif	/* _SOCK_H */
diff --git a/include/uapi/linux/netfilter.h b/include/uapi/linux/netfilter.h
index 53411ccc69db..65c6691249e6 100644
--- a/include/uapi/linux/netfilter.h
+++ b/include/uapi/linux/netfilter.h
@@ -45,8 +45,9 @@ enum nf_inet_hooks {
 	NF_INET_FORWARD,
 	NF_INET_LOCAL_OUT,
 	NF_INET_POST_ROUTING,
+	NF_INET_INGRESS,
 	NF_INET_NUMHOOKS,
-	NF_INET_INGRESS = NF_INET_NUMHOOKS,
+	NF_INET_SOCKET = NF_INET_NUMHOOKS,
 };
 
 enum nf_dev_hooks {
diff --git a/net/core/sock.c b/net/core/sock.c
index 1180a0cb0110..19e7906f8955 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -129,6 +129,7 @@
 #include <net/cls_cgroup.h>
 #include <net/netprio_cgroup.h>
 #include <linux/sock_diag.h>
+#include <linux/netfilter_socket.h>
 
 #include <linux/filter.h>
 #include <net/sock_reuseport.h>
@@ -520,7 +521,7 @@ int __sk_receive_skb(struct sock *sk, struct sk_buff *skb,
 {
 	int rc = NET_RX_SUCCESS;
 
-	if (sk_filter_trim_cap(sk, skb, trim_cap))
+	if (sk_inet_filter(sk, skb, trim_cap))
 		goto discard_and_relse;
 
 	skb->dev = NULL;
@@ -3222,6 +3223,25 @@ void sk_stop_timer_sync(struct sock *sk, struct timer_list *timer)
 }
 EXPORT_SYMBOL(sk_stop_timer_sync);
 
+int sk_inet_filter(struct sock *sk, struct sk_buff *skb, unsigned int cap)
+{
+	struct net *net = sock_net(sk);
+	int ret;
+
+	ret = sk_filter_trim_cap(sk, skb, cap);
+	if (ret < 0)
+		return ret;
+
+	if (nf_hook_socket_active(net, skb)) {
+		ret = nf_hook_socket(net, skb);
+		if (ret == 0)
+			return -EPERM;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(sk_inet_filter);
+
 void sock_init_data(struct socket *sock, struct sock *sk)
 {
 	sk_init_common(sk);
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index eab3bd1ee9a0..0f7bffde01ae 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -593,7 +593,7 @@ static int dccp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 	if (skb->protocol == htons(ETH_P_IP))
 		return dccp_v4_do_rcv(sk, skb);
 
-	if (sk_filter(sk, skb))
+	if (sk_inet_filter(sk, skb, 1))
 		goto discard;
 
 	/*
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index f9cec624068d..0aa5af583f71 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1872,7 +1872,7 @@ int tcp_filter(struct sock *sk, struct sk_buff *skb)
 {
 	struct tcphdr *th = (struct tcphdr *)skb->data;
 
-	return sk_filter_trim_cap(sk, skb, th->doff * 4);
+	return sk_inet_filter(sk, skb, th->doff * 4);
 }
 EXPORT_SYMBOL(tcp_filter);
 
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 6b4d8361560f..ac4a64071ac7 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2211,7 +2211,7 @@ static int udp_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 	    udp_lib_checksum_complete(skb))
 			goto csum_error;
 
-	if (sk_filter_trim_cap(sk, skb, sizeof(struct udphdr))) {
+	if (sk_inet_filter(sk, skb, sizeof(struct udphdr))) {
 		drop_reason = SKB_DROP_REASON_SOCKET_FILTER;
 		goto drop;
 	}
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 7f0fa9bd9ffe..374bc818c94f 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -734,7 +734,7 @@ static int udpv6_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 	    udp_lib_checksum_complete(skb))
 		goto csum_error;
 
-	if (sk_filter_trim_cap(sk, skb, sizeof(struct udphdr)))
+	if (sk_inet_filter(sk, skb, sizeof(struct udphdr)))
 		goto drop;
 
 	udp_csum_pull_header(skb);
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index ddc54b6d18ee..3eb7d54225f5 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -18,6 +18,13 @@ config NETFILTER_EGRESS
 	  This allows you to classify packets before transmission using the
 	  Netfilter infrastructure.
 
+config NETFILTER_SOCKET
+	bool "Netfilter socket support"
+	default y
+	help
+	  This allows you to classify packets for local sockets using the
+	  Netfilter infrastructure.
+
 config NETFILTER_SKIP_EGRESS
 	def_bool NETFILTER_EGRESS && (NET_CLS_ACT || IFB)
 
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index dcf752b55a52..0dfdf69e389a 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -284,13 +284,17 @@ nf_hook_entry_head(struct net *net, int pf, unsigned int hooknum,
 #endif
 #ifdef CONFIG_NETFILTER_INGRESS
 	case NFPROTO_INET:
-		if (WARN_ON_ONCE(hooknum != NF_INET_INGRESS))
-			return NULL;
-		if (!dev || dev_net(dev) != net) {
-			WARN_ON_ONCE(1);
-			return NULL;
+		if (hooknum == NF_INET_INGRESS) {
+			if (!dev || dev_net(dev) != net) {
+				WARN_ON_ONCE(1);
+				return NULL;
+			}
+			return &dev->nf_hooks_ingress;
+		} else if (hooknum == NF_INET_SOCKET) {
+			return net->nf.hooks_socket;
 		}
-		return &dev->nf_hooks_ingress;
+		WARN_ON_ONCE(1);
+		return NULL;
 #endif
 	case NFPROTO_IPV4:
 		if (WARN_ON_ONCE(ARRAY_SIZE(net->nf.hooks_ipv4) <= hooknum))
@@ -523,7 +527,8 @@ static void __nf_unregister_net_hook(struct net *net, int pf,
 void nf_unregister_net_hook(struct net *net, const struct nf_hook_ops *reg)
 {
 	if (reg->pf == NFPROTO_INET) {
-		if (reg->hooknum == NF_INET_INGRESS) {
+		if (reg->hooknum == NF_INET_INGRESS ||
+		    reg->hooknum == NF_INET_SOCKET) {
 			__nf_unregister_net_hook(net, NFPROTO_INET, reg);
 		} else {
 			__nf_unregister_net_hook(net, NFPROTO_IPV4, reg);
@@ -553,7 +558,8 @@ int nf_register_net_hook(struct net *net, const struct nf_hook_ops *reg)
 	int err;
 
 	if (reg->pf == NFPROTO_INET) {
-		if (reg->hooknum == NF_INET_INGRESS) {
+		if (reg->hooknum == NF_INET_INGRESS ||
+		    reg->hooknum == NF_INET_SOCKET) {
 			err = __nf_register_net_hook(net, NFPROTO_INET, reg);
 			if (err < 0)
 				return err;
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index c3563f0be269..eceeebfd0ab2 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -201,7 +201,8 @@ static const struct nft_chain_type nft_chain_filter_inet = {
 			  (1 << NF_INET_LOCAL_OUT) |
 			  (1 << NF_INET_FORWARD) |
 			  (1 << NF_INET_PRE_ROUTING) |
-			  (1 << NF_INET_POST_ROUTING),
+			  (1 << NF_INET_POST_ROUTING) |
+			  (1 << NF_INET_SOCKET),
 	.hooks		= {
 		[NF_INET_INGRESS]	= nft_do_chain_inet_ingress,
 		[NF_INET_LOCAL_IN]	= nft_do_chain_inet,
@@ -209,6 +210,7 @@ static const struct nft_chain_type nft_chain_filter_inet = {
 		[NF_INET_FORWARD]	= nft_do_chain_inet,
 		[NF_INET_PRE_ROUTING]	= nft_do_chain_inet,
 		[NF_INET_POST_ROUTING]	= nft_do_chain_inet,
+		[NF_INET_SOCKET]	= nft_do_chain_inet,
         },
 };
 
diff --git a/net/sctp/input.c b/net/sctp/input.c
index 90e12bafdd48..2ea84d1f607f 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -203,7 +203,7 @@ int sctp_rcv(struct sk_buff *skb)
 		goto discard_release;
 	nf_reset_ct(skb);
 
-	if (sk_filter(sk, skb))
+	if (sk_inet_filter(sk, skb, 1))
 		goto discard_release;
 
 	/* Create an SCTP packet structure. */

--F6b6hJBIi1pt3n7M
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="nft.patch"

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 9e07888013e8..5fd054c42212 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -49,6 +49,7 @@ enum nf_inet_hooks {
 	NF_INET_LOCAL_OUT,
 	NF_INET_POST_ROUTING,
 	NF_INET_INGRESS,
+	NF_INET_SOCKET,
 	NF_INET_NUMHOOKS
 };
 
diff --git a/src/evaluate.c b/src/evaluate.c
index b5f74d2f5051..03c18f413b09 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4465,6 +4465,8 @@ static uint32_t str2hooknum(uint32_t family, const char *hook)
 	case NFPROTO_INET:
 		if (!strcmp(hook, "ingress"))
 			return NF_INET_INGRESS;
+		if (!strcmp(hook, "socket"))
+			return NF_INET_SOCKET;
 		/* fall through */
 	case NFPROTO_IPV4:
 	case NFPROTO_BRIDGE:
diff --git a/src/parser_bison.y b/src/parser_bison.y
index ca5c488cd5ff..046ce92c0ab6 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -618,8 +618,8 @@ int nft_lex(void *, void *, void *);
 %type <limit_rate>		limit_rate_pkts
 %type <limit_rate>		limit_rate_bytes
 
-%type <string>			identifier type_identifier string comment_spec
-%destructor { xfree($$); }	identifier type_identifier string comment_spec
+%type <string>			identifier type_identifier string comment_spec hook_str
+%destructor { xfree($$); }	identifier type_identifier string comment_spec hook_str
 
 %type <val>			time_spec quota_used
 
@@ -2390,7 +2390,11 @@ type_identifier		:	STRING	{ $$ = $1; }
 			|	CLASSID { $$ = xstrdup("classid"); }
 			;
 
-hook_spec		:	TYPE		close_scope_type	STRING		HOOK		STRING		dev_spec	prio_spec
+hook_str		:	STRING { $$ = $1; }
+			|	SOCKET { $$ = xstrdup("socket"); }
+			;
+
+hook_spec		:	TYPE		close_scope_type	STRING		HOOK		hook_str	dev_spec	prio_spec
 			{
 				const char *chain_type = chain_type_name_lookup($3);
 
diff --git a/src/rule.c b/src/rule.c
index 799092eb15c5..b05351144c62 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -677,6 +677,7 @@ static const char * const chain_hookname_str_array[] = {
 	"output",
 	"ingress",
 	"egress",
+	"socket",
 	NULL,
 };
 
@@ -815,6 +816,8 @@ const char *hooknum2str(unsigned int family, unsigned int hooknum)
 			return "output";
 		case NF_INET_INGRESS:
 			return "ingress";
+		case NF_INET_SOCKET:
+			return "socket";
 		default:
 			break;
 		};

--F6b6hJBIi1pt3n7M--
