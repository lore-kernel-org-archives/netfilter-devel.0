From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] src: revisit tcp options support
Date: Wed, 22 Feb 2017 16:33:12 +0100
Message-ID: <20170222153312.GA18577@salvia>
References: <1487768503-17023-1-git-send-email-pablo@netfilter.org>
 <20170222140934.GD11144@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, mm@skelett.io
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39924 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932631AbdBVPkX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Feb 2017 10:40:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 353BE180195
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Feb 2017 16:33:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 24E5BDA816
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Feb 2017 16:33:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E0095DA7FA
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Feb 2017 16:33:17 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170222140934.GD11144@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 22, 2017 at 03:09:34PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Rework syntax, add tokens so we can extend the grammar more easily.
> > This has triggered several syntax changes with regards to the original
> > patch, specifically:
> > 
> > 	tcp option sack0 left 1
> > 
> > There is no space between sack and the block number anymore, no more
> > offset field, now they are a single field. Just like we do with rt, rt0
> > and rt2. This simplifies our grammar and that is good since it makes our
> > life easier when extending it later on to accomodate new features.
> > 
> > I have also renamed sack_permitted to sack-permitted. I couldn't find
> > any option using underscore so far, so let's keep it consistent with
> > what we have.
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > @Florian, @Manuel: I would appreciate an explicit review ack on this patch.
> 
> I am fine with 'sack-permitted' rename.
> 
> As for sack0 etc. I already said 'yuck', pointing at rt2 (not even
> documented...) doesn't make it any more pretty to me, sorry.

This is not about making things more pretty.

This is about making things extensible to accomodate new usecases, as
well as to keep it consistent with similar extensions that we have,
hence the reference to rtX.

> I also still fail to see how this helps/improves grammar state,
> all it does is removing
> 
> TCP     OPTION  STRING  NUM     tcp_option_field
> 
> and replacing
> 
> TCP     OPTION  STRING  STRING
> with
> TCP OPTION	option_tokens	field_tokens
> 
> so user syntax is the same (aside from removal of the 'NUM')
> version.

Change from string to token is there to accomodate the TCP option
exists usecase.

> > @@ -2604,13 +2607,33 @@ inet filter meta nfproto ipv6 output rt nexthop fd00::1
> >  								<entry>kind, length, count</entry>
> >  							</row>
> >  							<row>
> > -								<entry>sack_permitted</entry>
> > +								<entry>sack-permitted</entry>
> >  								<entry>TCP SACK permitted</entry>
> >  								<entry>kind, length</entry>
> >  							</row>
> >  							<row>
> >  								<entry>sack</entry>
> > -								<entry>TCP Selective Acknowledgement</entry>
> > +								<entry>TCP Selective Acknowledgement (alias of block 0)</entry>
> > +								<entry>kind, length, left, right</entry>
> > +							</row>
> > +							<row>
> > +								<entry>sack0</entry>
> > +								<entry>TCP Selective Acknowledgement (block 0)</entry>
> > +								<entry>kind, length, left, right</entry>
> > +							</row>
> > +							<row>
> > +								<entry>sack1</entry>
> > +								<entry>TCP Selective Acknowledgement (block 1)</entry>
> > +								<entry>kind, length, left, right</entry>
> 
> Thats the thing, sack1 doesn't have kind or length.

We can reject any invalid combination from the evaluation phase.
