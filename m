From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] datatype, meta: add new ifname_type for
 iifname/oifname
Date: Tue, 1 Mar 2016 14:15:22 +0100
Message-ID: <20160301131522.GA22826@salvia>
References: <1456514374-28827-1-git-send-email-fw@strlen.de>
 <20160229131202.GA16476@salvia>
 <20160229131923.GB7277@breakpoint.cc>
 <20160301101114.GA2654@salvia>
 <20160301110055.GA22817@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43923 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649AbcCANP2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2016 08:15:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B1398E664E
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Mar 2016 14:15:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A1BF2DA385
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Mar 2016 14:15:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 26FA1DA39B
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Mar 2016 14:15:24 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160301110055.GA22817@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 01, 2016 at 12:00:55PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Ok, but how do you plan to handle the key length?
> > 
> > Right, in concatenations we can infer this from the lhs, but in set
> > definitions there is not way.
> 
> Okay.  So whats the plan there?

I would review Carlos' patches, recover Patrick patch to add typeof()
and check if we can get all the pieces together to support this.

> > What I would suggest is to recover a patch that Patrick submitted that
> > introduces typeof(X) so we can use this from set definitions. We can
> > store in the TLV the original subtype X as a string. Thus, when
> > listing back to userspace we can use this information to display back
> > the typeof(X).
> 
> So you mean you'd use something like
> 
> nft add set filter ifnames '{typeof(meta iifname); }' ?
> 
> That should indeed work since we can derive the size
> from the meta iifname (or whatever other field),
> 
> > We have to potentially support every meta and packet selector,
> > including crazy ones as 48 bits fields, and last time we discussed
> > this, we agreed that adding one type per field size is not the way to
> > go.
> 
> Ok, yes, I see your point.
> 
> > Let me know your opinion on this, thanks!
> 
> I think typeof would be good; we could indeed derive the key size with
> this without the need for a new type.

Yep, we have a plan to address this then.
