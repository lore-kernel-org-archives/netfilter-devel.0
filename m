Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47BC4C48BDF
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Jun 2021 10:36:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 285C9613FE
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Jun 2021 10:36:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231983AbhFXKjL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Jun 2021 06:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231970AbhFXKjL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Jun 2021 06:39:11 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7FEAC061574
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Jun 2021 03:36:52 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lwMj4-0003DR-Uu; Thu, 24 Jun 2021 12:36:50 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     kadlec@netfilter.org, Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/2] netfilter: conntrack: do not renew timeout while in tcp SYN_SENT state
Date:   Thu, 24 Jun 2021 12:36:40 +0200
Message-Id: <20210624103642.29087-1-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Antonio Ojea reported a problem with a container environment where
connection retries prevent expiry of a SYN_SENT conntrack entry.

This in turn prevents a NAT rule from becoming active.

Consider:
  client -----> conntrack ---> Host

client sends a SYN, but $Host is unreachable/silent.

In the reported case, $host address doesn't exist at all --
its a 'virtual' ip that is made accessible via dnat/redirect.

The routing table even passes the packet back via the same interface
it arrived on.

In the mean time, a NAT rule has been added to the conntrack
namespace, but it has no effect until the existing conntrack
entry times out.

Unfortunately, in the above scenario, the client retries reconnects
faster than the SYN default timeout (60 seconds), i.e. the entry
never expires and the 'virtual' ip never becomes active.

First patch adds a test case:
 3 namespaces, one sender, one receiver.
 sender connects to non-existent/virtual ip.
 Then a dnat rule gets added.

 The test case succeeds once conntrack tool shows that the nat rule
 was evaluated.

Second patch prevents timeout refresh for entries stuck in
SYN_SENT state.

Without second patch the test case doesn't pass even though syn
timeout is set to 10 seconds.

Florian Westphal (2):
  selftest: netfilter: add test case for unreplied tcp connections
  netfilter: conntrack: do not renew entry stuck in tcp SYN_SENT state

 net/netfilter/nf_conntrack_proto_tcp.c        |  10 ++
 tools/testing/selftests/netfilter/Makefile    |   2 +-
 .../netfilter/conntrack_tcp_unreplied.sh      | 167 ++++++++++++++++++
 3 files changed, 178 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/netfilter/conntrack_tcp_unreplied.sh

-- 
2.31.1

