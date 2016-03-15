From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v4 3/3] netfilter: nftables: add connlabel set
 support
Date: Tue, 15 Mar 2016 03:14:00 +0100
Message-ID: <20160315021400.GA24921@salvia>
References: <1457963194-19132-1-git-send-email-fw@strlen.de>
 <1457964554-13907-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35658 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997AbcCOCOG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Mar 2016 22:14:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B317F114F43
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 03:14:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A372ADA383
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 03:14:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C7BCEDA8FB
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 03:14:01 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1457964554-13907-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Mon, Mar 14, 2016 at 03:09:14PM +0100, Florian Westphal wrote:
> Conntrack labels are currently sized depending on the iptables
> ruleset, i.e. if we're asked to test or set bits 1, 2, and 65 then we
> would allocate enough room to store at least bit 65.
> 
> However, with nft, the input is just a register with arbitrary runtime
> content.
> 
> We therefore ask for the upper ceiling we currently have, which is
> enough room to store 128 bits.

We can probably allow passing the label value as attribute to the
nft_ct expression so you don't have to use the upper ceiling. Patrick
suggested something similar for nft_ct set helper support.

BTW, during NetDev 0.1 he also suggested an alternative to maps that
would suit well for this case, the idea is to use the NFT_SET_EXT_EXPR
to store the connlabel set expression and build a dictionary as
alternative, it would be something like:

        ip saddr map {
                1.2.3.4 : connlabel bitset foo,
        }

So based on the source IP address, for the matching key we run the
expression on the data part of the element.

> Alternatively, we could alter nf_connlabel_replace to increase
> net->ct.label_words at run time, but since 128 bits is not that
> big we'd only save sizeof(long) so it doesn't seem worth it for now.

That's right, we save little memory.

Sorry for this late spinning on this, giving another think after
looking at nf_connlabels_replace() that we don't have it xt_connlabel.
