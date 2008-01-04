From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 6/27] xt_CONNMARK target, revision 1
Date: Fri, 04 Jan 2008 15:41:41 +0100
Message-ID: <477E45A5.1060302@trash.net>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022126550.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48445 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbYADOon (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jan 2008 09:44:43 -0500
In-Reply-To: <Pine.LNX.4.64.0801022126550.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit ff3ddea4afa7f7b7735ae439bb1cd82e5413d99e
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Wed Jan 2 17:42:13 2008 +0100
> 
>     [NETFILTER]: xt_CONNMARK target, revision 1
>     
>     Introduces the xt_CONNMARK target revision 1. It uses fixed types, and
>     also uses the more expressive XOR logic. Futhermore, it allows to
>     selectively pick bits from both the ctmark and the nfmark in the SAVE
>     and RESTORE operations.

Applied with some minor cosmetic changes:

> +static unsigned int
> +connmark_tg(struct sk_buff *skb, const struct net_device *in,
> +            const struct net_device *out, unsigned int hooknum,
> +            const struct xt_target *target, const void *targinfo)
> +{
> +	const struct xt_connmark_tginfo1 *info = targinfo;
> +	enum ip_conntrack_info ctinfo;
> +	struct nf_conn *ct;
> +	u_int32_t newmark;
> +
> +	ct = nf_ct_get(skb, &ctinfo);
> +	if (ct == NULL)
> +		return XT_CONTINUE;
> +
> +	switch (info->mode) {
> +		case XT_CONNMARK_SET:

switch cases should not be indented deeper then the switch statement.
