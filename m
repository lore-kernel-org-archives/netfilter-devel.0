Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA62DC25B04
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Dec 2022 16:18:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiLOQSN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Dec 2022 11:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiLOQSM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Dec 2022 11:18:12 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1330D2EF4E
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Dec 2022 08:18:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xPhEteIeZfWSwVL6jJYIWcXcu4taEDstLBPEJQFvWDo=; b=N5PM+9LwcpV1BBnuyLsGJ1HwKK
        ljSZ7Kw+IiIDbCpDIb9pqhhfbQhtZO4N6vpIcwNBeN3jN7AzwLEzf1ba+xSSNUAAJf1vnSKpF8/+0
        q02Rde+ybpuDpP2fvwS1e3ntvoBXtV2PrSgTf0mxd7Nmf2kVflYQJz1TV5ER0hbhBAeoJ2zAG2It6
        XSOv0GGJuFxEtGLO0ORb36n/aipmYYjxkEt/iR0Lyr2Kq1VwOsAXivEz9bHnvvscXTyynsK1ehxuo
        bjI9fC3FzBbL7Qi70U2NSzLdFdxAnnVa8gV17HpNc0zzAiPpCa4t6Ddy2md7G99sY8kZey6qBSW2y
        BFHyFNSw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p5qvy-0001u5-51; Thu, 15 Dec 2022 17:18:10 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [iptables PATCH 0/4] Make rule parsing strict
Date:   Thu, 15 Dec 2022 17:17:52 +0100
Message-Id: <20221215161756.3463-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Abort the program when encountering rules with unsupported matches.

While nft_is_table_compatible() tries to catch this situation, it boils
down to merely accepting or rejecting expressions based on type. Yet
these may still be used in incompatible ways.

Patch 1 fixes for payload matches on ICMP(v6) headers and is almost
independent of the rest.

Patch 2 prepares arptables rule parsing for the error message added by
patch 3.

Patch 3 makes various situations complain by emitting error messages. It
was compiled after reviewing all callees of rule_to_cs callback for
unhandled unexpected input.

Patch 5 then finally does it's thing.

Phil Sutter (4):
  nft: Parse icmp header matches
  arptables: Check the mandatory ar_pln match
  nft: Increase rule parser strictness
  nft: Make rule parsing errors fatal

 iptables/nft-arp.c                            |   9 +-
 iptables/nft-bridge.c                         |   4 +
 iptables/nft-ipv4.c                           |   4 +-
 iptables/nft-ipv6.c                           |   4 +-
 iptables/nft-shared.c                         | 113 ++++++++++++++++--
 .../nft-only/0010-iptables-nft-save.txt       |   6 +-
 6 files changed, 123 insertions(+), 17 deletions(-)

-- 
2.38.0

