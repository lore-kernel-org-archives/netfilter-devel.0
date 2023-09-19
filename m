Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8877ACE79AA
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Sep 2023 18:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjISSO2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Sep 2023 14:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjISSO1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Sep 2023 14:14:27 -0400
X-Greylist: delayed 569 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 19 Sep 2023 11:14:20 PDT
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B5B9E
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Sep 2023 11:14:20 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 23597CC02B6;
        Tue, 19 Sep 2023 20:04:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:x-mailer:message-id:date:date
        :from:from:received:received:received; s=20151130; t=1695146686;
         x=1696961087; bh=88UGzT60fHUGtXGY/gbn1YdXEvw7DRMlSiY6eOt8x6M=; b=
        T8nJWkxjU06zhvoLXLaul6ahA1i8M01Ce/t33QhWwmG5mbltYLRtOkgzfXx0tCFr
        nduYl/FI1bWlXXO9vIkYLu7usGtf57D1L+/Htjtd+nlpGDPxNdkTEXkblWmNB4Vu
        d6BOrlwRMRxFKIQj/WfuxyNNEkxO2+E2Q4918jI9pRw=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Tue, 19 Sep 2023 20:04:46 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id DFA1ACC02B4;
        Tue, 19 Sep 2023 20:04:45 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id D8E6C3431A9; Tue, 19 Sep 2023 20:04:45 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Kyle Zeng <zengyhkyle@gmail.com>
Subject: [PATCH 0/1] ipset patch for nf tree 
Date:   Tue, 19 Sep 2023 20:04:44 +0200
Message-Id: <20230919180445.3384561-1-kadlec@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

Please apply the next patch against your nf tree so that it'll get=20
applied to older stable branches too.

- Kyle Zeng reported that there is a race between IPSET_CMD_ADD and IPSET=
_CMD_SWAP:
  when the schedule point was added to call_ad(), the wrong reference cou=
nter was
  used. For long taking operations initiated from userspace the ref_netli=
nk reference
  counter must be used to exclude concurrent clashing operations.

Best regards,
Jozsef

The following changes since commit 7153a404fb70d21097af3169354e1e5fda3fbb=
02:

  Merge tag 'nf-23-09-06' of https://git.kernel.org/pub/scm/linux/kernel/=
git/netfilter/nf (2023-09-07 11:47:15 +0200)

are available in the Git repository at:

  git://blackhole.kfki.hu/nf 5adf434ae86e34a0c

for you to fetch changes up to 5adf434ae86e34a0cff2fd0aa737dab16d7f4812:

  netfilter: ipset: Fix race between IPSET_CMD_CREATE and IPSET_CMD_SWAP =
(2023-09-19 12:34:45 +0200)

----------------------------------------------------------------
Jozsef Kadlecsik (1):
      netfilter: ipset: Fix race between IPSET_CMD_CREATE and IPSET_CMD_S=
WAP

 net/netfilter/ipset/ip_set_core.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)
