Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96329C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Oct 2021 15:16:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7596D60EE9
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Oct 2021 15:16:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234350AbhJKPSb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Oct 2021 11:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233712AbhJKPSa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Oct 2021 11:18:30 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A01E4C061570
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Oct 2021 08:16:30 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mZx2S-0001qH-Qh; Mon, 11 Oct 2021 17:16:28 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/4] netfilter: remove obsolete hook wrappers
Date:   Mon, 11 Oct 2021 17:15:09 +0200
Message-Id: <20211011151514.6580-1-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

An earlier series, starting with
commit a4aeafa28cf706f65f ("netfilter: xt_nat: pass table to hookfn"),
converted the x_tables table implementations to store the hook blob in
the ->priv pointer that gets passed to the hook function.

Before this, the blobs were stored in struct net, so each table
required its own wrapper to fetch the correct table blob.

Nowadays, allmost all hook functions in x_table land just call the hook
evaluation loop.

This series converts the table evaluation loop so it can be used directly,
then removes most of the wrappers.

Florian Westphal (4):
  netfilter: iptables: allow use of ipt_do_table as hookfn
  netfilter: arp_tables: allow use of arpt_do_table as hookfn
  netfilter: ip6tables: allow use of ip6t_do_table as hookfn
  netfilter: ebtables: allow use of ebt_do_table as hookfn

 include/linux/netfilter_arp/arp_tables.h  |  5 ++---
 include/linux/netfilter_bridge/ebtables.h |  5 ++---
 include/linux/netfilter_ipv4/ip_tables.h  |  6 +++---
 include/linux/netfilter_ipv6/ip6_tables.h |  5 ++---
 net/bridge/netfilter/ebtable_broute.c     |  2 +-
 net/bridge/netfilter/ebtable_filter.c     | 13 +++----------
 net/bridge/netfilter/ebtable_nat.c        | 12 +++---------
 net/bridge/netfilter/ebtables.c           |  6 +++---
 net/ipv4/netfilter/arp_tables.c           |  7 ++++---
 net/ipv4/netfilter/arptable_filter.c      | 10 +---------
 net/ipv4/netfilter/ip_tables.c            |  7 ++++---
 net/ipv4/netfilter/iptable_filter.c       |  9 +--------
 net/ipv4/netfilter/iptable_mangle.c       |  8 ++++----
 net/ipv4/netfilter/iptable_nat.c          | 15 ++++-----------
 net/ipv4/netfilter/iptable_raw.c          | 10 +---------
 net/ipv4/netfilter/iptable_security.c     |  9 +--------
 net/ipv6/netfilter/ip6_tables.c           |  6 +++---
 net/ipv6/netfilter/ip6table_filter.c      | 10 +---------
 net/ipv6/netfilter/ip6table_mangle.c      |  8 ++++----
 net/ipv6/netfilter/ip6table_nat.c         | 15 ++++-----------
 net/ipv6/netfilter/ip6table_raw.c         | 10 +---------
 net/ipv6/netfilter/ip6table_security.c    |  9 +--------
 22 files changed, 53 insertions(+), 134 deletions(-)

-- 
2.32.0

