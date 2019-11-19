Return-Path: <SRS0=iRt+=ZL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2331C432C0
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Nov 2019 01:07:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6202C20730
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Nov 2019 01:07:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h1e45sBL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbfKSBHD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Nov 2019 20:07:03 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:31119 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726905AbfKSBHC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Nov 2019 20:07:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574125617;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rDMluAjc6Z9KP+3H5BwhepErQYIH5vAYba7n3k4Ztbk=;
        b=h1e45sBL2DHJr9hEiPN+03w+hXys/tAxoXGD1oFpUAHlg5o0ibrcb8quvSUI5OHsbZgzhC
        Ly4yyj7E5k8wqOFg8dRmlk7yYJ11pSXg0HTySOuVxayblgSemWZ+9jFkONCGeu9xMluEtN
        YeCccZ7zPmIDiokvdM1uvwJJoT9s6W4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-x44SSi12NoeqUe3vlke-cg-1; Mon, 18 Nov 2019 20:06:53 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B59F801E5A;
        Tue, 19 Nov 2019 01:06:52 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-24.ams2.redhat.com [10.36.112.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA7A51B5C2;
        Tue, 19 Nov 2019 01:06:48 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Jay Ligatti <ligatti@usf.edu>,
        Ori Rottenstreich <or@cs.technion.ac.il>,
        Kirill Kogan <kirill.kogan@gmail.com>
Subject: [PATCH nf-next 3/8] nf_tables: Add set type for arbitrary concatenation of ranges
Date:   Tue, 19 Nov 2019 02:06:30 +0100
Message-Id: <6da551247fd90666b0eca00fb4467151389bf1dc.1574119038.git.sbrivio@redhat.com>
In-Reply-To: <cover.1574119038.git.sbrivio@redhat.com>
References: <cover.1574119038.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: x44SSi12NoeqUe3vlke-cg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This new set type allows for intervals in concatenated fields,
which are expressed in the usual way, that is, simple byte
concatenation with padding to 32 bits for single fields, and
given as ranges by specifying start and end elements containing,
each, the full concatenation of start and end values for the
single fields.

Ranges are expanded to composing netmasks, for each field: these
are inserted as rules in per-field lookup tables. Bits to be
classified are divided in 4-bit groups, and for each group, the
lookup table contains 4^2 buckets, representing all the possible
values of a bit group. This approach was inspired by the Grouper
algorithm:
=09http://www.cse.usf.edu/~ligatti/projects/grouper/

Matching is performed by a sequence of AND operations between
bucket values, with buckets selected according to the value of
packet bits, for each group. The result of this sequence tells
us which rules matched for a given field.

In order to concatenate several ranged fields, per-field rules
are mapped using mapping arrays, one per field, that specify
which rules should be considered while matching the next field.
The mapping array for the last field contains a reference to
the element originally inserted.

The notes in nft_set_pipapo.c cover the algorithm in deeper
detail.

A pure hash-based approach is of no use here, as ranges need
to be classified. An implementation based on "proxying" the
existing red-black tree set type, creating a tree for each
field, was considered, but deemed impractical due to the fact
that elements would need to be shared between trees, at least
as long as we want to keep UAPI changes to a minimum.

A stand-alone implementation of this algorithm is available at:
=09https://pipapo.lameexcu.se
together with notes about possible future optimisations
(in pipapo.c).

This algorithm was designed with data locality in mind, and can
be highly optimised for SIMD instruction sets, as the bulk of
the matching work is done with repetitive, simple bitwise
operations.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 include/net/netfilter/nf_tables_core.h |    1 +
 net/netfilter/Makefile                 |    3 +-
 net/netfilter/nf_tables_set_core.c     |    2 +
 net/netfilter/nft_set_pipapo.c         | 2169 ++++++++++++++++++++++++
 4 files changed, 2174 insertions(+), 1 deletion(-)
 create mode 100644 net/netfilter/nft_set_pipapo.c

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter=
/nf_tables_core.h
index 7281895fa6d9..9759257ec8ec 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -74,6 +74,7 @@ extern struct nft_set_type nft_set_hash_type;
 extern struct nft_set_type nft_set_hash_fast_type;
 extern struct nft_set_type nft_set_rbtree_type;
 extern struct nft_set_type nft_set_bitmap_type;
+extern struct nft_set_type nft_set_pipapo_type;
=20
 struct nft_expr;
 struct nft_regs;
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 5e9b2eb24349..3f572e5a975e 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -81,7 +81,8 @@ nf_tables-objs :=3D nf_tables_core.o nf_tables_api.o nft_=
chain_filter.o \
 =09=09  nft_chain_route.o nf_tables_offload.o
=20
 nf_tables_set-objs :=3D nf_tables_set_core.o \
-=09=09      nft_set_hash.o nft_set_bitmap.o nft_set_rbtree.o
+=09=09      nft_set_hash.o nft_set_bitmap.o nft_set_rbtree.o \
+=09=09      nft_set_pipapo.o
=20
 obj-$(CONFIG_NF_TABLES)=09=09+=3D nf_tables.o
 obj-$(CONFIG_NF_TABLES_SET)=09+=3D nf_tables_set.o
diff --git a/net/netfilter/nf_tables_set_core.c b/net/netfilter/nf_tables_s=
et_core.c
index a9fce8d10051..586b621007eb 100644
--- a/net/netfilter/nf_tables_set_core.c
+++ b/net/netfilter/nf_tables_set_core.c
@@ -9,12 +9,14 @@ static int __init nf_tables_set_module_init(void)
 =09nft_register_set(&nft_set_rhash_type);
 =09nft_register_set(&nft_set_bitmap_type);
 =09nft_register_set(&nft_set_rbtree_type);
+=09nft_register_set(&nft_set_pipapo_type);
=20
 =09return 0;
 }
