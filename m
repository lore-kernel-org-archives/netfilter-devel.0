Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC08CC4332F
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Nov 2022 19:31:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234366AbiKVTbC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Nov 2022 14:31:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234131AbiKVTbB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Nov 2022 14:31:01 -0500
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA07905AA
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Nov 2022 11:31:00 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 9840ECC02A6;
        Tue, 22 Nov 2022 20:30:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:x-mailer:message-id:date:date
        :from:from:received:received:received; s=20151130; t=1669145457;
         x=1670959858; bh=qDd90VKp9VUcGn133Q+hCEq3dTiX2SU0SqAsOpfRO/k=; b=
        dWz3uTizsp3D0jfxtoKV2QW22TT0nRyOg85p/48vBOLo5COcZnsF4+LeLQbO+tmZ
        9uT6F87RDFzlfIj/utF0GSL6q+/Tok2131eAbDbq6gicwoIcvq6jI9pbqcBBXi8R
        /smlwmrMGTFeAvN5enBSRAyILPbBpCdwpjkV4FDVxYs=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Tue, 22 Nov 2022 20:30:57 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id A39DDCC0101;
        Tue, 22 Nov 2022 20:30:57 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 9D4FE343157; Tue, 22 Nov 2022 20:30:57 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/1] ipset patch for the nf-next tree
Date:   Tue, 22 Nov 2022 20:30:56 +0100
Message-Id: <20221122193057.1052032-1-kadlec@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

Please apply the next patch to your nf-next tree, which introduces a new =
feature
in ipset:

- The patch adds the new "bitmask" parameter to the hash:ip, hash:ip,port=
 and
  hash:net,net types. While the existing "netmask" parameter accepts only=
 valid
  netmask values, "bitmask" takes any arbitrary IP address and makes poss=
ible
  to mask out arbitrary bits. Patch is from Vishwanath Pai.

Best regards,
Jozsef =20

The following changes since commit ab0377803dafc58f1e22296708c1c28e309414=
d6:

  mrp: introduce active flags to prevent UAF when applicant uninit (2022-=
11-18 12:14:55 +0000)

are available in the Git repository at:

  git://blackhole.kfki.hu/nf-next b16269331983edf64f

for you to fetch changes up to b16269331983edf64ff0c4a5286b900502a362a8:

  netfilter: ipset: Add support for new bitmask parameter (2022-11-22 20:=
21:11 +0100)

----------------------------------------------------------------
Vishwanath Pai (1):
      netfilter: ipset: Add support for new bitmask parameter

 include/linux/netfilter/ipset/ip_set.h      | 10 ++++
 include/uapi/linux/netfilter/ipset/ip_set.h |  2 +
 net/netfilter/ipset/ip_set_hash_gen.h       | 71 +++++++++++++++++++++++=
++----
 net/netfilter/ipset/ip_set_hash_ip.c        | 19 ++++----
 net/netfilter/ipset/ip_set_hash_ipport.c    | 24 +++++++++-
 net/netfilter/ipset/ip_set_hash_netnet.c    | 26 +++++++++--
 6 files changed, 126 insertions(+), 26 deletions(-)
