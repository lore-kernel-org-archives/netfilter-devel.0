Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D554C433FE
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Oct 2022 21:47:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiJNVrf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Oct 2022 17:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbiJNVrJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Oct 2022 17:47:09 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B04CD1DDDFE
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Oct 2022 14:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ETkplRSZJztA/0s3BWoKxptSv4geRq+jhhmxptBTQrg=; b=fjyOjj9hB3loFQg4rqUdy7Tses
        Ryxbh4D7CaKd+xoWhim4KW9SG8ghudMRab3YN2hNRX70XEfiFyrzrMPVWoSf5TyTXpekYG6n4qU1s
        4jjsNvjnVvTZgFyUMN8TYbtkzNGGv/qhcljPmqo5/WayfugtwjFSUvO804qBW4fPWI9eyN+aa1TUn
        cpejsQi5OgHDVMNG6dwlwD2JTjJBNogCpIpMERGqN+1nx1LBzEENZ+MhkpVd48Kdti+0isoSxOTlf
        EZVsDutmkuKFBI1g7VEqrxrU5OcSfR2Oq6y2mTYGgX0pE/9qnFu0a65B5BowebCBM2KZwhGljlWuF
        jPJzJ1LQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1ojSVX-0000aI-MS; Fri, 14 Oct 2022 23:46:19 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH 0/2] Support resetting rules' state
Date:   Fri, 14 Oct 2022 23:45:57 +0200
Message-Id: <20221014214559.22254-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In order to "zero" a rule (in the 'iptables -Z' sense), users had to
dump (parts of) the ruleset in stateless form and restore it again after
removing the dumped parts.

Introduce a simpler method to reset any stateful elements of a rule or
all rules of a chain/table/family. Affects both counter and quota
expressions.

Phil Sutter (2):
  netfilter: nf_tables: Extend nft_expr_ops::dump callback parameters
  netfilter: nf_tables: Introduce NFT_MSG_GETRULE_RESET

 include/net/netfilter/nf_tables.h        |  5 ++-
 include/net/netfilter/nft_fib.h          |  2 +-
 include/net/netfilter/nft_meta.h         |  4 +-
 include/net/netfilter/nft_reject.h       |  3 +-
 include/uapi/linux/netfilter/nf_tables.h |  1 +
 net/ipv4/netfilter/nft_dup_ipv4.c        |  3 +-
 net/ipv6/netfilter/nft_dup_ipv6.c        |  3 +-
 net/netfilter/nf_tables_api.c            | 49 ++++++++++++++++--------
 net/netfilter/nft_bitwise.c              |  6 ++-
 net/netfilter/nft_byteorder.c            |  3 +-
 net/netfilter/nft_cmp.c                  |  9 +++--
 net/netfilter/nft_compat.c               |  9 +++--
 net/netfilter/nft_connlimit.c            |  3 +-
 net/netfilter/nft_counter.c              |  5 ++-
 net/netfilter/nft_ct.c                   |  6 ++-
 net/netfilter/nft_dup_netdev.c           |  3 +-
 net/netfilter/nft_dynset.c               |  7 ++--
 net/netfilter/nft_exthdr.c               |  9 +++--
 net/netfilter/nft_fib.c                  |  2 +-
 net/netfilter/nft_flow_offload.c         |  3 +-
 net/netfilter/nft_fwd_netdev.c           |  6 ++-
 net/netfilter/nft_hash.c                 |  4 +-
 net/netfilter/nft_immediate.c            |  3 +-
 net/netfilter/nft_last.c                 |  3 +-
 net/netfilter/nft_limit.c                |  5 ++-
 net/netfilter/nft_log.c                  |  3 +-
 net/netfilter/nft_lookup.c               |  3 +-
 net/netfilter/nft_masq.c                 |  3 +-
 net/netfilter/nft_meta.c                 |  5 ++-
 net/netfilter/nft_nat.c                  |  3 +-
 net/netfilter/nft_numgen.c               |  6 ++-
 net/netfilter/nft_objref.c               |  6 ++-
 net/netfilter/nft_osf.c                  |  3 +-
 net/netfilter/nft_payload.c              |  6 ++-
 net/netfilter/nft_queue.c                |  6 ++-
 net/netfilter/nft_quota.c                |  5 ++-
 net/netfilter/nft_range.c                |  3 +-
 net/netfilter/nft_redir.c                |  3 +-
 net/netfilter/nft_reject.c               |  3 +-
 net/netfilter/nft_rt.c                   |  2 +-
 net/netfilter/nft_socket.c               |  2 +-
 net/netfilter/nft_synproxy.c             |  3 +-
 net/netfilter/nft_tproxy.c               |  2 +-
 net/netfilter/nft_tunnel.c               |  2 +-
 net/netfilter/nft_xfrm.c                 |  2 +-
 45 files changed, 146 insertions(+), 81 deletions(-)

-- 
2.34.1

