Return-Path: <SRS0=f/Zg=EE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FA46C2D0A3
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Oct 2020 08:23:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 155FD2076E
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Oct 2020 08:23:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="aAfl/qFg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729335AbgJ2IW6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Oct 2020 04:22:58 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:33561 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725982AbgJ2IW5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Oct 2020 04:22:57 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 675cc25d;
        Thu, 29 Oct 2020 02:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-transfer-encoding;
         s=mail; bh=H+xkEXz6xd/uevfOEO8weeo2nyA=; b=aAfl/qFgFu+QAloI0Yq3
        U3RfuRqFJpImAk+B/ynkTCmWP1ezM9C0IIxwtgAfXOCzF9ZEx7uOQ0anF95WC0iv
        TZlbG4xlIBzJQlG8DCC87trDnCDRqdCgbu/D4QQ39slwNrw/Jy3yYo7n2GTguUmw
        jvH4rvThMBkLdd5JGx+CDxgmwA62LFEdQqJSGCkqQkbvVpnxX1gWLSLtrFEZNdp2
        8uwl3eSHc37UCG/k7POJIPIRINeVXtF7X5m3Sq0LMVAubAS63i6VHyGw5dB7yT0o
        1rMGHs97sMvAHc4+0wybZ5q5ybuUOAgCakOSi0/CsyWLMKb5Lcz4W4GLM8f3ECsz
        wA==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 00cca5fc (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 29 Oct 2020 02:54:54 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH nf 0/2] route_me_harder routing loop with tunnels
Date:   Thu, 29 Oct 2020 03:56:04 +0100
Message-Id: <20201029025606.3523771-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

This series fixes a bug in the route_me_harder family of functions with
regards to tunnel interfaces. The first patch contains an addition to
the wireguard test suite; I normally send my wireguard patches through
Dave's tree, but I thought it'd be nice to send these together here
because the test case is illustrative of the issue. The second patch
then fixes the issue with a lengthy explanation of what's going on.

These are intended for net.git/nf.git, not the -next variety, and to
eventually be backported to stable. So, the second patch has a proper
Fixes: line on it to help with that.

Thanks,
Jason

Jason A. Donenfeld (2):
  wireguard: selftests: check that route_me_harder packets use the right
    sk
  netfilter: use actual socket sk rather than skb sk when routing harder

 include/linux/netfilter_ipv4.h                       |  2 +-
 include/linux/netfilter_ipv6.h                       | 10 +++++-----
 net/ipv4/netfilter.c                                 |  8 +++++---
 net/ipv4/netfilter/iptable_mangle.c                  |  2 +-
 net/ipv4/netfilter/nf_reject_ipv4.c                  |  2 +-
 net/ipv6/netfilter.c                                 |  6 +++---
 net/ipv6/netfilter/ip6table_mangle.c                 |  2 +-
 net/netfilter/ipvs/ip_vs_core.c                      |  4 ++--
 net/netfilter/nf_nat_proto.c                         |  4 ++--
 net/netfilter/nf_synproxy_core.c                     |  2 +-
 net/netfilter/nft_chain_route.c                      |  4 ++--
 net/netfilter/utils.c                                |  4 ++--
 tools/testing/selftests/wireguard/netns.sh           |  8 ++++++++
 tools/testing/selftests/wireguard/qemu/kernel.config |  2 ++
 14 files changed, 36 insertions(+), 24 deletions(-)

-- 
2.29.1

