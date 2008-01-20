From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/4] [NETFILTER]: ebtables: remove casts, use consts
Date: Sun, 20 Jan 2008 15:52:23 +0100
Message-ID: <47936027.5080806@trash.net>
References: <Pine.LNX.4.64.0801172110060.18447@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801172110390.18447@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59612 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbYATOxX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 09:53:23 -0500
In-Reply-To: <Pine.LNX.4.64.0801172110390.18447@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit cae15d95db223db34c6ac39953061e7aa8ebc7b1
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Thu Jan 17 19:40:51 2008 +0100
> 
>     [NETFILTER]: ebtables: remove casts, use consts
>     
>     Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

Applied, thanks.

> diff --git a/include/net/arp.h b/include/net/arp.h
> index 752eb47..c236270 100644
> --- a/include/net/arp.h
> +++ b/include/net/arp.h
> @@ -13,15 +13,17 @@ extern int	arp_find(unsigned char *haddr, struct sk_buff *skb);
>  extern int	arp_ioctl(struct net *net, unsigned int cmd, void __user *arg);
>  extern void     arp_send(int type, int ptype, __be32 dest_ip,
>  			 struct net_device *dev, __be32 src_ip,
> -			 unsigned char *dest_hw, unsigned char *src_hw, unsigned char *th);
> +			 const unsigned char *dest_hw,
> +			 const unsigned char *src_hw, const unsigned char *th);
>  extern int	arp_bind_neighbour(struct dst_entry *dst);
>  extern int	arp_mc_map(__be32 addr, u8 *haddr, struct net_device *dev, int dir);
>  extern void	arp_ifdown(struct net_device *dev);


This would have been better in a seperate patch though.

