Return-Path: <SRS0=AyPt=3K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10109C2D0CE
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jan 2020 23:18:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6A8224653
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jan 2020 23:18:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gZVXrz8p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgAUXSN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Jan 2020 18:18:13 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:49832 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726407AbgAUXSN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Jan 2020 18:18:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579648691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=a8qDLdIn9zTn6qF5E7WgJBzjplPiNMUG1gn09uE0wj4=;
        b=gZVXrz8pH5TNAAegr6pUVNPqq+l3bl+OA5v+LOdwQfwhR9/GxLkQLZd1S5WA95vcmeN1mb
        PR1Dm38IlqYOJP/heOfAuquJrjPZeUyjFYkSMb4BubzLsTEVUVySwuMYhfArUdmOL+iCyG
        ff3c/sYqNbh3KaZ8YIEofZVxU04LRXE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-iN7YbKPsOsCb_UtqkVxWbA-1; Tue, 21 Jan 2020 18:18:05 -0500
X-MC-Unique: iN7YbKPsOsCb_UtqkVxWbA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58E17100550E;
        Tue, 21 Jan 2020 23:18:03 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-49.ams2.redhat.com [10.36.112.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F27D35C1BB;
        Tue, 21 Jan 2020 23:18:00 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH nf-next v4 0/9] nftables: Set implementation for arbitrary concatenation of ranges
Date:   Wed, 22 Jan 2020 00:17:50 +0100
Message-Id: <cover.1579647351.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

The fundamental idea, illustrated in deeper detail in patch 5/9, is to
use lookup tables classifying a small number of grouped bits from each
field, and map the lookup results in a way that yields a verdict for
the full set of specified fields.

The grouping bit aspect is loosely inspired by the Grouper algorithm,
by Jay Ligatti, Josh Kuhn, and Chris Gage (see patch 5/9 for the full
reference).

A reference, stand-alone implementation of the algorithm itself is
available at:
	https://pipapo.lameexcu.se

Some notes about possible future optimisations are also mentioned
there. This algorithm reduces the matching problem to, essentially,
a repetitive sequence of simple bitwise operations, and is
particularly suitable to be optimised by leveraging SIMD instruction
sets. An AVX2-based implementation is also presented in this series.

I plan to post the adaptation of the existing AVX2 vectorised
implementation for (at least) NEON at a later time.

Patches 1/9 to 3/9 implement the needed infrastructure: new
attributes are used to describe length of single ranged fields in
concatenations and to denote the upper bound for ranges.

Patch 4/9 adds a new bitmap operation that copies the source bitmap
onto the destination while removing a given region, and is needed to
delete regions of arrays mapping between lookup tables.

Patch 5/9 is the actual set implementation.

Patch 6/9 introduces selftests for the new implementation.

Patches 7/9 and 8/9 are preparatory work to add an alternative,
vectorised lookup implementation.

Patch 9/9 contains the AVX2-based implementation of the lookup
routines.

The nftables and libnftnl counterparts depend on changes to the UAPI
header file included in patches 2/9 and 3/9.

Credits go to Jay Ligatti, Josh Kuhn, and Chris Gage for their
original Grouper implementation and article from ICCCN proceedings
(see reference in patch 5/9), and to Daniel Lemire for his public
domain implementation of a fast iterator on set bits using built-in
implementations of the CTZL operation, also included in patch 5/9.

Special thanks go to Florian Westphal for all the nftables consulting
and the original interface idea, to Sabrina Dubroca for support with
RCU and bit manipulation topics, to Eric Garver for an early review,
to Phil Sutter for reaffirming the need for the use case covered
here, and to Pablo Neira Ayuso for proposing a dramatic
simplification of the infrastructure.

v4:
 - fix build for 32-bit architectures: 64-bit division needs div_u64()
   in 5/9 (kbuild test robot <lkp@intel.com>)
v3:
 - add patches 1/9 and 2/9
 - drop patch 5/8 (unrolled lookup loops), as it actually decreases
   matching rates in some cases
 - other changes listed in single patches
v2: Changes listed in messages for 3/8 and 8/8

Pablo Neira Ayuso (2):
  netfilter: nf_tables: add nft_setelem_parse_key()
  netfilter: nf_tables: add NFTA_SET_ELEM_KEY_END attribute

Stefano Brivio (7):
  netfilter: nf_tables: Support for sets with multiple ranged fields
  bitmap: Introduce bitmap_cut(): cut bits and shift remaining
  nf_tables: Add set type for arbitrary concatenation of ranges
  selftests: netfilter: Introduce tests for sets with range
    concatenation
  nft_set_pipapo: Prepare for vectorised implementation: alignment
  nft_set_pipapo: Prepare for vectorised implementation: helpers
  nft_set_pipapo: Introduce AVX2-based lookup implementation

 include/linux/bitmap.h                        |    4 +
 include/net/netfilter/nf_tables.h             |   22 +-
 include/net/netfilter/nf_tables_core.h        |    2 +
 include/uapi/linux/netfilter/nf_tables.h      |   17 +
 lib/bitmap.c                                  |   66 +
 net/netfilter/Makefile                        |    8 +-
 net/netfilter/nf_tables_api.c                 |  260 ++-
 net/netfilter/nf_tables_set_core.c            |    8 +
 net/netfilter/nft_dynset.c                    |    2 +-
 net/netfilter/nft_set_pipapo.c                | 2012 +++++++++++++++++
 net/netfilter/nft_set_pipapo.h                |  237 ++
 net/netfilter/nft_set_pipapo_avx2.c           |  842 +++++++
 net/netfilter/nft_set_pipapo_avx2.h           |   14 +
 net/netfilter/nft_set_rbtree.c                |    3 +
 tools/testing/selftests/netfilter/Makefile    |    3 +-
 .../selftests/netfilter/nft_concat_range.sh   | 1481 ++++++++++++
 16 files changed, 4911 insertions(+), 70 deletions(-)
 create mode 100644 net/netfilter/nft_set_pipapo.c
 create mode 100644 net/netfilter/nft_set_pipapo.h
 create mode 100644 net/netfilter/nft_set_pipapo_avx2.c
 create mode 100644 net/netfilter/nft_set_pipapo_avx2.h
 create mode 100755 tools/testing/selftests/netfilter/nft_concat_range.sh

--=20
2.24.1

