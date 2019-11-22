Return-Path: <SRS0=uBXc=ZO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1658C432C0
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Nov 2019 13:40:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 979D120707
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Nov 2019 13:40:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YUQEKG6j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbfKVNkR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Nov 2019 08:40:17 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:41437 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726633AbfKVNkR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Nov 2019 08:40:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574430016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=lLPRoC46alw99yP/vP90afIUlO6t3bOgXA7yIpu0lvE=;
        b=YUQEKG6jpYSA+pCe1Q/XgeQNQ1yiMQIliQc6IghU5WrbVzCgoe2eEZ+W3yV/obqGXNA1AU
        Qq4IXQS+zSKWPGVJvG5tleU1RIisz0ycwhDMtEEAkaddyGMsb75+keMYdQfQvo/Rq6rTIX
        kNv3t+D42UYxIs89kZKOJkqUR4QhS5g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-9sNZhzBEMPijokNMrvi5yw-1; Fri, 22 Nov 2019 08:40:12 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C683A801E58;
        Fri, 22 Nov 2019 13:40:10 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-24.ams2.redhat.com [10.36.112.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B5E9110375C4;
        Fri, 22 Nov 2019 13:40:08 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH nf-next v2 0/8] nftables: Set implementation for arbitrary concatenation of ranges
Date:   Fri, 22 Nov 2019 14:39:59 +0100
Message-Id: <cover.1574428269.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: 9sNZhzBEMPijokNMrvi5yw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Existing nftables set implementations allow matching entries with
interval expressions (rbtree), e.g. 192.0.2.1-192.0.2.4, entries
specifying field concatenation (hash, rhash), e.g. 192.0.2.1:22,
but not both.

In other words, none of the set types allows matching on range
expressions for more than one packet field at a time, such as ipset
does with types bitmap:ip,mac, and, to a more limited extent
(netmasks, not arbitrary ranges), with types hash:net,net,
hash:net,port, hash:ip,port,net, and hash:net,port,net.

As a pure hash-based approach is unsuitable for matching on ranges,
and "proxying" the existing red-black tree type looks impractical as
elements would need to be shared and managed across all employed
trees, this new set implementation intends to fill the functionality
gap by employing a relatively novel approach.

The fundamental idea, illustrated in deeper detail in patch 3/8, is to
use lookup tables classifying a small number of grouped bits from each
field, and map the lookup results in a way that yields a verdict for
the full set of specified fields.

The grouping bit aspect is loosely inspired by the Grouper algorithm,
by Jay Ligatti, Josh Kuhn, and Chris Gage (see patch 3/8 for the full
reference).

A reference, stand-alone implementation of the algorithm itself is
available at:
=09https://pipapo.lameexcu.se

Some notes about possible future optimisations are also mentioned
there. This algorithm reduces the matching problem to, essentially,
a repetitive sequence of simple bitwise operations, and is
particularly suitable to be optimised by leveraging SIMD instruction
sets. An AVX2-based implementation is also presented in this series.

I plan to post the adaptation of the existing AVX2 vectorised
implementation for (at least) NEON at a later time.

Patch 1/8 implements the needed UAPI bits: additions to the existing
interface are kept to a minimum by recycling existing concepts for
both ranging and concatenation, as suggested by Florian.

Patch 2/8 adds a new bitmap operation that copies the source bitmap
onto the destination while removing a given region, and is needed to
delete regions of arrays mapping between lookup tables.

Patch 3/8 is the actual set implementation.

Patch 4/8 introduces selftests for the new implementation.

Patch 5/8 provides an easy optimisation with substantial gain on
matching rates.

Patches 6/8 and 7/8 are preparatory work to add an alternative,
vectorised lookup implementation.

Patch 8/8 contains the AVX2-based implementation of the lookup
routines.

The nftables and libnftnl counterparts depend on changes to the UAPI
header file included in patch 1/8.

Credits go to Jay Ligatti, Josh Kuhn, and Chris Gage for their
original Grouper implementation and article from ICCCN proceedings
(see reference in patch 3/8), and to Daniel Lemire for his public
domain implementation of a fast iterator on set bits using built-in
implementations of the CTZL operation, also included in patch 3/8.

Special thanks go to Florian Westphal for all the nftables consulting
and the original interface idea, to Sabrina Dubroca for support with
RCU and bit manipulation topics, to Eric Garver for an early review,
and to Phil Sutter for reaffirming the need for the use case covered
here.

v2: changes listed in messages for 3/8 and 8/8

Stefano Brivio (8):
  netfilter: nf_tables: Support for subkeys, set with multiple ranged
    fields
  bitmap: Introduce bitmap_cut(): cut bits and shift remaining
  nf_tables: Add set type for arbitrary concatenation of ranges
  selftests: netfilter: Introduce tests for sets with range
    concatenation
  nft_set_pipapo: Provide unrolled lookup loops for common field sizes
  nft_set_pipapo: Prepare for vectorised implementation: alignment
  nft_set_pipapo: Prepare for vectorised implementation: helpers
  nft_set_pipapo: Introduce AVX2-based lookup implementation

 include/linux/bitmap.h                        |    4 +
 include/net/netfilter/nf_tables_core.h        |    2 +
 include/uapi/linux/netfilter/nf_tables.h      |   16 +
 lib/bitmap.c                                  |   66 +
 net/netfilter/Makefile                        |    6 +-
 net/netfilter/nf_tables_api.c                 |    4 +-
 net/netfilter/nf_tables_set_core.c            |    8 +
 net/netfilter/nft_set_pipapo.c                | 2165 +++++++++++++++++
 net/netfilter/nft_set_pipapo.h                |  236 ++
 net/netfilter/nft_set_pipapo_avx2.c           |  838 +++++++
 net/netfilter/nft_set_pipapo_avx2.h           |   14 +
 tools/testing/selftests/netfilter/Makefile    |    3 +-
 .../selftests/netfilter/nft_concat_range.sh   | 1481 +++++++++++
 13 files changed, 4839 insertions(+), 4 deletions(-)
 create mode 100644 net/netfilter/nft_set_pipapo.c
 create mode 100644 net/netfilter/nft_set_pipapo.h
 create mode 100644 net/netfilter/nft_set_pipapo_avx2.c
 create mode 100644 net/netfilter/nft_set_pipapo_avx2.h
 create mode 100755 tools/testing/selftests/netfilter/nft_concat_range.sh

--=20
2.20.1

