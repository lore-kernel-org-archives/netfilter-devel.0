Return-Path: <SRS0=B2LC=D5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDFB8C388F9
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Oct 2020 19:44:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75BE6207C4
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Oct 2020 19:44:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="EQP7F2bw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370375AbgJVTod (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Oct 2020 15:44:33 -0400
Received: from mx1.riseup.net ([198.252.153.129]:44132 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2508686AbgJVToc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Oct 2020 15:44:32 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4CHHr00qsTzFcs1;
        Thu, 22 Oct 2020 12:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1603395872; bh=PeKSMUebq81kRSE9Z3wXvFM/fUfzbaD65OZe1j9mYOQ=;
        h=From:To:Cc:Subject:Date:From;
        b=EQP7F2bwMCgilnG21M5xzlSNyRX5FX9ws660PKjwCGdJzEU4HHQao/7gMfAXNzcnl
         rwVgr3bONOUudEhRYdT/GQ5+lYNcu+VbRsKbBBr/uTa7CDC6xCbD8+8N2Ag1F8pdA1
         Kmp/AHe1AojYmTEXR6n2c9IkibkSHDn4MyWNuA0E=
X-Riseup-User-ID: 26A2AEFCF3AF9E445A540FBBB5EE922BD19B3B981627AE3E0062A7E936CF7B01
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 4CHHqz2P7Qz8sX6;
        Thu, 22 Oct 2020 12:44:31 -0700 (PDT)
From:   "Jose M. Guisado Gomez" <guigom@riseup.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH 0/5] add support for reject verdict in netdev
Date:   Thu, 22 Oct 2020 21:43:50 +0200
Message-Id: <20201022194355.1816-1-guigom@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch series comprises changes in kernel space and user space to
enable the reject verdict for the netdev family.

In addition, some code refactor has been made to the nft_reject
infrastructure in kernel, adding two new functions to create the icmp or
tcp reset skbuffs to avoid using ip_local_out. Also, reject init and
dump functions has been unified into nft_reject.c

This follows previous work from Laura García.

nf-next
-------

Jose M. Guisado Gomez (3):
  net: netfilter: add reject skbuff creation helpers
  net: netfilter: unify reject init and dump into nft_reject
  net: netfilter: add reject verdict support for netdev

 include/net/netfilter/ipv4/nf_reject.h   |  10 +
 include/net/netfilter/ipv6/nf_reject.h   |   9 +
 net/bridge/netfilter/Kconfig             |   2 +-
 net/bridge/netfilter/nft_reject_bridge.c | 255 +----------------------
 net/ipv4/netfilter/nf_reject_ipv4.c      | 122 +++++++++++
 net/ipv6/netfilter/nf_reject_ipv6.c      | 134 ++++++++++++
 net/netfilter/Kconfig                    |  10 +
 net/netfilter/Makefile                   |   1 +
 net/netfilter/nft_reject.c               |  12 +-
 net/netfilter/nft_reject_inet.c          |  60 +-----
 net/netfilter/nft_reject_netdev.c        | 189 +++++++++++++++++
 11 files changed, 495 insertions(+), 309 deletions(-)
 create mode 100644 net/netfilter/nft_reject_netdev.c


nftables
--------

Jose M. Guisado Gomez (2):
  evaluate: add netdev support for reject default
  tests: py: add netdev folder and reject.t icmp cases

 src/evaluate.c                   |  1 +
 tests/py/netdev/reject.t         | 20 +++++++++++
 tests/py/netdev/reject.t.payload | 60 ++++++++++++++++++++++++++++++++
 tests/py/nft-test.py             |  2 +-
 4 files changed, 82 insertions(+), 1 deletion(-)
 create mode 100644 tests/py/netdev/reject.t
 create mode 100644 tests/py/netdev/reject.t.payload

-- 
2.28.0

