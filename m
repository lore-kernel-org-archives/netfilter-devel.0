From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/2] src: rename ct eventmask to event
Date: Wed, 7 Jun 2017 12:38:50 +0200
Message-ID: <20170607103850.GA9320@salvia>
References: <20170607102410.21024-1-fw@strlen.de>
 <20170607102410.21024-2-fw@strlen.de>
 <20170607103820.GB9280@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53512 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751625AbdFGKi7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Jun 2017 06:38:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CB2F531636
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Jun 2017 12:38:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B276E1021A4
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Jun 2017 12:38:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 79939100783
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Jun 2017 12:38:47 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170607103820.GB9280@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 07, 2017 at 12:38:20PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Jun 07, 2017 at 12:24:10PM +0200, Florian Westphal wrote:
> > diff --git a/tests/py/any/ct.t b/tests/py/any/ct.t
> > index 667126e656ae..1c90ec1c769d 100644
> > --- a/tests/py/any/ct.t
> > +++ b/tests/py/any/ct.t
> > @@ -100,11 +100,11 @@ ct original mark 42;fail
> [...]
> > +ct event set new or related or destroy or foobar;fail
> > +ct event set 'new | related | destroy | label';ok;ct event set new | related | destroy | label
> 
> I would replace this by the new syntax in the tests too.
> 
> So anyone looking at test for example relies on this new one, it is
> more compact and readable IMO.

Apart from that small detail, LGTM.

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
