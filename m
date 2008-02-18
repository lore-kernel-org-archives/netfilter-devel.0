From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_conntrack structure size
Date: Mon, 18 Feb 2008 16:13:12 +0100
Message-ID: <47B9A088.4050501@trash.net>
References: <Pine.LNX.4.64.0802170208520.25183@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:52951 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753576AbYBRPOF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Feb 2008 10:14:05 -0500
In-Reply-To: <Pine.LNX.4.64.0802170208520.25183@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> talking with SiegeX6 on IRC we found consensus that the struct 
> xt_conntrack_mtinfo1 is just too fat -- 88 bytes if I counted right. 64 
> of that go away for supporting IPv6 masking, which is plenty. We could 
> use a uint8_t CIDR field instead of 'union nf_inet_addr origsrc_mask', 
> and use a lookup table:
> static const struct {
> 	union nf_inet_addr expanded;
> 	unsigned char contracted;
> } table[] = {
> 	{IN6_ADDR(0000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0), 0},
> 	{IN6_ADDR(8000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0), 1},
> 	{IN6_ADDR(c000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0), 2},
> 	{IN6_ADDR(e000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0), 3}, 
> 	{IN6_ADDR(f000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0), 4},
> 	{IN6_ADDR(f800,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0), 5},
> 	/* and so on */
> };
> This would cost us 2048 bytes once. Everything that uses IPv6 
> CIDR<->mask transformation could use this.
> 
> - xt_conntrack: save 60 bytes per struct
> 
> - xt_hashlimit: save on some static computation power
>   (currently, xt_hashlimit computes the mask from CIDR during
>   rule insertion)
> 
> - xt_connlimit: save 15 bytes per struct (realistically: 12, due to 
> aligned(8) padding)
> 
> - xt_policy: save 30 bytes per struct (realistically 24)
> 
> - ipt_entry, ip6t_entry: basically, these too, but it would touch
>   a non-revisionable structure - can't break it
> 
> - probably tons of other code in non-netfilter areas in net/
> 
> Are there any objections to having this big table?


Not against the table itself, but I would like to keep the
different revisions to the necessary minimum.

