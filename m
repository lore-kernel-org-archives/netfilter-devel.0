From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: kill redundant check code in which setting
 ip_summed value
Date: Mon, 14 Jun 2010 16:22:20 +0200
Message-ID: <4C163B1C.9010001@trash.net>
References: <4C109EED.2000405@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Shan Wei <shanwei@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51112 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189Ab0FNOWb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jun 2010 10:22:31 -0400
In-Reply-To: <4C109EED.2000405@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Shan Wei wrote:
> If the returned csum value is 0, We has set ip_summed with CHECKSUM_UNNECESSARY flag
> in __skb_checksum_complete_head(), 
>
> So this patch kills the check and changes to return to upper caller directly.
>
>   

Applied, thanks.

