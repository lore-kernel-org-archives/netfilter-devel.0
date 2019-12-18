Return-Path: <SRS0=U5wk=2I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4329CC43603
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Dec 2019 11:05:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1ED512176D
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Dec 2019 11:05:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfLRLF3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Dec 2019 06:05:29 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:35968 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726141AbfLRLF3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Dec 2019 06:05:29 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ihX8y-000778-54; Wed, 18 Dec 2019 12:05:28 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 0/9] netfilter: nft_meta: add support for slave device matching
Date:   Wed, 18 Dec 2019 12:05:12 +0100
Message-Id: <20191218110521.14048-1-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Martin Willi recently proposed addition of new xt_slavedev module to
allow matching the real interface within a VRF domain.

This adds an nft equivalent:

meta sdif "realdev" accept
meta sdifname "realdev" accept

In case packet had no vrf slave, sdif stores 0 or "" name, just
like 'oif/oifname' would on input.

sdif(name) is restricted to the ipv4/ipv6 input and forward hooks,
as it depends on ip(6) stack parsing/storing info in skb->cb[].

Because meta main eval function is now exceeding more than 200 LOC,
the first patches are diet work to debloat the function by using
helpers where appropriate.

Last patch adds the sdif/sdifname functionality.

Function                                     old     new   delta
nft_meta_get_eval_pkttype_lo                   -     588    +588
nft_meta_get_eval_time                         -     404    +404
nft_meta_get_eval_skugid                       -     397    +397
nft_meta_get_eval_cgroup                       -     234    +234
nft_meta_get_eval_sif                          -     148    +148
nft_meta_get_eval_kind                         -     138    +138
nft_meta_get_eval_sifname                      -      91     +91
nft_meta_get_validate                        111     169     +58
nft_prandom_u32                                -      20     +20
nft_meta_get_eval                           2904    1261   -1643
Total: Before=6076, After=6511, chg +7.16%


