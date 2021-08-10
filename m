Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D5AAC4338F
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Aug 2021 13:23:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50CA260FDA
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Aug 2021 13:23:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241269AbhHJNXa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Aug 2021 09:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239580AbhHJNX2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Aug 2021 09:23:28 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF30C0613D3;
        Tue, 10 Aug 2021 06:23:04 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mDRiS-0008GT-E0; Tue, 10 Aug 2021 15:22:48 +0200
Date:   Tue, 10 Aug 2021 15:22:48 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+649e339fa6658ee623d3@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] netfilter: protect nft_ct_pcpu_template_refcnt with
 mutex
Message-ID: <20210810132248.GS607@breakpoint.cc>
References: <20210810125523.15312-1-paskripkin@gmail.com>
 <20210810125920.23187-1-paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810125920.23187-1-paskripkin@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pavel Skripkin <paskripkin@gmail.com> wrote:
> Syzbot hit use-after-free in nf_tables_dump_sets. The problem was in
> missing lock protection for nft_ct_pcpu_template_refcnt.
> 
> Before commit f102d66b335a ("netfilter: nf_tables: use dedicated
> mutex to guard transactions") all transactions were serialized by global
> mutex, but then global mutex was changed to local per netnamespace
> commit_mutex.
> 
> This change causes use-after-free bug, when 2 netnamespaces concurently
> changing nft_ct_pcpu_template_refcnt without proper locking. Fix it by
> adding nft_ct_pcpu_mutex and protect all nft_ct_pcpu_template_refcnt
> changes with it.
> 
> Fixes: f102d66b335a ("netfilter: nf_tables: use dedicated mutex to guard transactions")
> Reported-and-tested-by: syzbot+649e339fa6658ee623d3@syzkaller.appspotmail.com
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>

Acked-by: Florian Westphal <fw@strlen.de>
