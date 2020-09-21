Return-Path: <SRS0=tgdo=C6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18B0CC43465
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Sep 2020 13:35:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEF28207C3
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Sep 2020 13:35:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="FkDwgdFK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgIUNfu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Sep 2020 09:35:50 -0400
Received: from mx1.riseup.net ([198.252.153.129]:40544 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726592AbgIUNfu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Sep 2020 09:35:50 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4Bw4z10cx3zFfGr;
        Mon, 21 Sep 2020 06:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1600694941; bh=qjCdlzGrIaUvusIA0+w7OZ3tQyaxIAaLqVeOZ8W2U10=;
        h=From:To:Cc:Subject:Date:From;
        b=FkDwgdFKmCGTwr9lMF3/jrTEmtAujwM4GkA4cG1Owj6kg3QVCac2PZYlGj69Luo11
         UJ6XuoY6YPmDfkRACmyX/5M9H9k9w8sgAmH4D/ikcUiRkK5MuimtZi/r76QXSR1Yl3
         TqxWrjZEseDjz8SzeqyH8EZZIJ0WH8pyPVBuVvTg=
X-Riseup-User-ID: 0F6146EEEB138CAF6E3538AF0A0FEA2596A127AF10A01DDA3D395CA235C46339
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 4Bw4z01pPlzJnD0;
        Mon, 21 Sep 2020 06:28:59 -0700 (PDT)
From:   "Jose M. Guisado Gomez" <guigom@riseup.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH 0/3] add userdata and comment support for chains
Date:   Mon, 21 Sep 2020 15:28:20 +0200
Message-Id: <20200921132822.55231-1-guigom@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch series adds userdata storage for chains and also support
for comments when adding a chain.

Userdata can be extended for other purposes in the future.

nftables patch relies on already_set[1] function to check for possible
duplicates when specifying a comment.

[1] https://patchwork.ozlabs.org/project/netfilter-devel/patch/20200910164019.86192-1-guigom@riseup.net/


nf-next:

  netfilter: nf_tables: add userdata attributes to nft_chain

 include/net/netfilter/nf_tables.h        |  2 ++
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c            | 19 +++++++++++++++++++
 3 files changed, 23 insertions(+)

libnftnl:

  chain: add userdata and comment support

 include/libnftnl/chain.h            |  1 +
 include/libnftnl/udata.h            |  6 ++++++
 include/linux/netfilter/nf_tables.h |  2 ++
 src/chain.c                         | 31 +++++++++++++++++++++++++++++
 4 files changed, 40 insertions(+)

nftables:

  src: add comment support for chains

 include/rule.h                                |  1 +
 src/mnl.c                                     | 11 +++++++
 src/netlink.c                                 | 32 +++++++++++++++++++
 src/parser_bison.y                            |  8 +++++
 src/rule.c                                    |  3 ++
 .../testcases/optionals/comments_chain_0      | 12 +++++++
 .../optionals/dumps/comments_chain_0.nft      |  5 +++
 7 files changed, 72 insertions(+)
 create mode 100755 tests/shell/testcases/optionals/comments_chain_0
 create mode 100644 tests/shell/testcases/optionals/dumps/comments_chain_0.nft


-- 
2.27.0

