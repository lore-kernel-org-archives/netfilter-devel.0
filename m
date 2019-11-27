Return-Path: <SRS0=TrSD=ZT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73756C432C0
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Nov 2019 09:29:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32B86204FD
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Nov 2019 09:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbfK0J34 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Nov 2019 04:29:56 -0500
Received: from correo.us.es ([193.147.175.20]:44782 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbfK0J34 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Nov 2019 04:29:56 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D249D120838
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Nov 2019 10:29:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AB722DA713
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Nov 2019 10:29:47 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9F8C4DA701; Wed, 27 Nov 2019 10:29:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E404CDA703;
        Wed, 27 Nov 2019 10:29:43 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 27 Nov 2019 10:29:43 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B1BFA42EE38E;
        Wed, 27 Nov 2019 10:29:43 +0100 (CET)
Date:   Wed, 27 Nov 2019 10:29:45 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?iso-8859-1?Q?J=F3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nf-next v2 3/8] nf_tables: Add set type for arbitrary
 concatenation of ranges
Message-ID: <20191127092945.kp25vjfwxcrbjapx@salvia>
References: <cover.1574428269.git.sbrivio@redhat.com>
 <5e7c454e030a8ad581a12d88881f96374e96da68.1574428269.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e7c454e030a8ad581a12d88881f96374e96da68.1574428269.git.sbrivio@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Stefano,

Just started reading, a few initial questions.

