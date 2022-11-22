Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18EBEC4332F
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Nov 2022 19:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234738AbiKVTZy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Nov 2022 14:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234426AbiKVTZx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Nov 2022 14:25:53 -0500
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 556128E28A
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Nov 2022 11:25:50 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id AB7E3CC02A8;
        Tue, 22 Nov 2022 20:19:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:x-mailer:message-id:date:date
        :from:from:received:received:received; s=20151130; t=1669144738;
         x=1670959139; bh=iINArx/eizoVN2Pcwdvu03wlngGBzzgZUd+yokg4jJs=; b=
        QEZMYnkbivrGBBvawSWXUEbaEx0yUUqTZ8dDiU6pUcpPqiPOCnqHWQwuo9wRHtla
        uDvnXjNBmlLDUzeeu865rimtAJLRkSyKXuDVwVXp4aVL7hZ2HOcp7Neyz1gUx4oj
        zf458DpGuOzgP9Oc5QnwBS6JI1gT2Tu2KPhGuMkevTA=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Tue, 22 Nov 2022 20:18:58 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id B1424CC02A0;
        Tue, 22 Nov 2022 20:18:58 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id AB629343157; Tue, 22 Nov 2022 20:18:58 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/1] ipset patch for the nf tree
Date:   Tue, 22 Nov 2022 20:18:57 +0100
Message-Id: <20221122191858.1051777-1-kadlec@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

Please apply the next one-liner patch to your nf tree. Thanks!

- The "netfilter: ipset: enforce documented limit to prevent allocating
  huge memory" patch contained a wrong condition which makes impossible t=
o
  add up to 64 clashing elements to a hash:net,iface type of set while it=
 is
  the documented feature of the set type. The patch fixes the condition a=
nd
  thus makes possible to add the elements while keeps preventing allocati=
ng
  huge memory.

Best regards,
Jozsef

The following changes since commit c7aa1a76d4a0a3c401025b60c401412bbb60f8=
c6:

  netfilter: ipset: regression in ip_set_hash_ip.c (2022-11-21 15:00:45 +=
0100)

are available in the Git repository at:

  git://blackhole.kfki.hu/nf 5e8cc0ff84d763559

for you to fetch changes up to 5e8cc0ff84d763559d34e3ddf5a1e645712ead54:

  netfilter: ipset: restore allowing 64 clashing elements in hash:net,ifa=
ce (2022-11-22 20:07:27 +0100)

----------------------------------------------------------------
Jozsef Kadlecsik (1):
      netfilter: ipset: restore allowing 64 clashing elements in hash:net=
,iface

 net/netfilter/ipset/ip_set_hash_gen.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
