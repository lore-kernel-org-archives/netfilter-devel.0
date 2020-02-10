Return-Path: <SRS0=1PBg=36=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 436B4C352A3
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 15:11:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1111F20661
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 15:11:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ypcx/iJh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729013AbgBJPLS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Feb 2020 10:11:18 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:39506 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727347AbgBJPLS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Feb 2020 10:11:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581347476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K9BteBGoEV7pOz2DdQ+VKKpDecjlXws7wcxhbNIotsY=;
        b=Ypcx/iJhXfnAYDSVFT+xsrRIY+/fVgBbAPWBFtUScLzFaDhE6vEw179SmulmcUWmLBuKAo
        BfNlje/KpYPHOzZAf/lnkjvh3osrlgEm+Udeamg/ALyYnBlUv+ujD+7rmHWXL9erDc62+E
        7nb0VrkdCZf9TjOgMN9DeUOSThR+6lU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-jFXoxKFoOBW45HuMdlzfLg-1; Mon, 10 Feb 2020 10:10:57 -0500
X-MC-Unique: jFXoxKFoOBW45HuMdlzfLg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6FFE63AD0;
        Mon, 10 Feb 2020 15:10:55 +0000 (UTC)
Received: from localhost (ovpn-200-43.brq.redhat.com [10.40.200.43])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C1AA101D481;
        Mon, 10 Feb 2020 15:10:52 +0000 (UTC)
Date:   Mon, 10 Feb 2020 16:10:47 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?UTF-8?B?SsOzenNlZg==?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nf-next v4 5/9] nf_tables: Add set type for arbitrary
 concatenation of ranges
Message-ID: <20200210161047.370582c5@redhat.com>
In-Reply-To: <20200207112308.sqtlvbluujlftqz2@salvia>
References: <cover.1579647351.git.sbrivio@redhat.com>
 <4e78727d12d54ebd6a6f832585d15f116280dc42.1579647351.git.sbrivio@redhat.com>
 <20200207112308.sqtlvbluujlftqz2@salvia>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 7 Feb 2020 12:23:08 +0100
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> Hi Stefano,
> 
> A bit of late feedback on your new datastructure.
> 
> Did you tests with 8-bits grouping instead of 4-bits?