On Fri, Nov 22, 2019 at 02:40:02PM +0100, Stefano Brivio wrote:
[...]
> diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
> index 7281895fa6d9..9759257ec8ec 100644
> --- a/include/net/netfilter/nf_tables_core.h
> +++ b/include/net/netfilter/nf_tables_core.h
> @@ -74,6 +74,7 @@ extern struct nft_set_type nft_set_hash_type;
>  extern struct nft_set_type nft_set_hash_fast_type;
>  extern struct nft_set_type nft_set_rbtree_type;
>  extern struct nft_set_type nft_set_bitmap_type;
> +extern struct nft_set_type nft_set_pipapo_type;
>  
>  struct nft_expr;
>  struct nft_regs;
> diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
> index 5e9b2eb24349..3f572e5a975e 100644
> --- a/net/netfilter/Makefile
> +++ b/net/netfilter/Makefile
> @@ -81,7 +81,8 @@ nf_tables-objs := nf_tables_core.o nf_tables_api.o nft_chain_filter.o \
>  		  nft_chain_route.o nf_tables_offload.o
>  
>  nf_tables_set-objs := nf_tables_set_core.o \
> -		      nft_set_hash.o nft_set_bitmap.o nft_set_rbtree.o
> +		      nft_set_hash.o nft_set_bitmap.o nft_set_rbtree.o \
> +		      nft_set_pipapo.o
>  
>  obj-$(CONFIG_NF_TABLES)		+= nf_tables.o
>  obj-$(CONFIG_NF_TABLES_SET)	+= nf_tables_set.o
> diff --git a/net/netfilter/nf_tables_set_core.c b/net/netfilter/nf_tables_set_core.c
> index a9fce8d10051..586b621007eb 100644
> --- a/net/netfilter/nf_tables_set_core.c
> +++ b/net/netfilter/nf_tables_set_core.c
> @@ -9,12 +9,14 @@ static int __init nf_tables_set_module_init(void)
>  	nft_register_set(&nft_set_rhash_type);
>  	nft_register_set(&nft_set_bitmap_type);
>  	nft_register_set(&nft_set_rbtree_type);
> +	nft_register_set(&nft_set_pipapo_type);
>  
>  	return 0;
>  }
>  
>  static void __exit nf_tables_set_module_exit(void)
>  {
> +	nft_unregister_set(&nft_set_pipapo_type);
>  	nft_unregister_set(&nft_set_rbtree_type);
>  	nft_unregister_set(&nft_set_bitmap_type);
>  	nft_unregister_set(&nft_set_rhash_type);
> diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
> new file mode 100644
> index 000000000000..3cad9aedc168
> --- /dev/null
> +++ b/net/netfilter/nft_set_pipapo.c
> @@ -0,0 +1,2197 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +/* PIPAPO: PIle PAcket POlicies: set for arbitrary concatenations of ranges
> + *
> + * Copyright (c) 2019 Red Hat GmbH
> + *
> + * Author: Stefano Brivio <sbrivio@redhat.com>
> + */
> +
> +/**
> + * DOC: Theory of Operation
> + *
> + *
> + * Problem
> + * -------
> + *
> + * Match packet bytes against entries composed of ranged or non-ranged packet
> + * field specifiers, mapping them to arbitrary references. For example:
> + *
> + * ::
> + *
> + *               --- fields --->
> + *      |    [net],[port],[net]... => [reference]
> + *   entries [net],[port],[net]... => [reference]
> + *      |    [net],[port],[net]... => [reference]
> + *      V    ...
> + *
> + * where [net] fields can be IP ranges or netmasks, and [port] fields are port
> + * ranges. Arbitrary packet fields can be matched.
> + *
> + *
> + * Algorithm Overview
> + * ------------------
> + *
> + * This algorithm is loosely inspired by [Ligatti 2010], and fundamentally
> + * relies on the consideration that every contiguous range in a space of b bits
> + * can be converted into b * 2 netmasks, from Theorem 3 in [Rottenstreich 2010],
> + * as also illustrated in Section 9 of [Kogan 2014].
> + *
> + * Classification against a number of entries, that require matching given bits
> + * of a packet field, is performed by grouping those bits in sets of arbitrary
> + * size, and classifying packet bits one group at a time.
> + *
> + * Example:
> + *   to match the source port (16 bits) of a packet, we can divide those 16 bits
> + *   in 4 groups of 4 bits each. Given the entry:
> + *      0000 0001 0101 1001
> + *   and a packet with source port:
> + *      0000 0001 1010 1001
> + *   first and second groups match, but the third doesn't. We conclude that the
> + *   packet doesn't match the given entry.
> + *
> + * Translate the set to a sequence of lookup tables, one per field. Each table
> + * has two dimensions: bit groups to be matched for a single packet field, and
> + * all the possible values of said groups (buckets). Input entries are
> + * represented as one or more rules, depending on the number of composing
> + * netmasks for the given field specifier, and a group match is indicated as a
> + * set bit, with number corresponding to the rule index, in all the buckets
> + * whose value matches the entry for a given group.
> + *
> + * Rules are mapped between fields through an array of x, n pairs, with each
> + * item mapping a matched rule to one or more rules. The position of the pair in
> + * the array indicates the matched rule to be mapped to the next field, x
> + * indicates the first rule index in the next field, and n the amount of
> + * next-field rules the current rule maps to.
> + *
> + * The mapping array for the last field maps to the desired references.
> + *
> + * To match, we perform table lookups using the values of grouped packet bits,
> + * and use a sequence of bitwise operations to progressively evaluate rule
> + * matching.
> + *
> + * A stand-alone, reference implementation, also including notes about possible
> + * future optimisations, is available at:
> + *    https://pipapo.lameexcu.se/
> + *
> + * Insertion
> + * ---------
> + *
> + * - For each packet field:
> + *
> + *   - divide the b packet bits we want to classify into groups of size t,
> + *     obtaining ceil(b / t) groups
> + *
> + *      Example: match on destination IP address, with t = 4: 32 bits, 8 groups
> + *      of 4 bits each
> + *
> + *   - allocate a lookup table with one column ("bucket") for each possible
> + *     value of a group, and with one row for each group
> + *
> + *      Example: 8 groups, 2^4 buckets:
> + *
> + * ::
> + *
> + *                     bucket
> + *      group  0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15
> + *        0
> + *        1
> + *        2
> + *        3
> + *        4
> + *        5
> + *        6
> + *        7
> + *
> + *   - map the bits we want to classify for the current field, for a given
> + *     entry, to a single rule for non-ranged and netmask set items, and to one
> + *     or multiple rules for ranges. Ranges are expanded to composing netmasks
> + *     by pipapo_expand().
> + *
> + *      Example: 2 entries, 10.0.0.5:1024 and 192.168.1.0-192.168.2.1:2048
> + *      - rule #0: 10.0.0.5
> + *      - rule #1: 192.168.1.0/24
> + *      - rule #2: 192.168.2.0/31
> + *
> + *   - insert references to the rules in the lookup table, selecting buckets
> + *     according to bit values of a rule in the given group. This is done by
> + *     pipapo_insert().
> + *
> + *      Example: given:
> + *      - rule #0: 10.0.0.5 mapping to buckets
> + *        < 0 10  0 0   0 0  0 5 >
> + *      - rule #1: 192.168.1.0/24 mapping to buckets
> + *        < 12 0  10 8  0 1  < 0..15 > < 0..15 > >
> + *      - rule #2: 192.168.2.0/31 mapping to buckets
> + *        < 12 0  10 8  0 2  0 < 0..1 > >
> + *
> + *      these bits are set in the lookup table:
> + *
> + * ::
> + *
> + *                     bucket
> + *      group  0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15
> + *        0    0                                              1,2
> + *        1   1,2                                      0
> + *        2    0                                      1,2
> + *        3    0                              1,2
> + *        4  0,1,2
> + *        5    0   1   2
> + *        6  0,1,2 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1
> + *        7   1,2 1,2  1   1   1  0,1  1   1   1   1   1   1   1   1   1   1
> + *
> + *   - if this is not the last field in the set, fill a mapping array that maps
> + *     rules from the lookup table to rules belonging to the same entry in
> + *     the next lookup table, done by pipapo_map().
> + *
> + *     Note that as rules map to contiguous ranges of rules, given how netmask
> + *     expansion and insertion is performed, &union nft_pipapo_map_bucket stores
> + *     this information as pairs of first rule index, rule count.
> + *
> + *      Example: 2 entries, 10.0.0.5:1024 and 192.168.1.0-192.168.2.1:2048,
> + *      given lookup table #0 for field 0 (see example above):
> + *
> + * ::
> + *
> + *                     bucket
> + *      group  0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15
> + *        0    0                                              1,2
> + *        1   1,2                                      0
> + *        2    0                                      1,2
> + *        3    0                              1,2
> + *        4  0,1,2
> + *        5    0   1   2
> + *        6  0,1,2 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1
> + *        7   1,2 1,2  1   1   1  0,1  1   1   1   1   1   1   1   1   1   1
> + *
> + *      and lookup table #1 for field 1 with:
> + *      - rule #0: 1024 mapping to buckets
> + *        < 0  0  4  0 >
> + *      - rule #1: 2048 mapping to buckets
> + *        < 0  0  5  0 >
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
> + *      we need to map rules for 10.0.0.5 in lookup table #0 (rule #0) to 1024
> + *      in lookup table #1 (rule #0) and rules for 192.168.1.0-192.168.2.1
> + *      (rules #1, #2) to 2048 in lookup table #2 (rule #1):
> + *
> + * ::
> + *
> + *       rule indices in current field: 0    1    2
> + *       map to rules in next field:    0    1    1
> + *
> + *   - if this is the last field in the set, fill a mapping array that maps
> + *     rules from the last lookup table to element pointers, also done by
> + *     pipapo_map().
> + *
> + *     Note that, in this implementation, we have two elements (start, end) for
> + *     each entry. The pointer to the end element is stored in this array, and
> + *     the pointer to the start element is linked from it.
> + *
> + *      Example: entry 10.0.0.5:1024 has a corresponding &struct nft_pipapo_elem
> + *      pointer, 0x66, and element for 192.168.1.0-192.168.2.1:2048 is at 0x42.
> + *      From the rules of lookup table #1 as mapped above:
> + *
> + * ::
> + *
> + *       rule indices in last field:    0    1
> + *       map to elements:             0x42  0x66
> + *
> + *
> + * Matching
> + * --------
> + *
> + * We use a result bitmap, with the size of a single lookup table bucket, to
> + * represent the matching state that applies at every algorithm step. This is
> + * done by pipapo_lookup().
> + *
> + * - For each packet field:
> + *
> + *   - start with an all-ones result bitmap (res_map in pipapo_lookup())
> + *
> + *   - perform a lookup into the table corresponding to the current field,
> + *     for each group, and at every group, AND the current result bitmap with
> + *     the value from the lookup table bucket
> + *
> + * ::
> + *
> + *      Example: 192.168.1.5 < 12 0  10 8  0 1  0 5 >, with lookup table from
> + *      insertion examples.
> + *      Lookup table buckets are at least 3 bits wide, we'll assume 8 bits for
> + *      convenience in this example. Initial result bitmap is 0xff, the steps
> + *      below show the value of the result bitmap after each group is processed:
> + *
> + *                     bucket
> + *      group  0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15
> + *        0    0                                              1,2
> + *        result bitmap is now: 0xff & 0x6 [bucket 12] = 0x6
> + *
> + *        1   1,2                                      0
> + *        result bitmap is now: 0x6 & 0x6 [bucket 0] = 0x6
> + *
> + *        2    0                                      1,2
> + *        result bitmap is now: 0x6 & 0x6 [bucket 10] = 0x6
> + *
> + *        3    0                              1,2
> + *        result bitmap is now: 0x6 & 0x6 [bucket 8] = 0x6
> + *
> + *        4  0,1,2
> + *        result bitmap is now: 0x6 & 0x7 [bucket 0] = 0x6
> + *
> + *        5    0   1   2
> + *        result bitmap is now: 0x6 & 0x2 [bucket 1] = 0x2
> + *
> + *        6  0,1,2 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1
> + *        result bitmap is now: 0x2 & 0x7 [bucket 0] = 0x2
> + *
> + *        7   1,2 1,2  1   1   1  0,1  1   1   1   1   1   1   1   1   1   1
> + *        final result bitmap for this field is: 0x2 & 0x3 [bucket 5] = 0x2
> + *
> + *   - at the next field, start with a new, all-zeroes result bitmap. For each
> + *     bit set in the previous result bitmap, fill the new result bitmap
> + *     (fill_map in pipapo_lookup()) with the rule indices from the
> + *     corresponding buckets of the mapping field for this field, done by
> + *     pipapo_refill()
> + *
> + *      Example: with mapping table from insertion examples, with the current
> + *      result bitmap from the previous example, 0x02:
> + *
> + * ::
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
> + *
> + *      the matching element is at 0x42.
> + *
> + *
> + * References
> + * ----------
> + *
> + * [Ligatti 2010]
> + *      A Packet-classification Algorithm for Arbitrary Bitmask Rules, with
> + *      Automatic Time-space Tradeoffs
> + *      Jay Ligatti, Josh Kuhn, and Chris Gage.
> + *      Proceedings of the IEEE International Conference on Computer
> + *      Communication Networks (ICCCN), August 2010.
> + *      http://www.cse.usf.edu/~ligatti/papers/grouper-conf.pdf
> + *
> + * [Rottenstreich 2010]
> + *      Worst-Case TCAM Rule Expansion
> + *      Ori Rottenstreich and Isaac Keslassy.
> + *      2010 Proceedings IEEE INFOCOM, San Diego, CA, 2010.
> + *      http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.212.4592&rep=rep1&type=pdf
> + *
> + * [Kogan 2014]
> + *      SAX-PAC (Scalable And eXpressive PAcket Classification)
> + *      Kirill Kogan, Sergey Nikolenko, Ori Rottenstreich, William Culhane,
> + *      and Patrick Eugster.
> + *      Proceedings of the 2014 ACM conference on SIGCOMM, August 2014.
> + *      http://www.sigcomm.org/sites/default/files/ccr/papers/2014/August/2619239-2626294.pdf
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/log2.h>
> +#include <linux/module.h>
> +#include <linux/netlink.h>
> +#include <linux/netfilter.h>
> +#include <linux/netfilter/nf_tables.h>
> +#include <net/netfilter/nf_tables_core.h>
> +#include <uapi/linux/netfilter/nf_tables.h>
> +#include <net/ipv6.h>			/* For the maximum length of a field */
> +#include <linux/bitmap.h>
> +#include <linux/bitops.h>
> +
> +/* Count of concatenated fields depends on count of 32-bit nftables registers */
> +#define NFT_PIPAPO_MAX_FIELDS		NFT_REG32_COUNT
> +
> +/* Largest supported field size */
> +#define NFT_PIPAPO_MAX_BYTES		(sizeof(struct in6_addr))
> +#define NFT_PIPAPO_MAX_BITS		(NFT_PIPAPO_MAX_BYTES * BITS_PER_BYTE)
> +
> +/* Number of bits to be grouped together in lookup table buckets, arbitrary */
> +#define NFT_PIPAPO_GROUP_BITS		4
> +#define NFT_PIPAPO_GROUPS_PER_BYTE	(BITS_PER_BYTE / NFT_PIPAPO_GROUP_BITS)
> +
> +/* Fields are padded to 32 bits in input registers */
> +#define NFT_PIPAPO_GROUPS_PADDED_SIZE(x)				\
> +	(round_up((x) / NFT_PIPAPO_GROUPS_PER_BYTE, sizeof(u32)))
> +#define NFT_PIPAPO_GROUPS_PADDING(x)					\
> +	(NFT_PIPAPO_GROUPS_PADDED_SIZE((x)) - (x) / NFT_PIPAPO_GROUPS_PER_BYTE)
> +
> +/* Number of buckets, given by 2 ^ n, with n grouped bits */
> +#define NFT_PIPAPO_BUCKETS		(1 << NFT_PIPAPO_GROUP_BITS)
> +
> +/* Each n-bit range maps to up to n * 2 rules */
> +#define NFT_PIPAPO_MAP_NBITS		(const_ilog2(NFT_PIPAPO_MAX_BITS * 2))
> +
> +/* Use the rest of mapping table buckets for rule indices, but it makes no sense
> + * to exceed 32 bits
> + */
> +#if BITS_PER_LONG == 64
> +#define NFT_PIPAPO_MAP_TOBITS		32
> +#else
> +#define NFT_PIPAPO_MAP_TOBITS		(BITS_PER_LONG - NFT_PIPAPO_MAP_NBITS)
> +#endif
> +
> +/* ...which gives us the highest allowed index for a rule */
> +#define NFT_PIPAPO_RULE0_MAX		((1UL << (NFT_PIPAPO_MAP_TOBITS - 1)) \
> +					- (1UL << NFT_PIPAPO_MAP_NBITS))
> +
> +#define nft_pipapo_for_each_field(field, index, match)		\
> +	for ((field) = (match)->f, (index) = 0;			\
> +	     (index) < (match)->field_count;			\
> +	     (index)++, (field)++)
> +
> +/**
> + * union nft_pipapo_map_bucket - Bucket of mapping table
> + * @to:		First rule number (in next field) this rule maps to
> + * @n:		Number of rules (in next field) this rule maps to
> + * @e:		If there's no next field, pointer to element this rule maps to
> + */
> +union nft_pipapo_map_bucket {
> +	struct {
> +#if BITS_PER_LONG == 64
> +		static_assert(NFT_PIPAPO_MAP_TOBITS <= 32);
> +		u32 to;
> +
> +		static_assert(NFT_PIPAPO_MAP_NBITS <= 32);
> +		u32 n;
> +#else
> +		unsigned long to:NFT_PIPAPO_MAP_TOBITS;
> +		unsigned long  n:NFT_PIPAPO_MAP_NBITS;
> +#endif
> +	};
> +	struct nft_pipapo_elem *e;
> +};
> +
> +/**
> + * struct nft_pipapo_field - Lookup, mapping tables and related data for a field
> + * @groups:	Amount of 4-bit groups
> + * @rules:	Number of inserted rules
> + * @bsize:	Size of each bucket in lookup table, in longs
> + * @lt:		Lookup table: 'groups' rows of NFT_PIPAPO_BUCKETS buckets
> + * @mt:		Mapping table: one bucket per rule
> + */
> +struct nft_pipapo_field {
> +	int groups;
> +	unsigned long rules;
> +	size_t bsize;
> +	unsigned long *lt;
> +	union nft_pipapo_map_bucket *mt;
> +};
> +
> +/**
> + * struct nft_pipapo_match - Data used for lookup and matching
> + * @field_count		Amount of fields in set
> + * @scratch:		Preallocated per-CPU maps for partial matching results
> + * @bsize_max:		Maximum lookup table bucket size of all fields, in longs
> + * @rcu			Matching data is swapped on commits
> + * @f:			Fields, with lookup and mapping tables
> + */
> +struct nft_pipapo_match {
> +	int field_count;
> +	unsigned long * __percpu *scratch;
> +	size_t bsize_max;
> +	struct rcu_head rcu;
> +	struct nft_pipapo_field f[0];
> +};
> +
> +/* Current working bitmap index, toggled between field matches */
> +static DEFINE_PER_CPU(bool, nft_pipapo_scratch_index);
> +
> +/**
> + * struct nft_pipapo - Representation of a set
> + * @match:	Currently in-use matching data
> + * @clone:	Copy where pending insertions and deletions are kept
> + * @groups:	Total amount of 4-bit groups for fields in this set
> + * @width:	Total bytes to be matched for one packet, including padding
> + * @dirty:	Working copy has pending insertions or deletions
> + * @last_gc:	Timestamp of last garbage collection run, jiffies
> + * @start_data:	Key data of start element for insertion
> + * @start_elem:	Start element for insertion
> + */
> +struct nft_pipapo {
> +	struct nft_pipapo_match __rcu *match;
> +	struct nft_pipapo_match *clone;
> +	int groups;
> +	int width;
> +	bool dirty;
> +	unsigned long last_gc;
> +	u8 start_data[NFT_DATA_VALUE_MAXLEN * sizeof(u32)];
> +	struct nft_pipapo_elem *start_elem;
> +};
> +
> +struct nft_pipapo_elem;
> +
> +/**
> + * struct nft_pipapo_elem - API-facing representation of single set element
> + * @start:	Pointer to element that represents start of interval
> + * @ext:	nftables API extensions
> + */
> +struct nft_pipapo_elem {
> +	struct nft_pipapo_elem *start;
> +	struct nft_set_ext ext;
> +};
> +
> +/**
> + * pipapo_refill() - For each set bit, set bits from selected mapping table item
> + * @map:	Bitmap to be scanned for set bits
> + * @len:	Length of bitmap in longs
> + * @rules:	Number of rules in field
> + * @dst:	Destination bitmap
> + * @mt:		Mapping table containing bit set specifiers
> + * @match_only:	Find a single bit and return, don't fill
> + *
> + * Iteration over set bits with __builtin_ctzl(): Daniel Lemire, public domain.
> + *
> + * For each bit set in map, select the bucket from mapping table with index
> + * corresponding to the position of the bit set. Use start bit and amount of
> + * bits specified in bucket to fill region in dst.
> + *
> + * Return: -1 on no match, bit position on 'match_only', 0 otherwise.
> + */
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
> +}
> +
> +/**
> + * nft_pipapo_lookup() - Lookup function
> + * @net:	Network namespace
> + * @set:	nftables API set representation
> + * @elem:	nftables API element representation containing key data
> + * @ext:	nftables API extension pointer, filled with matching reference
> + *
> + * For more details, see DOC: Theory of Operation.
> + *
> + * Return: true on match, false otherwise.
> + */
> +static bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
> +			      const u32 *key, const struct nft_set_ext **ext)
> +{
> +	struct nft_pipapo *priv = nft_set_priv(set);
> +	unsigned long *res_map, *fill_map;
> +	u8 genmask = nft_genmask_cur(net);
> +	const u8 *rp = (const u8 *)key;
> +	struct nft_pipapo_match *m;
> +	struct nft_pipapo_field *f;
> +	bool map_index;
> +	int i;
> +
> +	local_bh_disable();
> +
> +	map_index = raw_cpu_read(nft_pipapo_scratch_index);
> +
> +	m = rcu_dereference(priv->match);
> +
> +	if (unlikely(!m || !*raw_cpu_ptr(m->scratch)))
> +		goto out;
> +
> +	res_map  = *raw_cpu_ptr(m->scratch) + (map_index ? m->bsize_max : 0);
> +	fill_map = *raw_cpu_ptr(m->scratch) + (map_index ? 0 : m->bsize_max);
> +
> +	memset(res_map, 0xff, m->bsize_max * sizeof(*res_map));
> +
> +	nft_pipapo_for_each_field(f, i, m) {
> +		bool last = i == m->field_count - 1;
> +		unsigned long *lt = f->lt;
> +		int b, group;
> +
> +		/* For each 4-bit group: select lookup table bucket depending on
> +		 * packet bytes value, then AND bucket value
> +		 */
> +		for (group = 0; group < f->groups; group++) {
> +			u8 v;
> +
> +			if (group % 2) {
> +				v = *rp & 0x0f;
> +				rp++;
> +			} else {
> +				v = *rp >> 4;
> +			}
> +			__bitmap_and(res_map, res_map, lt + v * f->bsize,
> +				     f->bsize * BITS_PER_LONG);
> +
> +			lt += f->bsize * NFT_PIPAPO_BUCKETS;
> +		}
> +
> +		/* Now populate the bitmap for the next field, unless this is
> +		 * the last field, in which case return the matched 'ext'
> +		 * pointer if any.
> +		 *
> +		 * Now res_map contains the matching bitmap, and fill_map is the
> +		 * bitmap for the next field.
> +		 */
> +next_match:
> +		b = pipapo_refill(res_map, f->bsize, f->rules, fill_map, f->mt,
> +				  last);
> +		if (b < 0) {
> +			raw_cpu_write(nft_pipapo_scratch_index, map_index);
> +			local_bh_enable();
> +
> +			return false;
> +		}
> +
> +		if (last) {
> +			*ext = &f->mt[b].e->ext;
> +			if (unlikely(nft_set_elem_expired(*ext) ||
> +				     !nft_set_elem_active(*ext, genmask)))
> +				goto next_match;
> +
> +			/* Last field: we're just returning the key without
> +			 * filling the initial bitmap for the next field, so the
> +			 * current inactive bitmap is clean and can be reused as
> +			 * *next* bitmap (not initial) for the next packet.
> +			 */
> +			raw_cpu_write(nft_pipapo_scratch_index, map_index);
> +			local_bh_enable();
> +
> +			return true;
> +		}
> +
> +		/* Swap bitmap indices: res_map is the initial bitmap for the
> +		 * next field, and fill_map is guaranteed to be all-zeroes at
> +		 * this point.
> +		 */
> +		map_index = !map_index;
> +		swap(res_map, fill_map);
> +
> +		rp += NFT_PIPAPO_GROUPS_PADDING(f->groups);
> +	}
> +
> +out:
> +	local_bh_enable();
> +	return false;
> +}
> +
> +/**
> + * pipapo_get() - Get matching start or end element reference given key data
> + * @net:	Network namespace
> + * @set:	nftables API set representation
> + * @data:	Key data to be matched against existing elements
> + * @flags:	If NFT_SET_ELEM_INTERVAL_END is passed, return the end element
> + *
> + * This is essentially the same as the lookup function, except that it matches
> + * key data against the uncommitted copy and doesn't use preallocated maps for
> + * bitmap results.
> + *
> + * Return: pointer to &struct nft_pipapo_elem on match, error pointer otherwise.
> + */
> +static void *pipapo_get(const struct net *net, const struct nft_set *set,
> +			const u8 *data, unsigned int flags)
> +{
> +	struct nft_pipapo *priv = nft_set_priv(set);
> +	struct nft_pipapo_match *m = priv->clone;
> +	unsigned long *res_map, *fill_map = NULL;
> +	void *ret = ERR_PTR(-ENOENT);
> +	struct nft_pipapo_field *f;
> +	int i;
> +
> +	res_map = kmalloc_array(m->bsize_max, sizeof(*res_map), GFP_ATOMIC);
> +	if (!res_map) {
> +		ret = ERR_PTR(-ENOMEM);
> +		goto out;
> +	}
> +
> +	fill_map = kcalloc(m->bsize_max, sizeof(*res_map), GFP_ATOMIC);
> +	if (!fill_map) {
> +		ret = ERR_PTR(-ENOMEM);
> +		goto out;
> +	}
> +
> +	memset(res_map, 0xff, m->bsize_max * sizeof(*res_map));
> +
> +	nft_pipapo_for_each_field(f, i, m) {
> +		bool last = i == m->field_count - 1;
> +		unsigned long *lt = f->lt;
> +		int b, group;
> +
> +		/* For each 4-bit group: select lookup table bucket depending on
> +		 * packet bytes value, then AND bucket value
> +		 */
> +		for (group = 0; group < f->groups; group++) {
> +			u8 v;
> +
> +			if (group % 2) {
> +				v = *data & 0x0f;
> +				data++;
> +			} else {
> +				v = *data >> 4;
> +			}
> +			__bitmap_and(res_map, res_map, lt + v * f->bsize,
> +				     f->bsize * BITS_PER_LONG);
> +
> +			lt += f->bsize * NFT_PIPAPO_BUCKETS;
> +		}
> +
> +		/* Now populate the bitmap for the next field, unless this is
> +		 * the last field, in which case return the matched 'ext'
> +		 * pointer if any.
> +		 *
> +		 * Now res_map contains the matching bitmap, and fill_map is the
> +		 * bitmap for the next field.
> +		 */
> +next_match:
> +		b = pipapo_refill(res_map, f->bsize, f->rules, fill_map, f->mt,
> +				  last);
> +		if (b < 0)
> +			goto out;
> +
> +		if (last) {
> +			if (nft_set_elem_expired(&f->mt[b].e->ext))
> +				goto next_match;
> +
> +			if (flags & NFT_SET_ELEM_INTERVAL_END)
> +				ret = f->mt[b].e;
> +			else
> +				ret = f->mt[b].e->start;
> +			goto out;
> +		}
> +
> +		data += NFT_PIPAPO_GROUPS_PADDING(f->groups);
> +
> +		/* Swap bitmap indices: fill_map will be the initial bitmap for
> +		 * the next field (i.e. the new res_map), and res_map is
> +		 * guaranteed to be all-zeroes at this point, ready to be filled
> +		 * according to the next mapping table.
> +		 */
> +		swap(res_map, fill_map);
> +	}
> +
> +out:
> +	kfree(fill_map);
> +	kfree(res_map);
> +	return ret;
> +}
> +
> +/**
> + * nft_pipapo_get() - Get matching element reference given key data
> + * @net:	Network namespace
> + * @set:	nftables API set representation
> + * @elem:	nftables API element representation containing key data
> + * @flags:	If NFT_SET_ELEM_INTERVAL_END is passed, return the end element
> + */
> +static void *nft_pipapo_get(const struct net *net, const struct nft_set *set,
> +			    const struct nft_set_elem *elem, unsigned int flags)
> +{
> +	return pipapo_get(net, set, (const u8 *)elem->key.val.data, flags);
> +}
> +
> +/**
> + * pipapo_resize() - Resize lookup or mapping table, or both
> + * @f:		Field containing lookup and mapping tables
> + * @old_rules:	Previous amount of rules in field
> + * @rules:	New amount of rules
> + *
> + * Increase, decrease or maintain tables size depending on new amount of rules,
> + * and copy data over. In case the new size is smaller, throw away data for
> + * highest-numbered rules.
> + *
> + * Return: 0 on success, -ENOMEM on allocation failure.
> + */
> +static int pipapo_resize(struct nft_pipapo_field *f, int old_rules, int rules)
> +{
> +	long *new_lt = NULL, *new_p, *old_lt = f->lt, *old_p;
> +	union nft_pipapo_map_bucket *new_mt, *old_mt = f->mt;
> +	size_t new_bucket_size, copy;
> +	int group, bucket;
> +
> +	new_bucket_size = DIV_ROUND_UP(rules, BITS_PER_LONG);
> +
> +	if (new_bucket_size == f->bsize)
> +		goto mt;
> +
> +	if (new_bucket_size > f->bsize)
> +		copy = f->bsize;
> +	else
> +		copy = new_bucket_size;
> +
> +	new_lt = kvzalloc(f->groups * NFT_PIPAPO_BUCKETS * new_bucket_size *
> +			  sizeof(*new_lt), GFP_KERNEL);
> +	if (!new_lt)
> +		return -ENOMEM;
> +
> +	new_p = new_lt;
> +	old_p = old_lt;
> +	for (group = 0; group < f->groups; group++) {
> +		for (bucket = 0; bucket < NFT_PIPAPO_BUCKETS; bucket++) {
> +			memcpy(new_p, old_p, copy * sizeof(*new_p));
> +			new_p += copy;
> +			old_p += copy;
> +
> +			if (new_bucket_size > f->bsize)
> +				new_p += new_bucket_size - f->bsize;
> +			else
> +				old_p += f->bsize - new_bucket_size;
> +		}
> +	}
> +
> +mt:
> +	new_mt = kvmalloc(rules * sizeof(*new_mt), GFP_KERNEL);
> +	if (!new_mt) {
> +		kvfree(new_lt);
> +		return -ENOMEM;
> +	}
> +
> +	memcpy(new_mt, f->mt, min(old_rules, rules) * sizeof(*new_mt));
> +	if (rules > old_rules) {
> +		memset(new_mt + old_rules, 0,
> +		       (rules - old_rules) * sizeof(*new_mt));
> +	}
> +
> +	if (new_lt) {
> +		f->bsize = new_bucket_size;
> +		f->lt = new_lt;
> +		kvfree(old_lt);
> +	}
> +
> +	f->mt = new_mt;
> +	kvfree(old_mt);
> +
> +	return 0;
> +}
> +
> +/**
> + * pipapo_bucket_set() - Set rule bit in bucket given group and group value
> + * @f:		Field containing lookup table
> + * @rule:	Rule index
> + * @group:	Group index
> + * @v:		Value of bit group
> + */
> +static void pipapo_bucket_set(struct nft_pipapo_field *f, int rule, int group,
> +			      int v)
> +{
> +	unsigned long *pos;
> +
> +	pos = f->lt + f->bsize * NFT_PIPAPO_BUCKETS * group;
> +	pos += f->bsize * v;
> +
> +	__set_bit(rule, pos);
> +}
> +
> +/**
> + * pipapo_insert() - Insert new rule in field given input key and mask length
> + * @f:		Field containing lookup table
> + * @k:		Input key for classification, without nftables padding
> + * @mask_bits:	Length of mask; matches field length for non-ranged entry
> + *
> + * Insert a new rule reference in lookup buckets corresponding to k and
> + * mask_bits.
> + *
> + * Return: 1 on success (one rule inserted), negative error code on failure.
> + */
> +static int pipapo_insert(struct nft_pipapo_field *f, const uint8_t *k,
> +			 int mask_bits)
> +{
> +	int rule = f->rules++, group, ret;
> +
> +	ret = pipapo_resize(f, f->rules - 1, f->rules);
> +	if (ret)
> +		return ret;
> +
> +	for (group = 0; group < f->groups; group++) {
> +		int i, v;
> +		u8 mask;
> +
> +		if (group % 2)
> +			v = k[group / 2] & 0x0f;
> +		else
> +			v = k[group / 2] >> 4;
> +
> +		if (mask_bits >= (group + 1) * 4) {
> +			/* Not masked */
> +			pipapo_bucket_set(f, rule, group, v);
> +		} else if (mask_bits <= group * 4) {
> +			/* Completely masked */
> +			for (i = 0; i < NFT_PIPAPO_BUCKETS; i++)
> +				pipapo_bucket_set(f, rule, group, i);
> +		} else {
> +			/* The mask limit falls on this group */
> +			mask = 0x0f >> (mask_bits - group * 4);
> +			for (i = 0; i < NFT_PIPAPO_BUCKETS; i++) {
> +				if ((i & ~mask) == (v & ~mask))
> +					pipapo_bucket_set(f, rule, group, i);
> +			}
> +		}
> +	}
> +
> +	return 1;
> +}
> +
> +/**
> + * pipapo_step_diff() - Check if setting @step bit in netmask would change it
> + * @base:	Mask we are expanding
> + * @step:	Step bit for given expansion step
> + * @len:	Total length of mask space (set and unset bits), bytes
> + *
> + * Convenience function for mask expansion.
> + *
> + * Return: true if step bit changes mask (i.e. isn't set), false otherwise.
> + */
> +static bool pipapo_step_diff(u8 *base, int step, int len)
> +{
> +	/* Network order, byte-addressed */
> +#ifdef __BIG_ENDIAN__
> +	return !(BIT(step % BITS_PER_BYTE) & base[step / BITS_PER_BYTE]);
> +#else
> +	return !(BIT(step % BITS_PER_BYTE) &
> +		 base[len - 1 - step / BITS_PER_BYTE]);
> +#endif
> +}
> +
> +/**
> + * pipapo_step_after_end() - Check if mask exceeds range end with given step
> + * @base:	Mask we are expanding
> + * @end:	End of range
> + * @step:	Step bit for given expansion step, highest bit to be set
> + * @len:	Total length of mask space (set and unset bits), bytes
> + *
> + * Convenience function for mask expansion.
> + *
> + * Return: true if mask exceeds range setting step bits, false otherwise.
> + */
> +static bool pipapo_step_after_end(const u8 *base, const u8 *end, int step,
> +				  int len)
> +{
> +	u8 tmp[NFT_PIPAPO_MAX_BYTES];
> +	int i;
> +
> +	memcpy(tmp, base, len);
> +
> +	/* Network order, byte-addressed */
> +	for (i = 0; i <= step; i++)
> +#ifdef __BIG_ENDIAN__
> +		tmp[i / BITS_PER_BYTE] |= BIT(i % BITS_PER_BYTE);
> +#else
> +		tmp[len - 1 - i / BITS_PER_BYTE] |= BIT(i % BITS_PER_BYTE);
> +#endif
> +
> +	return memcmp(tmp, end, len) > 0;
> +}
> +
> +/**
> + * pipapo_base_sum() - Sum step bit to given len-sized netmask base with carry
> + * @base:	Netmask base
> + * @step:	Step bit to sum
> + * @len:	Netmask length, bytes
> + */
> +static void pipapo_base_sum(u8 *base, int step, int len)
> +{
> +	bool carry = false;
> +	int i;
> +
> +	/* Network order, byte-addressed */
> +#ifdef __BIG_ENDIAN__
> +	for (i = step / BITS_PER_BYTE; i < len; i++) {
> +#else
> +	for (i = len - 1 - step / BITS_PER_BYTE; i >= 0; i--) {
> +#endif
> +		if (carry)
> +			base[i]++;
> +		else
> +			base[i] += 1 << (step % BITS_PER_BYTE);
> +
> +		if (base[i])
> +			break;
> +
> +		carry = true;
> +	}
> +}
> +
> +/**
> + * expand() - Expand range to composing netmasks and insert into lookup table
> + * @f:		Field containing lookup table
> + * @start:	Start of range
> + * @end:	End of range
> + * @len:	Length of value in bits
> + *
> + * Expand range to composing netmasks and insert corresponding rule references
> + * in lookup buckets.
> + *
> + * Return: number of inserted rules on success, negative error code on failure.
> + */
> +static int pipapo_expand(struct nft_pipapo_field *f,
> +			 const u8 *start, const u8 *end, int len)
> +{
> +	int step, masks = 0, bytes = DIV_ROUND_UP(len, BITS_PER_BYTE);
> +	u8 base[NFT_PIPAPO_MAX_BYTES];
> +
> +	memcpy(base, start, bytes);
> +	while (memcmp(base, end, bytes) <= 0) {
> +		int err;
> +
> +		step = 0;
> +		while (pipapo_step_diff(base, step, bytes)) {
> +			if (pipapo_step_after_end(base, end, step, bytes))
> +				break;
> +
> +			step++;
> +			if (step >= len) {
> +				if (!masks) {
> +					pipapo_insert(f, base, 0);
> +					masks = 1;
> +				}
> +				goto out;
> +			}
> +		}
> +
> +		err = pipapo_insert(f, base, len - step);
> +
> +		if (err < 0)
> +			return err;
> +
> +		masks++;
> +		pipapo_base_sum(base, step, bytes);
> +	}
> +out:
> +	return masks;
> +}
> +
> +/**
> + * pipapo_map() - Insert rules in mapping tables, mapping them between fields
> + * @m:		Matching data, including mapping table
> + * @map:	Table of rule maps: array of first rule and amount of rules
> + *		in next field a given rule maps to, for each field
> + * @ext:	For last field, nft_set_ext pointer matching rules map to
> + */
> +static void pipapo_map(struct nft_pipapo_match *m,
> +		       union nft_pipapo_map_bucket map[NFT_PIPAPO_MAX_FIELDS],
> +		       struct nft_pipapo_elem *e)
> +{
> +	struct nft_pipapo_field *f;
> +	int i, j;
> +
> +	for (i = 0, f = m->f; i < m->field_count - 1; i++, f++) {
> +		for (j = 0; j < map[i].n; j++) {
> +			f->mt[map[i].to + j].to = map[i + 1].to;
> +			f->mt[map[i].to + j].n = map[i + 1].n;
> +		}
> +	}
> +
> +	/* Last field: map to ext instead of mapping to next field */
> +	for (j = 0; j < map[i].n; j++)
> +		f->mt[map[i].to + j].e = e;
> +}
> +
> +/**
> + * pipapo_realloc_scratch() - Reallocate scratch maps for partial match results
> + * @clone:	Copy of matching data with pending insertions and deletions
> + * @bsize_max	Maximum bucket size, scratch maps cover two buckets
> + *
> + * Return: 0 on success, -ENOMEM on failure.
> + */
> +static int pipapo_realloc_scratch(struct nft_pipapo_match *clone,
> +				  unsigned long bsize_max)
> +{
> +	int i;
> +
> +	for_each_possible_cpu(i) {
> +		unsigned long *scratch;
> +
> +		scratch = kzalloc_node(bsize_max * sizeof(*scratch) * 2,
> +				       GFP_KERNEL, cpu_to_node(i));
> +		if (!scratch) {
> +			/* On failure, there's no need to undo previous
> +			 * allocations: this means that some scratch maps have
> +			 * a bigger allocated size now (this is only called on
> +			 * insertion), but the extra space won't be used by any
> +			 * CPU as new elements are not inserted and m->bsize_max
> +			 * is not updated.
> +			 */
> +			return -ENOMEM;
> +		}
> +
> +		kfree(*per_cpu_ptr(clone->scratch, i));
> +
> +		*per_cpu_ptr(clone->scratch, i) = scratch;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * nft_pipapo_insert() - Validate and insert ranged elements
> + * @net:	Network namespace
> + * @set:	nftables API set representation
> + * @elem:	nftables API element representation containing key data
> + * @flags:	If NFT_SET_ELEM_INTERVAL_END is passed, this is the end element
> + * @ext2:	Filled with pointer to &struct nft_set_ext in inserted element
> + *
> + * In this set implementation, this functions needs to be called twice, with
> + * start and end element, to obtain a valid entry insertion.
> + *
> + * Calls to this function are serialised with each other, so we can store
> + * element and key data on the first call with start element, and use it on the
> + * second call once we get the end element too.
> + *
> + * However, userspace could send a single NFT_SET_ELEM_INTERVAL_END element,
> + * without a start element, so we need to check for it explicitly before
> + * inserting an entry, lest we end up in nft_pipapo_walk() with an empty start
> + * element.
> + *
> + * Also, we need to make sure that the start element hasn't been deactivated or
> + * destroyed between the two calls to this function, otherwise we might link an
> + * invalid start item to the end item triggering the insertion. Clear
> + * priv->start_elem on any operation that might render it invalid.
> + *
> + * Return: 0 on success, error pointer on failure.
> + */
> +static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
> +			     const struct nft_set_elem *elem,
> +			     struct nft_set_ext **ext2)
> +{
> +	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
> +	const u8 *data = (const u8 *)elem->key.val.data, *start, *end;
> +	union nft_pipapo_map_bucket rulemap[NFT_PIPAPO_MAX_FIELDS];
> +	struct nft_pipapo *priv = nft_set_priv(set);
> +	struct nft_pipapo_match *m = priv->clone;
> +	struct nft_pipapo_elem *e = elem->priv;
> +	struct nft_pipapo_field *f;
> +	int i, bsize_max, err = 0;
> +	void *dup;
> +
> +	dup = nft_pipapo_get(net, set, elem, 0);
> +	if (PTR_ERR(dup) != -ENOENT) {
> +		priv->start_elem = NULL;
> +		if (IS_ERR(dup))
> +			return PTR_ERR(dup);
> +		*ext2 = dup;

dup should be of nft_set_ext type. I just had a look at
nft_pipapo_get() and I think this returns nft_pipapo_elem, which is
almost good, since it contains nft_set_ext, right?

I think you also need to check if the object is active in the next
generation via nft_genmask_next() and nft_set_elem_active(), otherwise
ignore it.

Note that the datastructure needs to temporarily deal with duplicates,
ie. one inactive object (just deleted) and one active object (just
added) for the next generation.

> +		return -EEXIST;
> +	}
> +
> +	if (!nft_set_ext_exists(ext, NFT_SET_EXT_FLAGS) ||
> +	    !(*nft_set_ext_flags(ext) & NFT_SET_ELEM_INTERVAL_END)) {
> +		priv->start_elem = e;
> +		*ext2 = &e->ext;
> +		memcpy(priv->start_data, data, priv->width);
> +		return 0;
> +	}
> +
> +	if (!priv->start_elem)
> +		return -EINVAL;

I'm working on a sketch patch to extend the front-end code to make
this easier for you, will post it asap, so you don't need this special
handling to collect both ends of the interval.

So far, just spend a bit of time on this, will get back to you with
more feedback.

Thanks for working on this!
