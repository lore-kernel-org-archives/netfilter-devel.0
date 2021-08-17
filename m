Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB8FAC432BE
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Aug 2021 08:40:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 929FC60FD7
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Aug 2021 08:40:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235110AbhHQIki (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Aug 2021 04:40:38 -0400
Received: from sender4-of-o55.zoho.com ([136.143.188.55]:21543 "EHLO
        sender4-of-o55.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235100AbhHQIki (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Aug 2021 04:40:38 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1629189594; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=ACru1f440Vnink7EuptiLLqrXkQMI1xw7wIk6BLDXygBEWsNhur4n5Xt4L0n4O1zXdG8oypkgjz8S0C17+3RUB8cje1R4kDZyAZqd+sbJPewcZBCHL/5/CoNhs2aUd/06gA6tnWE2gbXvonAncoMzjjMQrt1w1DuznjE04qaaW8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1629189594; h=Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=/TtfpIfwNJDNUYBQ+9Zixrn4v1jwg3J7exjZaSqRjzk=; 
        b=H7lyEG7AhtSz4L1LzLuRu6OkJqh16jFbW04xwgn/LxyryJa6u+bQE0JKzvwEp4fDUKkGkcjbvLPipBXxpNwYpiETzruGOqlpaVYTvQWyiOebE2aZvtGcMZx5YIrwOoZRl0wtf7jv56ygyxSVDmPgq0jxUYOkUVBsG/xhLs0SifU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=proelbtn.com;
        spf=pass  smtp.mailfrom=contact@proelbtn.com;
        dmarc=pass header.from=<contact@proelbtn.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1629189594;
        s=default; d=proelbtn.com; i=contact@proelbtn.com;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Transfer-Encoding;
        bh=/TtfpIfwNJDNUYBQ+9Zixrn4v1jwg3J7exjZaSqRjzk=;
        b=QTBk/9KnghDXXyqu+TjEzkzE6tmIbzlaj9Dr3Pv7U3CS6HJtAMgNVF5jmGIrecuv
        JKRBVIG1AtFJ9S9lQlUUQpfduM73/n8QeENquxqdmqeGxncCuQv5UVBaL4/Ia5PyCHk
        vMl34kJ/ODI7K2Jy34/6jNkMfZxuvIEZ1HdsmeNs=
Received: from kerneldev.prochi.io (softbank060108183144.bbtec.net [60.108.183.144]) by mx.zohomail.com
        with SMTPS id 1629189592811866.6146120767155; Tue, 17 Aug 2021 01:39:52 -0700 (PDT)
From:   Ryoga Saito <contact@proelbtn.com>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org, stefano.salsano@uniroma2.it,
        andrea.mayer@uniroma2.it, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        Ryoga Saito <contact@proelbtn.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v7 0/2] netfilter: add netfilter hooks to track SRv6-encapsulated flows
Date:   Tue, 17 Aug 2021 08:39:36 +0000
Message-Id: <20210817083938.15051-1-contact@proelbtn.com>
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

v7: fix some comments
v6: apply some code chunks suggested
v5: rename nf_conntrack_lwtunnel to nf_hooks_lwtunnel, fix link error
 when CONFIG_SYSCTL, add example code
v4: fix compile error when CONFIG_LWTUNNEL isn't enabled
v3: fix warning in nf_conntrack_lwtunnel.c
v2: introduce nf_ct_lwtunnel_enabled static_key and sysctl toggle to turn
    on lightweight tunnel netfilter hook

Reported-by: kernel test robot <lkp@intel.com>

Ryoga Saito (2):
  netfilter: add new sysctl toggle for lightweight tunnel netfilter
    hooks
  netfilter: add netfilter hooks to SRv6 data plane

 .../networking/nf_conntrack-sysctl.rst        |   7 ++
 include/net/lwtunnel.h                        |   3 +
 include/net/netfilter/nf_hooks_lwtunnel.h     |  15 +++
 net/core/lwtunnel.c                           |   3 +
 net/ipv6/seg6_iptunnel.c                      |  74 +++++++++++-
 net/ipv6/seg6_local.c                         | 110 ++++++++++++------
 net/netfilter/Makefile                        |   3 +
 net/netfilter/nf_conntrack_standalone.c       |  15 +++
 net/netfilter/nf_hooks_lwtunnel.c             |  66 +++++++++++
 9 files changed, 260 insertions(+), 36 deletions(-)
 create mode 100644 include/net/netfilter/nf_hooks_lwtunnel.h
 create mode 100644 net/netfilter/nf_hooks_lwtunnel.c

-- 
2.25.1

