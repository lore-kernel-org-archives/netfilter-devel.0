From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Unique symbol names
Date: Sat, 20 Oct 2007 17:09:10 +0200
Message-ID: <471A1A16.4000005@trash.net>
References: <Pine.LNX.4.64.0710201216251.1997@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33405 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbXJTPKK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Oct 2007 11:10:10 -0400
In-Reply-To: <Pine.LNX.4.64.0710201216251.1997@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> Give the target, match, check, etc. functions unique names.
>
>  static unsigned int
> -target(struct sk_buff *skb,
> -       const struct net_device *in,
> -       const struct net_device *out,
> -       unsigned int hooknum,
> -       const struct xt_target *target,
> -       const void *targinfo)
> +CLUSTERIP_target(struct sk_buff *skb, const struct net_device *in,
> +                 const struct net_device *out, unsigned int hooknum,
> +                 const struct xt_target *target, const void *targinfo)
>  {

I don't really like this naming scheme since it uses capital letters
in the function name. The _target prefix should be enough to distinguish
matches and targets, no?


