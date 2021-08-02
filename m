Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30C3CC4338F
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Aug 2021 11:35:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07AD060FC1
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Aug 2021 11:35:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233401AbhHBLfJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Aug 2021 07:35:09 -0400
Received: from sender4-of-o55.zoho.com ([136.143.188.55]:21545 "EHLO
        sender4-of-o55.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233255AbhHBLfJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Aug 2021 07:35:09 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1627904089; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=mn84y5qrZXmLxKvPuqw026gt2ujfStS/PUdbnOLUGMpSNZIFYU72LalXpv0Xm8aUF/jFnP0lgRgaeZZgG5psS3qCm8haysTM2PBVrWGbNvZxst8c8wvWT92XCGnlXhsMrAR9HCjkZ3DImFUTVpqTRRF5yIb3+H2j4SEExVNtldw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1627904089; h=Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=3JbhOKXKke5adLspWfTx27bEtRMcEDWlApZV6pnwoAo=; 
        b=DtHcUg12aBs7w25DHB+79tKESkfMN7XfbNEq4xscYQW0l7SuhZwaWJyLAjtlEOja5wCKWmAoWcTFd4UZ5WhiMJaaAv4OKg7KUmrAfsZdCHiu+K720vL2Yt/2HhO3SEAzHtMaDgSFaH0aUzMPbnViKy0Yj6V4uKND6pvbqLbvMbo=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=proelbtn.com;
        spf=pass  smtp.mailfrom=contact@proelbtn.com;
        dmarc=pass header.from=<contact@proelbtn.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1627904089;
        s=default; d=proelbtn.com; i=contact@proelbtn.com;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Transfer-Encoding;
        bh=3JbhOKXKke5adLspWfTx27bEtRMcEDWlApZV6pnwoAo=;
        b=FDlNjqXwgO/DDEdvPsBOIyq46srJME8xCF381eAjxwGiLdyhzM59y3BBeLfIT2eR
        WMSW3o0FUM01NMnx2YYxirXeFbk/cma0ZdonZ9DzRmVa7+lxGrR/9gyWqFrDYSkvg4g
        pQ1N5GX0Cgas2vpHZcLNUGLgjNe2yjAyjuFjJ5Z4=
Received: from kerneldev.prochi.io (softbank060108183144.bbtec.net [60.108.183.144]) by mx.zohomail.com
        with SMTPS id 1627904082423181.9508807887762; Mon, 2 Aug 2021 04:34:42 -0700 (PDT)
From:   proelbtn <contact@proelbtn.com>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org, stefano.salsano@uniroma2.it,
        andrea.mayer@uniroma2.it, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        proelbtn <contact@proelbtn.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v4 0/2] netfilter: add netfilter hooks to track  SRv6-encapsulated flows
Date:   Mon,  2 Aug 2021 11:34:31 +0000
Message-Id: <20210802113433.6099-1-contact@proelbtn.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Tunneling protocols such as VXLAN or IPIP are implemented using virtual
network devices (vxlan0 or ipip0). Therefore, conntrack can record both
inner flows and outer flows correctly. In contrast, SRv6 is implemented
using lightweight tunnel infrastructure. Therefore, SRv6 packets are
encapsulated and decapsulated without passing through virtual network
device. Due to the following problems caused by this, conntrack can't
record both inner flows and outer flows correctly.

First problem is caused when SRv6 packets are encapsulated. In VXLAN, at
first, packets received are passed to nf_conntrack_in called from
ip_rcv/ipv6_rcv. These packets are sent to virtual network device and these
flows are confirmed in ip_output/ip6_output. However, in SRv6, at first,
packets are passed to nf_conntrack_in, encapsulated and flows are confirmed
in ipv6_output even if inner packets are IPv4. Therefore, IPv6 conntrack
needs to be enabled to track IPv4 inner flow.

Second problem is caused when SRv6 packets are decapsulated. If IPv6
conntrack is enabled, SRv6 packets are passed to nf_conntrack_in called
from ipv6_rcv. Even if inner packets are passed to nf_conntrack_in after
packets are decapsulated, flow aren't tracked because skb->_nfct is already
set. Therefore, IPv6 conntrack needs to be disabled to track IPv4 flow
when packets are decapsulated.

This patch series solves these problems and allows conntrack to record 
inner flows correctly. It introduces netfilter hooks to srv6 lwtunnel
and srv6local lwtunnel. It also introduces new sysctl toggle to turn on
lightweight tunnel netfilter hooks.

v4: fix compile error when CONFIG_LWTUNNEL isn't enabled
v3: fix warning in nf_conntrack_lwtunnel.c
v2: introduce nf_ct_lwtunnel_enabled static_key and sysctl toggle to turn
    on lightweight tunnel netfilter hooks

Reported-by: kernel test robot <lkp@intel.com>

proelbtn (2):
  netfilter: add new sysctl toggle for lightweight tunnel netfilter
    hooks
  netfilter: add netfilter hooks to SRv6 data plane

 .../networking/nf_conntrack-sysctl.rst        |   7 ++
 include/net/lwtunnel.h                        |   3 +
 include/net/netfilter/nf_conntrack_lwtunnel.h |  15 +++
 net/core/lwtunnel.c                           |   3 +
 net/ipv6/seg6_iptunnel.c                      |  68 ++++++++++-
 net/ipv6/seg6_local.c                         | 115 ++++++++++++------
 net/netfilter/Makefile                        |   3 +
 net/netfilter/nf_conntrack_lwtunnel.c         |  52 ++++++++
 net/netfilter/nf_conntrack_standalone.c       |  13 ++
 9 files changed, 237 insertions(+), 42 deletions(-)
 create mode 100644 include/net/netfilter/nf_conntrack_lwtunnel.h
 create mode 100644 net/netfilter/nf_conntrack_lwtunnel.c

-- 
2.25.1

