Return-Path: <SRS0=chdK=V2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3F5EC433FF
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Jul 2019 20:10:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71608205F4
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Jul 2019 20:10:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="eI1cwV0N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730451AbfG2UKv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 29 Jul 2019 16:10:51 -0400
Received: from smtp-out.kfki.hu ([148.6.0.45]:46809 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388044AbfG2Td7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Jul 2019 15:33:59 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id E8D7067400D9;
        Mon, 29 Jul 2019 21:33:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:x-mailer:message-id:date:date
        :from:from:received:received:received; s=20151130; t=1564428834;
         x=1566243235; bh=sd5tNlFa1w6cfClRlchaiZRGeeYY5qOAK1qmCvHsu2A=; b=
        eI1cwV0NQKENpACAAXn2hRfrqaeU0MW+ghPlD1oE2ZSZsmK9OMcviP77tKTvhlvw
        LUj5Rtloojzbie7aeHPSWF0V/7SfMH9bWY1c2S3OwZtMO67dJSbQseW5m7+KRX2w
        dPFEcPfft+si0UOyXMpcnEHYS8Ze8AwCgqZDO+HbBj4=
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Mon, 29 Jul 2019 21:33:54 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.240.2])
        by smtp0.kfki.hu (Postfix) with ESMTP id BD70C67400BD;
        Mon, 29 Jul 2019 21:33:54 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id A160A21B3B; Mon, 29 Jul 2019 21:33:54 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/3] ipset patches for the nf tree
Date:   Mon, 29 Jul 2019 21:33:51 +0200
Message-Id: <20190729193354.26559-1-kadlec@blackhole.kfki.hu>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

Please consider to apply the next patches to the nf tree:

- When the support of destination MAC addresses for hash:mac sets was
  introduced, it was forgotten to add the same functionality to hash:ip,m=
ac
  types of sets. The patch from Stefano Brivio adds the missing part.
- When the support of destination MAC addresses for hash:mac sets was
  introduced, a copy&paste error was made in the code of the hash:ip,mac
  and bitmap:ip,mac types: the MAC address in these set types is in
  the second position and not in the first one. Stefano Brivio's patch
  fixes the issue.
- There was still a not properly handled concurrency handling issue
  between renaming and listing sets at the same time, reported by
  Shijie Luo.

Best regards,
Jozsef

The following changes since commit 91826ba13855f73e252fef68369b3b0e1ed252=
53:

  netfilter: add include guard to xt_connlabel.h (2019-07-29 15:13:41 +02=
00)

are available in the Git repository at:

  git://blackhole.kfki.hu/nf 6c1f7e2c1b96ab9b

for you to fetch changes up to 6c1f7e2c1b96ab9b09ac97c4df2bd9dc327206f6:

  netfilter: ipset: Fix rename concurrency with listing (2019-07-29 21:18=
:07 +0200)

----------------------------------------------------------------
Jozsef Kadlecsik (1):
      netfilter: ipset: Fix rename concurrency with listing

Stefano Brivio (2):
      netfilter: ipset: Actually allow destination MAC address for hash:i=
p,mac sets too
      netfilter: ipset: Copy the right MAC address in bitmap:ip,mac and h=
ash:ip,mac sets

 net/netfilter/ipset/ip_set_bitmap_ipmac.c | 2 +-
 net/netfilter/ipset/ip_set_core.c         | 2 +-
 net/netfilter/ipset/ip_set_hash_ipmac.c   | 6 +-----
 3 files changed, 3 insertions(+), 7 deletions(-)