Yes, at the very beginning, not with the final implementation. It was
somewhat faster (on x86_64, I don't remember how much) for small
numbers of rules, then I thought we would use too much memory, because:

> Assuming a concatenation of 12 bytes (each field 4 bytes, hence 3
> fields):
> 
> * Using 4-bits groups: the number of buckets is 2^4 = 16 multiplied
>   by the bucket word (assuming one long word, 8 bytes, 64 pipapo
>   rules) is 16 * 8 = 128 bytes per group-row in the looking table. Then,
>   the number of group-rows is 8 given that 32 bits, then 32 / 4 = 8
>   group-rows.
> 
>   8 * 128 bytes = 1024 bytes per lookup table.
> 
>   Assuming 3 fields, then this is 1024 * 3 = 3072 bytes.
> 
> * Using 8-bits groups: 2^8 = 256, then 256 * 8 = 2048 bytes per
>   group-row. Then, 32 / 8 = 4 group-rows in total.
> 
>   4 * 2048 bytes = 8192 bytes per lookup table.
> 
>   Therefore, 3 * 8192 = 24576 bytes. Still rather small.
> 
> This is missing the mapping table that links the lookup tables in the
> memory counting. And I'm assuming that the number of pipapo rules in
> the lookup table fits into 64-bits bucket long word.

...the (reasonable?) worst case I wanted to cover was two IPv6
addresses, one port, one MAC address (in ipset terms
"net,net,port,mac"), with 2 ^ 16 unique, non-overlapping entries each
(or ranges expanding to that amount of rules), because that's what
(single, non-concatenated) ipset "bitmap" types can do.

Also ignoring the mapping table (it's "small"), with 4-bit buckets:

- for the IPv6 addresses, we have 16 buckets, each 2 ^ 16
  bits wide, and 32 groups (128 bits / 4 bits), that is, 8MiB in
  total

- for the MAC address, 16 buckets, each 2 ^ 16 bits wide, and 12
  groups, 1.5MiB

- for the port, 16 buckets, each 2 ^ 12 bits wide, 2 groups, 0.25MiB

that is, 9.75MiB.

With 8-bit buckets: we can just multiply everything by 8 (that is,
2 ^ 8 / 2 ^ 4 / 2, because we have 2 ^ (8 - 4) times the buckets, with
half the groups), 78MiB.

And that started feeling like "a lot". However, I'm probably overdoing
with the worst case -- this was just to explain what brought me to the
4-bit choice, now I start doubting about it.

> Anyway, my understanding is that the more bits you use for grouping,
> the larger the lookup table becomes.
> 
> Still, both look very small in terms of memory consumption for these
> days.
> 
> I'm just telling this because the C implementation can probably get
> better numbers at the cost of consuming more memory? Probably do this
> at some point?

Another topic is the additional amount of cachelines we would use. I
don't expect that effect to be visible, but I might be wrong.

So yes, I think it's definitely worth a try, thanks for the hint! I'll
try to look into this soon and test it on a few archs (something with
small cachelines, say MIPS r2k, would be worth checking, too).

We could even consider to dynamically adjust group size depending on
the set size, I don't know yet if that gets too convoluted.

> BTW, with a few more knobs it should be possible to integrate better
> this datastructure into the transaction infrastructure, this can be
> done incrementally.
> 
> More questions below.
> 
> On Wed, Jan 22, 2020 at 12:17:55AM +0100, Stefano Brivio wrote:
> [...]
> > diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
> > new file mode 100644
> > index 000000000000..f0cb1e13af50
> > --- /dev/null
> > +++ b/net/netfilter/nft_set_pipapo.c  
> [...]
> > + *
> > + *       rule indices in current field: 0    1    2
> > + *       map to rules in next field:    0    1    1
> > + *
> > + *      the new result bitmap will be 0x02: rule 1 was set, and rule 1 will be
> > + *      set.
> > + *
> > + *      We can now extend this example to cover the second iteration of the step
> > + *      above (lookup and AND bitmap): assuming the port field is
> > + *      2048 < 0  0  5  0 >, with starting result bitmap 0x2, and lookup table
> > + *      for "port" field from pre-computation example:
> > + *
> > + * ::
> > + *
> > + *                     bucket
> > + *      group  0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15
> > + *        0   0,1
> > + *        1   0,1
> > + *        2                    0   1
> > + *        3   0,1
> > + *
> > + *       operations are: 0x2 & 0x3 [bucket 0] & 0x3 [bucket 0] & 0x2 [bucket 5]
> > + *       & 0x3 [bucket 0], resulting bitmap is 0x2.
> > + *
> > + *   - if this is the last field in the set, look up the value from the mapping
> > + *     array corresponding to the final result bitmap
> > + *
> > + *      Example: 0x2 resulting bitmap from 192.168.1.5:2048, mapping array for
> > + *      last field from insertion example:
> > + *
> > + * ::
> > + *
> > + *       rule indices in last field:    0    1
> > + *       map to elements:             0x42  0x66  
> 
> Should this be instead?
> 
>             rule indices in last field:    0    1
>             map to elements:             0x66  0x42
> 
> If the resulting bitmap is 0x2, then this is actually pointing to
> rule index 1 in this lookup table, that is the 2048.

Right! Good catch, thanks.

I swapped the values also in the "insertion" example above. For some
reason, this was correct in the equivalent example of the stand-alone
implementation:
	https://pipapo.lameexcu.se/pipapo/tree/pipapo.c#n162

> > + *      the matching element is at 0x42.  
> 
> Hence, the matching 0x42 element.
> 
> Otherwise, I don't understand how to interpret the "result bitmap". I
> thought this contains the matching pipapo rule index that is expressed
> as a bitmask.

Yes, that's correct. Let me know if you want me to send a patch or if
you'd rather fix it.

> [...]
> > +static int pipapo_refill(unsigned long *map, int len, int rules,
> > +			 unsigned long *dst, union nft_pipapo_map_bucket *mt,
> > +			 bool match_only)
> > +{
> > +	unsigned long bitset;
> > +	int k, ret = -1;
> > +
> > +	for (k = 0; k < len; k++) {
> > +		bitset = map[k];
> > +		while (bitset) {
> > +			unsigned long t = bitset & -bitset;
> > +			int r = __builtin_ctzl(bitset);
> > +			int i = k * BITS_PER_LONG + r;
> > +
> > +			if (unlikely(i >= rules)) {
> > +				map[k] = 0;
> > +				return -1;
> > +			}
> > +
> > +			if (unlikely(match_only)) {  
> 
> Not a big issue, but this branch holds true for the last field, my
> understanding for unlikely() is that it should be used for paths where
> 99.99...% is not going to happen. Not a big issue, just that when
> reading the code I got confused this is actually likely to happen.

You're right, I wanted to make sure we avoid branching for the "common"
case (this early return happens just once), but this is probably an
abuse. I'll look into a more acceptable way to achieve this.

> > +				bitmap_clear(map, i, 1);
> > +				return i;
> > +			}
> > +
> > +			ret = 0;
> > +
> > +			bitmap_set(dst, mt[i].to, mt[i].n);
> > +
> > +			bitset ^= t;
> > +		}
> > +		map[k] = 0;
> > +	}
> > +
> > +	return ret;  
> > +}>   

-- 
Stefano

