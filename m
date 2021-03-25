Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06B6DC433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Mar 2021 17:26:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C64A061A16
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Mar 2021 17:26:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbhCYRZs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 13:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbhCYRZa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 13:25:30 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C02C06174A
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Mar 2021 10:25:29 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lPTja-0004q9-1V; Thu, 25 Mar 2021 18:25:26 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     phil@nwl.cc, Florian Westphal <fw@strlen.de>
Subject: [PATCH 0/8] netfilter: merge nf_log_proto modules
Date:   Thu, 25 Mar 2021 18:25:04 +0100
Message-Id: <20210325172512.17729-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Netfilter has multiple log modules:
 nf_log_arp
 nf_log_bridge
 nf_log_ipv4
 nf_log_ipv6
 nf_log_netdev
 nfnetlink_log
 nf_log_common

With the exception of nfnetlink_log (packet is sent to userspace for
dissection/logging) all of them log to the kernel ringbuffer.

This series merges all modules except nfnetlink_log into a single
module, nf_log_syslog.

After the series, only two log modules remain:
nfnetlink_log and nf_log_syslog. The latter provides the same
functionality as the old per-af log modules.

Last patch allows to move log backend module load
to nft_log to avoid a deadlock that can occur when request_module()
is called with the nft transaction mutex held.

Florian Westphal (8):
  netfilter: nf_log_ipv4: rename to nf_log_syslog
  netfilter: nf_log_arp: merge with nf_log_syslog
  netfilter: nf_log_ipv6: merge with nf_log_syslog
  netfilter: nf_log_netdev: merge with nf_log_syslog
  netfilter: nf_log_bridge: merge with nf_log_syslog
  netfilter: nf_log_common: merge with nf_log_syslog
  netfilter: nf_log: add module softdeps
  netfilter: nft_log: perform module load from nf_tables

 include/net/netfilter/nf_log.h       |   25 -
 include/net/netfilter/nf_tables.h    |    5 +
 net/bridge/netfilter/Kconfig         |    4 -
 net/bridge/netfilter/Makefile        |    3 -
 net/bridge/netfilter/nf_log_bridge.c |   79 --
 net/ipv4/netfilter/Kconfig           |   10 +-
 net/ipv4/netfilter/Makefile          |    4 -
 net/ipv4/netfilter/nf_log_arp.c      |  172 ----
 net/ipv4/netfilter/nf_log_ipv4.c     |  395 ----------
 net/ipv6/netfilter/Kconfig           |    5 +-
 net/ipv6/netfilter/Makefile          |    3 -
 net/ipv6/netfilter/nf_log_ipv6.c     |  427 ----------
 net/netfilter/Kconfig                |   20 +-
 net/netfilter/Makefile               |    6 +-
 net/netfilter/nf_log.c               |   10 -
 net/netfilter/nf_log_common.c        |  224 ------
 net/netfilter/nf_log_netdev.c        |   78 --
 net/netfilter/nf_log_syslog.c        | 1089 ++++++++++++++++++++++++++
 net/netfilter/nf_tables_api.c        |    5 +-
 net/netfilter/nft_log.c              |   20 +-
 net/netfilter/xt_LOG.c               |    1 +
 net/netfilter/xt_NFLOG.c             |    1 +
 net/netfilter/xt_TRACE.c             |    1 +
 23 files changed, 1144 insertions(+), 1443 deletions(-)
 delete mode 100644 net/bridge/netfilter/nf_log_bridge.c
 delete mode 100644 net/ipv4/netfilter/nf_log_arp.c
 delete mode 100644 net/ipv4/netfilter/nf_log_ipv4.c
 delete mode 100644 net/ipv6/netfilter/nf_log_ipv6.c
 delete mode 100644 net/netfilter/nf_log_common.c
 delete mode 100644 net/netfilter/nf_log_netdev.c
 create mode 100644 net/netfilter/nf_log_syslog.c

-- 
2.26.3

