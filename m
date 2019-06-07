Return-Path: <SRS0=PuwI=UG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 950CBC04AB5
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Jun 2019 00:36:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69FD9206DF
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Jun 2019 00:36:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="AOxsa03C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbfFGAgU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Jun 2019 20:36:20 -0400
Received: from mx1.riseup.net ([198.252.153.129]:58360 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725784AbfFGAgT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jun 2019 20:36:19 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 163641A1CE1
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Jun 2019 17:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1559867779; bh=eqi3xlNq8QK5YhRjjsZaHXgc5kDSDjYGhExAWW4h69E=;
        h=From:To:Cc:Subject:Date:From;
        b=AOxsa03CoMp+yjaeESibXJcNohb6vlol7BlwyJdD5l3sAFdKPAq+iDVMfP9H5eSJE
         F5IN1fzr2IiAjaQIDfAqE08YCWF6Hv93HKYF/Yo4BfUA+9NyMQ5P+KBjSQ+uLUP1hW
         LEROZRjZlDyzfbg2DiMw3L9CTfjieMLupHxnCdBo=
X-Riseup-User-ID: 49D0FF1ADDC383287376F5184BE784856E714B2F06E46730424B00C19D7F743B
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 4C85D222229;
        Thu,  6 Jun 2019 17:36:18 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nf-next v4 0/3] Extract SYNPROXY infrastructure
Date:   Fri,  7 Jun 2019 02:36:00 +0200
Message-Id: <20190607003603.7758-1-ffmancera@riseup.net>
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
ipt_SYNPROXY           16384  1
nf_synproxy_core       24576  1 ipt_SYNPROXY
nf_conntrack          159744  5 xt_conntrack,xt_state,ipt_SYNPROXY,nf_synproxy_core,xt_CT
x_tables               49152  7 xt_conntrack,nft_compat,xt_state,xt_tcpudp,ipt_SYNPROXY,xt_CT,ip_tables

Only IPv6:
ip6t_SYNPROXY          16384  1
nf_synproxy_core       24576  1 ip6t_SYNPROXY
nf_conntrack          159744  4 ip6t_SYNPROXY,xt_conntrack,xt_state,nf_synproxy_core
x_tables               49152  6 ip6t_SYNPROXY,xt_conntrack,nft_compat,xt_state,xt_tcpudp,ip_tables

IPv4 and IPv6:
ip6t_SYNPROXY          16384  1
ipt_SYNPROXY           16384  1
nf_synproxy_core       24576  2 ip6t_SYNPROXY,ipt_SYNPROXY
nf_conntrack          159744  6 ip6t_SYNPROXY,xt_conntrack,xt_state,ipt_SYNPROXY,nf_synproxy_core,xt_CT
x_tables               49152  8 ip6t_SYNPROXY,xt_conntrack,nft_compat,xt_state,xt_tcpudp,ipt_SYNPROXY,xt_CT,ip_tables

v1: Initial patch
v2: Unify nf_synproxy_ipv4 and nf_synproxy_ipv6 into nf_synproxy
v3: Remove synproxy_cookie dependency
v4: Remove another synproxy_cookie, unify nf_synproxy into nf_synproxy_core so now we are using a single module. 

Fernando Fernandez Mancera (3):
  netfilter: synproxy: add common uapi for SYNPROXY infrastructure
  netfilter: synproxy: remove module dependency on IPv6 SYNPROXY
  netfilter: synproxy: extract SYNPROXY infrastructure from
    {ipt,ip6t}_SYNPROXY

 include/linux/netfilter_ipv6.h                |  36 +
 include/net/netfilter/nf_conntrack_synproxy.h |  13 +-
 include/net/netfilter/nf_synproxy.h           |  46 +
 include/uapi/linux/netfilter/nf_SYNPROXY.h    |  19 +
 include/uapi/linux/netfilter/xt_SYNPROXY.h    |  18 +-
 net/ipv4/netfilter/ipt_SYNPROXY.c             | 394 +-------
 net/ipv6/netfilter.c                          |   2 +
 net/ipv6/netfilter/ip6t_SYNPROXY.c            | 420 +-------
 net/netfilter/nf_synproxy_core.c              | 897 +++++++++++++++++-
 9 files changed, 987 insertions(+), 858 deletions(-)
 create mode 100644 include/net/netfilter/nf_synproxy.h
 create mode 100644 include/uapi/linux/netfilter/nf_SYNPROXY.h

-- 
2.20.1

