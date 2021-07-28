Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14FC0C4338F
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Jul 2021 15:02:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F03DA60F9B
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Jul 2021 15:02:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236916AbhG1PCH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 11:02:07 -0400
Received: from smtp-out.kfki.hu ([148.6.0.48]:49599 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237046AbhG1PB3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 11:01:29 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 13981CC00F8;
        Wed, 28 Jul 2021 17:01:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:x-mailer:message-id:date:date
        :from:from:received:received:received; s=20151130; t=1627484475;
         x=1629298876; bh=QdOCoNKAne96engqwdFLIbEzItfWIzA0/zcOZHTHEKo=; b=
        OVl+07UizhFaPDpPecZKy+GHj3kA0x4X5UKpB3zoiXyNvjDAXqtXNHOGsfO3eH6N
        cgh+06Jnp+hBkSJrt679+9tMJ6nCTVC3YPIcLv+pYoRAY1VKgA17ogAB7b13lunC
        Yc14sVxh9oK6FQhw6q18ArvCucccL2jbFC5AdY01ONE=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Wed, 28 Jul 2021 17:01:15 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 214D5CC00F3;
        Wed, 28 Jul 2021 17:01:15 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 169A13412EC; Wed, 28 Jul 2021 17:01:15 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/1] ipset patch for the nf tree v2
Date:   Wed, 28 Jul 2021 17:01:14 +0200
Message-Id: <20210728150115.5107-1-kadlec@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

Please apply the next patch to the nf tree. Brad Spengler reported that
huge range of consecutive elements could result soft lockup errors due
to the long execution time. The patch limits and enforces the maximal siz=
e
of such ranges. Previous version did not take into account that 64bit
division isn't allowed on 32bit systems.

Best regards,
Jozsef

The following changes since commit 832df96d5f957d42fd9eb9660519a0c51fe853=
8e:

  Merge branch 'sctp-pmtu-probe' (2021-07-25 23:06:21 +0100)

are available in the Git repository at:

  git://blackhole.kfki.hu/nf eeae0a4c9f8992

for you to fetch changes up to eeae0a4c9f899291f6ec461efdc0f2f75791ea0b:

  netfilter: ipset: Limit the maximal range of consecutive elements to ad=
d/delete (2021-07-28 16:42:13 +0200)

----------------------------------------------------------------
Jozsef Kadlecsik (1):
      netfilter: ipset: Limit the maximal range of consecutive elements t=
o add/delete

 include/linux/netfilter/ipset/ip_set.h       |  3 +++
 net/netfilter/ipset/ip_set_hash_ip.c         |  9 ++++++++-
 net/netfilter/ipset/ip_set_hash_ipmark.c     | 10 +++++++++-
 net/netfilter/ipset/ip_set_hash_ipport.c     |  3 +++
 net/netfilter/ipset/ip_set_hash_ipportip.c   |  3 +++
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |  3 +++
 net/netfilter/ipset/ip_set_hash_net.c        | 11 ++++++++++-
 net/netfilter/ipset/ip_set_hash_netiface.c   | 10 +++++++++-
 net/netfilter/ipset/ip_set_hash_netnet.c     | 16 +++++++++++++++-
 net/netfilter/ipset/ip_set_hash_netport.c    | 11 ++++++++++-
 net/netfilter/ipset/ip_set_hash_netportnet.c | 16 +++++++++++++++-
 11 files changed, 88 insertions(+), 7 deletions(-)
