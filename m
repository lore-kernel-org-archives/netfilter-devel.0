From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/3] meta: add short-hand mnemonic for probalistic
 matching
Date: Thu, 14 Jul 2016 14:17:28 +0200
Message-ID: <20160714121728.GA5056@salvia>
References: <1467704135-9154-1-git-send-email-fw@strlen.de>
 <1467704135-9154-3-git-send-email-fw@strlen.de>
 <20160714104108.GA2250@salvia>
 <20160714105218.GA24700@breakpoint.cc>
 <20160714113239.GA2807@salvia>
 <20160714120840.GB24700@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45456 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbcGNMRd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jul 2016 08:17:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 7F4AE210566
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Jul 2016 14:17:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6C1C6FAB52
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Jul 2016 14:17:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5FD9DFAB52
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Jul 2016 14:17:29 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160714120840.GB24700@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 14, 2016 at 02:08:40PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > But if the user introduces a meta random value that can be mapped to
> > probability datatype, we would still hit this asymmetry, right? So the
> > guess game would fail and the user would get confused.
> 
> Yes, but thats not really different from what we do with dependency
> removal, e.g. with 'ip protocol tcp tcp dport 22', the 'ip protocol tcp'
> is still elided from list output since its redundant.

Dependencies are a different thing, they are dealing with redundant
information. This is about what datatype userspace should use to
intepret data.

> > > Nothing, but the meta random might be interesting to e.g. set random
> > > (ct)mark for load balancing purposes.
> > 
> > Could you have a look at the libnftnl userdata tlv infrastructure? We
> > can probably place this information the RULE_USERDATA so we provide an
> > explicit indication to userspace of how to interpret this.  Currently
> > this is only used for rule comments, but we can stash this
> > how-to-interpret-this information there.
> 
> Sure, I will have a look.  It might take a while though.

Thanks.
