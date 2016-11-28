From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/2] netfilter: nf_tables: add chain to pktinfo
 structure
Date: Mon, 28 Nov 2016 12:27:21 +0100
Message-ID: <20161128112721.GC1024@salvia>
References: <1480291244-3666-1-git-send-email-pablo@netfilter.org>
 <20161128005649.GA17749@breakpoint.cc>
 <20161128084428.GA949@salvia>
 <20161128103224.GA28510@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49898 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932334AbcK1L11 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Nov 2016 06:27:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B8C6DED066
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 12:27:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A9C3E212605
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 12:27:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9AD45212617
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 12:27:22 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161128103224.GA28510@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 28, 2016 at 11:32:24AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Mon, Nov 28, 2016 at 01:56:49AM +0100, Florian Westphal wrote:
> > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > This patch adds the chain object to the pktinfo structure. This
> > > > potentially allow us to know what basechain this packet is walking over
> > > > from the expression evaluation path.
> > > 
> > > ... for what?  Why...?
> > 
> > Quota depletion event notification needs to know from what table
> > delivery is happening, so this one actually belongs to the stateful
> > object patchset..
> 
> Which patch uses this?
> 
> I see nft_chain() call in patch 8, but it doesn't need the chain object
> but uses it to fetch the table pointer.

That's the only client for this new thing so far.

> However, table is available at init() time so this could also be stored
> in ->priv area afaics.
>
> [ I am not opposed to this chain store thing, but after getting rid of
>   a lot of members from pktinfo it seems to me we should not add
>   new ones without a compelling reason ]

OK, nft_pktinfo is still on the 64 bytes cacheline bound. pahole
reports a couple of holes there. Actually we can provide avoid those
holes by reordering. better not to increase pressure there only for
this.

I'll follow a different path: I can store the table pointer in struct
nft_object. Actually, this would be better since I can pass struct
nft_object to obj->type->foo() functions instead of the ugly void * I
have now, then fetch the object data area via something like
nft_data_priv(obj).

Thanks.
