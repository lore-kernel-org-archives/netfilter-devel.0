Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A018BC4338F
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Aug 2021 16:44:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 761C860EB9
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Aug 2021 16:44:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhHHQoV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 8 Aug 2021 12:44:21 -0400
Received: from sender4-of-o55.zoho.com ([136.143.188.55]:21518 "EHLO
        sender4-of-o55.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbhHHQoV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 8 Aug 2021 12:44:21 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1628441031; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=O93sfjlgVHlWFOZpNDNTQ2B7eg7MawW6hEbVyvQwVab5VajEdaK7PVnq+7fUZjr/oiU20768VbZr6vcIVl0mRN+D9+Ftu2vtf6GgLneCrt2TJ9Zh1YHKpyRXT6kZRlJ/PiPMjS8xHLDS5ofpPumGBUCZnt0gxuVd0U56Fy1kd24=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1628441031; h=Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=emfQ9I/A3WN/OvBkIGv5xoTu31dVFxLi4djrBXma4k8=; 
        b=bBR9i6FaTdGRi40Jhc9l6QgfGuB5WrLoJ/0rfLdwllR9mtPYIq0kA+lliUxpMxn6SeH8hzG/CHvHnhv9/JH7EtAkHzUUBuV4m80L1hG23tv2LY/VSoKr4/Gr1pB75XHB5GHtrXgaFJA90qTRRTml5eOuCo7uEUyPC5P1F5HQ2XQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=proelbtn.com;
        spf=pass  smtp.mailfrom=contact@proelbtn.com;
        dmarc=pass header.from=<contact@proelbtn.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1628441031;
        s=default; d=proelbtn.com; i=contact@proelbtn.com;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Transfer-Encoding;
        bh=emfQ9I/A3WN/OvBkIGv5xoTu31dVFxLi4djrBXma4k8=;
        b=jzp6evoJvyAChP6l55Guv8cn9oY/S1ZY31CuxMt0pFeNoRJ07TOayW5UEYYqiRKJ
        AA5ecYBgNorf4OTVHR5o45UCYStUTUqeQJZ9Xfby0G+UXRNM0+SSJMC3IQu04uSkb9t
        6E/SqJGtTpDVWiehbt3LLVEvts/XIVEZYaLkIaXA=
Received: from kerneldev.prochi.io (softbank060108183144.bbtec.net [60.108.183.144]) by mx.zohomail.com
        with SMTPS id 1628441029093976.9565183678375; Sun, 8 Aug 2021 09:43:49 -0700 (PDT)
From:   proelbtn <contact@proelbtn.com>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org, stefano.salsano@uniroma2.it,
        andrea.mayer@uniroma2.it, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        proelbtn <contact@proelbtn.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v5 0/2] netfilter: add netfilter hooks to track  SRv6-encapsulated flows
Date:   Sun,  8 Aug 2021 16:43:21 +0000
Message-Id: <20210808164323.498860-1-contact@proelbtn.com>
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
lightweight tunnel netfilter hooks. You can enable lwtunnel netfilter as
following:

  sysctl net.netfilter.nf_hooks_lwtunnel=1

v5: rename nf_conntrack_lwtunnel to nf_hooks_lwtunnel, fix link error
 when CONFIG_SYSCTL, add example code
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
 include/net/netfilter/nf_hooks_lwtunnel.h     |  15 +++
 net/core/lwtunnel.c                           |   3 +
 net/ipv6/seg6_iptunnel.c                      |  69 ++++++++++-
 net/ipv6/seg6_local.c                         | 116 ++++++++++++------
 net/netfilter/Makefile                        |   3 +
 net/netfilter/nf_conntrack_standalone.c       |  15 +++
 net/netfilter/nf_hooks_lwtunnel.c             |  66 ++++++++++
 9 files changed, 255 insertions(+), 42 deletions(-)
 create mode 100644 include/net/netfilter/nf_hooks_lwtunnel.h
 create mode 100644 net/netfilter/nf_hooks_lwtunnel.c

-- 
2.25.1

