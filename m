Return-Path: <SRS0=fe67=44=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33AADC18E5A
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Mar 2020 11:59:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09172208E4
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Mar 2020 11:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729228AbgCKL7R (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Mar 2020 07:59:17 -0400
Received: from mailout2.hostsharing.net ([83.223.78.233]:58525 "EHLO
        mailout2.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728996AbgCKL7R (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Mar 2020 07:59:17 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by mailout2.hostsharing.net (Postfix) with ESMTPS id F0F3E101684AD;
        Wed, 11 Mar 2020 12:59:14 +0100 (CET)
Received: from localhost (unknown [87.130.102.138])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id AE0476005A67;
        Wed, 11 Mar 2020 12:59:14 +0100 (CET)
X-Mailbox-Line: From 14ab7e5af20124a34a50426fd570da7d3b0369ce Mon Sep 17 00:00:00 2001
Message-Id: <cover.1583927267.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Wed, 11 Mar 2020 12:59:00 +0100
Subject: [PATCH nf-next 0/3] Netfilter egress hook
To:     "Pablo Neira Ayuso" <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Martin Mares <mj@ucw.cz>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Thomas Graf <tgraf@suug.ch>,
        Alexei Starovoitov <ast@kernel.org>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Introduce a netfilter egress hook to complement the existing ingress hook.

User space support for nft will be submitted separately in a minute.

I'm re-submitting this as non-RFC per Pablo's request.  Compared to the
RFC, I've changed the order in patch [3/3] to perform netfilter first,
then tc (instead of the other way round).  The rationale is provided in
the commit message.  I've also extended the commit message with performance
measurements.

To reproduce the performance measurements in patch [3/3], you'll need
net-next commit 1e09e5818b3a ("pktgen: Allow on loopback device").

Link to the RFC version:
https://lore.kernel.org/netdev/cover.1572528496.git.lukas@wunner.de/

Thanks!

Lukas Wunner (3):
  netfilter: Rename ingress hook include file
  netfilter: Generalize ingress hook
  netfilter: Introduce egress hook

 include/linux/netdevice.h         |   4 ++
 include/linux/netfilter_ingress.h |  58 -----------------
 include/linux/netfilter_netdev.h  | 102 ++++++++++++++++++++++++++++++
 include/uapi/linux/netfilter.h    |   1 +
 net/core/dev.c                    |  27 ++++++--
 net/netfilter/Kconfig             |   8 +++
 net/netfilter/core.c              |  24 +++++--
 net/netfilter/nft_chain_filter.c  |   4 +-
 8 files changed, 160 insertions(+), 68 deletions(-)
 delete mode 100644 include/linux/netfilter_ingress.h
 create mode 100644 include/linux/netfilter_netdev.h

-- 
2.25.0

