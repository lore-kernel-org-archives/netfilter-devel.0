From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 1/2] src: add dscp support
Date: Wed, 25 Nov 2015 23:05:28 +0100
Message-ID: <20151125220528.GA1028@salvia>
References: <1448480362-12411-1-git-send-email-pablo@netfilter.org>
 <20151125200124.GH30712@macbook.localdomain>
 <20151125202201.GA11893@salvia>
 <20151125204512.GA20093@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55924 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbbKYWFf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 17:05:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C0F331324CE
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 23:05:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B0140DA801
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 23:05:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C7E2FDA795
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 23:05:29 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151125204512.GA20093@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 25, 2015 at 08:45:13PM +0000, Patrick McHardy wrote:
> On 25.11, Pablo Neira Ayuso wrote:
> > On Wed, Nov 25, 2015 at 08:01:25PM +0000, Patrick McHardy wrote:
> > > On 25.11, Pablo Neira Ayuso wrote:
> > > >  #define TYPE_MAX		(__TYPE_MAX - 1)
> > > > diff --git a/include/proto.h b/include/proto.h
> > > > index a43bf98..41af0c1 100644
> > > > --- a/include/proto.h
> > > > +++ b/include/proto.h
> > > > @@ -176,7 +176,7 @@ enum ip_hdr_fields {
> > > >  	IPHDR_INVALID,
> > > >  	IPHDR_VERSION,
> > > >  	IPHDR_HDRLENGTH,
> > > > -	IPHDR_TOS,
> > > > +	IPHDR_DSCP,
> > > 
> > > Shouldn't we keep both? I think it should work to do that or at least not be
> > > difficult to make it work.
> > 
> > Last time we discussed this, people arised concerns related to the
> > fact that this is obsolete, and nobody should be using this these
> > days.
> 
> I don't really buy into these arguments. We support lots of obsolete things,
> the fact is that even though it is obsoleted, it still exists and for old
> devices might even be the only thing they support.

ToS breaks useful things like ECN, and the more I keep reading docs on
the Internet, the more problem I have to see how the user can benefit
from this.
