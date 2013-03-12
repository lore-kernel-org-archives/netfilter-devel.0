From: Florian Westphal <fw@strlen.de>
Subject: Re: Unable to get NPTv6 to work with kernel 3.8.2
Date: Tue, 12 Mar 2013 07:11:01 +0100
Message-ID: <20130312061101.GB7938@breakpoint.cc>
References: <513DE42B.5070702@universe-factory.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Matthias Schiffer <mschiffer@universe-factory.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33981 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754860Ab3CLGLE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Mar 2013 02:11:04 -0400
Content-Disposition: inline
In-Reply-To: <513DE42B.5070702@universe-factory.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Matthias Schiffer <mschiffer@universe-factory.net> wrote:
> ip6tables -t nat -A OUTPUT -d fd00:0:0:3::/64 -j DNPT --src-pfx
> fd00:0:0:3::/64 --dst-pfx fd00:0:0:1::/64
[..]

This won't work, DNPT is stateless, the nat table is only consulted
for the first packet of a connection.

Use mangle instead, this should also take care of possible new
route due to changed dst address.

Any objections wrt. restricting NPT to mangle?

From: Florian Westphal <fw@strlen.de>
Subject: [PATCH] netfilter: ip6t_NPT: restrict to mangle table

As the translation is stateless, using it in nat table
doesn't work (only initial packet is translated).
filter table OUTPUT works but won't re-route the packet after translation.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
not even compile tested.

diff --git a/net/ipv6/netfilter/ip6t_NPT.c b/net/ipv6/netfilter/ip6t_NPT.c
index 83acc14..33608c6 100644
--- a/net/ipv6/netfilter/ip6t_NPT.c
+++ b/net/ipv6/netfilter/ip6t_NPT.c
@@ -114,6 +114,7 @@ ip6t_dnpt_tg(struct sk_buff *skb, const struct xt_action_param *par)
 static struct xt_target ip6t_npt_target_reg[] __read_mostly = {
 	{
 		.name		= "SNPT",
+		.table		= "mangle",
 		.target		= ip6t_snpt_tg,
 		.targetsize	= sizeof(struct ip6t_npt_tginfo),
 		.checkentry	= ip6t_npt_checkentry,
@@ -124,6 +125,7 @@ static struct xt_target ip6t_npt_target_reg[] __read_mostly = {
 	},
 	{
 		.name		= "DNPT",
+		.table		= "mangle",
 		.target		= ip6t_dnpt_tg,
 		.targetsize	= sizeof(struct ip6t_npt_tginfo),
 		.checkentry	= ip6t_npt_checkentry,
-- 
1.7.12.4

