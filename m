From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Seeking help for implementing CT HELPER in nftables
Date: Fri, 23 Sep 2016 17:19:21 +0200
Message-ID: <20160923151921.GA18242@salvia>
References: <56DAC502.2060809@c-s.fr>
 <20160307132011.GA7620@macbook.localdomain>
 <56DF5F61.2060000@c-s.fr>
 <570CFAB1.6090409@c-s.fr>
 <20160412135155.GA27975@breakpoint.cc>
 <2cfbf6f4-0031-36da-6d56-10f919d9eaf8@c-s.fr>
 <20160920153846.GB22503@breakpoint.cc>
 <c93e2f7e-fe6b-b43d-c1d4-0c57287ff06c@c-s.fr>
 <20160923142435.GA17227@salvia>
 <dabf3ae2-c497-a346-e806-c9e485de0daf@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Florian Westphal <fw@strlen.de>, Patrick McHardy <kaber@trash.net>,
        netfilter-devel@vger.kernel.org
To: Christophe Leroy <christophe.leroy@c-s.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46720 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1035312AbcIWPT3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Sep 2016 11:19:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5CFF31324D7
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Sep 2016 17:19:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4B57BDA844
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Sep 2016 17:19:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2C173DA846
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Sep 2016 17:19:25 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <dabf3ae2-c497-a346-e806-c9e485de0daf@c-s.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 23, 2016 at 04:48:32PM +0200, Christophe Leroy wrote:
> Le 23/09/2016 à 16:24, Pablo Neira Ayuso a écrit :
> >On Fri, Sep 23, 2016 at 12:45:06PM +0200, Christophe Leroy wrote:
> >>Le 20/09/2016 à 17:38, Florian Westphal a écrit :
> >[...]
> >>>nft will need to populate this (or rather, libnftnl will do this on
> >>>behalf of nft).
> >>>
> >>>Currently we do this:
> >>>nft --debug=netlink add rule filter i ct helper set foo
> >>>ip filter i
> >>> [ immediate reg 1 0x006f6f66 0x00000000 0x00000000 0x00000000 ]
> >
> >Florian, Christophe, sorry for this late jump on this.
> >
> >If we pass the helper name as string, then helper autoload will not
> >work as we don't have a way to solve this from the packet path.
> 
> That's maybe a stupid idea, but my idea was to do the same as
> xt_ct_set_helper() from nft_ct_set_init(), hence the need to be able to
> catch the name in the _init() function.
>
> By doing this, the helper would be autoloaded if needed, wouldn't it ?

Yes. Something similar to xt_ct_set_helper() would autoload the
module.

Hm, but this needs more attributes, not only the helper name.
nf_conntrack_helper_try_module_get() needs l3 and l4 protocol numbers,
and this information won't be available from there unless we add
explicit netlink attributes to specify then too. This information is
important since we have helpers that run over udp and tcp.
