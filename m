From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 25/27] Merge ipt_ah and ip6t_ah into xt_ah
Date: Tue, 08 Jan 2008 17:03:48 +0100
Message-ID: <47839EE4.4000601@trash.net>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022133440.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63464 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760746AbYAHQHq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:07:46 -0500
In-Reply-To: <Pine.LNX.4.64.0801022133440.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 11c4c687b1df11aeadd9ab76f37c4a89144d9a73
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Wed Jan 2 20:14:28 2008 +0100
> 
>     [NETFILTER]: Merge ipt_ah and ip6t_ah into xt_ah
>     

> +	err = ipv6_find_hdr(skb, &ptr, NEXTHDR_AUTH, NULL);


This also adds a ipv6 dependency. For other modules I used
ipv6_skip_exthdr, but this doesn't work in this case since
AH is an extension header.


