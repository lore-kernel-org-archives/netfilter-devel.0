From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] parser_bison: allow to use mark as datatype for maps
 and sets
Date: Tue, 16 Jun 2015 17:57:32 +0200
Message-ID: <20150616155732.GA7067@salvia>
References: <1434469933-6402-1-git-send-email-pablo@netfilter.org>
 <20150616154924.GL20951@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, exa.exa@gmail.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57166 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123AbbFPPwN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jun 2015 11:52:13 -0400
Content-Disposition: inline
In-Reply-To: <20150616154924.GL20951@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 16, 2015 at 05:49:24PM +0200, Patrick McHardy wrote:
> On 16.06, Pablo Neira Ayuso wrote:
> > Update the grammar to accept a MARK token as datatype.
> > 
> > Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1012
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > @Patrick: I think you prefer this update rather than renaming this to
> > packetmark. This comes in response to this patch proposal:
> > http://patchwork.ozlabs.org/patch/485058/
> 
> Yes, I think this is preferrable since the mark type can be used for
> things besides packet marking, f.i. conntracks.

Ok, then I'll push this patch, thanks!
