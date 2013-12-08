From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipt_SYNPROXY: kernel panic caused by nullpointer dereference
Date: Sun, 8 Dec 2013 16:52:31 +0000
Message-ID: <20131208165231.GA1564@macbook.localnet>
References: <e9d26e1c009f406b1bb5a893aebc7771.squirrel@webmail.interwerk.de>
 <20131208100146.GA3840@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Nicki P." <xastx@gmx.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:65231 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768Ab3LHQwf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Dec 2013 11:52:35 -0500
Content-Disposition: inline
In-Reply-To: <20131208100146.GA3840@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Dec 08, 2013 at 11:01:46AM +0100, Pablo Neira Ayuso wrote:
> On Sun, Dec 08, 2013 at 08:16:00AM +0100, Nicki P. wrote:
> > hi,
> > 
> > when activating ipt_SYNPROXY with:
> > iptables -t raw -A PREROUTING -p tcp -d 1.2.3.4 --dport 80 --tcp-flags
> > SYN,ACK,RST,FIN SYN -j SYNPROXY
> >
> > and sending a SYN packet to port 80:
> > hping3 -S -d 64 1.2.3.4 -p 80
> > 
> > I get kernel panic:
> > http://goo.gl/L6dCz6
> >
> > I'm using kernel v3.12.2 and iptables v1.4.21. Am I doing something wrong,
> > or is it a bug?
> 
> You have to run this from the INPUT/FORWARD chain, SYNPROXY needs the
> routing information to work.

Let's fix that:

>From e5b31e75df3c3f9629900016a95336c04165d13f Mon Sep 17 00:00:00 2001
From: Patrick McHardy <kaber@trash.net>
Date: Sun, 8 Dec 2013 16:49:36 +0000
Subject: [PATCH] netfilter: SYNPROXY target: restrict to INPUT/FORWARD

Fix a crash in synproxy_send_tcp() when using the SYNPROXY target in the
PREROUTING chain caused by missing routing information.

Reported-by: Nicki P. <xastx@gmx.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/ipv4/netfilter/ipt_SYNPROXY.c  | 1 +
 net/ipv6/netfilter/ip6t_SYNPROXY.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/ipv4/netfilter/ipt_SYNPROXY.c b/net/ipv4/netfilter/ipt_SYNPROXY.c
index f13bd91..a313c3f 100644
--- a/net/ipv4/netfilter/ipt_SYNPROXY.c
+++ b/net/ipv4/netfilter/ipt_SYNPROXY.c
@@ -423,6 +423,7 @@ static void synproxy_tg4_destroy(const struct xt_tgdtor_param *par)
 static struct xt_target synproxy_tg4_reg __read_mostly = {
 	.name		= "SYNPROXY",
 	.family		= NFPROTO_IPV4,
+	.hooks		= (1 << NF_INET_LOCAL_IN) | (1 << NF_INET_FORWARD),
 	.target		= synproxy_tg4,
 	.targetsize	= sizeof(struct xt_synproxy_info),
 	.checkentry	= synproxy_tg4_check,
diff --git a/net/ipv6/netfilter/ip6t_SYNPROXY.c b/net/ipv6/netfilter/ip6t_SYNPROXY.c
index f78f41a..a0d1727 100644
--- a/net/ipv6/netfilter/ip6t_SYNPROXY.c
+++ b/net/ipv6/netfilter/ip6t_SYNPROXY.c
@@ -446,6 +446,7 @@ static void synproxy_tg6_destroy(const struct xt_tgdtor_param *par)
 static struct xt_target synproxy_tg6_reg __read_mostly = {
 	.name		= "SYNPROXY",
 	.family		= NFPROTO_IPV6,
+	.hooks		= (1 << NF_INET_LOCAL_IN) | (1 << NF_INET_FORWARD),
 	.target		= synproxy_tg6,
 	.targetsize	= sizeof(struct xt_synproxy_info),
 	.checkentry	= synproxy_tg6_check,
-- 
1.8.3.1

