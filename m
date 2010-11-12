From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: ipv6: fix overlap check for fragments
Date: Fri, 12 Nov 2010 08:52:57 +0100
Message-ID: <4CDCF259.5070601@trash.net>
References: <4CD3F0F8.5030205@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: nicolas.dichtel@6wind.com, David Miller <davem@davemloft.net>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	netfilter-devel@vger.kernel.org
To: Shan Wei <shanwei@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56293 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab0KLHw4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Nov 2010 02:52:56 -0500
In-Reply-To: <4CD3F0F8.5030205@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 05.11.2010 12:56, Shan Wei wrote:
> The type of FRAG6_CB(prev)->offset is int, skb->len is *unsigned* int,
> and offset is int.
> 
> Without this patch, type conversion occurred to this expression, when
> (FRAG6_CB(prev)->offset + prev->len) is less than offset.

Applied, thanks Shan.
