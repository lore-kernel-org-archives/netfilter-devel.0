Return-Path: <SRS0=kyt/=4Y=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DA6AC10F00
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Mar 2020 16:52:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA4AE20684
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Mar 2020 16:52:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YcayXVTR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgCGQwz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 7 Mar 2020 11:52:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33443 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726065AbgCGQwz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 7 Mar 2020 11:52:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583599974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7dnIWmWWgMar2nny6ZfqFMEsaup3/Gm+8EQBSdwMvyg=;
        b=YcayXVTRKeigy73rhgb0zMyYOKC0w34ainY/iWXKICySf97i9JamNS6HqwVbwllj6RzNxd
        4XotFkiyzK8DrgYpIVBiwcM5P1DmuDPmvgzRfXeaWG1dBxNH3JPZTX+xXmzYMm4bTPH9Di
        EVs8XTyUIwBB0S7NTvFRtv4RFLQTPIg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-EyyOlMyHPoi4Z0TSe-kMpQ-1; Sat, 07 Mar 2020 11:52:52 -0500
X-MC-Unique: EyyOlMyHPoi4Z0TSe-kMpQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1632C800D4E;
        Sat,  7 Mar 2020 16:52:51 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-200-16.brq.redhat.com [10.40.200.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 699186E3EE;
        Sat,  7 Mar 2020 16:52:49 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 0/6] nft_set_pipapo: Performance improvements: Season 1
Date:   Sat,  7 Mar 2020 17:52:31 +0100
Message-Id: <cover.1583598508.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Patches 1/6 and 2/6, as discussed with Pablo, introduce support and
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

Patches 3/6 and 4/6 are similar to what I posted earlier, and they
are preparation work for vectorised implementations: we need to
support arbitrary requirements about data alignment and we also
need to share some helper functions.

Patch 5/6 implements the AVX2 lookup routines, now supporting 4-bit
and 8-bit as group sizes.

Patch 6/6 adjusts the set implementations to also support sets with
a single, ranged field. This can be now conveniently enabled with a
define, and allows us to have a fair comparison with the rbtree set
back-end.

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
comparison with hash types, because hash types don't support ranges.

Matching rates for concatenated ranges:
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
 port,proto     |        |        |        |        |     [1]    |    [1]=
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
 BCM2711        |          baselines, Mpps          | patch 2/6  |
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

Matching rates for non-concatenated ranges (first field):
 ---------------.--------------------------.-------------------------.
 AMD Epyc 7402  |      baselines, Mpps     |   Mpps, % over rbtree   |
  1 thread      |__________________________|_________________________|
  3.35GHz       |        |        |        |            |            |
  768KiB L1D$   | netdev |  hash  | rbtree |            |   pipapo   |
 ---------------|  hook  |   no   | single |   pipapo   |single field|
 type   entries |  drop  | ranges | field  |single field|    AVX2    |
 ---------------|--------|--------|--------|------------|------------|
 net,port       |        |        |        |            |            |
          1000  |   19.0 |   10.4 |    3.8 | 6.0   +58% | 9.6  +153% |
 ---------------|--------|--------|--------|------------|------------|
 port,net       |        |        |        |            |            |
           100  |   18.8 |   10.3 |    5.8 | 9.1   +57% |11.6  +100% |
 ---------------|--------|--------|--------|------------|------------|
 net6,port      |        |        |        |            |            |
          1000  |   16.4 |    7.6 |    1.8 | 2.8   +55% | 6.5  +261% |
 ---------------|--------|--------|--------|------------|------------|
 port,proto     |        |        |        |     [1]    |    [1]     |
         30000  |   19.6 |   11.6 |    3.9 | 0.9   -77% | 2.7   -31% |
 ---------------|--------|--------|--------|------------|------------|
 port,proto     |        |        |        |            |            |
         10000  |   19.6 |   11.6 |    4.4 | 2.1   -52% | 5.6   +27% |
 ---------------|--------|--------|--------|------------|------------|
 port,proto     |        |        |        |            |            |
 4 threads 10000|   77.9 |   45.1 |   17.4 | 8.3   -52% |22.4   +29% |
 ---------------|--------|--------|--------|------------|------------|
 net6,port,mac  |        |        |        |            |            |
            10  |   16.5 |    5.4 |    4.3 | 4.5    +5% | 8.2   +91% |
 ---------------|--------|--------|--------|------------|------------|
 net6,port,mac, |        |        |        |            |            |
 proto    1000  |   16.5 |    5.7 |    1.9 | 2.8   +47% | 6.6  +247% |
 ---------------|--------|--------|--------|------------|------------|
 net,mac        |        |        |        |            |            |
          1000  |   19.0 |    8.4 |    3.9 | 6.0   +54% | 9.9  +154% |
 ---------------'--------'--------'--------'------------'------------'
 [1] Causes switch of lookup table buckets for 'port' to 4-bit groups


v2: Rebase, especially as series "netfilter: nf_tables: make sets
    built-in" was merged, add 6/6 as new patch and single-field
    comparison with rbtree.


Stefano Brivio (6):
  nft_set_pipapo: Generalise group size for buckets
  nft_set_pipapo: Add support for 8-bit lookup groups and dynamic switch
  nft_set_pipapo: Prepare for vectorised implementation: alignment
  nft_set_pipapo: Prepare for vectorised implementation: helpers
  nft_set_pipapo: Introduce AVX2-based lookup implementation
  nft_set_pipapo: Prepare for single ranged field usage

 include/net/netfilter/nf_tables_core.h |    1 +
 net/netfilter/Makefile                 |    6 +
 net/netfilter/nf_tables_api.c          |    3 +
 net/netfilter/nft_set_pipapo.c         |  630 +++++++-----
 net/netfilter/nft_set_pipapo.h         |  280 ++++++
 net/netfilter/nft_set_pipapo_avx2.c    | 1223 ++++++++++++++++++++++++
 net/netfilter/nft_set_pipapo_avx2.h    |   14 +
 7 files changed, 1893 insertions(+), 264 deletions(-)
 create mode 100644 net/netfilter/nft_set_pipapo.h
 create mode 100644 net/netfilter/nft_set_pipapo_avx2.c
 create mode 100644 net/netfilter/nft_set_pipapo_avx2.h

--=20
2.25.1

