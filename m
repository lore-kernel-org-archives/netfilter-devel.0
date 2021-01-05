Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E78E0C433E0
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Jan 2021 23:16:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B062122E00
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Jan 2021 23:16:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbhAEXQ0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Jan 2021 18:16:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbhAEXQ0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Jan 2021 18:16:26 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E37C061574;
        Tue,  5 Jan 2021 15:15:45 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kwvYD-0000RJ-4E; Wed, 06 Jan 2021 00:15:41 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     christian.perle@secunet.com, steffen.klassert@secunet.com,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH net 0/3] net: fix netfilter defrag/ip tunnel pmtu blackhole
Date:   Wed,  6 Jan 2021 00:15:20 +0100
Message-Id: <20210105231523.622-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210105121208.GA11593@cell>
References: <20210105121208.GA11593@cell>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Christian Perle reported a PMTU blackhole due to unexpected interaction
between the ip defragmentation that comes with connection tracking and
ip tunnels.

Unfortunately setting 'nopmtudisc' on the tunnel breaks the test
scenario even without netfilter.

Christinas setup looks like this:
     +--------+       +---------+       +--------+
     |Router A|-------|Wanrouter|-------|Router B|
     |        |.IPIP..|         |..IPIP.|        |
     +--------+       +---------+       +--------+
          /             mtu 1400           \
         /                                  \
 +--------+                                  +--------+
 |Client A|                                  |Client B|
 +--------+                                  +--------+

MTU is 1500 everywhere, except on Router A to Wanrouter and
Wanrouter to Router B.

Router A and Router B use IPIP tunnel interfaces to tunnel traffic
between Client A and Client B over WAN.

Client A sends a 1400 byte UDP datagram to Client B.
This packet gets encapsulated in the IPIP tunnel.

This works, packet is received on client B.

When conntrack (or anything else that forces ip defragmentation) is
enabled on Router A, the packet gets dropped on Router A after
encapsulation because they exceed the link MTU.

Setting the 'nopmtudisc' flag on the IPIP tunnel makes things worse,
no packets pass even in the no-netfilter scenario.

Patch one is a reproducer script for selftest infra.

Patch two is a fix for 'nopmtudisc' behaviour so ip_tunnel will send
an icmp error to Client A.  This allows 'nopmtudisc' tunnel to forward
the UDP datagrams.

Patch three enables ip refragmentation for all reassembled packets, just
like ipv6.

