Return-Path: <SRS0=Eqja=WM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E2DFC3A59C
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Aug 2019 14:44:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49F6F206C1
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Aug 2019 14:44:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbfHPOor (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Aug 2019 10:44:47 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:46164 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727245AbfHPOoq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Aug 2019 10:44:46 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hydTB-0002nN-2w; Fri, 16 Aug 2019 16:44:45 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Subject: [PATCH nftables 0/8] add typeof keyword
Date:   Fri, 16 Aug 2019 16:42:33 +0200
Message-Id: <20190816144241.11469-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch series adds the typeof keyword.

The only dependency is a small change to libnftnl to add two new
UDATA_SET_TYPEOF enum values.

named set can be configured as follows:

set os {
   type typeof(osf name)
   elements = { "Linux", "Windows" }
}

or
nft add set ip filter allowed "{ type typeof(ip daddr) . typeof(tcp dport); }"

... which is the same as the "old" 'type ipv4_addr . inet_service".

The type is stored in the kernel via the udata set infrastructure,
on listing -- if a udata type is present -- nft will validate that this
type matches the set key length.

This initial submission doesn't include a documentation update because
I'd like to get feedback on the chosen syntax first.

Florian Westphal (8):
      src: libnftnl: run single-initcalls only once
      src: libnftnl: split nft_ctx_new/free
      src: store expr, not dtype to track data in sets
      src: parser: add syntax to provide bitsize for non-spcific types
      src: add "typeof" keyword
      src: add "typeof" print support
      src: netlink: remove assertion
      tests: add typeof test cases

 include/datatype.h                                 |    1 
 include/netlink.h                                  |    1 
 include/nftables.h                                 |    3 
 include/rule.h                                     |    6 
 src/datatype.c                                     |    5 
 src/evaluate.c                                     |   58 ++++--
 src/expression.c                                   |    2 
 src/json.c                                         |    4 
 src/libnftables.c                                  |   48 +++--
 src/mnl.c                                          |   39 ++++
 src/monitor.c                                      |    2 
 src/netlink.c                                      |  176 ++++++++++++++++++---
 src/netlink_delinearize.c                          |   15 +
 src/parser_bison.y                                 |   26 ++-
 src/parser_json.c                                  |    8 
 src/rule.c                                         |   35 +++-
 src/scanner.l                                      |    1 
 src/segtree.c                                      |    8 
 tests/shell/testcases/maps/dumps/typeof_maps_0.nft |   16 +
 tests/shell/testcases/maps/typeof_maps_0           |   26 +++
 tests/shell/testcases/sets/dumps/typeof_sets_0.nft |   31 +++
 tests/shell/testcases/sets/typeof_sets_0           |   40 ++++
 22 files changed, 459 insertions(+), 92 deletions(-)


