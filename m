From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Seeking help for implementing CT HELPER in nftables
Date: Fri, 23 Sep 2016 16:24:35 +0200
Message-ID: <20160923142435.GA17227@salvia>
References: <56DAC502.2060809@c-s.fr>
 <20160307132011.GA7620@macbook.localdomain>
 <56DF5F61.2060000@c-s.fr>
 <570CFAB1.6090409@c-s.fr>
 <20160412135155.GA27975@breakpoint.cc>
 <2cfbf6f4-0031-36da-6d56-10f919d9eaf8@c-s.fr>
 <20160920153846.GB22503@breakpoint.cc>
 <c93e2f7e-fe6b-b43d-c1d4-0c57287ff06c@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Florian Westphal <fw@strlen.de>, Patrick McHardy <kaber@trash.net>,
        netfilter-devel@vger.kernel.org
To: Christophe Leroy <christophe.leroy@c-s.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58366 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760392AbcIWOYm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Sep 2016 10:24:42 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 56E6CFB453
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Sep 2016 16:24:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3C56BDA841
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Sep 2016 16:24:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2B807DA818
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Sep 2016 16:24:37 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <c93e2f7e-fe6b-b43d-c1d4-0c57287ff06c@c-s.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 23, 2016 at 12:45:06PM +0200, Christophe Leroy wrote:
> Le 20/09/2016 à 17:38, Florian Westphal a écrit :
[...]
> >nft will need to populate this (or rather, libnftnl will do this on
> >behalf of nft).
> >
> >Currently we do this:
> >nft --debug=netlink add rule filter i ct helper set foo
> >ip filter i
> >  [ immediate reg 1 0x006f6f66 0x00000000 0x00000000 0x00000000 ]

Florian, Christophe, sorry for this late jump on this.

If we pass the helper name as string, then helper autoload will not
work as we don't have a way to solve this from the packet path.

To solve this, I'm considering a different approach. Basically,
explicit preload the helpers and pass a helper handle through
register instead.

In the ruleset file, this would look like this:

        table ip x {
                helper ftp protocol tcp                 #1

                chain y {
                        ...
                        tcp dport 21 ct helper set ftp  #2
                }
        }

Line #1 makes sure the ftp helper is loaded, we also increment reference
counter. This results in a handle that is dynamically allocated by
nf_tables, that can be retrieve in the same fashion of if_index (ie.
we can look up for the handle from the helper name).

Then from #2, we use the helper handle to refer to the helper.

Good things I see on this:

1) We can still use maps, although we would need a function to lookup
   for the nf_conntrack_helper struct form this handle. We can have a
   small hashtable for this (actually, we have similar approach currently
   to look up for helpers from ports in the deprecated automagic helper
   as signment).
2) We use a u32 instead of string to identify the helper.
3) We solve the module autoload issue.
4) We make sure helper module cannot be removed while there is a
   reference from the ruleset.
5) We can validate that the helper runs from the right layer 4
   protocol, eg. ensure the ftp helper is called for tcp since we can
   do this from nft evaluation phase.

This would need commands like:

        nft add helper ip x name ftp protocol tcp

and to delete this:

        nft delete helper ip x name ftp protocol tcp

Main drawback is that this needs a explicit definition of the helper,
but I think this extra line is ok if it helps resolve other problems.
