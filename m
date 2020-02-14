Return-Path: <SRS0=aq0Q=4C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62D9AC3B1B7
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Feb 2020 18:16:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3556A24673
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Feb 2020 18:16:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404968AbgBNSQn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Feb 2020 13:16:43 -0500
Received: from correo.us.es ([193.147.175.20]:49964 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392609AbgBNSQi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Feb 2020 13:16:38 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2D2BC7B546
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Feb 2020 19:16:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1F199DA712
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Feb 2020 19:16:38 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1442ADA70E; Fri, 14 Feb 2020 19:16:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0D427DA705;
        Fri, 14 Feb 2020 19:16:36 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 14 Feb 2020 19:16:36 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E3F4342EF4E0;
        Fri, 14 Feb 2020 19:16:35 +0100 (CET)
Date:   Fri, 14 Feb 2020 19:16:34 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?iso-8859-1?Q?J=F3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nf-next v4 5/9] nf_tables: Add set type for arbitrary
 concatenation of ranges
Message-ID: <20200214181634.cacy3elfwnankvop@salvia>
References: <cover.1579647351.git.sbrivio@redhat.com>
 <4e78727d12d54ebd6a6f832585d15f116280dc42.1579647351.git.sbrivio@redhat.com>
 <20200207112308.sqtlvbluujlftqz2@salvia>
 <20200210161047.370582c5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200210161047.370582c5@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Feb 10, 2020 at 04:10:47PM +0100, Stefano Brivio wrote:
> On Fri, 7 Feb 2020 12:23:08 +0100
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
[...]
> > Did you tests with 8-bits grouping instead of 4-bits?
> 
> Yes, at the very beginning, not with the final implementation. It was
> somewhat faster (on x86_64, I don't remember how much) for small
> numbers of rules, then I thought we would use too much memory, because:
> 
> > Assuming a concatenation of 12 bytes (each field 4 bytes, hence 3
> > fields):
> > 
> > * Using 4-bits groups: the number of buckets is 2^4 = 16 multiplied
> >   by the bucket word (assuming one long word, 8 bytes, 64 pipapo
> >   rules) is 16 * 8 = 128 bytes per group-row in the looking table. Then,
> >   the number of group-rows is 8 given that 32 bits, then 32 / 4 = 8
> >   group-rows.
> > 
> >   8 * 128 bytes = 1024 bytes per lookup table.
> > 
> >   Assuming 3 fields, then this is 1024 * 3 = 3072 bytes.
> > 
> > * Using 8-bits groups: 2^8 = 256, then 256 * 8 = 2048 bytes per
> >   group-row. Then, 32 / 8 = 4 group-rows in total.
> > 
> >   4 * 2048 bytes = 8192 bytes per lookup table.
> > 
> >   Therefore, 3 * 8192 = 24576 bytes. Still rather small.
> > 
> > This is missing the mapping table that links the lookup tables in the
> > memory counting. And I'm assuming that the number of pipapo rules in
> > the lookup table fits into 64-bits bucket long word.
> 
> ...the (reasonable?) worst case I wanted to cover was two IPv6
> addresses, one port, one MAC address (in ipset terms
> "net,net,port,mac"), with 2 ^ 16 unique, non-overlapping entries each
> (or ranges expanding to that amount of rules), because that's what
> (single, non-concatenated) ipset "bitmap" types can do.

I see, so you were considering the worst case. You're assuming each
element takes exactly one pipapo rule, so it's 2^16 elements, correct?

You refer to a property that says that you can split a range into a
2*n netmasks IIRC. Do you know what is the worst case when splitting
ranges?

There is no ipset set like this, but I agree usecase might happen.

> Also ignoring the mapping table (it's "small"), with 4-bit buckets:
> 
> - for the IPv6 addresses, we have 16 buckets, each 2 ^ 16
>   bits wide, and 32 groups (128 bits / 4 bits), that is, 8MiB in
>   total
>
> - for the MAC address, 16 buckets, each 2 ^ 16 bits wide, and 12
>   groups, 1.5MiB
>
> - for the port, 16 buckets, each 2 ^ 12 bits wide, 2 groups, 0.25MiB
>
> that is, 9.75MiB.
> 
> With 8-bit buckets: we can just multiply everything by 8 (that is,
> 2 ^ 8 / 2 ^ 4 / 2, because we have 2 ^ (8 - 4) times the buckets, with
> half the groups), 78MiB.

Yes, this is large. Compared to a hashtable with 2^16 entries, then
it's 2^17 hashtable buckets and using struct hlist_head, this is 2
MBytes. Then, each hlist_node is 16 bytes, so 2^16 * 16 ~= 1 MByte.
That is 3 MBytes if my maths are fine.

Just telling this to find what could be considered as reasonable
amount of memory to be consumed. ~10 MBytes is slightly more than, but
I agree you selected a reasonable worst through this "complex tuple".

> And that started feeling like "a lot". However, I'm probably overdoing
> with the worst case -- this was just to explain what brought me to the
> 4-bit choice, now I start doubting about it.
> 
> > Anyway, my understanding is that the more bits you use for grouping,
> > the larger the lookup table becomes.
> > 
> > Still, both look very small in terms of memory consumption for these
> > days.
> > 
> > I'm just telling this because the C implementation can probably get
> > better numbers at the cost of consuming more memory? Probably do this
> > at some point?
> 
> Another topic is the additional amount of cachelines we would use. I
> don't expect that effect to be visible, but I might be wrong.
> 
> So yes, I think it's definitely worth a try, thanks for the hint! I'll
> try to look into this soon and test it on a few archs (something with
> small cachelines, say MIPS r2k, would be worth checking, too).
> 
> We could even consider to dynamically adjust group size depending on
> the set size, I don't know yet if that gets too convoluted.

Yes, keeping this maintainable is a good idea.

The per-cpu scratch index is only required if we cannot fit in the
"result bitmap" into the stack, right?

Probably up to 256 bytes result bitmap in the stack is reasonable?
That makes 8192 pipapo rules. There will be no need to disable bh and
make use of the percpu scratchpad area in that case.

If adjusting the code to deal with variable length "pipapo word" size
is not too convoluted, then you could just deal with the variable word
size from the insert / delete / get (slow) path and register one
lookup function for the version that is optimized for this pipapo word
size.

Probably adding helper function to deal with pipapo words would help
to prepare for such update in the future. There is the ->estimate
function that allows to calculate for the best word size depending on
all the information this gets from the set definition.

Just to keep this in the radar for future work.

Thanks.
