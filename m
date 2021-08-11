Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05188C4338F
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Aug 2021 09:22:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D23D460F55
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Aug 2021 09:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234869AbhHKJWc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Aug 2021 05:22:32 -0400
Received: from mail.netfilter.org ([217.70.188.207]:44268 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234670AbhHKJWc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Aug 2021 05:22:32 -0400
Received: from netfilter.org (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4370560066;
        Wed, 11 Aug 2021 11:21:25 +0200 (CEST)
Date:   Wed, 11 Aug 2021 11:22:02 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+649e339fa6658ee623d3@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] netfilter: protect nft_ct_pcpu_template_refcnt with
 mutex
Message-ID: <20210811092201.GA23996@salvia>
References: <20210810125523.15312-1-paskripkin@gmail.com>
 <20210810125920.23187-1-paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210810125920.23187-1-paskripkin@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 10, 2021 at 03:59:20PM +0300, Pavel Skripkin wrote:
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

Applied to nf.git, thanks
