Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8DAAC4338F
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 10:35:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C724A60FA0
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 10:35:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236195AbhG0KfX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Jul 2021 06:35:23 -0400
Received: from smtp-out.kfki.hu ([148.6.0.48]:44739 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236104AbhG0KfU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Jul 2021 06:35:20 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id E6DE2CC010A;
        Tue, 27 Jul 2021 12:35:18 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Tue, 27 Jul 2021 12:35:16 +0200 (CEST)
Received: from ix.szhk.kfki.hu (wdc11.wdc.kfki.hu [148.6.200.11])
        (Authenticated sender: kadlecsik.jozsef@wigner.hu)
        by smtp2.kfki.hu (Postfix) with ESMTPSA id B6819CC0108;
        Tue, 27 Jul 2021 12:35:16 +0200 (CEST)
Received: by ix.szhk.kfki.hu (Postfix, from userid 1000)
        id 885EA180579; Tue, 27 Jul 2021 12:35:16 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by ix.szhk.kfki.hu (Postfix) with ESMTP id 83C0018050A;
        Tue, 27 Jul 2021 12:35:16 +0200 (CEST)
Date:   Tue, 27 Jul 2021 12:35:16 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [ANNOUNCE] ipset 7.13 released
Message-ID: <f5d9071-7558-17a-9cd1-6ac0922710@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I'm happy to announce ipset 7.13 - 7.12 was released but not announced due 
to additional fixes required in two patches.

Thanks to Pablo for the ipset to nftables translation infrastructure!

Userspace changes:
7.13
  - When parsing protocols by number, do not check it in /etc/protocols.
  - Add missing hunk to patch "Allow specifying protocols by number"

7.12
  - Allow specifying protocols by number (Haw Loeung)
  - Fix example in ipset.8 manpage discovered by Pablo Neira Ayuso.
  - tests: add tests ipset to nftables (Pablo Neira Ayuso)
  - add ipset to nftables translation infrastructure (Pablo Neira Ayuso)
  - lib: Detach restore routine from parser (Pablo Neira Ayuso)
  - lib: split parser from command execution (Pablo Neira Ayuso)
  - Fix patch "Parse port before trying by service name"

Kernel part changes:
7.13
  - Limit the maximal range of consecutive elements to add/delete fix

7.12
  - Limit the maximal range of consecutive elements to add/delete
  - Backport "netfilter: use nfnetlink_unicast()"
  - Backport "netfilter: nfnetlink: consolidate callback type"
  - Backport "netfilter: nfnetlink: add struct nfnl_info and
    pass it to callbacks"
  - Backport "netfilter: add helper function to set up the
    nfnetlink header and use it"

You can download the source code of ipset from:
        http://ipset.netfilter.org
        ftp://ftp.netfilter.org/pub/ipset/
        git://git.netfilter.org/ipset.git

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
