From: Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH net-next] netfilter:ipvs: use kmemdup
Date: Mon, 7 Mar 2011 14:04:56 +0900
Message-ID: <20110307050456.GA2811@verge.net.au>
References: <4D743ED6.5010608@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Wensong Zhang <wensong@linux-vs.org>, ja@ssi.bg,
	Patrick McHardy <kaber@trash.net>, lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: Shan Wei <shanwei@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:36705 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab1CGFFE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2011 00:05:04 -0500
Content-Disposition: inline
In-Reply-To: <4D743ED6.5010608@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 07, 2011 at 10:11:34AM +0800, Shan Wei wrote:
> The semantic patch that makes this output is available
> in scripts/coccinelle/api/memdup.cocci.
> 
> More information about semantic patching is available at
> http://coccinelle.lip6.fr/

Thanks, applied.
