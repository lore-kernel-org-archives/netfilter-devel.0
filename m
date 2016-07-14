From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/3] meta: add short-hand mnemonic for probalistic
 matching
Date: Thu, 14 Jul 2016 13:32:39 +0200
Message-ID: <20160714113239.GA2807@salvia>
References: <1467704135-9154-1-git-send-email-fw@strlen.de>
 <1467704135-9154-3-git-send-email-fw@strlen.de>
 <20160714104108.GA2250@salvia>
 <20160714105218.GA24700@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60666 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444AbcGNLco (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jul 2016 07:32:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id CC5B11C4384
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Jul 2016 13:32:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BB07AFAB56
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Jul 2016 13:32:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9F556FAB48
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Jul 2016 13:32:40 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160714105218.GA24700@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 14, 2016 at 12:52:18PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Tue, Jul 05, 2016 at 09:35:34AM +0200, Florian Westphal wrote:
> > > Allow users to use a simpler way to specify probalistic matching, e. g.:
> > > 
> > > meta probability 0.5		(match approx. every 2nd packet)
> > > meta probability 0.001		(match approx. once every 1000 packets)
> > > 
> > > nft list will still show
> > > meta random <= 2147483647
> > > meta random <= 4294967
> > 
> > I don't like this asymmetry.
> 
> Its changed in patch #3 when adding the shorthand reverse
> translation.

But if the user introduces a meta random value that can be mapped to
probability datatype, we would still hit this asymmetry, right? So the
guess game would fail and the user would get confused.

> > What is the usecase for 'meta random' out of this probability case that
> > maps to what xt_statistics offers?
> 
> Nothing, but the meta random might be interesting to e.g. set random
> (ct)mark for load balancing purposes.

Could you have a look at the libnftnl userdata tlv infrastructure? We
can probably place this information the RULE_USERDATA so we provide an
explicit indication to userspace of how to interpret this.  Currently
this is only used for rule comments, but we can stash this
how-to-interpret-this information there.

The idea is to keep this information around as context in the
delinearize step, so we can replace the default datatype that is
assigned to the one that displays this as a probability from the
rule_parse_postprocess() phase.
