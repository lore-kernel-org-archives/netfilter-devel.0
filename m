Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB050C4338F
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Jul 2021 08:53:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B79D561059
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Jul 2021 08:53:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234916AbhG2IxX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 04:53:23 -0400
Received: from sender4-of-o55.zoho.com ([136.143.188.55]:21515 "EHLO
        sender4-of-o55.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234886AbhG2IxX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 04:53:23 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Jul 2021 04:53:23 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1627547886; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=KMu7Jfs+E2sDS3y9rLy+L0Q9LmSPZROWz6IwqX3tK5AxrRtUJnNgqs3IADoitPBqqhOgXrW8laEW/tnUYoHzNCqiIr5GWboXtQp0P3WxQ6i6lwIwkGIJxcpu954SdDRbxfCSoJ2EAkjXC8MmmVHGr2hB0sur6uGwepA7BhjKvFc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1627547886; h=Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=Lub84JBFG0rq3/oKqAHCgKIg2MR83n5PMj7m9KBBhlc=; 
        b=hQKsvnluA9MSC90Ca1ZgJhJ68S/ju8qO7b/yiHhhxzpoKJEb+neWRPkQCId+xvU4Xm1DU1Pqdki/wIvUEofqrkXZSSdr1aEQJ6GbKI4pag+2Z7p6kSOTt0RC1CGnzsuG447YRTW2ohYIUiysYTQE6l0yC12hYncpJ4B3jWXWL3k=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=proelbtn.com;
        spf=pass  smtp.mailfrom=contact@proelbtn.com;
        dmarc=pass header.from=<contact@proelbtn.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1627547886;
        s=default; d=proelbtn.com; i=contact@proelbtn.com;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Transfer-Encoding;
        bh=Lub84JBFG0rq3/oKqAHCgKIg2MR83n5PMj7m9KBBhlc=;
        b=Mc1sz1Y/LlED9zL07eUXOwn+ae1VIjwH7JWIq0rVZVY783ebBWjTNqp3N2yMC1Bd
        aiH3P4jlLicuc+cFPn3V4q+1bWMsbTRew5l+cWAeDb3bs8aJLPJndm7BiUq3epRKNRN
        xWEd0e6zZd1aBAF5Qp41U9ROITAAEC4CDpI1Qz9g=
Received: from srv6.prochi.io (softbank060108183144.bbtec.net [60.108.183.144]) by mx.zohomail.com
        with SMTPS id 1627547870389496.82354347456544; Thu, 29 Jul 2021 01:37:50 -0700 (PDT)
From:   Ryoga Saito <contact@proelbtn.com>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org, stefano.salsano@uniroma2.it,
        andrea.mayer@uniroma2.it, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        Ryoga Saito <contact@proelbtn.com>
Subject: [PATCH v2 0/2] net: add netfilter hooks to track SRv6-encapsulated flows
Date:   Thu, 29 Jul 2021 08:37:11 +0000
Message-Id: <cover.1627546390.git.contact@proelbtn.com>
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

v2: introduce nf_ct_lwtunnel_enabled static_key and sysctl toggle to turn
    on lightweight tunnel netfilter hooks

Ryoga Saito (2):
  netfilter: add new sysctl toggle for lightweight tunnel netfilter
    hooks
  netfilter: add netfilter hooks to SRv6 data plane

 .../networking/nf_conntrack-sysctl.rst        |   7 ++
 include/net/lwtunnel.h                        |   2 +
 include/net/netfilter/nf_conntrack.h          |   4 +
 net/core/lwtunnel.c                           |   3 +
 net/ipv6/seg6_iptunnel.c                      |  68 ++++++++++-
 net/ipv6/seg6_local.c                         | 115 ++++++++++++------
 net/netfilter/Makefile                        |   2 +-
 net/netfilter/nf_conntrack_lwtunnel.c         |  51 ++++++++
 net/netfilter/nf_conntrack_standalone.c       |   8 ++
 9 files changed, 217 insertions(+), 43 deletions(-)
 create mode 100644 net/netfilter/nf_conntrack_lwtunnel.c

-- 
2.25.1

