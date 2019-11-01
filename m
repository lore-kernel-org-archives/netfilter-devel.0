Return-Path: <SRS0=Gx1r=YZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA01ECA9ECF
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Nov 2019 16:35:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7462321734
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Nov 2019 16:35:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="KSoc+eUY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbfKAQf7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Nov 2019 12:35:59 -0400
Received: from smtp-out.kfki.hu ([148.6.0.48]:45021 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727148AbfKAQf7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Nov 2019 12:35:59 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 2D05ECC0130;
        Fri,  1 Nov 2019 17:35:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:x-mailer:message-id:date:date
        :from:from:received:received:received; s=20151130; t=1572626155;
         x=1574440556; bh=O3seKCXPcBMnp5DoAja7P8amGhooel20ub3sZesmAyo=; b=
        KSoc+eUYfTti0sF6gPDU88z4dbClSjG8vLoQdaRvkwQW14gu5Hga6d+MrJbohFmU
        mIkzNy7r7aMJOXDNPhTkQpvJg9Ur3cPaMTMdNzwCCz0Jg9blJluHIlV3LudwNqa+
        0IWevYN6yUTIusWWJ+u8tii7mLBluGhWk0ymNzTKkV8=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Fri,  1 Nov 2019 17:35:55 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 1F058CC0123;
        Fri,  1 Nov 2019 17:35:55 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 0781121A47; Fri,  1 Nov 2019 17:35:54 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/3] ipset patches for nf
Date:   Fri,  1 Nov 2019 17:35:51 +0100
Message-Id: <20191101163554.10561-1-kadlec@blackhole.kfki.hu>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

Please pull the next ipset patches for the nf tree:

- Fix the error code in ip_set_sockfn_get() when copy_to_user() is used,
  from Dan Carpenter.
- The IPv6 part was missed when fixing copying the right MAC address
  in the patch "netfilter: ipset: Copy the right MAC address in bitmap:ip=
,mac
  and hash:ip,mac sets", it is completed now by Stefano Brivio.
- ipset nla_policies are fixed to fully support NL_VALIDATE_STRICT and
  the code is converted from deprecated parsings to verified ones.

Best regards,
Jozsef

The following changes since commit 3da09663209d6732c74cb7b6d5890b8dea9cf6=
f3:

  Merge branch 'hv_netvsc-fix-error-handling-in-netvsc_attach-set_feature=
s' (2019-10-30 18:17:36 -0700)

are available in the Git repository at:

  it://blackhole.kfki.hu/nf e2eaf4585997c8576d

for you to fetch changes up to e2eaf4585997c8576d28b2028d7a937c9c710011:

  netfilter: ipset: Fix nla_policies to fully support NL_VALIDATE_STRICT =
(2019-11-01 17:13:18 +0100)

----------------------------------------------------------------
Dan Carpenter (1):
      netfilter: ipset: Fix an error code in ip_set_sockfn_get()

Jozsef Kadlecsik (1):
      netfilter: ipset: Fix nla_policies to fully support NL_VALIDATE_STR=
ICT

Stefano Brivio (1):
      netfilter: ipset: Copy the right MAC address in hash:ip,mac IPv6 se=
ts

 net/netfilter/ipset/ip_set_core.c        | 49 +++++++++++++++++++++-----=
------
 net/netfilter/ipset/ip_set_hash_ipmac.c  |  2 +-
 net/netfilter/ipset/ip_set_hash_net.c    |  1 +
 net/netfilter/ipset/ip_set_hash_netnet.c |  1 +
 4 files changed, 36 insertions(+), 17 deletions(-)
