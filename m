Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB3D2CDB465
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Oct 2023 19:19:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346407AbjJSTTq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Oct 2023 15:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345872AbjJSTTp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2023 15:19:45 -0400
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB7EE8
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 12:19:43 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id EC06ECC02C6;
        Thu, 19 Oct 2023 21:19:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:x-mailer:message-id:date:date
        :from:from:received:received:received; s=20151130; t=1697743178;
         x=1699557579; bh=qF1sKEHbc2pwfY3zK/XvuJxRjD8yqZSo9i1n+S+bNt0=; b=
        lvh0SswLbryTPmMweUtu6CXg9iCF31qqr18ctZUtfueoC5karu5vu5ExG3HgxCGP
        02xAe4Y4Fpe8b8F8CS4bbDmEoPhq9TYwRYLKZd9YkPRYfIRlKBZYGeVxHcN3kipr
        7FBL/Y5ypihgElYXYJ+YpAcsxe/kVFLmSbW8TPCC2Lc=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Thu, 19 Oct 2023 21:19:38 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 2F357CC02B7;
        Thu, 19 Oct 2023 21:19:37 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id D5B5D3431A9; Thu, 19 Oct 2023 21:19:37 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Linkui Xiao <xiaolinkui@kylinos.cn>
Subject: [PATCH 0/1] ipset patch to fix race condition between swap/destroy and add/del/test
Date:   Thu, 19 Oct 2023 21:19:36 +0200
Message-Id: <20231019191937.3931271-1-kadlec@netfilter.org>
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
  forcing destroy() to wait for the rcu_read_unlock() markers.

Thanks!
Jozsef

The following changes since commit 7153a404fb70d21097af3169354e1e5fda3fbb=
02:

  Merge tag 'nf-23-09-06' of https://git.kernel.org/pub/scm/linux/kernel/=
git/netfilter/nf (2023-09-07 11:47:15 +0200)

are available in the Git repository at:

  git://blackhole.kfki.hu/nf c063bd2737f588

for you to fetch changes up to c063bd2737f588859bc5f1455be9df6544e98ff2:

  netfilter: ipset: fix race condition between swap/destroy and kernel si=
de add/del/test (2023-10-19 21:06:09 +0200)

----------------------------------------------------------------
Jozsef Kadlecsik (1):
      netfilter: ipset: fix race condition between swap/destroy and kerne=
l side add/del/test

 net/netfilter/ipset/ip_set_core.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)
