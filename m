Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E8B0C31E5B
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 18:55:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD06B206BA
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 18:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730194AbfFRSzu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 14:55:50 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:54546 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730162AbfFRSzu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 14:55:50 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hdJGm-0002eU-Mi; Tue, 18 Jun 2019 20:55:48 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 0/3] use skb->protocol as l3 protocol dependency
Date:   Tue, 18 Jun 2019 20:43:56 +0200
Message-Id: <20190618184359.29760-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Real patch is the last one, first two do preparation work:
1. Allow removal of the dependency for the reject statement
2. Keep exact icmp type for bridge when printing.
   This is needed so we do not lose the l3 protocol information.
   In the ip family, "reject" and "reject with icmp type
   port-unreachable" are the same, but in case of bridge the latter
   adds a protocol dependency on ipv4, whereas the former rejects
   ip with icmp and ipv6 with a similar icmp-v6 error packet.
3. Prefer meta protocol for bridge family for all implicit
   depencencies.

 include/statement.h                   |    3 
 src/json.c                            |    6 -
 src/meta.c                            |    6 -
 src/netlink_delinearize.c             |   10 +
 src/payload.c                         |   18 +++
 src/statement.c                       |    6 -
 tests/py/bridge/ether.t               |    4 
 tests/py/bridge/ether.t.json.output   |   48 ---------
 tests/py/bridge/ether.t.payload       |   24 +++-
 tests/py/bridge/icmpX.t.payload       |    4 
 tests/py/bridge/reject.t              |   28 ++---
 tests/py/bridge/reject.t.json.output  |  170 +++++---------------------------
 tests/py/bridge/reject.t.payload      |   24 ++--
 tests/py/inet/ip_tcp.t.payload.bridge |    8 -
 tests/py/inet/sets.t.payload.bridge   |    4 
 tests/py/ip/ip.t.payload.bridge       |  180 +++++++++++++++++-----------------
 16 files changed, 217 insertions(+), 326 deletions(-)


