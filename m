Return-Path: <SRS0=J2Vc=4L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F08F9C35673
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Feb 2020 21:23:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C744C206E0
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Feb 2020 21:23:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YmUk/sTg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgBWVXe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 23 Feb 2020 16:23:34 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38066 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726740AbgBWVXe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Feb 2020 16:23:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582493013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zQCycQuOrwS8JLezYnjyYsHaCG6/FHPpO4Khu6PIzus=;
        b=YmUk/sTgpmszN3o/zzlmtngknh88x3Npr3lexyJKT4WEhTnp/+XQ1+5P7l7KYdUEdrQyS5
        ImPaEyDv8l+UykltmCOyH5zEd+Nb2JPgFKF/07jTYIHVM067vcuDFPNqprJl9FuplRyAVg
        zv/Rjnh8f7CkUFrRoqUJqJpyiCcWLuo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-JR1fDruuNAuiiknaiAOlgQ-1; Sun, 23 Feb 2020 16:23:31 -0500
X-MC-Unique: JR1fDruuNAuiiknaiAOlgQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90E2A477;
        Sun, 23 Feb 2020 21:23:28 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-200-29.brq.redhat.com [10.40.200.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7AD2A87B01;
        Sun, 23 Feb 2020 21:23:26 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 0/5] nft_set_pipapo: Performance improvements: Season 1
Date:   Sun, 23 Feb 2020 22:23:11 +0100
Message-Id: <cover.1582488826.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I'll still need some time to finish up the ARM NEON vectorised
implementation, so I thought I'd start posting patches introducing
support for 8-bit groups and the related adaptation of the
(previously posted) AVX2-based vectorised implementation.

Patches 1/5 and 2/5, as discussed with Pablo, introduce support and
switching mechanisms for 8-bit packet matching groups. I opted to
pick the fitting implementation with conditionals, instead of
replacing the set lookup operation on the fly, as this allows for
fields with different group sizes. The cost of these conditionals
actually appears negligible.

For the non-vectorised case, the two implementations are almost
identical and mostly remain as a single function, while, at least
for AVX2, operation sequences turned out to be fairly different, so
the new matching functions for 8-bit groups are all separated.

As a side note, I also tried out Pablo's suggestion to use the stack
for scratch maps, instead of per-CPU pre-allocated ones, if bucket
sizes are small enough. The outcome was rather surprising: it looks
cheaper, at least on x86_64, to access pre-allocated data compared
to initialise the room we need on the stack.

Patches 3/5 and 4/5 are similar to what I posted earlier, and they
are preparation work for vectorised implementations: we need to
support arbitrary requirements about data alignment and we also
need to share some helper functions.

Patch 5/5 implements the AVX2 lookup routines, now supporting 4-bit
and 8-bit as group sizes.

The matching rate figures below were obtained with the usual
kselftests cases, averaged over five runs, on a single thread of
an AMD Epyc 7402 CPU for x86_64 and on a single BCM2711 thread
(Raspberry Pi 4 Model B clocked at 2147MHz) for a comparison with
ARM 64-bit.

Note that I disabled retpolines (on x86_64) and SSBD (on aarch64),
so these matching rates can't be directly compared to figures I
shared previously -- hence the new baselines (also repeated in
single patch messages). For some reason, I'm getting more
repeatable numbers this way, and we're probably going to get rid
of a number of indirect calls in the future anyway. By hardcoding
calls to set lookup functions, I'm getting numbers rather close to
these baselines even with CONFIG_RETPOLINE set.

Also note, as it was the case earlier, that this is not a fair
comparison with hash and rbtree types, because hash types don't
support ranges and rbtree doesn't support multiple fields. Especially
matching on a single field is significantly faster than this. Some
minor adjustments are still needed to properly support matching on
less than two fields, though. Once they are implemented, we could
at least get a fair comparison with rbtree.

 ---------------.-----------------------------------.--------------------=
-----.
 AMD Epyc 7402  |          baselines, Mpps          |    this series, Mpp=
s    |
  1 thread      |___________________________________|____________________=
_____|
  3.35GHz       |        |        |        |        |            |       =
     |
  768KiB L1D$   | netdev |  hash  | rbtree |        |            |       =
     |
 ---------------|  hook  |   no   | single | pipapo |   pipapo   |   pipa=
po   |
 type   entries |  drop  | ranges | field  | 4 bits | bit switch |    AVX=
2    |
 ---------------|--------|--------|--------|--------|------------|-------=
-----|
 net,port       |        |        |        |        |            |       =
     |
          1000  |   19.0 |   10.4 |    3.8 |    2.8 | 4.0   +43% | 7.5  +=
168% |
 ---------------|--------|--------|--------|--------|------------|-------=
