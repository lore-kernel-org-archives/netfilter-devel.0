From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 2/3] meta: add short-hand mnemonic for probalistic
 matching
Date: Thu, 14 Jul 2016 14:08:40 +0200
Message-ID: <20160714120840.GB24700@breakpoint.cc>
References: <1467704135-9154-1-git-send-email-fw@strlen.de>
 <1467704135-9154-3-git-send-email-fw@strlen.de>
 <20160714104108.GA2250@salvia>
 <20160714105218.GA24700@breakpoint.cc>
 <20160714113239.GA2807@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44970 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751115AbcGNMIq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jul 2016 08:08:46 -0400
Content-Disposition: inline
In-Reply-To: <20160714113239.GA2807@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> But if the user introduces a meta random value that can be mapped to
> probability datatype, we would still hit this asymmetry, right? So the
> guess game would fail and the user would get confused.

Yes, but thats not really different from what we do with dependency
removal, e.g. with 'ip protocol tcp tcp dport 22', the 'ip protocol tcp'
is still elided from list output since its redundant.

> > Nothing, but the meta random might be interesting to e.g. set random
> > (ct)mark for load balancing purposes.
> 
> Could you have a look at the libnftnl userdata tlv infrastructure? We
> can probably place this information the RULE_USERDATA so we provide an
> explicit indication to userspace of how to interpret this.  Currently
> this is only used for rule comments, but we can stash this
> how-to-interpret-this information there.

Sure, I will have a look.  It might take a while though.
