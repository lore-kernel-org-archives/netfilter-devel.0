Return-Path: <SRS0=8vd7=4K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D161C35666
	for <netfilter-devel@archiver.kernel.org>; Sat, 22 Feb 2020 11:30:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76730206EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 22 Feb 2020 11:30:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="jxRltRi2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbgBVLaK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 22 Feb 2020 06:30:10 -0500
Received: from smtp-out.kfki.hu ([148.6.0.45]:57439 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726763AbgBVLaK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 22 Feb 2020 06:30:10 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id CFCB3674010A;
        Sat, 22 Feb 2020 12:30:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:x-mailer:message-id:date:date
        :from:from:received:received:received; s=20151130; t=1582371005;
         x=1584185406; bh=lyxo71HyiQBUrDGn3qs7qaXdjwF5I91g+vZrDzWTFSw=; b=
        jxRltRi2i2Izypa0hUh/GpqQLSZfhXSewVwblIgK8ZsxvsWmgdAWQLdzC8sfHIhP
        nvlmQ98fD6DFufMNNFktgWw/EBlIgqj4YRAcYBR7e93++YzmRydbE0CQkoL/ZTP1
        1Dp0CRF1bddWHvGEAJ5q6RFryVEf2OdnpagPuJdYXrc=
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Sat, 22 Feb 2020 12:30:05 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp0.kfki.hu (Postfix) with ESMTP id BB09267400F8;
        Sat, 22 Feb 2020 12:30:05 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id A38F021B3B; Sat, 22 Feb 2020 12:30:05 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/2] ipset patches for nf
Date:   Sat, 22 Feb 2020 12:30:03 +0100
Message-Id: <20200222113005.5647-1-kadlec@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

Please consider to apply the next two patches to the nf tree. The first o=
ne
is larger than usual, but the issue could not be solved simpler. Also, it=
's
a resend of the patch I submitted a few days ago, with a one line fix on
top of that: the size of the comment extensions was not taken into accoun=
t
at reporting the full size of the set.

- Fix "INFO: rcu detected stall in hash_xxx" reports of syzbot
  by introducing region locking and using workqueue instead of timer base=
d
  gc of timed out entries in hash types of sets in ipset.
- Fix the forceadd evaluation path - the bug was also uncovered by the sy=
zbot.

Best regards,
Jozsef

The following changes since commit 83d0585f91da441a0b11bc5ff93f4cda56de67=
03:

  Merge branch 'Fix-reconnection-latency-caused-by-FIN-ACK-handling-race'=
 (2020-02-02 13:45:05 -0800)

are available in the Git repository at:

  git://blackhole.kfki.hu/nf 8af1c6fbd923987799

for you to fetch changes up to 8af1c6fbd9239877998c7f5a591cb2c88d41fb66:

  netfilter: ipset: Fix forceadd evaluation path (2020-02-22 12:13:45 +01=
00)

----------------------------------------------------------------
Jozsef Kadlecsik (2):
      netfilter: ipset: Fix "INFO: rcu detected stall in hash_xxx" report=
s
      netfilter: ipset: Fix forceadd evaluation path

 include/linux/netfilter/ipset/ip_set.h |  11 +-
 net/netfilter/ipset/ip_set_core.c      |  34 +-
 net/netfilter/ipset/ip_set_hash_gen.h  | 635 +++++++++++++++++++++++----=
------
 3 files changed, 474 insertions(+), 206 deletions(-)
