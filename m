From: Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH] netfilter: remove silly double assignment
Date: Mon, 29 Oct 2012 10:21:04 +0900
Message-ID: <20121029012103.GF26847@verge.net.au>
References: <20121026101320.18664.26806.stgit@localhost.localdomain>
 <20121028225349.GB1143@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:59515 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757434Ab2J2BVI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Oct 2012 21:21:08 -0400
Content-Disposition: inline
In-Reply-To: <20121028225349.GB1143@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 28, 2012 at 11:53:49PM +0100, Pablo Neira Ayuso wrote:
> On Fri, Oct 26, 2012 at 11:13:27AM +0100, Alan Cox wrote:
> > From: Alan Cox <alan@linux.intel.com>
> > 
> > I don't even want to think what the C spec says for this 8)
> 
> I don't want to know it either :-), I have applied this.
> 
> @Simon: this patch is fairly small, I'll take it myself into nf-next.

Thanks.
