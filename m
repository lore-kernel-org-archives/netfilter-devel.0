Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52EA9C4332F
	for <netfilter-devel@archiver.kernel.org>; Sat,  4 Nov 2023 10:04:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbjKDKEC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 4 Nov 2023 06:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjKDKEC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 4 Nov 2023 06:04:02 -0400
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23695D45
        for <netfilter-devel@vger.kernel.org>; Sat,  4 Nov 2023 03:03:59 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 77523CC011C;
        Sat,  4 Nov 2023 11:03:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:x-mailer:message-id:date:date
        :from:from:received:received:received; s=20151130; t=1699092230;
         x=1700906631; bh=oAdCc3m5QKe9Aq1Cx/qd0UkjEOB+9CRLMg2oCu2LpjY=; b=
        f8GeaD+f8PDWefSc58byVwFg4903rJA7QAjij5EIw+XJdjheuXlvYUuxoR6dIn8k
        tzLqDrofTNpFzDFyRoVcil41NbLlIrJC5Fr9lTQnf4UtFhDCxDE/izKAPp8+LYX+
        HfsQqZ9b8j77zguYF9UbVST2zFGcZ7+q8CL1jAWYOJs=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Sat,  4 Nov 2023 11:03:50 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 293E0CC0114;
        Sat,  4 Nov 2023 11:03:49 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 72B4D3431A9; Sat,  4 Nov 2023 11:03:49 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Linkui Xiao <xiaolinkui@kylinos.cn>
Subject: [PATCH 0/1] ipset patch to fix race condition between swap/destroy and add/del/test, v2
Date:   Sat,  4 Nov 2023 11:03:48 +0100
Message-Id: <20231104100349.4184215-1-kadlec@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

Please apply the next patch to your nf tree, which fixes a race condition=
:

* Due to the insufficiently protected set pointers, there's a race betwee=
n a fast
  swap/destroy and a slow kernel side add/del/test element operation in i=
pset.
  The attached patch fixes it by extending the the rcu_read_lock() protec=
ted areas and
  forcing ip_set_swap() to wait for the rcu_read_unlock() markers.
  v2: synchronize_rcu() is moved into ip_set_swap() in order not to burde=
n
  ip_set_destroy() unnecessarily when all sets are destroyed.

Thanks!
Jozsef

The following changes since commit 7153a404fb70d21097af3169354e1e5fda3fbb=
02:

  Merge tag 'nf-23-09-06' of https://git.kernel.org/pub/scm/linux/kernel/=
git/netfilter/nf (2023-09-07 11:47:15 +0200)

are available in the Git repository at:

  git://blackhole.kfki.hu/nf 682a101165d8b640577ed

for you to fetch changes up to 682a101165d8b640577ede10ca2a803250e48ba8:

  netfilter: ipset: fix race condition between swap/destroy and kernel si=
de add/del/test, v2 (2023-11-04 10:58:49 +0100)

----------------------------------------------------------------
Jozsef Kadlecsik (1):
      netfilter: ipset: fix race condition between swap/destroy and kerne=
l side add/del/test, v2

 net/netfilter/ipset/ip_set_core.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)
