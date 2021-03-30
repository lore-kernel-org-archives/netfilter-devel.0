Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF8C3C433C1
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Mar 2021 22:55:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5EAE619D1
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Mar 2021 22:55:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233049AbhC3WzF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Mar 2021 18:55:05 -0400
Received: from mail.netfilter.org ([217.70.188.207]:46520 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbhC3WzA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Mar 2021 18:55:00 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9238C63E55;
        Wed, 31 Mar 2021 00:54:45 +0200 (CEST)
Date:   Wed, 31 Mar 2021 00:54:56 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        kadlec@netfilter.org
Subject: Re: [PATCH -next] netfilter: nftables: remove unnecessary
 spin_lock_init()
Message-ID: <20210330225456.GA14489@salvia>
References: <20210329135541.3304940-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210329135541.3304940-1-yangyingliang@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Mar 29, 2021 at 09:55:41PM +0800, Yang Yingliang wrote:
> The spinlock nf_tables_destroy_list_lock is initialized statically.
> It is unnecessary to initialize by spin_lock_init().

Applied, thanks.