-----|
 port,net       |        |        |        |        |            |       =
     |
           100  |   18.8 |   10.3 |    5.8 |    5.5 | 6.3   +14% | 8.1   =
+47% |
 ---------------|--------|--------|--------|--------|------------|-------=
-----|
 net6,port      |        |        |        |        |            |       =
     |
          1000  |   16.4 |    7.6 |    1.8 |    1.3 | 2.1   +61% | 4.8  +=
269% |
 ---------------|--------|--------|--------|--------|------------|-------=
-----|
 port,proto     |        |        |        |        |     [1]    |       =
     |
         30000  |   19.6 |   11.6 |    3.9 |    0.3 | 0.5   +66% | 2.6  +=
766% |
 ---------------|--------|--------|--------|--------|------------|-------=
-----|
 net6,port,mac  |        |        |        |        |            |       =
     |
            10  |   16.5 |    5.4 |    4.3 |    2.6 | 3.4   +31% | 4.7   =
+81% |
 ---------------|--------|--------|--------|--------|------------|-------=
-----|
 net6,port,mac, |        |        |        |        |            |       =
     |
 proto    1000  |   16.5 |    5.7 |    1.9 |    1.0 | 1.4   +40% | 3.6  +=
260% |
 ---------------|--------|--------|--------|--------|------------|-------=
-----|
 net,mac        |        |        |        |        |            |       =
     |
          1000  |   19.0 |    8.4 |    3.9 |    1.7 | 2.5   +47% | 6.4  +=
276% |
 ---------------'--------'--------'--------'--------'------------'-------=
-----'
 [1] Causes switch of lookup table buckets for 'port' to 4-bit groups

 ---------------.-----------------------------------.------------.
 BCM2711        |          baselines, Mpps          | patch 2/5  |
  1 thread      |___________________________________|____________|
  2147MHz       |        |        |        |        |            |
  32KiB L1D$    | netdev |  hash  | rbtree |        |            |
 ---------------|  hook  |   no   | single | pipapo |   pipapo   |
 type   entries |  drop  | ranges | field  | 4 bits | bit switch |
 ---------------|--------|--------|--------|--------|------------|
 net,port       |        |        |        |        |            |
          1000  |   1.63 |   1.37 |   0.87 |   0.61 | 0.70  +17% |
 ---------------|--------|--------|--------|--------|------------|
 port,net       |        |        |        |        |            |
           100  |   1.64 |   1.36 |   1.02 |   0.78 | 0.81   +4% |
 ---------------|--------|--------|--------|--------|------------|
 net6,port      |        |        |        |        |            |
          1000  |   1.56 |   1.27 |   0.65 |   0.34 | 0.50  +47% |
 ---------------|--------|--------|--------|--------|------------|
 port,proto [1] |        |        |        |        |            |
         10000  |   1.68 |   1.43 |   0.84 |   0.30 | 0.40  +13% |
 ---------------|--------|--------|--------|--------|------------|
 net6,port,mac  |        |        |        |        |            |
            10  |   1.56 |   1.14 |   1.02 |   0.62 | 0.66   +6% |
 ---------------|--------|--------|--------|--------|------------|
 net6,port,mac, |        |        |        |        |            |
 proto    1000  |   1.56 |   1.12 |   0.64 |   0.27 | 0.40  +48% |
 ---------------|--------|--------|--------|--------|------------|
 net,mac        |        |        |        |        |            |
          1000  |   1.63 |   1.26 |   0.87 |   0.41 | 0.53  +29% |
 ---------------'--------'--------'--------'--------'------------'
 [1] Using 10000 entries instead of 30000 as it would take way too
     long for the test script to generate all of them


Stefano Brivio (5):
  nft_set_pipapo: Generalise group size for buckets
  nft_set_pipapo: Add support for 8-bit lookup groups and dynamic switch
  nft_set_pipapo: Prepare for vectorised implementation: alignment
  nft_set_pipapo: Prepare for vectorised implementation: helpers
  nft_set_pipapo: Introduce AVX2-based lookup implementation

 include/net/netfilter/nf_tables_core.h |    1 +
 net/netfilter/Makefile                 |    5 +
 net/netfilter/nf_tables_set_core.c     |    6 +
 net/netfilter/nft_set_pipapo.c         |  614 +++++++-----
 net/netfilter/nft_set_pipapo.h         |  277 ++++++
 net/netfilter/nft_set_pipapo_avx2.c    | 1222 ++++++++++++++++++++++++
 net/netfilter/nft_set_pipapo_avx2.h    |   14 +
 7 files changed, 1881 insertions(+), 258 deletions(-)
 create mode 100644 net/netfilter/nft_set_pipapo.h
 create mode 100644 net/netfilter/nft_set_pipapo_avx2.c
 create mode 100644 net/netfilter/nft_set_pipapo_avx2.h

--=20
2.25.0

