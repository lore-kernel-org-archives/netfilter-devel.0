From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_owner-xt_socket plans
Date: Tue, 22 Jan 2008 00:22:56 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801211539020.25080@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801201914260.14598@fbirervta.pbzchgretzou.qr>
 <479461C2.1060703@balabit.hu> <Pine.LNX.4.64.0801211417200.24186@fbirervta.pbzchgretzou.qr>
 <4794AB98.1050607@balabit.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	KOVACS Krisztian <hidden@sch.bme.hu>
To: Laszlo Attila Toth <panther@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:47911 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762388AbYAUXW6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2008 18:22:58 -0500
In-Reply-To: <4794AB98.1050607@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 21 2008 15:26, Laszlo Attila Toth wrote:
>> Here is what I had in mind, please have a look.
>> http://dev.computergmbh.de/gitweb.cgi?p=linux;h=dev-xtsocket;a=shortlog
>
> The following snippet of socket_mt_get() should be in socket_mt():
>
>       if (sk != NULL)
>                 nf_tproxy_put_sock(sk);
>
> The socket buffer is first referenced by nf_tproxy_get_v4() then
> immediately released (put back) also it is not garanteed that the
> socket is valid.

Ok.

> Furthermore I don't know whether the sk->sk_socket is valid through
> the whole function in a multiprocessor environment (the program,
> that opened it, may close the socket).

For the input path, nf_tproxy_get_v4 will up sk->sk_refcnt which 
should prevent sk->file from going away.
For the output path I suppose our caller holds sk->sk_refcnt.
Well if anyone knows better, let me know.

> The tproxy lookup only works with tcp and udp, and afaik the original owner
> match also limited to these protocols, also it can be tested in
> socket_mt4_check()
>
> I noticed that you forgot rename the match to "socket" in socket_mt_reg[].

That is intended - it is the old owner match revision 0
(ipt_owner/ip6t_owner).

This is how it would look then:
commit 807482809f619a167d3dd349553d621ee4cd3b48
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Mon Jan 21 14:08:27 2008 +0100

    [NETFILTER]: xt_socket: input path processing
    
    tproxy adds a function for socket lookup; xt_socket can use this to
    be usable in the PREROUTING and INPUT chains.
    (This code has not been compile tested, but serves as an example.)
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index 07d681c..1deacb2 100644
--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -76,17 +76,46 @@ owner_mt6_v0(const struct sk_buff *skb, const struct net_device *in,
 	return true;
 }
 
+static struct sock *
+socket_mt_getsock(const struct sk_buff *skb, const struct net_device *in)
+{
+#ifdef CONFIG_NETFILTER_TPROXY
+	const struct iphdr *iph = ip_hdr(skb);
+	const struct udphdr *udph;
+	struct udphdr udphdr;
+
+	if (iph->protocol != IPPROTO_TCP && iph->protocol != IPPROTO_UDP &&
+	    iph->protocol != IPPROTO_UDPLITE)
+		return false;
+
+	/*
+	 * All the protocols that are currently supported (see above if
+	 * statement) have source and destination port at the same position,
+	 * so we can use this udph shortcut. Why UDP? The struct is the
+	 * smallest.
+	 */
+	udph = skb_header_pointer(skb, ip_hdrlen(skb), udphdr, sizeof(udphdr));
+	if (udph == NULL)
+		return NULL;
+
+	return nf_tproxy_get_v4(iph->protocol, iph->saddr, iph->daddr,
+	                        hp->source, hp->dest, in, false);
+#endif
+	return NULL;
+}
+
+static void socket_mt_putsock(struct sock *sk)
+{
+#ifdef CONFIG_NETFILTER_TPROXY
+	nf_tproxy_put_sock(sk);
+#endif
+}
+
 static bool
-socket_mt(const struct sk_buff *skb, const struct net_device *in,
-          const struct net_device *out, const struct xt_match *match,
-          const void *matchinfo, int offset, unsigned int protoff,
-          bool *hotdrop)
+socket_mt_match(const struct sock *sk, const struct xt_socket_mtinfo *info)
 {
-	const struct xt_socket_mtinfo *info = matchinfo;
 	const struct file *filp;
-	const struct sock *sk;
 
-	sk = skb->sk;
 	if (sk == NULL || sk->sk_socket == NULL)
 		return (info->match ^ info->invert) == 0;
 	else if (info->match & info->invert & XT_SOCKET_EXISTS)
@@ -117,6 +146,25 @@ socket_mt(const struct sk_buff *skb, const struct net_device *in,
 }
 
 static bool
+socket_mt(const struct sk_buff *skb, const struct net_device *in,
+          const struct net_device *out, const struct xt_match *match,
+          const void *matchinfo, int offset, unsigned int protoff,
+          bool *hotdrop)
+{
+	struct sock *tpsk = NULL;
+	const struct sock *sk;
+	bool ret;
+
+	sk = skb->sk;
+	if (sk == NULL && in != NULL && match->family == AF_INET)
+		sk = tpsk = socket_mt_getsock(skb, in);
+	ret = socket_mt_match(sk, matchinfo);
+	if (tpsk != NULL)
+		socket_mt_putsock(tpsk);
+	return ret;
+}
+
+static bool
 owner_mt_check_v0(const char *tablename, const void *ip,
                   const struct xt_match *match, void *matchinfo,
                   unsigned int hook_mask)
@@ -149,6 +197,22 @@ owner_mt6_check_v0(const char *tablename, const void *ip,
 	return true;
 }
 
+static bool
+socket_mt4_check(const char *tablename, const void *ip,
+                 const struct xt_match *match, void *matchinfo,
+                 unsigned int hook_mask)
+{
+#ifndef CONFIG_NETFILTER_TPROXY
+	if (hook_mask & (NF_INET_PRE_ROUTING | NF_INET_LOCAL_IN)) {
+		printk(KERN_WARNING KBUILD_MODNAME
+			       ": Use in PREROUTING and INPUT chains only "
+			       "possible with tproxy\n");
+		return false;
+	}
+#endif
+	return true;
+}
+
 static struct xt_match socket_mt_reg[] __read_mostly = {
 	{
 		.name       = "owner",
@@ -178,7 +242,10 @@ static struct xt_match socket_mt_reg[] __read_mostly = {
 		.family     = AF_INET,
 		.match      = socket_mt,
 		.matchsize  = sizeof(struct xt_socket_mtinfo),
-		.hooks      = (1 << NF_INET_LOCAL_OUT) |
+		.checkentry = socket_mt4_check,
+		.hooks      = (1 << NF_INET_PRE_ROUTING) |
+		              (1 << NF_INET_LOCAL_IN) |
+		              (1 << NF_INET_LOCAL_OUT) |
 		              (1 << NF_INET_POST_ROUTING),
 		.me         = THIS_MODULE,
 	},
@@ -196,6 +263,13 @@ static struct xt_match socket_mt_reg[] __read_mostly = {
 
 static int __init socket_mt_init(void)
 {
+#ifdef CONFIG_NETFILTER_TPROXY
+	printk(KERN_INFO KBUILD_MODNAME
+	       ": Input path socket lookup for IPv4 via tproxy.\n");
+#else
+	printk(KERN_INFO KBUILD_MODNAME
+	       ": No socket lookup for PREROUTING/INPUT available.\n");
+#endif
 	return xt_register_matches(socket_mt_reg, ARRAY_SIZE(socket_mt_reg));
 }
 
