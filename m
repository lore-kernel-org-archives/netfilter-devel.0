From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Adding element to interval map consumes entire memory
Date: Tue, 13 Dec 2016 01:48:49 +0100
Message-ID: <20161213004849.GA15100@salvia>
References: <044c1296-0e35-4224-459f-3482691a3462@tu-dresden.de>
 <20161211192807.GA31470@salvia>
 <3acabb81-c5b5-2004-18ce-8b5242f07921@tu-dresden.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Richard =?iso-8859-1?Q?M=F6rbitz?=
        <richard.moerbitz@tu-dresden.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37636 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751615AbcLMAtA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Dec 2016 19:49:00 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C356FD162F
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Dec 2016 01:48:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ABF84DA7E0
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Dec 2016 01:48:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6BAB3DA7E0
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Dec 2016 01:48:54 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <3acabb81-c5b5-2004-18ce-8b5242f07921@tu-dresden.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Richard,

On Mon, Dec 12, 2016 at 04:43:33PM +0100, Richard Mörbitz wrote:
> 
> > interval code is buggy, I remember to have seen a large memory
> > allocation being triggered in libgmp calls.
> 
> These allocations are triggered from the expr_to_intervals function in
> segtree.c - three times, 500 MB each. I have attached the full valgrind
> leak summary to the mail.

I think I found the problem, we have an underflow triggering the
allocation of a huge bitmask, see patch:

http://patchwork.ozlabs.org/patch/705279/

Quickly tested with your example ruleset.

BTW, if you have some spare cycles, I would really appreciate if you
can send a shell test, similar to:

nftables/tests/shell/testcases/sets/0012add_delete_many_elements_0
nftables/tests/shell/testcases/sets/0013add_delete_many_elements_0

It would be great to cover intervals and maps too.

> I also want to point out that calculating overlapping intervals has
> bugs; trying to add a non-overlapping interval can result in the error
> "interval overlaps with an existing one" (function set_overlap,
> segtree.c). However, this should probably become a different thread.

Are you running nft from git.netfilter.org? I just would like to make
sure you're not seeing anything that is already fixed.

I have also posted this patch:

http://patchwork.ozlabs.org/patch/705278/

So nft doesn't complain on exact overlaps to keep it consistent with
non-interval sets. Probably you refering to this?

> > If you can hand over an example that I can use to reproduce I'd
> > appreciate, I understand this may require some confidentiality, so
> > feel free to send me a file with randomized addresses or such.
> 
> I have attached a dummy ruleset that represents the one we use in size
> and shape. You can read it (nft -f test.ruleset) without problems. If
> you attempt to add another map element (say, nft add element nat2
> subnettoip {0.0.0.0/24: 0.0.0.0}) you get the error I have described.
> Of course it depends on the memory of the machine you are using, but you
> should see memory consumption going up drastically.

Thanks for providing the example to reproduce it.
