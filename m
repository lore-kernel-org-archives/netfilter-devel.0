Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85744C433B4
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 May 2021 15:24:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B44861261
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 May 2021 15:24:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350159AbhERPZt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 May 2021 11:25:49 -0400
Received: from mail.netfilter.org ([217.70.188.207]:43072 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241047AbhERPZt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 May 2021 11:25:49 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9D7E36414D;
        Tue, 18 May 2021 17:23:35 +0200 (CEST)
Date:   Tue, 18 May 2021 17:24:26 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     =?utf-8?B?U3TDqXBoYW5l?= Veyret <sveyret@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: warning splat in nftables ct expect
Message-ID: <20210518152426.GA23687@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I'm hitting a warning with the custom ct expect infrastructure for
nftables:

[ 1825.349056] WARNING: CPU: 0 PID: 1279 at net/netfilter/nf_conntrack_extend.c:48 nf_ct_xt_add+0x18e/0x1a0 [nf_conntrack]
[ 1825.351391] RIP: 0010:nf_ct_ext_add+0x18e/0x1a0 [nf_conntrack]
[ 1825.351493] Code: 41 5c 41 5d 41 5e 41 5f c3 41 bc 0a 00 00 00 e9 15 ff ff ff ba 09 00                                                                                                      00 00 31 f6 4c 89 ff e8 69 6c 3d e9 eb 96 45 31 ed eb cd <0f> 0b e9 b1 fe ff ff e8 86 79 1                                                                                                     4 e9 eb bf 0f 1f 40 00 0f 1f 44 00
[ 1825.351721] RSP: 0018:ffffc90002e1f1e8 EFLAGS: 00010202
[ 1825.351790] RAX: 000000000000000e RBX: ffff88814f5783c0 RCX: ffffffffc0e4f887
[ 1825.351881] RDX: dffffc0000000000 RSI: 0000000000000008 RDI: ffff88814f578440
[ 1825.351971] RBP: 0000000000000000 R08: 0000000000000000 R09: ffff88814f578447
[ 1825.352060] R10: ffffed1029eaf088 R11: 0000000000000001 R12: ffff88814f578440
[ 1825.352150] R13: ffff8882053f3a00 R14: 0000000000000000 R15: 0000000000000a20
[ 1825.352240] FS:  00007f992261c900(0000) GS:ffff889faec00000(0000) knlGS:000000000000000                                                                                                     0
[ 1825.352343] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1825.352417] CR2: 000056070a4d1158 CR3: 000000015efe0000 CR4: 0000000000350ee0
[ 1825.352508] Call Trace:
[ 1825.352544]  nf_ct_helper_ext_add+0x10/0x60 [nf_conntrack]
[ 1825.352641]  nft_ct_expect_obj_eval+0x1b8/0x1e0 [nft_ct]
[ 1825.352716]  nft_do_chain+0x232/0x850 [nf_tables]

nft_ct_expect_obj_eval() calls nf_ct_ext_add() for a confirmed
conntrack entry. However, nf_ct_ext_add() can only be called for
!nf_ct_is_confirmed().

I can fix this by adding the nf_ct_is_confirmed() check, but then you
can only create an expectation from the first packet. I guess this is
fine for your usecase, right?

It should be possible to remove this limitation via explicit ct helper
definition in the ruleset, ie. decouple helper definition from the
expectation setup which happens from nft_ct_expect_obj_eval().

Thanks.
