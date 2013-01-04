From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: fix IPv6 NTP checksum calculation
Date: Fri, 4 Jan 2013 20:22:52 +0100
Message-ID: <20130104192252.GA17684@1984>
References: <20130102152440.GA3760@uweber-WS>
 <20130104092042.GB28028@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ulrich Weber <ulrich.weber@sophos.com>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42943 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754381Ab3ADTXA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jan 2013 14:23:00 -0500
Content-Disposition: inline
In-Reply-To: <20130104092042.GB28028@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 04, 2013 at 10:20:43AM +0100, Patrick McHardy wrote:
> On Wed, Jan 02, 2013 at 04:24:40PM +0100, Ulrich Weber wrote:
> > csum16_add() has a broken carry detection, should be:
> > sum += sum < (__force u16)b;
> > 
> > Instead of fixing csum16_add, remove the custom checksum
> > functions and use the generic csum_add/csum_sub ones.
> 
> Looks good to me.
> 
> Acked-by: Patrick McHardy <kaber@trash.net>

Applied, thanks!
