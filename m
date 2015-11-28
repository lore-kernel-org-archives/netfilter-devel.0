From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] src: perform sub-byte length matching from the
 evaluation step
Date: Sat, 28 Nov 2015 19:01:29 +0100
Message-ID: <20151128180129.GA31884@salvia>
References: <1448715052-5705-1-git-send-email-pablo@netfilter.org>
 <20151128132023.GC17106@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50963 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540AbbK1SBj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 28 Nov 2015 13:01:39 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 6C909129246
	for <netfilter-devel@vger.kernel.org>; Sat, 28 Nov 2015 19:01:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5A992DA795
	for <netfilter-devel@vger.kernel.org>; Sat, 28 Nov 2015 19:01:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 31E4FDA795
	for <netfilter-devel@vger.kernel.org>; Sat, 28 Nov 2015 19:01:35 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151128132023.GC17106@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Nov 28, 2015 at 01:20:23PM +0000, Patrick McHardy wrote:
> On 28.11, Pablo Neira Ayuso wrote:
> > I'm not working on the protocol definition problem:
> > http://marc.info/?l=netfilter-devel&m=144862242521205&w=2, but I also
> > need this gets fixed. Let me know if you will be looking into this, just
> > to avoid overlap.
> 
> It kinds of depends on the sub-byte handling, so we should get this done
> first.

Looking into this.

> From my previous work on this I still have this patch, which allows you to
> generate an rshift to get the payload to offset 0, then transfers it to the
> LHS during binop simplification if its used in a relational expression.
> 
> The upside is that is generic and reuses what we already have.

I like the shift approach based on binop transfer.

But I think this will not to cover this case, on IPv6 the DSCP field
is split between two bytes.

     4 bits    6 bits
    +-+-+-+-+-+-+-+-+-+-+
    | vers  |   dscp    |
    +-+-+-+-+-+-+-+-+-+-+
                    |
       1st bytes    | 2nd byte

So 4 bit are on the 1st byte and 2 bit are placed on the second byte.

I think this needs a binary-and to get rid of the bits that we dont
need from the 1st and 2nd byte, in this case I'm not sure we can use
your transfer trick.

> The load masking should IMO not be done in eval but netlink_linearize.

I think we can't handle the following case with this approach, eg.

        ip dscp & 0xf == 0xf

then we get two bitwise in the code generation:

        payload
        bitwise
        bitwise
        cmp

If we perform that transformation from the evaluation step, we can
merge those two bitwise into one.

> We don't even know yet if the payload expression is actually used in
> a relational expression or f.i. in a statement, where handling needs
> to be different.

But these two cases, payload expression and statement, I think they
need different handling both for evaluation and code generation.

For payload statements, the bitwise will need to be retain the bits
that we don't want to mangle, then inclusive-OR them with the value
that we want to set, ie.

r1 = payload(offset, base, len)
r1 = bitwise(r1, AND, mask)
r1 = bitwise(r1, OR, r2)
payload_set(r1, ...)

Cheers,
Pablo
