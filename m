Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2912DC433FE
	for <netfilter-devel@archiver.kernel.org>; Sat, 12 Nov 2022 00:21:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233581AbiKLAVY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Nov 2022 19:21:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbiKLAVX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Nov 2022 19:21:23 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C24BC2D
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Nov 2022 16:21:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+NW48Qcf6ZvTelkqfkkSvEoT2dnWF/yUOLrYqLqfHPA=; b=IQTAtq/9GWaz9klfkte09l4pNL
        uFRM4CPP4Pjl54MiPPxZLoSUfQz5uaqsONAC/b2zOZBSz7aWmDsqwz31O6ocd+NMcoSEYxR+IKvu5
        sAwas8E7ogBWx2K/Zbl6SqYOSYkGaXQNVfYxec+oRWPin8bS6BeCL7RAmbASRNV2X/zowNXWrhkfy
        u8y3u0V5wS00a+IuCqFKcXZQVVUrQ9SddJnpViWYaalkjy35yMQq08BOHzT+P+RENWYbAbebqJ3Y+
        NGnIvqBMVRzrqnJU1B9/vD7lJYUtPcokLl9m1EnhK/qo4xfOiByM/bKOaOwXe+bQ4TNH3pbxwl0v8
        Jo1lp7NA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oteGv-00022x-BL
        for netfilter-devel@vger.kernel.org; Sat, 12 Nov 2022 01:21:21 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 0/7] De-duplicate code here and there
Date:   Sat, 12 Nov 2022 01:20:49 +0100
Message-Id: <20221112002056.31917-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A series of unrelated patches reducing code size in different ways:

Patch 1 is a typical "move function to xshared.c for common use", patch
2 eliminates some c'n'p programming in nft-shared.c, patch 3 merges
libipt_LOG.c and libip6t_LOG.c, patch 4 removes code from libebt_ip.c by
including the right header, patch 5 drops some local IP address parsers
in favor of the respective libxtables function and patches 6 and 7 move
duplicate definitions and code into a header shared by multiple
extensions.

Phil Sutter (7):
  xshared: Share make_delete_mask() between ip{,6}tables
  nft-shared: Introduce port_match_single_to_range()
  extensions: libip*t_LOG: Merge extensions
  extensions: libebt_ip: Include kernel header
  extensions: libebt_arp, libebt_ip: Use xtables_ipparse_any()
  extensions: Collate ICMP types/codes in libxt_icmp.h
  extensions: Unify ICMP parser into libxt_icmp.h

 extensions/libebt_arp.c                   |  89 +-------
 extensions/libebt_arp.t                   |   3 +
 extensions/libebt_ip.c                    | 262 ++--------------------
 extensions/libebt_ip6.c                   | 111 +--------
 extensions/libip6t_icmp6.c                |  97 +-------
 extensions/libipt_LOG.c                   | 250 ---------------------
 extensions/libipt_icmp.c                  | 110 +--------
 extensions/{libip6t_LOG.c => libxt_LOG.c} | 158 +++++--------
 extensions/libxt_icmp.h                   | 242 +++++++++++++++++++-
 include/linux/netfilter_bridge/ebt_ip.h   |  15 +-
 iptables/ip6tables.c                      |  38 +---
 iptables/iptables.c                       |  38 +---
 iptables/nft-shared.c                     | 130 +++--------
 iptables/xshared.c                        |  34 +++
 iptables/xshared.h                        |   4 +
 15 files changed, 409 insertions(+), 1172 deletions(-)
 delete mode 100644 extensions/libipt_LOG.c
 rename extensions/{libip6t_LOG.c => libxt_LOG.c} (52%)

-- 
2.38.0

