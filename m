From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nf_nat: fix buffer overflow in IRC NAT
 helper
Date: Mon, 6 Jan 2014 14:04:44 +0100
Message-ID: <20140106130444.GA8155@localhost>
References: <1388503719-17766-1-git-send-email-dborkman@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="a8Wt8u1KmwUX3Y2C"
Cc: netfilter-devel@vger.kernel.org,
	Harald Welte <laforge@gnumonks.org>
To: Daniel Borkmann <dborkman@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56878 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbaAFNEx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 08:04:53 -0500
Content-Disposition: inline
In-Reply-To: <1388503719-17766-1-git-send-email-dborkman@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Daniel,

On Tue, Dec 31, 2013 at 04:28:39PM +0100, Daniel Borkmann wrote:
> diff --git a/net/netfilter/nf_nat_irc.c b/net/netfilter/nf_nat_irc.c
> index f02b360..fbbb1e6 100644
> --- a/net/netfilter/nf_nat_irc.c
> +++ b/net/netfilter/nf_nat_irc.c
> @@ -34,10 +34,14 @@ static unsigned int help(struct sk_buff *skb,
>  			 struct nf_conntrack_expect *exp)
>  {
>  	char buffer[sizeof("4294967296 65635")];
> +	struct nf_conn *ct = exp->master;
> +	union nf_inet_addr newaddr;
>  	u_int16_t port;
>  	unsigned int ret;
>  
>  	/* Reply comes from server. */
> +	newaddr = ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3;
> +
>  	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;
>  	exp->dir = IP_CT_DIR_REPLY;
>  	exp->expectfn = nf_nat_follow_master;
> @@ -57,17 +61,41 @@ static unsigned int help(struct sk_buff *skb,
>  	}
>  
>  	if (port == 0) {
> -		nf_ct_helper_log(skb, exp->master, "all ports in use");
> +		nf_ct_helper_log(skb, ct, "all ports in use");
>  		return NF_DROP;
>  	}
>  
> -	ret = nf_nat_mangle_tcp_packet(skb, exp->master, ctinfo,
> -				       protoff, matchoff, matchlen, buffer,
> -				       strlen(buffer));
> +	/* strlen("\1DCC CHAT chat AAAAAAAA P\1\n")=27
> +	 * strlen("\1DCC SCHAT chat AAAAAAAA P\1\n")=28
> +	 * strlen("\1DCC SEND F AAAAAAAA P S\1\n")=26
> +	 * strlen("\1DCC MOVE F AAAAAAAA P S\1\n")=26
> +	 * strlen("\1DCC TSEND F AAAAAAAA P S\1\n")=27
> +	 *
> +	 * AAAAAAAAA: bound addr (1.0.0.0==16777216, min 8 digits,
> +	 *                        255.255.255.255==4294967296, 10 digits)
> +	 * P:         bound port (min 1 d, max 5d (65635))
> +	 * F:         filename   (min 1 d )
> +	 * S:         size       (min 1 d )
> +	 * 0x01, \n:  terminators
> +	 */
> +	/* AAA = "us", ie. where server normally talks to. */
> +	if (nf_ct_l3num(ct) == NFPROTO_IPV4) {
> +		snprintf(buffer, sizeof(buffer), "%u %u",
> +			 ntohl(newaddr.ip), port);
> +		pr_debug("nf_nat_irc: inserting '%s' == %pI4, port %u\n",
> +			 buffer, &newaddr.ip, port);
> +	} else {
> +		nf_ct_helper_log(skb, ct, "IPv6 DCC unsupported for now");
> +		return NF_DROP;
> +	}

I have mangled your patch (see attachment) to remove this branch since
there is real IPv6 support for IRC yet in master. We'll need to
revisit this anyway when finishing IPv6 support to the IRC helper. Let
me know if you have any concern with this. Thanks.

--a8Wt8u1KmwUX3Y2C
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-nf_nat-fix-access-to-uninitialized-buffer-.patch"

>From 3e2bfa06c86a51cfcfec7933c28daf952d5714b9 Mon Sep 17 00:00:00 2001
From: Daniel Borkmann <dborkman@redhat.com>
Date: Tue, 31 Dec 2013 16:28:39 +0100
Subject: [PATCH] netfilter: nf_nat: fix access to uninitialized buffer in IRC
 NAT helper

Commit 5901b6be885e attempted to introduce IPv6 support into
IRC NAT helper. By doing so, the following code seemed to be removed
by accident:

  ip = ntohl(exp->master->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3.ip);
  sprintf(buffer, "%u %u", ip, port);
  pr_debug("nf_nat_irc: inserting '%s' == %pI4, port %u\n", buffer, &ip, port);

This leads to the fact that buffer[] was left uninitialized and
contained some stack value. When we call nf_nat_mangle_tcp_packet(),
we call strlen(buffer) on excatly this uninitialized buffer. If we
are unlucky and the skb has enough tailroom, we overwrite resp. leak
contents with values that sit on our stack into the packet and send
that out to the receiver.

Since the rather informal DCC spec [1] does not seem to specify
IPv6 support right now, we log such occurences so that admins can
act accordingly, and drop the packet. I've looked into XChat source,
and IPv6 is not supported there: addresses are in u32 and print
via %u format string.

Therefore, restore old behaviour as in IPv4, use snprintf(). The
IRC helper does not support IPv6 by now. By this, we can safely use
strlen(buffer) in nf_nat_mangle_tcp_packet() and prevent a buffer
overflow. Also simplify some code as we now have ct variable anyway.

  [1] http://www.irchelp.org/irchelp/rfc/ctcpspec.html

Fixes: 5901b6be885e ("netfilter: nf_nat: support IPv6 in IRC NAT helper")
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Cc: Harald Welte <laforge@gnumonks.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_nat_irc.c |   32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_nat_irc.c b/net/netfilter/nf_nat_irc.c
index f02b360..1fb2258 100644
--- a/net/netfilter/nf_nat_irc.c
+++ b/net/netfilter/nf_nat_irc.c
@@ -34,10 +34,14 @@ static unsigned int help(struct sk_buff *skb,
 			 struct nf_conntrack_expect *exp)
 {
 	char buffer[sizeof("4294967296 65635")];
+	struct nf_conn *ct = exp->master;
+	union nf_inet_addr newaddr;
 	u_int16_t port;
 	unsigned int ret;
 
 	/* Reply comes from server. */
+	newaddr = ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3;
+
 	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;
 	exp->dir = IP_CT_DIR_REPLY;
 	exp->expectfn = nf_nat_follow_master;
@@ -57,17 +61,35 @@ static unsigned int help(struct sk_buff *skb,
 	}
 
 	if (port == 0) {
-		nf_ct_helper_log(skb, exp->master, "all ports in use");
+		nf_ct_helper_log(skb, ct, "all ports in use");
 		return NF_DROP;
 	}
 
-	ret = nf_nat_mangle_tcp_packet(skb, exp->master, ctinfo,
-				       protoff, matchoff, matchlen, buffer,
-				       strlen(buffer));
+	/* strlen("\1DCC CHAT chat AAAAAAAA P\1\n")=27
+	 * strlen("\1DCC SCHAT chat AAAAAAAA P\1\n")=28
+	 * strlen("\1DCC SEND F AAAAAAAA P S\1\n")=26
+	 * strlen("\1DCC MOVE F AAAAAAAA P S\1\n")=26
+	 * strlen("\1DCC TSEND F AAAAAAAA P S\1\n")=27
+	 *
+	 * AAAAAAAAA: bound addr (1.0.0.0==16777216, min 8 digits,
+	 *                        255.255.255.255==4294967296, 10 digits)
+	 * P:         bound port (min 1 d, max 5d (65635))
+	 * F:         filename   (min 1 d )
+	 * S:         size       (min 1 d )
+	 * 0x01, \n:  terminators
+	 */
+	/* AAA = "us", ie. where server normally talks to. */
+	snprintf(buffer, sizeof(buffer), "%u %u", ntohl(newaddr.ip), port);
+	pr_debug("nf_nat_irc: inserting '%s' == %pI4, port %u\n",
+		 buffer, &newaddr.ip, port);
+
+	ret = nf_nat_mangle_tcp_packet(skb, ct, ctinfo, protoff, matchoff,
+				       matchlen, buffer, strlen(buffer));
 	if (ret != NF_ACCEPT) {
-		nf_ct_helper_log(skb, exp->master, "cannot mangle packet");
+		nf_ct_helper_log(skb, ct, "cannot mangle packet");
 		nf_ct_unexpect_related(exp);
 	}
+
 	return ret;
 }
 
-- 
1.7.10.4


--a8Wt8u1KmwUX3Y2C--
