Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E4BFC433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Apr 2022 13:51:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352875AbiDSNx5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Apr 2022 09:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353152AbiDSNwa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Apr 2022 09:52:30 -0400
Received: from mail.strongswan.org (sitav-80046.hsr.ch [152.96.80.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D65B3D1E5;
        Tue, 19 Apr 2022 06:47:14 -0700 (PDT)
Received: from think.home (67.36.7.85.dynamic.wline.res.cust.swisscom.ch [85.7.36.67])
        by mail.strongswan.org (Postfix) with ESMTPSA id 12A16406A2;
        Tue, 19 Apr 2022 15:47:12 +0200 (CEST)
From:   Martin Willi <martin@strongswan.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        David Ahern <dsahern@kernel.org>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH nf v2 0/2] netfilter: Fix/update mangled packet re-routing within VRF domains
Date:   Tue, 19 Apr 2022 15:46:59 +0200
Message-Id: <20220419134701.153090-1-martin@strongswan.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The first patch fixes re-routing of IPv6 packets mangled by Netfilter 
rules to consider the layer 3 VRF domain. The second patch updates both 
IPv4 and IPv6 re-routing to use the recently added l3mdev flow key instead
of abusing the oif flow key to select the L3 domain.

These patches have been explicitly split up to allow stable to pick up the
first patch as-is.

Changes in v2:
- Add a second patch to migrate IPv4/6 re-routing to l3mdev flow key

Martin Willi (2):
  netfilter: Update ip6_route_me_harder to consider L3 domain
  netfilter: Use l3mdev flow key when re-routing mangled packets

 net/ipv4/netfilter.c | 3 +--
 net/ipv6/netfilter.c | 9 +++++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

-- 
2.25.1

