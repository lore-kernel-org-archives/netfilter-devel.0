Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38A8EC3DA7C
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Dec 2022 12:34:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiL3Mej (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 30 Dec 2022 07:34:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiL3Meh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Dec 2022 07:34:37 -0500
X-Greylist: delayed 592 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 30 Dec 2022 04:34:35 PST
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B675582
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Dec 2022 04:34:34 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 50AC8CC00FD;
        Fri, 30 Dec 2022 13:24:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:x-mailer:message-id:date:date
        :from:from:received:received:received; s=20151130; t=1672403078;
         x=1674217479; bh=Ep3ZPC8KMp/vv7/8QBSU05t7E9MZRRYtw04bBHxu2d8=; b=
        n7oOOGBrEnz1IW3u2AFgMTd3r2KcNshaEFkSldR+zQxCAMRjxXJ9FqwG3rTynowo
        HUcqGtV8HHRzx3mMDb7uwUMBiEbLkO/PQ7+FQGJ3PQS0rErMtXBkSIMLyAR+F3vy
        u9dvUFgIcLEjPiq/6ccw95iEncA7srPx1x6W/jEsVOY=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Fri, 30 Dec 2022 13:24:38 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 52359CC00EA;
        Fri, 30 Dec 2022 13:24:38 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 4B722343156; Fri, 30 Dec 2022 13:24:38 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/2] ipset patches for nf
Date:   Fri, 30 Dec 2022 13:24:36 +0100
Message-Id: <20221230122438.1618153-1-kadlec@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

Please pull the next patches into your nf tree.

- The first patch fixes a hang when 0/0 subnets is added to a
  hash:net,port,net type of set. Except hash:net,port,net and
  hash:net,iface, the set types don't support 0/0 and the auxiliary
  functions rely on this fact. So 0/0 needs a special handling in
  hash:net,port,net which was missing (hash:net,iface was not affected
  by this bug).
- When adding/deleting large number of elements in one step in ipset,
  it can take a reasonable amount of time and can result in soft lockup
  errors. This patch is a complete rework of the previous version in orde=
r
  to use a smaller internal batch limit and at the same time removing
  the external hard limit to add arbitrary number of elements in one step=
.

Please note, while the second patch removes half of the first patch, the
remaining part of the first patch is still important.

Best regards,
Jozsef

The following changes since commit 123b99619cca94bdca0bf7bde9abe28f0a0dfe=
06:

  netfilter: nf_tables: honor set timeout and garbage collection updates =
(2022-12-22 10:36:37 +0100)

are available in the Git repository at:

  git://blackhole.kfki.hu/nf 82f6ab0989c5aa14e

for you to fetch changes up to 82f6ab0989c5aa14e89f2689f47f89589733f2b2:

  netfilter: ipset: Rework long task execution when adding/deleting entri=
es (2022-12-30 13:11:23 +0100)

----------------------------------------------------------------
Jozsef Kadlecsik (2):
      netfilter: ipset: fix hash:net,port,net hang with /0 subnet
      netfilter: ipset: Rework long task execution when adding/deleting e=
ntries

 include/linux/netfilter/ipset/ip_set.h       |  2 +-
 net/netfilter/ipset/ip_set_core.c            |  7 ++---
 net/netfilter/ipset/ip_set_hash_ip.c         | 14 +++++-----
 net/netfilter/ipset/ip_set_hash_ipmark.c     | 13 ++++-----
 net/netfilter/ipset/ip_set_hash_ipport.c     | 13 ++++-----
 net/netfilter/ipset/ip_set_hash_ipportip.c   | 13 ++++-----
 net/netfilter/ipset/ip_set_hash_ipportnet.c  | 13 +++++----
 net/netfilter/ipset/ip_set_hash_net.c        | 17 +++++-------
 net/netfilter/ipset/ip_set_hash_netiface.c   | 15 +++++------
 net/netfilter/ipset/ip_set_hash_netnet.c     | 23 +++++-----------
 net/netfilter/ipset/ip_set_hash_netport.c    | 19 +++++--------
 net/netfilter/ipset/ip_set_hash_netportnet.c | 40 +++++++++++++++-------=
------
 12 files changed, 89 insertions(+), 100 deletions(-)
