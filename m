From: Patrick McHardy <kaber@trash.net>
Subject: Re: 6/7 [NETFILTER]: Use NFPROTO_* in extensions
Date: Thu, 04 Sep 2008 17:05:43 +0200
Message-ID: <48BFF947.5070201@trash.net>
References: <alpine.LNX.1.10.0808131925160.13154@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0808131943000.13154@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000405000102000507020307"
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63855 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbYIDPFo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Sep 2008 11:05:44 -0400
In-Reply-To: <alpine.LNX.1.10.0808131943000.13154@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000405000102000507020307
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Jan Engelhardt wrote:
> commit 13b7a78eb14ed69f0dcd2af48d39b2284a2c9aed
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Sun Aug 10 17:46:39 2008 -0400
> 
> [NETFILTER]: Use NFPROTO_* in extensions

Applied with two minor fixups, one for the reject resulting
from not applying the xt_length patch, one in arptable_filter
for unknown reasons.


--------------000405000102000507020307
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index 984d05d..bee3d11 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -89,21 +89,21 @@ static struct nf_hook_ops arpt_ops[] __read_mostly = {
 	{
 		.hook		= arpt_in_hook,
 		.owner		= THIS_MODULE,
-		.pf		= NF_ARP,
+		.pf		= NFPROTO_ARP,
 		.hooknum	= NF_ARP_IN,
 		.priority	= NF_IP_PRI_FILTER,
 	},
 	{
 		.hook		= arpt_out_hook,
 		.owner		= THIS_MODULE,
-		.pf		= NF_ARP,
+		.pf		= NFPROTO_ARP,
 		.hooknum	= NF_ARP_OUT,
 		.priority	= NF_IP_PRI_FILTER,
 	},
 	{
 		.hook		= arpt_forward_hook,
 		.owner		= THIS_MODULE,
-		.pf		= NF_ARP,
+		.pf		= NFPROTO_ARP,
 		.hooknum	= NF_ARP_FORWARD,
 		.priority	= NF_IP_PRI_FILTER,
 	},
diff --git a/net/netfilter/xt_length.c b/net/netfilter/xt_length.c
index b8640f9..b8612d1 100644
--- a/net/netfilter/xt_length.c
+++ b/net/netfilter/xt_length.c
@@ -48,14 +48,14 @@ length_mt6(const struct sk_buff *skb, const struct net_device *in,
 static struct xt_match length_mt_reg[] __read_mostly = {
 	{
 		.name		= "length",
-		.family		= AF_INET,
+		.family		= NFPROTO_IPV4,
 		.match		= length_mt,
 		.matchsize	= sizeof(struct xt_length_info),
 		.me		= THIS_MODULE,
 	},
 	{
 		.name		= "length",
-		.family		= AF_INET6,
+		.family		= NFPROTO_IPV6,
 		.match		= length_mt6,
 		.matchsize	= sizeof(struct xt_length_info),
 		.me		= THIS_MODULE,

--------------000405000102000507020307--
