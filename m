Return-Path: <SRS0=/ozj=TY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68130C072B5
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 17:01:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AD53217F9
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 17:01:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="OEVAz83T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390733AbfEXRBA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 May 2019 13:01:00 -0400
Received: from mx1.riseup.net ([198.252.153.129]:41962 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390210AbfEXRBA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 May 2019 13:01:00 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 260061A4460
        for <netfilter-devel@vger.kernel.org>; Fri, 24 May 2019 10:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1558717260; bh=y9R26yRAdaB3T7To9nbViquaSynHaOyCRsl01rU8pUc=;
        h=From:To:Cc:Subject:Date:From;
        b=OEVAz83TIGV3xEEoxOFU5dSztCCJOjfJ2tiIXdo0Hp9EYP8ZCdnpYV5dZjq54FbC3
         ITeiqJI6LRVFMUYR6AL8IS9rZimLsH5+QUsP1NLJ//h5qGM5kWX/ViYBlwOonliWng
         h37bo6oIag2BGEzpgpgA86xXpIaevHNADV43TqjY=
X-Riseup-User-ID: FD854EF0ADC06D9049199094A2CBDF07C8604E24221658C069DE5343EB3FBAC6
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 4FF71223561;
        Fri, 24 May 2019 10:00:59 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nf-next v3 0/4] Extract SYNPROXY infrastructure
Date:   Fri, 24 May 2019 19:01:02 +0200
Message-Id: <20190524170106.2686-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The patch series have been tested by enabling iptables and ip6tables SYNPROXY.
All the modules loaded as expected.

$ lsmod | grep synproxy
Only IPv4:
nf_synproxy            20480  1 ipt_SYNPROXY
nf_synproxy_core       16384  2 ipt_SYNPROXY,nf_synproxy
nf_conntrack          159744  5 xt_conntrack,xt_state,ipt_SYNPROXY,nf_synproxy_core,nf_synproxy

Only IPv6:
nf_synproxy            20480  1 ip6t_SYNPROXY
nf_synproxy_core       16384  2 ip6t_SYNPROXY,nf_synproxy
nf_conntrack          159744  5 ip6t_SYNPROXY,xt_conntrack,xt_state,nf_synproxy_core,nf_synproxy

IPv4 and IPv6:
nf_synproxy            20480  2 ip6t_SYNPROXY,ipt_SYNPROXY
nf_synproxy_core       16384  3 ip6t_SYNPROXY,ipt_SYNPROXY,nf_synproxy
nf_conntrack          159744  6 ip6t_SYNPROXY,xt_conntrack,xt_state,ipt_SYNPROXY,nf_synproxy_core,nf_synproxy

v1: Initial patch
v2: Unify nf_synproxy_ipv4 and nf_synproxy_ipv6 into nf_synproxy
v3: Remove synproxy_cookie dependency

Fernando Fernandez Mancera (4):
  netfilter: synproxy: add common uapi for SYNPROXY infrastructure
  netfilter: synproxy: remove module dependency on IPv6 SYNPROXY
  netfilter: synproxy: extract SYNPROXY infrastructure from
    {ipt,ip6t}_SYNPROXY
  netfilter: add NF_SYNPROXY symbol

 include/linux/netfilter_ipv6.h             |  17 +
 include/net/netfilter/nf_synproxy.h        |  46 ++
 include/uapi/linux/netfilter/nf_SYNPROXY.h |  19 +
 include/uapi/linux/netfilter/xt_SYNPROXY.h |  18 +-
 net/ipv4/netfilter/Kconfig                 |   2 +-
 net/ipv4/netfilter/ipt_SYNPROXY.c          | 394 +---------
 net/ipv6/netfilter.c                       |   1 +
 net/ipv6/netfilter/Kconfig                 |   2 +-
 net/ipv6/netfilter/ip6t_SYNPROXY.c         | 420 +----------
 net/netfilter/Kconfig                      |   4 +
 net/netfilter/Makefile                     |   1 +
 net/netfilter/nf_synproxy.c                | 836 +++++++++++++++++++++
 12 files changed, 948 insertions(+), 812 deletions(-)
 create mode 100644 include/net/netfilter/nf_synproxy.h
 create mode 100644 include/uapi/linux/netfilter/nf_SYNPROXY.h
 create mode 100644 net/netfilter/nf_synproxy.c

-- 
2.20.1

