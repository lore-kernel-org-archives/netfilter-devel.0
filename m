From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] List handles of added rules if requested
Date: Mon, 8 May 2017 19:35:03 +0200
Message-ID: <20170508173503.GA27054@salvia>
References: <20170504123421.22147-1-phil@nwl.cc>
 <20170504133626.GC5607@salvia>
 <20170504134419.GG13320@breakpoint.cc>
 <20170504140042.GA6436@salvia>
 <20170504222612.GD20805@orbyte.nwl.cc>
 <20170505104954.GA1676@salvia>
 <1493983116.2675.4.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "phil@nwl.cc" <phil@nwl.cc>, "fw@strlen.de" <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Puustinen, Ismo" <ismo.puustinen@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46956 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755124AbdEHRfP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 May 2017 13:35:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5A2011F4B7D
        for <netfilter-devel@vger.kernel.org>; Mon,  8 May 2017 19:35:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 24B421BDA08
        for <netfilter-devel@vger.kernel.org>; Mon,  8 May 2017 19:35:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8ABF81BC65B
        for <netfilter-devel@vger.kernel.org>; Mon,  8 May 2017 19:35:05 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1493983116.2675.4.camel@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 05, 2017 at 11:18:37AM +0000, Puustinen, Ismo wrote:
> On Fri, 2017-05-05 at 12:49 +0200, Pablo Neira Ayuso wrote:
> > This does not integrate at all into the scripting features we have in
> > 
> > nftables. We don't want people to use bash (or like) shell scripts
> > anymore, they are bad, they break atomicity for us. We should extend
> > native nftables scripting capabilities to support what user need,
> > natively. Look, this will not work with nft -i either...
> > 
> > And this also will not work for robots using incremental updates via
> > nft -f. And we very much want to support such transaction like
> > scheme,
> > ie. place a bunch of incremental updates in one single file and apply
> > that in one single transaction.
> > 
> > This is just covering one very specific usecase, that is, users have
> > a
> > quick way to delete the rule that just added. And we have better ways
> > to achieve this, and that will work from all the scenarios that I
> > described above.
> 
> I would be interested in any documentation you might have concerning
> the "better ways" of creating modular rulesets, that is, automatically
> adding and deleting rules and rule groups. This is a real issue that
> I'm currently struggling with.
> 
> My use case is  pretty simple: when a service is loaded, it also loads
> the firewall rules associated with it. When a service is stopped, the
> rules corresponding to the service are unloaded. There is no
> interactive user present in the system.

Would it be better if you do this programmatically? ie. from a
library. Do you have some example code of how you're doing things
there?

> Having "nft add rule ..." return a rule handle would fix this, so I was
> happy to see Phil's patches.

But this is basically pushing nft to the domain of using non-native
shell scripts.

I guess you call several commands there in a row and that is defeating
the existing commit protocol we have.