=20
 static void __exit nf_tables_set_module_exit(void)
 {
+=09nft_unregister_set(&nft_set_pipapo_type);
 =09nft_unregister_set(&nft_set_rbtree_type);
 =09nft_unregister_set(&nft_set_bitmap_type);
 =09nft_unregister_set(&nft_set_rhash_type);
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.=
c
new file mode 100644
index 000000000000..1829289a54f7
--- /dev/null
+++ b/net/netfilter/nft_set_pipapo.c
@@ -0,0 +1,2169 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/* PIPAPO: PIle PAcket POlicies: set for arbitrary concatenations of range=
s
+ *
+ * Copyright (c) 2019 Red Hat GmbH
+ *
+ * Author: Stefano Brivio <sbrivio@redhat.com>
+ */
+
+/**
+ * DOC: Theory of Operation
+ *
+ *
+ * Problem
+ * -------
+ *
+ * Match packet bytes against entries composed of ranged or non-ranged pac=
ket
+ * field specifiers, mapping them to arbitrary references. For example:
+ *
+ * ::
+ *
+ *               --- fields --->
+ *      |    [net],[port],[net]... =3D> [reference]
+ *   entries [net],[port],[net]... =3D> [reference]
+ *      |    [net],[port],[net]... =3D> [reference]
+ *      V    ...
+ *
+ * where [net] fields can be IP ranges or netmasks, and [port] fields are =
port
+ * ranges. Arbitrary packet fields can be matched.
+ *
+ *
+ * Algorithm Overview
+ * ------------------
+ *
+ * This algorithm is loosely inspired by [Ligatti 2010], and fundamentally
+ * relies on the consideration that every contiguous range in a space of b=
 bits
+ * can be converted into b * 2 netmasks, from Theorem 3 in [Rottenstreich =
2010],
+ * as also illustrated in Section 9 of [Kogan 2014].
+ *
+ * Classification against a number of entries, that require matching given=
 bits
+ * of a packet field, is performed by grouping those bits in sets of arbit=
rary
+ * size, and classifying packet bits one group at a time.
+ *
+ * Example:
+ *   to match the source port (16 bits) of a packet, we can divide those 1=
6 bits
+ *   in 4 groups of 4 bits each. Given the entry:
+ *      0000 0001 0101 1001
+ *   and a packet with source port:
+ *      0000 0001 1010 1001
+ *   first and second groups match, but the third doesn't. We conclude tha=
t the
+ *   packet doesn't match the given entry.
+ *
+ * Translate the set to a sequence of lookup tables, one per field. Each t=
able
+ * has two dimensions: bit groups to be matched for a single packet field,=
 and
+ * all the possible values of said groups (buckets). Input entries are
+ * represented as one or more rules, depending on the number of composing
+ * netmasks for the given field specifier, and a group match is indicated =
as a
+ * set bit, with number corresponding to the rule index, in all the bucket=
s
+ * whose value matches the entry for a given group.
+ *
+ * Rules are mapped between fields through an array of x, n pairs, with ea=
ch
+ * item mapping a matched rule to one or more rules. The position of the p=
air in
+ * the array indicates the matched rule to be mapped to the next field, x
+ * indicates the first rule index in the next field, and n the amount of
+ * next-field rules the current rule maps to.
+ *
+ * The mapping array for the last field maps to the desired references.
+ *
+ * To match, we perform table lookups using the values of grouped packet b=
its,
+ * and use a sequence of bitwise operations to progressively evaluate rule
+ * matching.
+ *
+ * A stand-alone, reference implementation, also including notes about pos=
sible
+ * future optimisations, is available at:
+ *    https://pipapo.lameexcu.se/
+ *
+ * Insertion
+ * ---------
+ *
+ * - For each packet field:
+ *
+ *   - divide the b packet bits we want to classify into groups of size t,
+ *     obtaining ceil(b / t) groups
+ *
+ *      Example: match on destination IP address, with t =3D 4: 32 bits, 8=
 groups
+ *      of 4 bits each
+ *
+ *   - allocate a lookup table with one column ("bucket") for each possibl=
e
+ *     value of a group, and with one row for each group
+ *
+ *      Example: 8 groups, 2^4 buckets:
+ *
+ * ::
+ *
+ *                     bucket
+ *      group  0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  =
15
+ *        0
+ *        1
+ *        2
+ *        3
+ *        4
+ *        5
+ *        6
+ *        7
+ *
+ *   - map the bits we want to classify for the current field, for a given
+ *     entry, to a single rule for non-ranged and netmask set items, and t=
o one
+ *     or multiple rules for ranges. Ranges are expanded to composing netm=
asks
+ *     by pipapo_expand().
+ *
+ *      Example: 2 entries, 10.0.0.5:1024 and 192.168.1.0-192.168.2.1:2048
+ *      - rule #0: 10.0.0.5
+ *      - rule #1: 192.168.1.0/24
+ *      - rule #2: 192.168.2.0/31
+ *
+ *   - insert references to the rules in the lookup table, selecting bucke=
ts
+ *     according to bit values of a rule in the given group. This is done =
by
+ *     pipapo_insert().
+ *
+ *      Example: given:
+ *      - rule #0: 10.0.0.5 mapping to buckets
+ *        < 0 10  0 0   0 0  0 5 >
+ *      - rule #1: 192.168.1.0/24 mapping to buckets
+ *        < 12 0  10 8  0 1  < 0..15 > < 0..15 > >
+ *      - rule #2: 192.168.2.0/31 mapping to buckets
+ *        < 12 0  10 8  0 2  0 < 0..1 > >
+ *
+ *      these bits are set in the lookup table:
+ *
+ * ::
+ *
+ *                     bucket
+ *      group  0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  =
15
+ *        0    0                                              1,2
+ *        1   1,2                                      0
+ *        2    0                                      1,2
+ *        3    0                              1,2
+ *        4  0,1,2
+ *        5    0   1   2
+ *        6  0,1,2 1   1   1   1   1   1   1   1   1   1   1   1   1   1  =
 1
+ *        7   1,2 1,2  1   1   1  0,1  1   1   1   1   1   1   1   1   1  =
 1
+ *
+ *   - if this is not the last field in the set, fill a mapping array that=
 maps
+ *     rules from the lookup table to rules belonging to the same entry in
+ *     the next lookup table, done by pipapo_map().
+ *
+ *     Note that as rules map to contiguous ranges of rules, given how net=
mask
+ *     expansion and insertion is performed, &union nft_pipapo_map_bucket =
stores
+ *     this information as pairs of first rule index, rule count.
+ *
+ *      Example: 2 entries, 10.0.0.5:1024 and 192.168.1.0-192.168.2.1:2048=
,
+ *      given lookup table #0 for field 0 (see example above):
+ *
+ * ::
+ *
+ *                     bucket
+ *      group  0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  =
15
+ *        0    0                                              1,2
+ *        1   1,2                                      0
+ *        2    0                                      1,2
+ *        3    0                              1,2
+ *        4  0,1,2
+ *        5    0   1   2
+ *        6  0,1,2 1   1   1   1   1   1   1   1   1   1   1   1   1   1  =
 1
+ *        7   1,2 1,2  1   1   1  0,1  1   1   1   1   1   1   1   1   1  =
 1
+ *
+ *      and lookup table #1 for field 1 with:
+ *      - rule #0: 1024 mapping to buckets
+ *        < 0  0  4  0 >
+ *      - rule #1: 2048 mapping to buckets
+ *        < 0  0  5  0 >
+ *
+ * ::
+ *
+ *                     bucket
+ *      group  0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  =
15
+ *        0   0,1
+ *        1   0,1
+ *        2                    0   1
+ *        3   0,1
+ *
+ *      we need to map rules for 10.0.0.5 in lookup table #0 (rule #0) to =
1024
+ *      in lookup table #1 (rule #0) and rules for 192.168.1.0-192.168.2.1
+ *      (rules #1, #2) to 2048 in lookup table #2 (rule #1):
+ *
+ * ::
+ *
+ *       rule indices in current field: 0    1    2
+ *       map to rules in next field:    0    1    1
+ *
+ *   - if this is the last field in the set, fill a mapping array that map=
s
+ *     rules from the last lookup table to element pointers, also done by
+ *     pipapo_map().
+ *
+ *     Note that, in this implementation, we have two elements (start, end=
) for
+ *     each entry. The pointer to the end element is stored in this array,=
 and
+ *     the pointer to the start element is linked from it.
+ *
+ *      Example: entry 10.0.0.5:1024 has a corresponding &struct nft_pipap=
o_elem
+ *      pointer, 0x66, and element for 192.168.1.0-192.168.2.1:2048 is at =
0x42.
+ *      From the rules of lookup table #1 as mapped above:
+ *
+ * ::
+ *
+ *       rule indices in last field:    0    1
+ *       map to elements:             0x42  0x66
+ *
+ *
+ * Matching
+ * --------
+ *
+ * We use a result bitmap, with the size of a single lookup table bucket, =
to
+ * represent the matching state that applies at every algorithm step. This=
 is
+ * done by pipapo_lookup().
+ *
+ * - For each packet field:
+ *
+ *   - start with an all-ones result bitmap (res_map in pipapo_lookup())
+ *
+ *   - perform a lookup into the table corresponding to the current field,
+ *     for each group, and at every group, AND the current result bitmap w=
ith
+ *     the value from the lookup table bucket
+ *
+ * ::
+ *
+ *      Example: 192.168.1.5 < 12 0  10 8  0 1  0 5 >, with lookup table f=
rom
+ *      insertion examples.
+ *      Lookup table buckets are at least 3 bits wide, we'll assume 8 bits=
 for
+ *      convenience in this example. Initial result bitmap is 0xff, the st=
eps
+ *      below show the value of the result bitmap after each group is proc=
essed:
+ *
+ *                     bucket
+ *      group  0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  =
15
+ *        0    0                                              1,2
+ *        result bitmap is now: 0xff & 0x6 [bucket 12] =3D 0x6
+ *
+ *        1   1,2                                      0
+ *        result bitmap is now: 0x6 & 0x6 [bucket 0] =3D 0x6
+ *
+ *        2    0                                      1,2
+ *        result bitmap is now: 0x6 & 0x6 [bucket 10] =3D 0x6
+ *
+ *        3    0                              1,2
+ *        result bitmap is now: 0x6 & 0x6 [bucket 8] =3D 0x6
+ *
+ *        4  0,1,2
+ *        result bitmap is now: 0x6 & 0x7 [bucket 0] =3D 0x6
+ *
+ *        5    0   1   2
+ *        result bitmap is now: 0x6 & 0x2 [bucket 1] =3D 0x2
+ *
+ *        6  0,1,2 1   1   1   1   1   1   1   1   1   1   1   1   1   1  =
 1
+ *        result bitmap is now: 0x2 & 0x7 [bucket 0] =3D 0x2
+ *
+ *        7   1,2 1,2  1   1   1  0,1  1   1   1   1   1   1   1   1   1  =
 1
+ *        final result bitmap for this field is: 0x2 & 0x3 [bucket 5] =3D =
0x2
+ *
+ *   - at the next field, start with a new, all-zeroes result bitmap. For =
each
+ *     bit set in the previous result bitmap, fill the new result bitmap
+ *     (fill_map in pipapo_lookup()) with the rule indices from the
+ *     corresponding buckets of the mapping field for this field, done by
+ *     pipapo_refill()
+ *
+ *      Example: with mapping table from insertion examples, with the curr=
ent
+ *      result bitmap from the previous example, 0x02:
+ *
+ * ::
+ *
+ *       rule indices in current field: 0    1    2
+ *       map to rules in next field:    0    1    1
+ *
+ *      the new result bitmap will be 0x02: rule 1 was set, and rule 1 wil=
l be
+ *      set.
+ *
+ *      We can now extend this example to cover the second iteration of th=
e step
+ *      above (lookup and AND bitmap): assuming the port field is
+ *      2048 < 0  0  5  0 >, with starting result bitmap 0x2, and lookup t=
able
+ *      for "port" field from pre-computation example:
+ *
+ * ::
+ *
+ *                     bucket
+ *      group  0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  =
15
+ *        0   0,1
+ *        1   0,1
+ *        2                    0   1
+ *        3   0,1
+ *
+ *       operations are: 0x2 & 0x3 [bucket 0] & 0x3 [bucket 0] & 0x2 [buck=
et 5]
+ *       & 0x3 [bucket 0], resulting bitmap is 0x2.
+ *
+ *   - if this is the last field in the set, look up the value from the ma=
pping
+ *     array corresponding to the final result bitmap
+ *
+ *      Example: 0x2 resulting bitmap from 192.168.1.5:2048, mapping array=
 for
+ *      last field from insertion example:
+ *
+ * ::
+ *
+ *       rule indices in last field:    0    1
+ *       map to elements:             0x42  0x66
+ *
+ *      the matching element is at 0x42.
+ *
+ *
+ * References
+ * ----------
+ *
+ * [Ligatti 2010]
+ *      A Packet-classification Algorithm for Arbitrary Bitmask Rules, wit=
h
+ *      Automatic Time-space Tradeoffs
+ *      Jay Ligatti, Josh Kuhn, and Chris Gage.
+ *      Proceedings of the IEEE International Conference on Computer
+ *      Communication Networks (ICCCN), August 2010.
+ *      http://www.cse.usf.edu/~ligatti/papers/grouper-conf.pdf
+ *
+ * [Rottenstreich 2010]
+ *      Worst-Case TCAM Rule Expansion
+ *      Ori Rottenstreich and Isaac Keslassy.
+ *      2010 Proceedings IEEE INFOCOM, San Diego, CA, 2010.
+ *      http://citeseerx.ist.psu.edu/viewdoc/download?doi=3D10.1.1.212.459=
2&rep=3Drep1&type=3Dpdf
+ *
+ * [Kogan 2014]
+ *      SAX-PAC (Scalable And eXpressive PAcket Classification)
+ *      Kirill Kogan, Sergey Nikolenko, Ori Rottenstreich, William Culhane=
,
+ *      and Patrick Eugster.
+ *      Proceedings of the 2014 ACM conference on SIGCOMM, August 2014.
+ *      http://www.sigcomm.org/sites/default/files/ccr/papers/2014/August/=
2619239-2626294.pdf
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/log2.h>
+#include <linux/module.h>
+#include <linux/netlink.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_core.h>
+#include <uapi/linux/netfilter/nf_tables.h>
+#include <net/ipv6.h>=09=09=09/* For the maximum length of a field */
+#include <linux/bitmap.h>
+#include <linux/bitops.h>
+
+/* Count of concatenated fields depends on count of 32-bit nftables regist=
ers */
+#define NFT_PIPAPO_MAX_FIELDS=09=09NFT_REG32_COUNT
+
+/* Largest supported field size */
+#define NFT_PIPAPO_MAX_BYTES=09=09(sizeof(struct in6_addr))
+#define NFT_PIPAPO_MAX_BITS=09=09(NFT_PIPAPO_MAX_BYTES * BITS_PER_BYTE)
+
+/* Number of bits to be grouped together in lookup table buckets, arbitrar=
y */
+#define NFT_PIPAPO_GROUP_BITS=09=094
+#define NFT_PIPAPO_GROUPS_PER_BYTE=09(BITS_PER_BYTE / NFT_PIPAPO_GROUP_BIT=
S)
+
+/* Fields are padded to 32 bits in input registers */
+#define NFT_PIPAPO_GROUPS_PADDED_SIZE(x)=09=09=09=09\
+=09(round_up((x) / NFT_PIPAPO_GROUPS_PER_BYTE, sizeof(u32)))
+#define NFT_PIPAPO_GROUPS_PADDING(x)=09=09=09=09=09\
+=09(NFT_PIPAPO_GROUPS_PADDED_SIZE((x)) - (x) / NFT_PIPAPO_GROUPS_PER_BYTE)
+
+/* Number of buckets, given by 2 ^ n, with n grouped bits */
+#define NFT_PIPAPO_BUCKETS=09=09(1 << NFT_PIPAPO_GROUP_BITS)
+
+/* Each n-bit range maps to up to n * 2 rules */
+#define NFT_PIPAPO_MAP_NBITS=09=09(const_ilog2(NFT_PIPAPO_MAX_BITS * 2))
+
+/* Use the rest of mapping table buckets for rule indices, but it makes no=
 sense
+ * to exceed 32 bits
+ */
+#if BITS_PER_LONG =3D=3D 64
+#define NFT_PIPAPO_MAP_TOBITS=09=0932
+#else
+#define NFT_PIPAPO_MAP_TOBITS=09=09(BITS_PER_LONG - NFT_PIPAPO_MAP_NBITS)
+#endif
+
+/* ...which gives us the highest allowed index for a rule */
+#define NFT_PIPAPO_RULE0_MAX=09=09((1UL << (NFT_PIPAPO_MAP_TOBITS - 1)) \
+=09=09=09=09=09- (1UL << NFT_PIPAPO_MAP_NBITS))
+
+#define nft_pipapo_for_each_field(field, index, match)=09=09\
+=09for ((field) =3D (match)->f, (index) =3D 0;=09=09=09\
+=09     (index) < (match)->field_count;=09=09=09\
+=09     (index)++, (field)++)
+
+/**
+ * union nft_pipapo_map_bucket - Bucket of mapping table
+ * @to:=09=09First rule number (in next field) this rule maps to
+ * @n:=09=09Number of rules (in next field) this rule maps to
+ * @e:=09=09If there's no next field, pointer to element this rule maps to
+ */
+union nft_pipapo_map_bucket {
+=09struct {
+#if BITS_PER_LONG =3D=3D 64
+=09=09static_assert(NFT_PIPAPO_MAP_TOBITS <=3D 32);
+=09=09u32 to;
+
+=09=09static_assert(NFT_PIPAPO_MAP_NBITS <=3D 32);
+=09=09u32 n;
+#else
+=09=09unsigned long to:NFT_PIPAPO_MAP_TOBITS;
+=09=09unsigned long  n:NFT_PIPAPO_MAP_NBITS;
+#endif
+=09};
+=09struct nft_pipapo_elem *e;
+};
+
+/**
+ * struct nft_pipapo_field - Lookup, mapping tables and related data for a=
 field
+ * @groups:=09Amount of 4-bit groups
+ * @rules:=09Number of inserted rules
+ * @bsize:=09Size of each bucket in lookup table, in longs
+ * @lt:=09=09Lookup table: 'groups' rows of NFT_PIPAPO_BUCKETS buckets
+ * @mt:=09=09Mapping table: one bucket per rule
+ */
+struct nft_pipapo_field {
+=09int groups;
+=09unsigned long rules;
+=09size_t bsize;
+=09unsigned long *lt;
+=09union nft_pipapo_map_bucket *mt;
+};
+
+/**
+ * struct nft_pipapo_match - Data used for lookup and matching
+ * @field_count=09=09Amount of fields in set
+ * @scratch:=09=09Preallocated per-CPU maps for partial matching results
+ * @bsize_max:=09=09Maximum lookup table bucket size of all fields, in lon=
gs
+ * @rcu=09=09=09Matching data is swapped on commits
+ * @f:=09=09=09Fields, with lookup and mapping tables
+ */
+struct nft_pipapo_match {
+=09int field_count;
+=09unsigned long * __percpu *scratch;
+=09size_t bsize_max;
+=09struct rcu_head rcu;
+=09struct nft_pipapo_field f[0];
+};
+
+/* Current working bitmap index, toggled between field matches */
+static DEFINE_PER_CPU(bool, nft_pipapo_scratch_index);
+
+/**
+ * struct nft_pipapo - Representation of a set
+ * @match:=09Currently in-use matching data
+ * @clone:=09Copy where pending insertions and deletions are kept
+ * @groups:=09Total amount of 4-bit groups for fields in this set
+ * @width:=09Total bytes to be matched for one packet, including padding
+ * @dirty:=09Working copy has pending insertions or deletions
+ * @last_gc:=09Timestamp of last garbage collection run, jiffies
+ * @start_data:=09Key data of start element for insertion
+ * @start_elem:=09Start element for insertion
+ *
+ * nft_pipapo_insert() is called separately with start and end elements to=
 be
+ * inserted. While a tree implementation (see nft_set_rbtree) can insert n=
odes
+ * in the tree right away, we need to cache the start element, and perform=
 the
+ * actual insertion once the end element is also seen. This is fine as ins=
ertion
+ * is serialised by the nftables API.
+ */
+struct nft_pipapo {
+=09struct nft_pipapo_match __rcu *match;
+=09struct nft_pipapo_match *clone;
+=09int groups;
+=09int width;
+=09bool dirty;
+=09unsigned long last_gc;
+=09u8 start_data[NFT_DATA_VALUE_MAXLEN * sizeof(u32)];
+=09struct nft_pipapo_elem *start_elem;
+};
+
+struct nft_pipapo_elem;
+
+/**
+ * struct nft_pipapo_elem - API-facing representation of single set elemen=
t
+ * @start:=09Pointer to element that represents start of interval
+ * @ext:=09nftables API extensions
+ */
+struct nft_pipapo_elem {
+=09struct nft_pipapo_elem *start;
+=09struct nft_set_ext ext;
+};
+
+/**
+ * pipapo_refill() - For each set bit, set bits from selected mapping tabl=
e item
+ * @map:=09Bitmap to be scanned for set bits
+ * @len:=09Length of bitmap in longs
+ * @rules:=09Number of rules in field
+ * @dst:=09Destination bitmap
+ * @mt:=09=09Mapping table containing bit set specifiers
+ * @match_only:=09Find a single bit and return, don't fill
+ *
+ * Iteration over set bits with __builtin_ctzl(): Daniel Lemire, public do=
main.
+ *
+ * For each bit set in map, select the bucket from mapping table with inde=
x
+ * corresponding to the position of the bit set. Use start bit and amount =
of
+ * bits specified in bucket to fill region in dst.
+ *
+ * Return: -1 on no match, bit position on 'match_only', 0 otherwise.
+ */
+static int pipapo_refill(unsigned long *map, int len, int rules,
+=09=09=09 unsigned long *dst, union nft_pipapo_map_bucket *mt,
+=09=09=09 bool match_only)
+{
+=09unsigned long bitset;
+=09int k, ret =3D -1;
+
+=09for (k =3D 0; k < len; k++) {
+=09=09bitset =3D map[k];
+=09=09while (bitset) {
+=09=09=09unsigned long t =3D bitset & -bitset;
+=09=09=09int r =3D __builtin_ctzl(bitset);
+=09=09=09int i =3D k * BITS_PER_LONG + r;
+
+=09=09=09if (unlikely(i >=3D rules)) {
+=09=09=09=09map[k] =3D 0;
+=09=09=09=09return -1;
+=09=09=09}
+
+=09=09=09if (unlikely(match_only)) {
+=09=09=09=09bitmap_clear(map, i, 1);
+=09=09=09=09return i;
+=09=09=09}
+
+=09=09=09ret =3D 0;
+
+=09=09=09bitmap_set(dst, mt[i].to, mt[i].n);
+
+=09=09=09bitset ^=3D t;
+=09=09}
+=09=09map[k] =3D 0;
+=09}
+
+=09return ret;
+}
+
+/**
+ * nft_pipapo_lookup() - Lookup function
+ * @net:=09Network namespace
+ * @set:=09nftables API set representation
+ * @elem:=09nftables API element representation containing key data
+ * @ext:=09nftables API extension pointer, filled with matching reference
+ *
+ * For more details, see DOC: Theory of Operation.
+ *
+ * Return: true on match, false otherwise.
+ */
+static bool nft_pipapo_lookup(const struct net *net, const struct nft_set =
*set,
+=09=09=09      const u32 *key, const struct nft_set_ext **ext)
+{
+=09struct nft_pipapo *priv =3D nft_set_priv(set);
+=09unsigned long *res_map, *fill_map;
+=09u8 genmask =3D nft_genmask_cur(net);
+=09const u8 *rp =3D (const u8 *)key;
+=09struct nft_pipapo_match *m;
+=09struct nft_pipapo_field *f;
+=09bool map_index;
+=09int i;
+
+=09map_index =3D raw_cpu_read(nft_pipapo_scratch_index);
+
+=09rcu_read_lock();
+=09m =3D rcu_dereference(priv->match);
+
+=09if (unlikely(!m || !*raw_cpu_ptr(m->scratch)))
+=09=09goto out;
+
+=09res_map  =3D *raw_cpu_ptr(m->scratch) + (map_index ? m->bsize_max : 0);
+=09fill_map =3D *raw_cpu_ptr(m->scratch) + (map_index ? 0 : m->bsize_max);
+
+=09memset(res_map, 0xff, m->bsize_max * sizeof(*res_map));
+
+=09nft_pipapo_for_each_field(f, i, m) {
+=09=09bool last =3D i =3D=3D m->field_count - 1;
+=09=09unsigned long *lt =3D f->lt;
+=09=09int b, group;
+
+=09=09/* For each 4-bit group: select lookup table bucket depending on
+=09=09 * packet bytes value, then AND bucket value
+=09=09 */
+=09=09for (group =3D 0; group < f->groups; group++) {
+=09=09=09u8 v;
+
+=09=09=09if (group % 2) {
+=09=09=09=09v =3D *rp & 0x0f;
+=09=09=09=09rp++;
+=09=09=09} else {
+=09=09=09=09v =3D *rp >> 4;
+=09=09=09}
+=09=09=09__bitmap_and(res_map, res_map, lt + v * f->bsize,
+=09=09=09=09     f->bsize * BITS_PER_LONG);
+
+=09=09=09lt +=3D f->bsize * NFT_PIPAPO_BUCKETS;
+=09=09}
+
+=09=09/* Now populate the bitmap for the next field, unless this is
+=09=09 * the last field, in which case return the matched 'ext'
+=09=09 * pointer if any.
+=09=09 *
+=09=09 * Now res_map contains the matching bitmap, and fill_map is the
+=09=09 * bitmap for the next field.
+=09=09 */
+next_match:
+=09=09b =3D pipapo_refill(res_map, f->bsize, f->rules, fill_map, f->mt,
+=09=09=09=09  last);
+=09=09if (b < 0) {
+=09=09=09rcu_read_unlock();
+=09=09=09raw_cpu_write(nft_pipapo_scratch_index, map_index);
+
+=09=09=09return false;
+=09=09}
+
+=09=09if (last) {
+=09=09=09*ext =3D &f->mt[b].e->ext;
+=09=09=09if (unlikely(nft_set_elem_expired(*ext) ||
+=09=09=09=09     !nft_set_elem_active(*ext, genmask)))
+=09=09=09=09goto next_match;
+
+=09=09=09/* Last field: we're just returning the key without
+=09=09=09 * filling the initial bitmap for the next field, so the
+=09=09=09 * current inactive bitmap is clean and can be reused as
+=09=09=09 * *next* bitmap (not initial) for the next packet.
+=09=09=09 */
+=09=09=09rcu_read_unlock();
+=09=09=09raw_cpu_write(nft_pipapo_scratch_index, map_index);
+
+=09=09=09return true;
+=09=09}
+
+=09=09/* Swap bitmap indices: res_map is the initial bitmap for the
+=09=09 * next field, and fill_map is guaranteed to be all-zeroes at
+=09=09 * this point.
+=09=09 */
+=09=09map_index =3D !map_index;
+=09=09swap(res_map, fill_map);
+
+=09=09rp +=3D NFT_PIPAPO_GROUPS_PADDING(f->groups);
+=09}
+
+out:
+=09rcu_read_unlock();
+=09return false;
+}
+
+/**
+ * pipapo_get() - Get matching start or end element reference given key da=
ta
+ * @net:=09Network namespace
+ * @set:=09nftables API set representation
+ * @data:=09Key data to be matched against existing elements
+ * @flags:=09If NFT_SET_ELEM_INTERVAL_END is passed, return the end elemen=
t
+ *
+ * This is essentially the same as the lookup function, except that it mat=
ches
+ * key data against the uncommitted copy and doesn't use preallocated maps=
 for
+ * bitmap results.
+ *
+ * Return: pointer to &struct nft_pipapo_elem on match, error pointer othe=
rwise.
+ */
+static void *pipapo_get(const struct net *net, const struct nft_set *set,
+=09=09=09const u8 *data, unsigned int flags)
+{
+=09struct nft_pipapo *priv =3D nft_set_priv(set);
+=09struct nft_pipapo_match *m =3D priv->clone;
+=09unsigned long *res_map, *fill_map =3D NULL;
+=09void *ret =3D ERR_PTR(-ENOENT);
+=09struct nft_pipapo_field *f;
+=09int i;
+
+=09res_map =3D kmalloc_array(m->bsize_max, sizeof(*res_map), GFP_ATOMIC);
+=09if (!res_map) {
+=09=09ret =3D ERR_PTR(-ENOMEM);
+=09=09goto out;
+=09}
+
+=09fill_map =3D kcalloc(m->bsize_max, sizeof(*res_map), GFP_ATOMIC);
+=09if (!fill_map) {
+=09=09ret =3D ERR_PTR(-ENOMEM);
+=09=09goto out;
+=09}
+
+=09memset(res_map, 0xff, m->bsize_max * sizeof(*res_map));
+
+=09nft_pipapo_for_each_field(f, i, m) {
+=09=09bool last =3D i =3D=3D m->field_count - 1;
+=09=09unsigned long *lt =3D f->lt;
+=09=09int b, group;
+
+=09=09/* For each 4-bit group: select lookup table bucket depending on
+=09=09 * packet bytes value, then AND bucket value
+=09=09 */
+=09=09for (group =3D 0; group < f->groups; group++) {
+=09=09=09u8 v;
+
+=09=09=09if (group % 2) {
+=09=09=09=09v =3D *data & 0x0f;
+=09=09=09=09data++;
+=09=09=09} else {
+=09=09=09=09v =3D *data >> 4;
+=09=09=09}
+=09=09=09__bitmap_and(res_map, res_map, lt + v * f->bsize,
+=09=09=09=09     f->bsize * BITS_PER_LONG);
+
+=09=09=09lt +=3D f->bsize * NFT_PIPAPO_BUCKETS;
+=09=09}
+
+=09=09/* Now populate the bitmap for the next field, unless this is
+=09=09 * the last field, in which case return the matched 'ext'
+=09=09 * pointer if any.
+=09=09 *
+=09=09 * Now res_map contains the matching bitmap, and fill_map is the
+=09=09 * bitmap for the next field.
+=09=09 */
+next_match:
+=09=09b =3D pipapo_refill(res_map, f->bsize, f->rules, fill_map, f->mt,
+=09=09=09=09  last);
+=09=09if (b < 0)
+=09=09=09goto out;
+
+=09=09if (last) {
+=09=09=09if (nft_set_elem_expired(&f->mt[b].e->ext))
+=09=09=09=09goto next_match;
+
+=09=09=09if (flags & NFT_SET_ELEM_INTERVAL_END)
+=09=09=09=09ret =3D f->mt[b].e;
+=09=09=09else
+=09=09=09=09ret =3D f->mt[b].e->start;
+=09=09=09goto out;
+=09=09}
+
+=09=09data +=3D NFT_PIPAPO_GROUPS_PADDING(f->groups);
+
+=09=09/* Swap bitmap indices: fill_map will be the initial bitmap for
+=09=09 * the next field (i.e. the new res_map), and res_map is
+=09=09 * guaranteed to be all-zeroes at this point, ready to be filled
+=09=09 * according to the next mapping table.
+=09=09 */
+=09=09swap(res_map, fill_map);
+=09}
+
+out:
+=09kfree(fill_map);
+=09kfree(res_map);
+=09return ret;
+}
+
+/**
+ * nft_pipapo_get() - Get matching element reference given key data
+ * @net:=09Network namespace
+ * @set:=09nftables API set representation
+ * @elem:=09nftables API element representation containing key data
+ * @flags:=09If NFT_SET_ELEM_INTERVAL_END is passed, return the end elemen=
t
+ */
+static void *nft_pipapo_get(const struct net *net, const struct nft_set *s=
et,
+=09=09=09    const struct nft_set_elem *elem, unsigned int flags)
+{
+=09return pipapo_get(net, set, (const u8 *)elem->key.val.data, flags);
+}
+
+/**
+ * pipapo_resize() - Resize lookup or mapping table, or both
+ * @f:=09=09Field containing lookup and mapping tables
+ * @old_rules:=09Previous amount of rules in field
+ * @rules:=09New amount of rules
+ *
+ * Increase, decrease or maintain tables size depending on new amount of r=
ules,
+ * and copy data over. In case the new size is smaller, throw away data fo=
r
+ * highest-numbered rules.
+ *
+ * Return: 0 on success, -ENOMEM on allocation failure.
+ */
+static int pipapo_resize(struct nft_pipapo_field *f, int old_rules, int ru=
les)
+{
+=09long *new_lt =3D NULL, *new_p, *old_lt =3D f->lt, *old_p;
+=09union nft_pipapo_map_bucket *new_mt, *old_mt =3D f->mt;
+=09size_t new_bucket_size, copy;
+=09int group, bucket;
+
+=09new_bucket_size =3D DIV_ROUND_UP(rules, BITS_PER_LONG);
+
+=09if (new_bucket_size =3D=3D f->bsize)
+=09=09goto mt;
+
+=09if (new_bucket_size > f->bsize)
+=09=09copy =3D f->bsize;
+=09else
+=09=09copy =3D new_bucket_size;
+
+=09new_lt =3D kvzalloc(f->groups * NFT_PIPAPO_BUCKETS * new_bucket_size *
+=09=09=09  sizeof(*new_lt), GFP_KERNEL);
+=09if (!new_lt)
+=09=09return -ENOMEM;
+
+=09new_p =3D new_lt;
+=09old_p =3D old_lt;
+=09for (group =3D 0; group < f->groups; group++) {
+=09=09for (bucket =3D 0; bucket < NFT_PIPAPO_BUCKETS; bucket++) {
+=09=09=09memcpy(new_p, old_p, copy * sizeof(*new_p));
+=09=09=09new_p +=3D copy;
+=09=09=09old_p +=3D copy;
+
+=09=09=09if (new_bucket_size > f->bsize)
+=09=09=09=09new_p +=3D new_bucket_size - f->bsize;
+=09=09=09else
+=09=09=09=09old_p +=3D f->bsize - new_bucket_size;
+=09=09}
+=09}
+
+mt:
+=09new_mt =3D kvmalloc(rules * sizeof(*new_mt), GFP_KERNEL);
+=09if (!new_mt) {
+=09=09kvfree(new_lt);
+=09=09return -ENOMEM;
+=09}
+
+=09memcpy(new_mt, f->mt, min(old_rules, rules) * sizeof(*new_mt));
+=09if (rules > old_rules) {
+=09=09memset(new_mt + old_rules, 0,
+=09=09       (rules - old_rules) * sizeof(*new_mt));
+=09}
+
+=09if (new_lt) {
+=09=09f->bsize =3D new_bucket_size;
+=09=09f->lt =3D new_lt;
+=09=09kvfree(old_lt);
+=09}
+
+=09f->mt =3D new_mt;
+=09kvfree(old_mt);
+
+=09return 0;
+}
+
+/**
+ * pipapo_bucket_set() - Set rule bit in bucket given group and group valu=
e
+ * @f:=09=09Field containing lookup table
+ * @rule:=09Rule index
+ * @group:=09Group index
+ * @v:=09=09Value of bit group
+ */
+static void pipapo_bucket_set(struct nft_pipapo_field *f, int rule, int gr=
oup,
+=09=09=09      int v)
+{
+=09unsigned long *pos;
+
+=09pos =3D f->lt + f->bsize * NFT_PIPAPO_BUCKETS * group;
+=09pos +=3D f->bsize * v;
+
+=09__set_bit(rule, pos);
+}
+
+/**
+ * pipapo_insert() - Insert new rule in field given input key and mask len=
gth
+ * @f:=09=09Field containing lookup table
+ * @k:=09=09Input key for classification, without nftables padding
+ * @mask_bits:=09Length of mask; matches field length for non-ranged entry
+ *
+ * Insert a new rule reference in lookup buckets corresponding to k and
+ * mask_bits.
+ *
+ * Return: 1 on success (one rule inserted), negative error code on failur=
e.
+ */
+static int pipapo_insert(struct nft_pipapo_field *f, const uint8_t *k,
+=09=09=09 int mask_bits)
+{
+=09int rule =3D f->rules++, group, ret;
+
+=09ret =3D pipapo_resize(f, f->rules - 1, f->rules);
+=09if (ret)
+=09=09return ret;
+
+=09for (group =3D 0; group < f->groups; group++) {
+=09=09int i, v;
+=09=09u8 mask;
+
+=09=09if (group % 2)
+=09=09=09v =3D k[group / 2] & 0x0f;
+=09=09else
+=09=09=09v =3D k[group / 2] >> 4;
+
+=09=09if (mask_bits >=3D (group + 1) * 4) {
+=09=09=09/* Not masked */
+=09=09=09pipapo_bucket_set(f, rule, group, v);
+=09=09} else if (mask_bits <=3D group * 4) {
+=09=09=09/* Completely masked */
+=09=09=09for (i =3D 0; i < NFT_PIPAPO_BUCKETS; i++)
+=09=09=09=09pipapo_bucket_set(f, rule, group, i);
+=09=09} else {
+=09=09=09/* The mask limit falls on this group */
+=09=09=09mask =3D 0x0f >> (mask_bits - group * 4);
+=09=09=09for (i =3D 0; i < NFT_PIPAPO_BUCKETS; i++) {
+=09=09=09=09if ((i & ~mask) =3D=3D (v & ~mask))
+=09=09=09=09=09pipapo_bucket_set(f, rule, group, i);
+=09=09=09}
+=09=09}
+=09}
+
+=09return 1;
+}
+
+/**
+ * pipapo_step_diff() - Check if setting @step bit in netmask would change=
 it
+ * @base:=09Mask we are expanding
+ * @step:=09Step bit for given expansion step
+ * @len:=09Total length of mask space (set and unset bits), bytes
+ *
+ * Convenience function for mask expansion.
+ *
+ * Return: true if step bit changes mask (i.e. isn't set), false otherwise=
.
+ */
+static bool pipapo_step_diff(u8 *base, int step, int len)
+{
+=09/* Network order, byte-addressed */
+#ifdef __BIG_ENDIAN__
+=09return !(BIT(step % BITS_PER_BYTE) & base[step / BITS_PER_BYTE]);
+#else
+=09return !(BIT(step % BITS_PER_BYTE) &
+=09=09 base[len - 1 - step / BITS_PER_BYTE]);
+#endif
+}
+
+/**
+ * pipapo_step_after_end() - Check if mask exceeds range end with given st=
ep
+ * @base:=09Mask we are expanding
+ * @end:=09End of range
+ * @step:=09Step bit for given expansion step, highest bit to be set
+ * @len:=09Total length of mask space (set and unset bits), bytes
+ *
+ * Convenience function for mask expansion.
+ *
+ * Return: true if mask exceeds range setting step bits, false otherwise.
+ */
+static bool pipapo_step_after_end(const u8 *base, const u8 *end, int step,
+=09=09=09=09  int len)
+{
+=09u8 tmp[NFT_PIPAPO_MAX_BYTES];
+=09int i;
+
+=09memcpy(tmp, base, len);
+
+=09/* Network order, byte-addressed */
+=09for (i =3D 0; i <=3D step; i++)
+#ifdef __BIG_ENDIAN__
+=09=09tmp[i / BITS_PER_BYTE] |=3D BIT(i % BITS_PER_BYTE);
+#else
+=09=09tmp[len - 1 - i / BITS_PER_BYTE] |=3D BIT(i % BITS_PER_BYTE);
+#endif
+
+=09return memcmp(tmp, end, len) > 0;
+}
+
+/**
+ * pipapo_base_sum() - Sum step bit to given len-sized netmask base with c=
arry
+ * @base:=09Netmask base
+ * @step:=09Step bit to sum
+ * @len:=09Netmask length, bytes
+ */
+static void pipapo_base_sum(u8 *base, int step, int len)
+{
+=09bool carry =3D false;
+=09int i;
+
+=09/* Network order, byte-addressed */
+#ifdef __BIG_ENDIAN__
+=09for (i =3D step / BITS_PER_BYTE; i < len; i++) {
+#else
+=09for (i =3D len - 1 - step / BITS_PER_BYTE; i >=3D 0; i--) {
+#endif
+=09=09if (carry)
+=09=09=09base[i]++;
+=09=09else
+=09=09=09base[i] +=3D 1 << (step % BITS_PER_BYTE);
+
+=09=09if (base[i])
+=09=09=09break;
+
+=09=09carry =3D true;
+=09}
+}
+
+/**
+ * expand() - Expand range to composing netmasks and insert into lookup ta=
ble
+ * @f:=09=09Field containing lookup table
+ * @start:=09Start of range
+ * @end:=09End of range
+ * @len:=09Length of value in bits
+ *
+ * Expand range to composing netmasks and insert corresponding rule refere=
nces
+ * in lookup buckets.
+ *
+ * Return: number of inserted rules on success, negative error code on fai=
lure.
+ */
+static int pipapo_expand(struct nft_pipapo_field *f,
+=09=09=09 const u8 *start, const u8 *end, int len)
+{
+=09int step, masks =3D 0, bytes =3D DIV_ROUND_UP(len, BITS_PER_BYTE);
+=09u8 base[NFT_PIPAPO_MAX_BYTES];
+
+=09memcpy(base, start, bytes);
+=09while (memcmp(base, end, bytes) <=3D 0) {
+=09=09int err;
+
+=09=09step =3D 0;
+=09=09while (pipapo_step_diff(base, step, bytes)) {
+=09=09=09if (pipapo_step_after_end(base, end, step, bytes))
+=09=09=09=09break;
+
+=09=09=09step++;
+=09=09=09if (step >=3D len) {
+=09=09=09=09if (!masks) {
+=09=09=09=09=09pipapo_insert(f, base, 0);
+=09=09=09=09=09masks =3D 1;
+=09=09=09=09}
+=09=09=09=09goto out;
+=09=09=09}
+=09=09}
+
+=09=09err =3D pipapo_insert(f, base, len - step);
+
+=09=09if (err < 0)
+=09=09=09return err;
+
+=09=09masks++;
+=09=09pipapo_base_sum(base, step, bytes);
+=09}
+out:
+=09return masks;
+}
+
+/**
+ * pipapo_map() - Insert rules in mapping tables, mapping them between fie=
lds
+ * @m:=09=09Matching data, including mapping table
+ * @map:=09Table of rule maps: array of first rule and amount of rules
+ *=09=09in next field a given rule maps to, for each field
+ * @ext:=09For last field, nft_set_ext pointer matching rules map to
+ */
+static void pipapo_map(struct nft_pipapo_match *m,
+=09=09       union nft_pipapo_map_bucket map[NFT_PIPAPO_MAX_FIELDS],
+=09=09       struct nft_pipapo_elem *e)
+{
+=09struct nft_pipapo_field *f;
+=09int i, j;
+
+=09for (i =3D 0, f =3D m->f; i < m->field_count - 1; i++, f++) {
+=09=09for (j =3D 0; j < map[i].n; j++) {
+=09=09=09f->mt[map[i].to + j].to =3D map[i + 1].to;
+=09=09=09f->mt[map[i].to + j].n =3D map[i + 1].n;
+=09=09}
+=09}
+
+=09/* Last field: map to ext instead of mapping to next field */
+=09for (j =3D 0; j < map[i].n; j++)
+=09=09f->mt[map[i].to + j].e =3D e;
+}
+
+/**
+ * pipapo_realloc_scratch() - Reallocate scratch maps for partial match re=
sults
+ * @m:=09=09Matching data
+ * @bsize_max=09Maximum bucket size, scratch maps cover two buckets
+ *
+ * Return: 0 on success, -ENOMEM on failure.
+ */
+static int pipapo_realloc_scratch(struct nft_pipapo_match *m,
+=09=09=09=09  unsigned long bsize_max)
+{
+=09int i;
+
+=09for_each_possible_cpu(i) {
+=09=09unsigned long *scratch;
+
+=09=09scratch =3D kzalloc_node(bsize_max * sizeof(*scratch) * 2,
+=09=09=09=09       GFP_KERNEL, cpu_to_node(i));
+=09=09if (!scratch)
+=09=09=09return -ENOMEM;
+
+=09=09kfree(*per_cpu_ptr(m->scratch, i));
+
+=09=09*per_cpu_ptr(m->scratch, i) =3D scratch;
+=09}
+
+=09return 0;
+}
+
+/**
+ * nft_pipapo_insert() - Validate and insert ranged elements
+ * @net:=09Network namespace
+ * @set:=09nftables API set representation
+ * @elem:=09nftables API element representation containing key data
+ * @flags:=09If NFT_SET_ELEM_INTERVAL_END is passed, this is the end eleme=
nt
+ * @ext2:=09Filled with pointer to &struct nft_set_ext in inserted element
+ *
+ * In this set implementation, this functions needs to be called twice, wi=
th
+ * start and end element, to obtain a valid entry insertion. Calls to this
+ * function are serialised, so we can store element and key data on the fi=
rst
+ * call with start element, and use it on the second call once we get the =
end
+ * element too.
+ *
+ * Return: 0 on success, error pointer on failure.
+ */
+static int nft_pipapo_insert(const struct net *net, const struct nft_set *=
set,
+=09=09=09     const struct nft_set_elem *elem,
+=09=09=09     struct nft_set_ext **ext2)
+{
+=09const struct nft_set_ext *ext =3D nft_set_elem_ext(set, elem->priv);
+=09const u8 *data =3D (const u8 *)elem->key.val.data, *start, *end;
+=09union nft_pipapo_map_bucket rulemap[NFT_PIPAPO_MAX_FIELDS];
+=09struct nft_pipapo *priv =3D nft_set_priv(set);
+=09struct nft_pipapo_match *m =3D priv->clone;
+=09struct nft_pipapo_elem *e =3D elem->priv;
+=09struct nft_pipapo_field *f;
+=09int i, bsize_max, err =3D 0;
+=09void *dup;
+
+=09dup =3D nft_pipapo_get(net, set, elem, 0);
+=09if (PTR_ERR(dup) !=3D -ENOENT) {
+=09=09if (IS_ERR(dup))
+=09=09=09return PTR_ERR(dup);
+=09=09*ext2 =3D dup;
+=09=09return -EEXIST;
+=09}
+
+=09if (!nft_set_ext_exists(ext, NFT_SET_EXT_FLAGS) ||
+=09    !(*nft_set_ext_flags(ext) & NFT_SET_ELEM_INTERVAL_END)) {
+=09=09priv->start_elem =3D e;
+=09=09*ext2 =3D &e->ext;
+=09=09memcpy(priv->start_data, data, priv->width);
+=09=09return 0;
+=09}
+
+=09e->start =3D priv->start_elem;
+
+=09/* Validate */
+=09start =3D priv->start_data;
+=09end =3D data;
+
+=09nft_pipapo_for_each_field(f, i, m) {
+=09=09if (f->rules >=3D (unsigned long)NFT_PIPAPO_RULE0_MAX)
+=09=09=09return -ENOSPC;
+
+=09=09if (memcmp(start, end,
+=09=09=09   f->groups / NFT_PIPAPO_GROUPS_PER_BYTE) > 0)
+=09=09=09return -EINVAL;
+
+=09=09start +=3D NFT_PIPAPO_GROUPS_PADDED_SIZE(f->groups);
+=09=09end +=3D NFT_PIPAPO_GROUPS_PADDED_SIZE(f->groups);
+=09}
+
+=09/* Insert */
+=09priv->dirty =3D true;
+
+=09bsize_max =3D m->bsize_max;
+
+=09start =3D priv->start_data;
+=09end =3D data;
+=09nft_pipapo_for_each_field(f, i, m) {
+=09=09int ret;
+
+=09=09rulemap[i].to =3D f->rules;
+
+=09=09ret =3D memcmp(start, end,
+=09=09=09     f->groups / NFT_PIPAPO_GROUPS_PER_BYTE);
+=09=09if (!ret) {
+=09=09=09ret =3D pipapo_insert(f, start,
+=09=09=09=09=09    f->groups * NFT_PIPAPO_GROUP_BITS);
+=09=09} else {
+=09=09=09ret =3D pipapo_expand(f, start, end,
+=09=09=09=09=09    f->groups * NFT_PIPAPO_GROUP_BITS);
+=09=09}
+
+=09=09if (f->bsize > bsize_max)
+=09=09=09bsize_max =3D f->bsize;
+
+=09=09rulemap[i].n =3D ret;
+
+=09=09start +=3D NFT_PIPAPO_GROUPS_PADDED_SIZE(f->groups);
+=09=09end +=3D NFT_PIPAPO_GROUPS_PADDED_SIZE(f->groups);
+=09}
+
+=09if (!*this_cpu_ptr(m->scratch) || bsize_max > m->bsize_max) {
+=09=09err =3D pipapo_realloc_scratch(m, bsize_max);
+=09=09if (err)
+=09=09=09return err;
+
+=09=09this_cpu_write(nft_pipapo_scratch_index, false);
+
+=09=09m->bsize_max =3D bsize_max;
+=09}
+
+=09*ext2 =3D &e->ext;
+
+=09pipapo_map(m, rulemap, e);
+
+=09return 0;
+}
+
+/**
+ * pipapo_clone() - Clone matching data to create new working copy
+ * @old:=09Existing matching data
+ *
+ * Return: copy of matching data passed as 'old', error pointer on failure
+ */
+static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
+{
+=09struct nft_pipapo_field *dst, *src;
+=09struct nft_pipapo_match *new;
+=09int i;
+
+=09new =3D kmalloc(sizeof(*new) + sizeof(*dst) * old->field_count,
+=09=09      GFP_KERNEL);
+=09if (!new)
+=09=09return ERR_PTR(-ENOMEM);
+
+=09new->field_count =3D old->field_count;
+=09new->bsize_max =3D old->bsize_max;
+
+=09new->scratch =3D alloc_percpu(*new->scratch);
+=09if (!new->scratch)
+=09=09goto out_scratch;
+
+=09rcu_head_init(&new->rcu);
+
+=09src =3D old->f;
+=09dst =3D new->f;
+
+=09for (i =3D 0; i < old->field_count; i++) {
+=09=09memcpy(dst, src, offsetof(struct nft_pipapo_field, lt));
+
+=09=09dst->lt =3D kvzalloc(src->groups * NFT_PIPAPO_BUCKETS *
+=09=09=09=09   src->bsize * sizeof(*dst->lt),
+=09=09=09=09   GFP_KERNEL);
+=09=09if (!dst->lt)
+=09=09=09goto out_lt;
+
+=09=09memcpy(dst->lt, src->lt,
+=09=09       src->bsize * sizeof(*dst->lt) *
+=09=09       src->groups * NFT_PIPAPO_BUCKETS);
+
+=09=09dst->mt =3D kvmalloc(src->rules * sizeof(*src->mt), GFP_KERNEL);
+=09=09if (!dst->mt)
+=09=09=09goto out_mt;
+
+=09=09memcpy(dst->mt, src->mt, src->rules * sizeof(*src->mt));
+=09=09src++;
+=09=09dst++;
+=09}
+
+=09return new;
+
+out_mt:
+=09kvfree(dst->lt);
+out_lt:
+=09for (dst--; i > 0; i--) {
+=09=09kvfree(dst->mt);
+=09=09kvfree(dst->lt);
+=09=09dst--;
+=09}
+=09free_percpu(new->scratch);
+out_scratch:
+=09kfree(new);
+
+=09return ERR_PTR(-ENOMEM);
+}
+
+/**
+ * pipapo_rules_same_key() - Get number of rules originated from the same =
entry
+ * @f:=09=09Field containing mapping table
+ * @first:=09Index of first rule in set of rules mapping to same entry
+ *
+ * Using the fact that all rules in a field that originated from the same =
entry
+ * will map to the same set of rules in the next field, or to the same ele=
ment
+ * reference, return the cardinality of the set of rules that originated f=
rom
+ * the same entry as the rule with index @first, @first rule included.
+ *
+ * In pictures:
+ *=09=09=09=09rules
+ *=09field #0=09=090    1    2    3    4
+ *=09=09map to:=09=090    1   2-4  2-4  5-9
+ *=09=09=09=09.    .    .......   . ...
+ *=09=09=09=09|    |    |    | \   \
+ *=09=09=09=09|    |    |    |  \   \
+ *=09=09=09=09|    |    |    |   \   \
+ *=09=09=09=09'    '    '    '    '   \
+ *=09in field #1=09=090    1    2    3    4    5 ...
+ *
+ * if this is called for rule 2 on field #0, it will return 3, as also rul=
es 2
+ * and 3 in field 0 map to the same set of rules (2, 3, 4) in the next fie=
ld.
+ *
+ * For the last field in a set, we can rely on associated entries to map t=
o the
+ * same element references.
+ *
+ * Return: Number of rules that originated from the same entry as @first.
+ */
+static int pipapo_rules_same_key(struct nft_pipapo_field *f, int first)
+{
+=09struct nft_pipapo_elem *e =3D NULL; /* Keep gcc happy */
+=09int r;
+
+=09for (r =3D first; r < f->rules; r++) {
+=09=09if (r !=3D first && e !=3D f->mt[r].e)
+=09=09=09return r - first;
+
+=09=09e =3D f->mt[r].e;
+=09}
+
+=09if (r !=3D first)
+=09=09return r - first;
+
+=09return 0;
+}
+
+/**
+ * pipapo_unmap() - Remove rules from mapping tables, renumber remaining o=
nes
+ * @mt:=09=09Mapping array
+ * @rules:=09Original amount of rules in mapping table
+ * @start:=09First rule index to be removed
+ * @n:=09=09Amount of rules to be removed
+ * @to_offset:=09First rule index, in next field, this group of rules maps=
 to
+ * @is_last:=09If this is the last field, delete reference from mapping ar=
ray
+ *
+ * This is used to unmap rules from the mapping table for a single field,
+ * maintaining consistency and compactness for the existing ones.
+ *
+ * In pictures: let's assume that we want to delete rules 2 and 3 from the
+ * following mapping array:
+ *
+ *                 rules
+ *               0      1      2      3      4
+ *      map to:  4-10   4-10   11-15  11-15  16-18
+ *
+ * the result will be:
+ *
+ *                 rules
+ *               0      1      2
+ *      map to:  4-10   4-10   11-13
+ *
+ * for fields before the last one. In case this is the mapping table for t=
he
+ * last field in a set, and rules map to pointers to &struct nft_pipapo_el=
em:
+ *
+ *                      rules
+ *                        0      1      2      3      4
+ *  element pointers:  0x42   0x42   0x33   0x33   0x44
+ *
+ * the result will be:
+ *
+ *                      rules
+ *                        0      1      2
+ *  element pointers:  0x42   0x42   0x44
+ */
+static void pipapo_unmap(union nft_pipapo_map_bucket *mt, int rules,
+=09=09=09 int start, int n, int to_offset, bool is_last)
+{
+=09int i;
+
+=09memmove(mt + start, mt + start + n, (rules - start - n) * sizeof(*mt));
+=09memset(mt + rules - n, 0, n * sizeof(*mt));
+
+=09if (is_last)
+=09=09return;
+
+=09for (i =3D start; i < rules - n; i++)
+=09=09mt[i].to -=3D to_offset;
+}
+
+/**
+ * pipapo_drop() - Delete entry from lookup and mapping tables, given rule=
 map
+ * @m:=09=09Matching data
+ * @rulemap=09Table of rule maps, arrays of first rule and amount of rules
+ *=09=09in next field a given entry maps to, for each field
+ *
+ * For each rule in lookup table buckets mapping to this set of rules, dro=
p
+ * all bits set in lookup table mapping. In pictures, assuming we want to =
drop
+ * rules 0 and 1 from this lookup table:
+ *
+ *                     bucket
+ *      group  0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  =
15
+ *        0    0                                              1,2
+ *        1   1,2                                      0
+ *        2    0                                      1,2
+ *        3    0                              1,2
+ *        4  0,1,2
+ *        5    0   1   2
+ *        6  0,1,2 1   1   1   1   1   1   1   1   1   1   1   1   1   1  =
 1
+ *        7   1,2 1,2  1   1   1  0,1  1   1   1   1   1   1   1   1   1  =
 1
+ *
+ * rule 2 becomes rule 0, and the result will be:
+ *
+ *                     bucket
+ *      group  0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  =
15
+ *        0                                                    0
+ *        1    0
+ *        2                                            0
+ *        3                                    0
+ *        4    0
+ *        5            0
+ *        6    0
+ *        7    0   0
+ *
+ * once this is done, call unmap() to drop all the corresponding rule refe=
rences
+ * from mapping tables.
+ */
+static void pipapo_drop(struct nft_pipapo_match *m,
+=09=09=09union nft_pipapo_map_bucket rulemap[])
+{
+=09struct nft_pipapo_field *f;
+=09int i;
+
+=09nft_pipapo_for_each_field(f, i, m) {
+=09=09int g;
+
+=09=09for (g =3D 0; g < f->groups; g++) {
+=09=09=09unsigned long *pos;
+=09=09=09int b;
+
+=09=09=09pos =3D f->lt + g * NFT_PIPAPO_BUCKETS * f->bsize;
+
+=09=09=09for (b =3D 0; b < NFT_PIPAPO_BUCKETS; b++) {
+=09=09=09=09bitmap_cut(pos, pos, rulemap[i].to,
+=09=09=09=09=09   rulemap[i].n,
+=09=09=09=09=09   f->bsize * BITS_PER_LONG);
+
+=09=09=09=09pos +=3D f->bsize;
+=09=09=09}
+=09=09}
+
+=09=09pipapo_unmap(f->mt, f->rules, rulemap[i].to, rulemap[i].n,
+=09=09=09     rulemap[i + 1].n, i =3D=3D m->field_count - 1);
+=09=09if (pipapo_resize(f, f->rules, f->rules - rulemap[i].n)) {
+=09=09=09/* We can ignore this, a failure to shrink tables down
+=09=09=09 * doesn't make tables invalid.
+=09=09=09 */
+=09=09=09;
+=09=09}
+=09=09f->rules -=3D rulemap[i].n;
+=09}
+}
+
+/**
+ * pipapo_gc() - Drop expired entries from set, destroy start and end elem=
ents
+ * @set:=09nftables API set representation
+ * @m:=09=09Matching data
+ */
+static void pipapo_gc(const struct nft_set *set, struct nft_pipapo_match *=
m)
+{
+=09struct nft_pipapo *priv =3D nft_set_priv(set);
+=09int rules_f0, first_rule =3D 0;
+
+=09while ((rules_f0 =3D pipapo_rules_same_key(m->f, first_rule))) {
+=09=09union nft_pipapo_map_bucket rulemap[NFT_PIPAPO_MAX_FIELDS];
+=09=09struct nft_pipapo_field *f;
+=09=09struct nft_pipapo_elem *e;
+=09=09int i, start, rules_fx;
+
+=09=09start =3D first_rule;
+=09=09rules_fx =3D rules_f0;
+
+=09=09nft_pipapo_for_each_field(f, i, m) {
+=09=09=09rulemap[i].to =3D start;
+=09=09=09rulemap[i].n =3D rules_fx;
+
+=09=09=09if (i < m->field_count - 1) {
+=09=09=09=09rules_fx =3D f->mt[start].n;
+=09=09=09=09start =3D f->mt[start].to;
+=09=09=09}
+=09=09}
+
+=09=09/* Pick the last field, and its last index */
+=09=09f--;
+=09=09i--;
+=09=09e =3D f->mt[rulemap[i].to].e;
+=09=09if (nft_set_elem_expired(&e->ext) &&
+=09=09    !nft_set_elem_mark_busy(&e->ext)) {
+=09=09=09priv->dirty =3D true;
+=09=09=09pipapo_drop(m, rulemap);
+
+=09=09=09rcu_barrier();
+=09=09=09nft_set_elem_destroy(set, e->start, true);
+=09=09=09nft_set_elem_destroy(set, e, true);
+
+=09=09=09/* And check again current first rule, which is now the
+=09=09=09 * first we haven't checked.
+=09=09=09 */
+=09=09} else {
+=09=09=09first_rule +=3D rules_f0;
+=09=09}
+=09}
+
+=09priv->last_gc =3D jiffies;
+}
+
+/**
+ * pipapo_free_fields() - Free per-field tables contained in matching data
+ * @m:=09=09Matching data
+ */
+static void pipapo_free_fields(struct nft_pipapo_match *m)
+{
+=09struct nft_pipapo_field *f;
+=09int i;
+
+=09nft_pipapo_for_each_field(f, i, m) {
+=09=09kvfree(f->lt);
+=09=09kvfree(f->mt);
+=09}
+}
+
+/**
+ * pipapo_reclaim_match - RCU callback to free fields from old matching da=
ta
+ * @rcu:=09RCU head
+ */
+static void pipapo_reclaim_match(struct rcu_head *rcu)
+{
+=09struct nft_pipapo_match *m;
+=09int i;
+
+=09m =3D container_of(rcu, struct nft_pipapo_match, rcu);
+
+=09for_each_possible_cpu(i)
+=09=09kfree(*per_cpu_ptr(m->scratch, i));
+
+=09free_percpu(m->scratch);
+
+=09pipapo_free_fields(m);
+
+=09kfree(m);
+}
+
+/**
+ * pipapo_commit() - Replace lookup data with current working copy
+ * @set:=09nftables API set representation
+ *
+ * While at it, check if we should perform garbage collection on the worki=
ng
+ * copy before committing it for lookup, and don't replace the table if th=
e
+ * working copy doesn't have pending changes.
+ *
+ * We also need to create a new working copy for subsequent insertions and
+ * deletions.
+ */
+static void pipapo_commit(const struct nft_set *set)
+{
+=09struct nft_pipapo *priv =3D nft_set_priv(set);
+=09struct nft_pipapo_match *new_clone, *old;
+
+=09if (time_after_eq(jiffies, priv->last_gc + nft_set_gc_interval(set)))
+=09=09pipapo_gc(set, priv->clone);
+
+=09if (!priv->dirty)
+=09=09return;
+
+=09new_clone =3D pipapo_clone(priv->clone);
+=09if (IS_ERR(new_clone))
+=09=09return;
+
+=09priv->dirty =3D false;
+
+=09old =3D rcu_access_pointer(priv->match);
+=09rcu_assign_pointer(priv->match, priv->clone);
+=09if (old)
+=09=09call_rcu(&old->rcu, pipapo_reclaim_match);
+
+=09priv->clone =3D new_clone;
+}
+
+/**
+ * nft_pipapo_activate() - Mark element reference as active given key, com=
mit
+ * @net:=09Network namespace
+ * @set:=09nftables API set representation
+ * @elem:=09nftables API element representation containing key data
+ *
+ * On insertion, elements are added to a copy of the matching data current=
ly
+ * in use for lookups, and not directly inserted into current lookup data,=
 so
+ * we'll take care of that by calling pipapo_commit() here. This is probab=
ly as
+ * close as we can get to an actual atomic transaction: both nft_pipapo_in=
sert()
+ * and nft_pipapo_activate() are called once for each element, hence we ca=
n't
+ * purpose either one as a real commit operation.
+ */
+static void nft_pipapo_activate(const struct net *net,
+=09=09=09=09const struct nft_set *set,
+=09=09=09=09const struct nft_set_elem *elem)
+{
+=09const struct nft_set_ext *ext =3D nft_set_elem_ext(set, elem->priv);
+=09struct nft_pipapo_elem *e;
+
+=09if (!nft_set_ext_exists(ext, NFT_SET_EXT_FLAGS) ||
+=09    !(*nft_set_ext_flags(ext) & NFT_SET_ELEM_INTERVAL_END)) {
+=09=09e =3D pipapo_get(net, set, (const u8 *)elem->key.val.data, 0);
+=09=09if (IS_ERR(e))
+=09=09=09return;
+
+=09=09nft_set_elem_change_active(net, set, &e->ext);
+=09=09nft_set_elem_clear_busy(&e->ext);
+
+=09=09return;
+=09}
+
+=09e =3D pipapo_get(net, set, (const u8 *)elem->key.val.data,
+=09=09       NFT_SET_ELEM_INTERVAL_END);
+=09if (IS_ERR(e))
+=09=09return;
+
+=09nft_set_elem_change_active(net, set, &e->ext);
+=09nft_set_elem_clear_busy(&e->ext);
+
+=09pipapo_commit(set);
+}
+
+/**
+ * pipapo_deactivate() - Check that element is in set, mark as inactive
+ * @net:=09Network namespace
+ * @set:=09nftables API set representation
+ * @data:=09Input key data
+ * @ext:=09nftables API extension pointer, used to check for end element
+ *
+ * This is a convenience function that can be called from both
+ * nft_pipapo_deactivate() and nft_pipapo_flush(), as they are in fact the=
 same
+ * operation.
+ *
+ * Return: deactivated element if found, NULL otherwise.
+ */
+static void *pipapo_deactivate(const struct net *net, const struct nft_set=
 *set,
+=09=09=09       const u8 *data, const struct nft_set_ext *ext)
+{
+=09u8 genmask =3D nft_genmask_next(net);
+=09struct nft_pipapo_elem *e;
+=09unsigned int flags =3D 0;
+
+=09if (nft_set_ext_exists(ext, NFT_SET_EXT_FLAGS))
+=09=09flags =3D *nft_set_ext_flags(ext) & NFT_SET_ELEM_INTERVAL_END;
+
+=09e =3D pipapo_get(net, set, data, flags);
+=09if (IS_ERR(e))
+=09=09return NULL;
+
+=09if (nft_set_elem_active(&e->ext, genmask))
+=09=09nft_set_elem_change_active(net, set, &e->ext);
+
+=09return e;
+}
+
+/**
+ * nft_pipapo_deactivate() - Call pipapo_deactivate() to make element inac=
tive
+ * @net:=09Network namespace
+ * @set:=09nftables API set representation
+ * @elem:=09nftables API element representation containing key data
+ *
+ * Return: deactivated element if found, NULL otherwise.
+ */
+static void *nft_pipapo_deactivate(const struct net *net,
+=09=09=09=09   const struct nft_set *set,
+=09=09=09=09   const struct nft_set_elem *elem)
+{
+=09const struct nft_set_ext *ext =3D nft_set_elem_ext(set, elem->priv);
+
+=09return pipapo_deactivate(net, set, (const u8 *)elem->key.val.data, ext)=
;
+}
+
+/**
+ * nft_pipapo_flush() - Call pipapo_deactivate() to make element inactive
+ * @net:=09Network namespace
+ * @set:=09nftables API set representation
+ * @elem:=09nftables API element representation containing key data
+ *
+ * This is functionally the same as nft_pipapo_deactivate(), with a slight=
ly
+ * different interface, and it's also called once for each element in a se=
t
+ * being flushed, so we can't implement an atomic flush operation, which w=
ould
+ * otherwise be as simple as allocating an empty copy of the matching data=
.
+ *
+ * Note that we could in theory do that, mark the set as flushed, and igno=
re
+ * subsequent calls, but we would leak all the elements after the first on=
e,
+ * because they wouldn't then be freed as result of API calls.
+ *
+ * Return: true if element was found and deactivated.
+ */
+static bool nft_pipapo_flush(const struct net *net, const struct nft_set *=
set,
+=09=09=09     void *elem)
+{
+=09struct nft_pipapo_elem *e =3D elem;
+
+=09return pipapo_deactivate(net, set, (const u8 *)nft_set_ext_key(&e->ext)=
,
+=09=09=09=09 &e->ext);
+}
+
+/**
+ * pipapo_get_boundaries() - Get byte interval for associated rules
+ * @f:=09=09Field including lookup table
+ * @first_rule:=09First rule (lowest index)
+ * @rule_count:=09Number of associated rules
+ * @left:=09Byte expression for left boundary (start of range)
+ * @right:=09Byte expression for right boundary (end of range)
+ *
+ * Given the first rule and amount of rules that originated from the same =
entry,
+ * build the original range associated with the entry, and calculate the l=
ength
+ * of the originating netmask.
+ *
+ * In pictures:
+ *
+ *                     bucket
+ *      group  0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  =
15
+ *        0                                                   1,2
+ *        1   1,2
+ *        2                                           1,2
+ *        3                                   1,2
+ *        4   1,2
+ *        5        1   2
+ *        6   1,2  1   1   1   1   1   1   1   1   1   1   1   1   1   1  =
 1
+ *        7   1,2 1,2  1   1   1   1   1   1   1   1   1   1   1   1   1  =
 1
+ *
+ * this is the lookup table corresponding to the IPv4 range
+ * 192.168.1.0-192.168.2.1, which was expanded to the two composing netmas=
ks,
+ * rule #1: 192.168.1.0/24, and rule #2: 192.168.2.0/31.
+ *
+ * This function fills @left and @right with the byte values of the leftmo=
st
+ * and rightmost bucket indices for the lowest and highest rule indices,
+ * respectively. If @first_rule is 1 and @rule_count is 2, we obtain, in
+ * nibbles:
+ *   left:  < 12, 0, 10, 8, 0, 1, 0, 0 >
+ *   right: < 12, 0, 10, 8, 0, 2, 2, 1 >
+ * corresponding to bytes:
+ *   left:  < 192, 168, 1, 0 >
+ *   right: < 192, 168, 2, 1 >
+ * with mask length irrelevant here, unused on return, as the range is alr=
eady
+ * defined by its start and end points. The mask length is relevant for a =
single
+ * ranged entry instead: if @first_rule is 1 and @rule_count is 1, we igno=
re
+ * rule 2 above: @left becomes < 192, 168, 1, 0 >, @right becomes
+ * < 192, 168, 1, 255 >, and the mask length, calculated from the distance=
s
+ * between leftmost and rightmost bucket indices for each group, would be =
24.
+ *
+ * Return: mask length, in bits.
+ */
+static int pipapo_get_boundaries(struct nft_pipapo_field *f, int first_rul=
e,
+=09=09=09=09 int rule_count, u8 *left, u8 *right)
+{
+=09u8 *l =3D left, *r =3D right;
+=09int g, mask_len =3D 0;
+
+=09for (g =3D 0; g < f->groups; g++) {
+=09=09int b, x0, x1;
+
+=09=09x0 =3D -1;
+=09=09x1 =3D -1;
+=09=09for (b =3D 0; b < NFT_PIPAPO_BUCKETS; b++) {
+=09=09=09unsigned long *pos;
+
+=09=09=09pos =3D f->lt + (g * NFT_PIPAPO_BUCKETS + b) * f->bsize;
+=09=09=09if (test_bit(first_rule, pos) && x0 =3D=3D -1)
+=09=09=09=09x0 =3D b;
+=09=09=09if (test_bit(first_rule + rule_count - 1, pos))
+=09=09=09=09x1 =3D b;
+=09=09}
+
+=09=09if (g % 2) {
+=09=09=09*(l++) |=3D x0 & 0x0f;
+=09=09=09*(r++) |=3D x1 & 0x0f;
+=09=09} else {
+=09=09=09*l |=3D x0 << 4;
+=09=09=09*r |=3D x1 << 4;
+=09=09}
+
+=09=09if (x1 - x0 =3D=3D 0)
+=09=09=09mask_len +=3D 4;
+=09=09else if (x1 - x0 =3D=3D 1)
+=09=09=09mask_len +=3D 3;
+=09=09else if (x1 - x0 =3D=3D 3)
+=09=09=09mask_len +=3D 2;
+=09=09else if (x1 - x0 =3D=3D 7)
+=09=09=09mask_len +=3D 1;
+=09}
+
+=09return mask_len;
+}
+
+/**
+ * pipapo_match_field() - Match rules against byte ranges
+ * @f:=09=09Field including the lookup table
+ * @first_rule:=09First of associated rules originating from same entry
+ * @rule_count:=09Amount of associated rules
+ * @start:=09Start of range to be matched
+ * @end:=09End of range to be matched
+ *
+ * Return: true on match, false otherwise.
+ */
+static bool pipapo_match_field(struct nft_pipapo_field *f,
+=09=09=09       int first_rule, int rule_count,
+=09=09=09       const u8 *start, const u8 *end)
+{
+=09u8 right[NFT_PIPAPO_MAX_BYTES] =3D { 0 };
+=09u8 left[NFT_PIPAPO_MAX_BYTES] =3D { 0 };
+
+=09pipapo_get_boundaries(f, first_rule, rule_count, left, right);
+
+=09return !memcmp(start, left, f->groups / NFT_PIPAPO_GROUPS_PER_BYTE) &&
+=09       !memcmp(end, right, f->groups / NFT_PIPAPO_GROUPS_PER_BYTE);
+}
+
+/**
+ * nft_pipapo_remove() - Remove element given key, commit
+ * @net:=09Network namespace
+ * @set:=09nftables API set representation
+ * @elem:=09nftables API element representation containing key data
+ *
+ * Similarly to nft_pipapo_activate(), this is used as commit operation by=
 the
+ * API, but it's called once per element in the pending transaction, so we=
 can't
+ * implement an actual, atomic commit operation. Closest we can get is to =
remove
+ * the matched element here, if any, and commit the updated matching data.
+ */
+static void nft_pipapo_remove(const struct net *net, const struct nft_set =
*set,
+=09=09=09      const struct nft_set_elem *elem)
+{
+=09const u8 *data =3D (const u8 *)elem->key.val.data;
+=09struct nft_pipapo *priv =3D nft_set_priv(set);
+=09struct nft_pipapo_match *m =3D priv->clone;
+=09const struct nft_set_ext *ext;
+=09int rules_f0, first_rule =3D 0;
+=09struct nft_pipapo_elem *e;
+
+=09ext =3D nft_set_elem_ext(set, elem->priv);
+=09if (!nft_set_ext_exists(ext, NFT_SET_EXT_FLAGS) ||
+=09    !(*nft_set_ext_flags(ext) & NFT_SET_ELEM_INTERVAL_END))
+=09=09return;
+
+=09e =3D pipapo_get(net, set, data, NFT_SET_ELEM_INTERVAL_END);
+=09if (IS_ERR(e))
+=09=09return;
+
+=09while ((rules_f0 =3D pipapo_rules_same_key(m->f, first_rule))) {
+=09=09union nft_pipapo_map_bucket rulemap[NFT_PIPAPO_MAX_FIELDS];
+=09=09const u8 *match_start, *match_end;
+=09=09struct nft_pipapo_field *f;
+=09=09int i, start, rules_fx;
+
+=09=09match_start =3D (const u8 *)nft_set_ext_key(&e->start->ext);
+=09=09match_end =3D data;
+
+=09=09start =3D first_rule;
+=09=09rules_fx =3D rules_f0;
+
+=09=09nft_pipapo_for_each_field(f, i, m) {
+=09=09=09if (!pipapo_match_field(f, start, rules_fx,
+=09=09=09=09=09=09match_start, match_end))
+=09=09=09=09break;
+
+=09=09=09rulemap[i].to =3D start;
+=09=09=09rulemap[i].n =3D rules_fx;
+
+=09=09=09rules_fx =3D f->mt[start].n;
+=09=09=09start =3D f->mt[start].to;
+
+=09=09=09match_start +=3D NFT_PIPAPO_GROUPS_PADDED_SIZE(f->groups);
+=09=09=09match_end +=3D NFT_PIPAPO_GROUPS_PADDED_SIZE(f->groups);
+=09=09}
+
+=09=09if (i =3D=3D m->field_count) {
+=09=09=09priv->dirty =3D true;
+=09=09=09pipapo_drop(m, rulemap);
+=09=09=09pipapo_commit(set);
+=09=09=09return;
+=09=09}
+
+=09=09first_rule +=3D rules_f0;
+=09}
+}
+
+/**
+ * nft_pipapo_walk() - Walk over elements
+ * @ctx:=09nftables API context
+ * @set:=09nftables API set representation
+ * @iter:=09Iterator
+ *
+ * As elements are referenced in the mapping array for the last field, dir=
ectly
+ * scan that array: there's no need to follow rule mappings from the first
+ * field.
+ *
+ * Note that we'll return two elements for each call, as each entry is
+ * represented as start and end elements.
+ */
+static void nft_pipapo_walk(const struct nft_ctx *ctx, struct nft_set *set=
,
+=09=09=09    struct nft_set_iter *iter)
+{
+=09struct nft_pipapo *priv =3D nft_set_priv(set);
+=09struct nft_pipapo_match *m;
+=09struct nft_pipapo_field *f;
+=09int i, r;
+
+=09rcu_read_lock();
+=09m =3D rcu_dereference(priv->match);
+
+=09if (unlikely(!m))
+=09=09goto out;
+
+=09for (i =3D 0, f =3D m->f; i < m->field_count - 1; i++, f++)
+=09=09;
+
+=09for (r =3D 0; r < f->rules; r++) {
+=09=09struct nft_set_elem elem_start, elem_end;
+=09=09struct nft_pipapo_elem *e;
+
+=09=09if (r < f->rules - 1 && f->mt[r + 1].e =3D=3D f->mt[r].e)
+=09=09=09continue;
+
+=09=09if (iter->count < iter->skip)
+=09=09=09goto cont;
+
+=09=09e =3D f->mt[r].e;
+=09=09if (nft_set_elem_expired(&e->ext))
+=09=09=09goto cont;
+
+=09=09elem_start.priv =3D e->start;
+
+=09=09iter->err =3D iter->fn(ctx, set, iter, &elem_start);
+=09=09if (iter->err < 0)
+=09=09=09goto out;
+
+=09=09elem_end.priv =3D e;
+
+=09=09iter->err =3D iter->fn(ctx, set, iter, &elem_end);
+=09=09if (iter->err < 0)
+=09=09=09goto out;
+
+cont:
+=09=09iter->count +=3D 2;
+=09}
+
+out:
+=09rcu_read_unlock();
+}
+
+/**
+ * nft_pipapo_privsize() - Return the size of private data for the set
+ * @nla:=09netlink attributes, ignored as size doesn't depend on them
+ * @desc:=09Set description, ignored as size doesn't depend on it
+ *
+ * Return: size of private data for this set implementation, in bytes
+ */
+static u64 nft_pipapo_privsize(const struct nlattr * const nla[],
+=09=09=09       const struct nft_set_desc *desc)
+{
+=09return sizeof(struct nft_pipapo);
+}
+
+/**
+ * nft_pipapo_estimate() - Estimate set size, space and lookup complexity
+ * @desc:=09Set description, initial element count used here
+ * @features:=09Flags: NFT_SET_SUBKEY needs to be there
+ * @est:=09Storage for estimation data
+ *
+ * The size for this set type can vary dramatically, as it depends on the =
number
+ * of rules (composing netmasks) the entries expand to. We compute the wor=
st
+ * case here, in order to ensure that other types are used if concatenatio=
n of
+ * ranges is not needed.
+ *
+ * In general, for a non-ranged entry or a single composing netmask, we ne=
ed
+ * one bit in each of the sixteen NFT_PIPAPO_BUCKETS, for each 4-bit group=
 (that
+ * is, each input bit needs four bits of matching data), plus a bucket in =
the
+ * mapping table for each field.
+ *
+ * Return: true
+ */
+static bool nft_pipapo_estimate(const struct nft_set_desc *desc, u32 featu=
res,
+=09=09=09=09struct nft_set_estimate *est)
+{
+=09if (!(features & NFT_SET_SUBKEY))
+=09=09return false;
+
+=09est->size =3D sizeof(struct nft_pipapo) + sizeof(struct nft_pipapo_matc=
h);
+
+=09/* Worst-case with current amount of 32-bit VM registers (16 of them):
+=09 * - 2 IPv6 addresses=098 registers
+=09 * - 2 interface names=098 registers
+=09 * that is, four 128-bit fields:
+=09 */
+=09est->size +=3D sizeof(struct nft_pipapo_field) * 4;
+
+=09/* expanding to worst-case ranges, 128 * 2 rules each, resulting in:
+=09 * - 128 4-bit groups
+=09 * - each set entry taking 256 bits in each bucket
+=09 */
+=09est->size +=3D desc->size * NFT_PIPAPO_MAX_BITS / NFT_PIPAPO_GROUP_BITS=
 *
+=09=09     NFT_PIPAPO_BUCKETS * NFT_PIPAPO_MAX_BITS * 2 /
+=09=09     BITS_PER_BYTE;
+
+=09/* and we need mapping buckets, too */
+=09est->size +=3D desc->size * NFT_PIPAPO_MAP_NBITS *
+=09=09     sizeof(union nft_pipapo_map_bucket);
+
+=09est->lookup =3D NFT_SET_CLASS_O_LOG_N;
+
+=09est->space =3D NFT_SET_CLASS_O_N;
+
+=09return true;
+}
+
+/**
+ * nft_pipapo_init() - Initialise data for a set instance
+ * @set:=09nftables API set representation
+ * @desc:=09Set description
+ * @nla:=09netlink attributes
+ *
+ * Validate number and size of fields passed as NFTA_SET_SUBKEY netlink
+ * attributes, initialise internal set parameters, current instance of mat=
ching
+ * data and a copy for subsequent insertions.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+static int nft_pipapo_init(const struct nft_set *set,
+=09=09=09   const struct nft_set_desc *desc,
+=09=09=09   const struct nlattr * const nla[])
+{
+=09struct nft_pipapo *priv =3D nft_set_priv(set);
+=09int rem, err =3D -EINVAL, field_count =3D 0, i;
+=09struct nft_pipapo_match *m;
+=09struct nft_pipapo_field *f;
+=09struct nlattr *attr;
+=09unsigned int klen;
+
+=09if (!nla || !nla[NFTA_SET_SUBKEY])
+=09=09return -EINVAL;
+
+=09nla_for_each_nested(attr, nla[NFTA_SET_SUBKEY], rem) {
+=09=09if (++field_count >=3D NFT_PIPAPO_MAX_FIELDS)
+=09=09=09return -EINVAL;
+
+=09=09if (nla_len(attr) !=3D sizeof(klen) ||
+=09=09    nla_type(attr) !=3D NFTA_SET_SUBKEY_LEN)
+=09=09=09return -EINVAL;
+=09}
+
+=09if (!field_count)
+=09=09return -EINVAL;
+
+=09m =3D kmalloc(sizeof(*priv->match) + sizeof(*f) * field_count,
+=09=09    GFP_KERNEL);
+=09if (!m)
+=09=09return -ENOMEM;
+
+=09m->field_count =3D field_count;
+=09m->bsize_max =3D 0;
+
+=09m->scratch =3D alloc_percpu(unsigned long *);
+=09if (!m->scratch) {
+=09=09err =3D -ENOMEM;
+=09=09goto out_free;
+=09}
+=09for_each_possible_cpu(i)
+=09=09*per_cpu_ptr(m->scratch, i) =3D NULL;
+
+=09rcu_head_init(&m->rcu);
+
+=09f =3D m->f;
+=09priv->width =3D 0;
+=09nla_for_each_nested(attr, nla[NFTA_SET_SUBKEY], rem) {
+=09=09klen =3D ntohl(nla_get_be32(attr));
+=09=09if (!klen || klen % NFT_PIPAPO_GROUP_BITS)
+=09=09=09goto out_free;
+
+=09=09if (klen > NFT_PIPAPO_MAX_BITS)
+=09=09=09goto out_free;
+
+=09=09priv->groups +=3D f->groups =3D klen / NFT_PIPAPO_GROUP_BITS;
+=09=09priv->width +=3D round_up(klen / BITS_PER_BYTE, sizeof(u32));
+
+=09=09f->bsize =3D 0;
+=09=09f->rules =3D 0;
+=09=09f->lt =3D NULL;
+=09=09f->mt =3D NULL;
+
+=09=09f++;
+=09}
+
+=09/* Create an initial clone of matching data for next insertion */
+=09priv->clone =3D pipapo_clone(m);
+=09if (IS_ERR(priv->clone)) {
+=09=09err =3D PTR_ERR(priv->clone);
+=09=09goto out_free;
+=09}
+
+=09priv->dirty =3D false;
+
+=09rcu_assign_pointer(priv->match, m);
+
+=09return 0;
+
+out_free:
+=09free_percpu(m->scratch);
+=09kfree(m);
+
+=09return err;
+}
+
+/**
+ * nft_pipapo_destroy() - Free private data for set and all committed elem=
ents
+ * @set:=09nftables API set representation
+ */
+static void nft_pipapo_destroy(const struct nft_set *set)
+{
+=09struct nft_pipapo *priv =3D nft_set_priv(set);
+=09struct nft_pipapo_match *m;
+=09struct nft_pipapo_field *f;
+=09int i, r, cpu;
+
+=09m =3D rcu_dereference_protected(priv->match, true);
+=09if (m) {
+=09=09rcu_barrier();
+
+=09=09for (i =3D 0, f =3D m->f; i < m->field_count - 1; i++, f++)
+=09=09=09;
+
+=09=09for (r =3D 0; r < f->rules; r++) {
+=09=09=09struct nft_pipapo_elem *e;
+
+=09=09=09if (r < f->rules - 1 && f->mt[r + 1].e =3D=3D f->mt[r].e)
+=09=09=09=09continue;
+
+=09=09=09e =3D f->mt[r].e;
+
+=09=09=09nft_set_elem_destroy(set, e->start, true);
+=09=09=09nft_set_elem_destroy(set, e, true);
+=09=09}
+
+=09=09for_each_possible_cpu(cpu)
+=09=09=09kfree(*per_cpu_ptr(m->scratch, cpu));
+=09=09free_percpu(m->scratch);
+
+=09=09pipapo_free_fields(m);
+=09=09kfree(m);
+=09=09priv->match =3D NULL;
+=09}
+
+=09if (priv->clone) {
+=09=09for_each_possible_cpu(cpu)
+=09=09=09kfree(*per_cpu_ptr(priv->clone->scratch, cpu));
+=09=09free_percpu(priv->clone->scratch);
+
+=09=09pipapo_free_fields(priv->clone);
+=09=09kfree(priv->clone);
+=09=09priv->clone =3D NULL;
+=09}
+}
+
+/**
+ * nft_pipapo_gc_init() - Initialise garbage collection
+ * @set:=09nftables API set representation
+ *
+ * Instead of actually setting up a periodic work for garbage collection, =
as
+ * this operation requires a swap of matching data with the working copy, =
we'll
+ * do that opportunistically with other commit operations if the interval =
is
+ * elapsed, so we just need to set the current jiffies timestamp here.
+ */
+static void nft_pipapo_gc_init(const struct nft_set *set)
+{
+=09struct nft_pipapo *priv =3D nft_set_priv(set);
+
+=09priv->last_gc =3D jiffies;
+}
+
+struct nft_set_type nft_set_pipapo_type __read_mostly =3D {
+=09.owner=09=09=3D THIS_MODULE,
+=09.features=09=3D NFT_SET_INTERVAL | NFT_SET_MAP | NFT_SET_OBJECT |
+=09=09=09  NFT_SET_TIMEOUT | NFT_SET_SUBKEY,
+=09.ops=09=09=3D {
+=09=09.lookup=09=09=3D nft_pipapo_lookup,
+=09=09.insert=09=09=3D nft_pipapo_insert,
+=09=09.activate=09=3D nft_pipapo_activate,
+=09=09.deactivate=09=3D nft_pipapo_deactivate,
+=09=09.flush=09=09=3D nft_pipapo_flush,
+=09=09.remove=09=09=3D nft_pipapo_remove,
+=09=09.walk=09=09=3D nft_pipapo_walk,
+=09=09.get=09=09=3D nft_pipapo_get,
+=09=09.privsize=09=3D nft_pipapo_privsize,
+=09=09.estimate=09=3D nft_pipapo_estimate,
+=09=09.init=09=09=3D nft_pipapo_init,
+=09=09.destroy=09=3D nft_pipapo_destroy,
+=09=09.gc_init=09=3D nft_pipapo_gc_init,
+=09=09.elemsize=09=3D offsetof(struct nft_pipapo_elem, ext),
+=09},
+};
--=20
2.20.1

