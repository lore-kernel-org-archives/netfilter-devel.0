Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65AAEC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Sep 2021 13:13:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 496916115A
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Sep 2021 13:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234006AbhIWNOa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Sep 2021 09:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232798AbhIWNOa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Sep 2021 09:14:30 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6592C061574
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Sep 2021 06:12:58 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mTOX2-00025y-Bs; Thu, 23 Sep 2021 15:12:56 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     eric@garver.life, phil@nwl.cc, kadlec@netfilter.org,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 0/1.5 RFC] netfilter: nat: source port shadowing
Date:   Thu, 23 Sep 2021 15:12:41 +0200
Message-Id: <20210923131243.24071-1-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In brief:

Given
internal_client -- <router:service> -- external_client

The internal client can create NAT entry on router in a way so that
an external client trying to contact router:service is reverse-natted
to internal_client:service instead.

Long version: https://breakpointingbad.com/2021/09/08/Port-Shadows-via-Network-Alchemy.html

First patch extends nft_nat.sh selftest with above scenario plus three
ruleset changes that prevent this (sport-filtering, notrack for
router:service and sport-based port remapping).

I tried to come up with a kernel based solution as well, but those
are not really nice either.

The first option is attached: kernel queries udp with reversed addresses
to see if this maps to a socket.  If so, remap.

Major pain point: adds entanglement to socket layer and will
need extra glue for CONFIG_IPV6=m case.

Second option is similar to the attached patch, but instead of
sk lookup check the porposed new source port versus the
'ip_local_reserved_ports' sysctl.

Would require userspace to set the reserved ports accordingly.

I also had a look at the 'socket' match, but it cannot be used.
It would have to be extended so that the socket lookup is done
on arbirary saddr/daddr/sport/dport combination, or at the very
least we'd need a 'invert' flag.

Existing 'socket' uses the addresses/ports in the packet, but
we'd need the addresses/ports of the hypothetical reply.

Things that do not work:
Change the sport range to only cover the IANA reserved port
range.  It sounds tempting but it sabotages dns resolvers using random
source ports.

Comments welcome.

Florian Westphal (2):
  selftests: nft_nat: add udp hole punch test case
  netfilter: nf_nat: don't allow source ports that shadow local port

 net/netfilter/nf_nat_core.c                  |  41 +++++-
 tools/testing/selftests/netfilter/nft_nat.sh | 145 +++++++++++++++++++
 2 files changed, 183 insertions(+), 3 deletions(-)

-- 
2.32.0

