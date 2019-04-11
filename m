Return-Path: <SRS0=iy/8=SN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0922C10F13
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Apr 2019 14:39:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FD7A206BA
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Apr 2019 14:39:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfDKOjn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Apr 2019 10:39:43 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:36462 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726391AbfDKOjn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Apr 2019 10:39:43 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hEarc-0001so-5z; Thu, 11 Apr 2019 16:39:40 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        <netdev@vger.kernel.org>
Subject: [PATCH nf-next 0/4] netfilter: bridge: remove broute hook
Date:   Thu, 11 Apr 2019 16:36:38 +0200
Message-Id: <20190411143642.1087-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This series removes the 'broute' hook by promoting ebtables' broute table
to a normal ebtables table (invoked via normal PREROUTING netfilter hook).

The downside is that nf_hook_slow() needs to be duplicated in br_input.c
(see patch 3).

However, I think its worth the price as this allows to remove the
br_should_route_hook.

There are quite some changes in bridge specific code, if you prefer
I can re-submit this for net-next instead of nf-next.

Main motivation is to provide 'ebtables -t broute' functionality via
nftables later on, this can then be done without touching the bridge
or netfilter core infrastructure again.

Florian Westphal (4):
      selftests: netfilter: add ebtables broute test case
      bridge: reduce size of input cb to 16 bytes
      bridge: netfilter: unroll NF_HOOK helper in bridge input path
      bridge: broute: make broute a real ebtables table

 include/linux/if_bridge.h                           |    3 
 include/net/netfilter/nf_queue.h                    |    3 
 net/bridge/br_arp_nd_proxy.c                        |   18 +-
 net/bridge/br_input.c                               |   72 +++++++--
 net/bridge/br_private.h                             |   15 +-
 net/bridge/netfilter/ebtable_broute.c               |   63 ++++++--
 net/bridge/netfilter/ebtables.c                     |    7 
 net/netfilter/core.c                                |    1 
 net/netfilter/nf_internals.h                        |    3 
 net/netfilter/nf_queue.c                            |    1 
 tools/testing/selftests/netfilter/Makefile          |    2 
 tools/testing/selftests/netfilter/bridge_brouter.sh |  146 ++++++++++++++++++++
 12 files changed, 268 insertions(+), 66 deletions(-)

