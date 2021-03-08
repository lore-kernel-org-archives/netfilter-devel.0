Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 538ECC4332E
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 17:19:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BB02650E0
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 17:19:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbhCHRTG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Mar 2021 12:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbhCHRSq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Mar 2021 12:18:46 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A76C06174A
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Mar 2021 09:18:46 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lJJWm-0000LL-4r; Mon, 08 Mar 2021 18:18:44 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 0/6] scanner rework part 1
Date:   Mon,  8 Mar 2021 18:18:31 +0100
Message-Id: <20210308171837.8542-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is the initial batch of patches to rework the nft scanner.
This adds a start condition stack and moves a few expressions to
use start conditions.

This first batch only comes with inclusive start conditions, i.e.
the rules in INITIAL scope are still recognized; the only change is that
the tokens moved to per-expression start conditions disappear from the
INITIAL scope.

For example, after this series 'chain mod' is no longer a syntax error
because the MOD token isn't part of the initial scope anymore.

The next set of patches (not included here) adds start conditions for ip, ip6, arp,
ether and makes saddr/daddr recognized as STRING unless part of a
'ip/ip6 ...' expression.

The plan is to introduce exclusive scopes to deal with table/chain
names, i.e. 'TABLE' and 'CHAIN' keywords switch nft into a mode where
all default rules are disabled.

This will then allow to handle really weird rulesets like

table ip chain {
	chain netdev {
		meta iifname saddr ip saddr 1.2.3.4 ...
	}

and so on.

Main motivation is to avoid breakage of existing rulesets, e.g.

table inet filter {
	chain vid {

... when a future version of nft adds a 'vid' token.

Another effect is that this reduces the need for workarounds like e.g.
'parser: allow classid as set key' and other workarounds that needed to
(re-) enable keywords in STRING context.


Florian Westphal (6):
  scanner: remove unused tokens
  scanner: introduce start condition stack
  scanner: queue: move to own scope
  scanner: ipsec: move to own scope
  scanner: rt: move to own scope
  scanner: socket: move to own scope

 include/parser.h   | 12 +++++++
 src/parser_bison.y | 41 +++++++++++-----------
 src/scanner.l      | 86 ++++++++++++++++++++++++++++++----------------
 3 files changed, 89 insertions(+), 50 deletions(-)

-- 
2.26.2

