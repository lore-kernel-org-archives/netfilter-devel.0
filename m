Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD732C4320A
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 11:22:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5253619E7
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 11:22:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236455AbhG0LWp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Jul 2021 07:22:45 -0400
Received: from smtp-out.kfki.hu ([148.6.0.48]:46465 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236446AbhG0LWo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Jul 2021 07:22:44 -0400
X-Greylist: delayed 316 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Jul 2021 07:22:44 EDT
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 4442ACC00FD;
        Tue, 27 Jul 2021 13:17:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:x-mailer:message-id:date:date
        :from:from:received:received:received; s=20151130; t=1627384645;
         x=1629199046; bh=0PizZSNgjI/X7nOPtGz9s4rfcHAdWp+gvLtgH6zSceo=; b=
        CZammEXJ4cikYtvYRn4A9F8xBprKx3t5VE+C1eiDyWoJbkVqp1NIdIjbbK5IIdD1
        rauasMtdV2nZPVKyKcZoSRYUc1H9ij/3SIwJmq0AvZGm/2hFXRVkNVm1jJJZ1RCt
        s5RWorIR1fxiajlvMJphb3/72cI9XsAnMF7FxEHYEjQ=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Tue, 27 Jul 2021 13:17:25 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 538CBCC00F4;
        Tue, 27 Jul 2021 13:17:25 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 48B073412EC; Tue, 27 Jul 2021 13:17:25 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/1] ipset patch for the nf tree
Date:   Tue, 27 Jul 2021 13:17:24 +0200
Message-Id: <20210727111725.14013-1-kadlec@netfilter.org>
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
of such ranges.

Best regards,
Jozsef

The following changes since commit 832df96d5f957d42fd9eb9660519a0c51fe853=
8e:

  Merge branch 'sctp-pmtu-probe' (2021-07-25 23:06:21 +0100)

are available in the Git repository at:

  git://blackhole.kfki.hu/nf 97b5fa905d232f300fd

for you to fetch changes up to 97b5fa905d232f300fd943c320932dd0523727ee:

  netfilter: ipset: Limit the maximal range of consecutive elements to ad=
d/delete (2021-07-27 12:59:38 +0200)

----------------------------------------------------------------
Jozsef Kadlecsik (1):
      netfilter: ipset: Limit the maximal range of consecutive elements t=
o add/delete

 include/linux/netfilter/ipset/ip_set.h       |  3 +++
 net/netfilter/ipset/ip_set_hash_ip.c         |  8 +++++++-
 net/netfilter/ipset/ip_set_hash_ipmark.c     | 10 +++++++++-
 net/netfilter/ipset/ip_set_hash_ipport.c     |  3 +++
 net/netfilter/ipset/ip_set_hash_ipportip.c   |  3 +++
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |  3 +++
 net/netfilter/ipset/ip_set_hash_net.c        | 11 ++++++++++-
 net/netfilter/ipset/ip_set_hash_netiface.c   | 10 +++++++++-
 net/netfilter/ipset/ip_set_hash_netnet.c     | 16 +++++++++++++++-
 net/netfilter/ipset/ip_set_hash_netport.c    | 11 ++++++++++-
 net/netfilter/ipset/ip_set_hash_netportnet.c | 16 +++++++++++++++-
 11 files changed, 87 insertions(+), 7 deletions(-)
