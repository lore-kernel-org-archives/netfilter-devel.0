Return-Path: <SRS0=l6lg=33=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B42BC352A2
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Feb 2020 11:23:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48AAD20726
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Feb 2020 11:23:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgBGLXN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Feb 2020 06:23:13 -0500
Received: from correo.us.es ([193.147.175.20]:59272 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726674AbgBGLXN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Feb 2020 06:23:13 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 409F4118460
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Feb 2020 12:23:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 32CF5DA709
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Feb 2020 12:23:12 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 21745DA712; Fri,  7 Feb 2020 12:23:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2001FDA712;
        Fri,  7 Feb 2020 12:23:10 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 07 Feb 2020 12:23:10 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id F33D742EF42F;
        Fri,  7 Feb 2020 12:23:09 +0100 (CET)
Date:   Fri, 7 Feb 2020 12:23:08 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?iso-8859-1?Q?J=F3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nf-next v4 5/9] nf_tables: Add set type for arbitrary
 concatenation of ranges
Message-ID: <20200207112308.sqtlvbluujlftqz2@salvia>
References: <cover.1579647351.git.sbrivio@redhat.com>
 <4e78727d12d54ebd6a6f832585d15f116280dc42.1579647351.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e78727d12d54ebd6a6f832585d15f116280dc42.1579647351.git.sbrivio@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Stefano,

A bit of late feedback on your new datastructure.

Did you tests with 8-bits grouping instead of 4-bits?

Assuming a concatenation of 12 bytes (each field 4 bytes, hence 3
fields):

* Using 4-bits groups: the number of buckets is 2^4 = 16 multiplied
  by the bucket word (assuming one long word, 8 bytes, 64 pipapo
  rules) is 16 * 8 = 128 bytes per group-row in the looking table. Then,
  the number of group-rows is 8 given that 32 bits, then 32 / 4 = 8
  group-rows.

  8 * 128 bytes = 1024 bytes per lookup table.

  Assuming 3 fields, then this is 1024 * 3 = 3072 bytes.

* Using 8-bits groups: 2^8 = 256, then 256 * 8 = 2048 bytes per
  group-row. Then, 32 / 8 = 4 group-rows in total.

  4 * 2048 bytes = 8192 bytes per lookup table.

  Therefore, 3 * 8192 = 24576 bytes. Still rather small.

This is missing the mapping table that links the lookup tables in the
memory counting. And I'm assuming that the number of pipapo rules in
the lookup table fits into 64-bits bucket long word.

Anyway, my understanding is that the more bits you use for grouping,
the larger the lookup table becomes.

Still, both look very small in terms of memory consumption for these
days.

I'm just telling this because the C implementation can probably get
better numbers at the cost of consuming more memory? Probably do this
at some point?

BTW, with a few more knobs it should be possible to integrate better
this datastructure into the transaction infrastructure, this can be
done incrementally.

More questions below.

On Wed, Jan 22, 2020 at 12:17:55AM +0100, Stefano Brivio wrote:
[...]
> diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
> new file mode 100644
> index 000000000000..f0cb1e13af50
> --- /dev/null
> +++ b/net/netfilter/nft_set_pipapo.c
[...]
> + *
> + *       rule indices in current field: 0    1    2
> + *       map to rules in next field:    0    1    1
> + *
> + *      the new result bitmap will be 0x02: rule 1 was set, and rule 1 will be
> + *      set.
> + *
> + *      We can now extend this example to cover the second iteration of the step
> + *      above (lookup and AND bitmap): assuming the port field is
> + *      2048 < 0  0  5  0 >, with starting result bitmap 0x2, and lookup table
> + *      for "port" field from pre-computation example:
> + *
> + * ::
> + *
> + *                     bucket
> + *      group  0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15
> + *        0   0,1
> + *        1   0,1
> + *        2                    0   1
> + *        3   0,1
> + *
> + *       operations are: 0x2 & 0x3 [bucket 0] & 0x3 [bucket 0] & 0x2 [bucket 5]
> + *       & 0x3 [bucket 0], resulting bitmap is 0x2.
> + *
> + *   - if this is the last field in the set, look up the value from the mapping
> + *     array corresponding to the final result bitmap
> + *
> + *      Example: 0x2 resulting bitmap from 192.168.1.5:2048, mapping array for
> + *      last field from insertion example:
> + *
> + * ::
> + *
> + *       rule indices in last field:    0    1
> + *       map to elements:             0x42  0x66

Should this be instead?

            rule indices in last field:    0    1
            map to elements:             0x66  0x42

If the resulting bitmap is 0x2, then this is actually pointing to
rule index 1 in this lookup table, that is the 2048.

> + *      the matching element is at 0x42.

Hence, the matching 0x42 element.

Otherwise, I don't understand how to interpret the "result bitmap". I
thought this contains the matching pipapo rule index that is expressed
as a bitmask.

[...]
> +static int pipapo_refill(unsigned long *map, int len, int rules,
> +			 unsigned long *dst, union nft_pipapo_map_bucket *mt,
> +			 bool match_only)
> +{
> +	unsigned long bitset;
> +	int k, ret = -1;
> +
> +	for (k = 0; k < len; k++) {
> +		bitset = map[k];
> +		while (bitset) {
> +			unsigned long t = bitset & -bitset;
> +			int r = __builtin_ctzl(bitset);
> +			int i = k * BITS_PER_LONG + r;
> +
> +			if (unlikely(i >= rules)) {
> +				map[k] = 0;
> +				return -1;
> +			}
> +
> +			if (unlikely(match_only)) {

Not a big issue, but this branch holds true for the last field, my
understanding for unlikely() is that it should be used for paths where
99.99...% is not going to happen. Not a big issue, just that when
reading the code I got confused this is actually likely to happen.

> +				bitmap_clear(map, i, 1);
> +				return i;
> +			}
> +
> +			ret = 0;
> +
> +			bitmap_set(dst, mt[i].to, mt[i].n);
> +
> +			bitset ^= t;
> +		}
> +		map[k] = 0;
> +	}
> +
> +	return ret;
> +}> 
