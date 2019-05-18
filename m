Return-Path: <SRS0=bWeD=TS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 302FEC04AAF
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 May 2019 18:22:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1B0820872
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 May 2019 18:21:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="Z3mCx/zc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729313AbfERSV7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 18 May 2019 14:21:59 -0400
Received: from mx1.riseup.net ([198.252.153.129]:59794 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727380AbfERSV7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 18 May 2019 14:21:59 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 91B981A33BF
        for <netfilter-devel@vger.kernel.org>; Sat, 18 May 2019 11:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1558203718; bh=PKxTd70XB3kh8xfguXscxm8uprzj5Z5kpi9OBeE9RZQ=;
        h=From:To:Cc:Subject:Date:From;
        b=Z3mCx/zcfIjxHyS7xoJcWnxHowZ6ARohiHIuBUQRHpbBTP74EaQb9ff4XaGHXTRQu
         SUwoSqTofJM6edRb6oiEwqgrrjW7iauf5wqQUEFEV/S+ScMKTEeNvIXFLa6aWlVr7v
         5fwQ6Wcfmaj+Smxdkemt/QX/2oST97vET5IAxmow=
X-Riseup-User-ID: 337B725E1CC40CF940EC03BA4040B12DBB7F8005FEE906DFE789D98514399C59
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id A7616120814;
        Sat, 18 May 2019 11:21:57 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH 0/5] Extract SYNPROXY infrastructure
Date:   Sat, 18 May 2019 20:21:46 +0200
Message-Id: <20190518182151.1231-1-ffmancera@riseup.net>
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
nf_synproxy_ipv4       16384  1 ipt_SYNPROXY
nf_synproxy_core       16384  4 ipt_SYNPROXY,nf_synproxy_ipv4
nf_conntrack          159744  8 xt_conntrack,xt_state,ipt_SYNPROXY,nf_synproxy_ipv4,nf_synproxy_core,xt_CT

Only IPv6:
nf_synproxy_ipv6       16384  1 ip6t_SYNPROXY
nf_synproxy_core       16384  4 ip6t_SYNPROXY,nf_synproxy_ipv6
nf_conntrack          159744  8 ip6t_SYNPROXY,xt_conntrack,xt_state,nf_synproxy_ipv6,nf_synproxy_core,xt_CT

IPv4 and IPv6:
nf_synproxy_ipv6       16384  1 ip6t_SYNPROXY
nf_synproxy_ipv4       16384  1 ipt_SYNPROXY
nf_synproxy_core       16384  4 ip6t_SYNPROXY,nf_synproxy_ipv6,ipt_SYNPROXY,nf_synproxy_ipv4
nf_conntrack          159744  8 ip6t_SYNPROXY,xt_conntrack,xt_state,nf_synproxy_ipv6,ipt_SYNPROXY,nf_synproxy_ipv4,nf_synproxy_core,xt_CT

Fernando Fernandez Mancera (5):
  netfilter: synproxy: add common uapi for SYNPROXY infrastructure
  netfilter: synproxy: extract IPv4 SYNPROXY infrastructure from
    ipt_SYNPROXY
  netfilter: add NF_SYNPROXY_IPV4 symbol
  netfilter: synproxy: extract IPv6 SYNPROXY infrastructure from
    ip6t_SYNPROXY
  netfilter: add NF_SYNPROXY_IPV6 symbol

 include/net/netfilter/ipv4/nf_synproxy_ipv4.h |  42 ++
 include/net/netfilter/ipv6/nf_synproxy_ipv6.h |  43 ++
 include/uapi/linux/netfilter/nf_SYNPROXY.h    |  19 +
 include/uapi/linux/netfilter/xt_SYNPROXY.h    |  18 +-
 net/ipv4/netfilter/Kconfig                    |   4 +
 net/ipv4/netfilter/Makefile                   |   3 +
 net/ipv4/netfilter/ipt_SYNPROXY.c             | 394 +---------------
 net/ipv4/netfilter/nf_synproxy_ipv4.c         | 393 ++++++++++++++++
 net/ipv6/netfilter/Kconfig                    |   4 +
 net/ipv6/netfilter/Makefile                   |   3 +
 net/ipv6/netfilter/ip6t_SYNPROXY.c            | 420 +-----------------
 net/ipv6/netfilter/nf_synproxy_ipv6.c         | 414 +++++++++++++++++
 12 files changed, 947 insertions(+), 810 deletions(-)
 create mode 100644 include/net/netfilter/ipv4/nf_synproxy_ipv4.h
 create mode 100644 include/net/netfilter/ipv6/nf_synproxy_ipv6.h
 create mode 100644 include/uapi/linux/netfilter/nf_SYNPROXY.h
 create mode 100644 net/ipv4/netfilter/nf_synproxy_ipv4.c
 create mode 100644 net/ipv6/netfilter/nf_synproxy_ipv6.c

-- 
2.20.1

