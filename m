From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] meta: fix error checks in tc handle parser
Date: Mon, 1 Feb 2016 21:02:43 +0100
Message-ID: <20160201200243.GB19789@breakpoint.cc>
References: <1454324556-29019-1-git-send-email-fw@strlen.de>
 <20160201175330.GA2355@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34796 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753450AbcBAUCp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Feb 2016 15:02:45 -0500
Content-Disposition: inline
In-Reply-To: <20160201175330.GA2355@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Feb 01, 2016 at 12:02:36PM +0100, Florian Westphal wrote:
> > 'meta priority foobar' did not return an error -- instead
> > we used min/max values with undefined content.
> > 
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> Fine with me. IIRC, the scanner is still broken though.

Ho-hum.  It is.  And I don't see how this can be fixed.
Teaching scanner.l about

tchandle       {hexdigit}{4}:{hexdigit}{4}

breaks

tcp sport vmap { 1225:accept, }

( 1225:acc is handle).

