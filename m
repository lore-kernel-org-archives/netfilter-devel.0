Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C205BC4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Sep 2021 22:53:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CDC260F51
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Sep 2021 22:53:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350067AbhIMWxi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 18:53:38 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53580 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349745AbhIMWxC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 18:53:02 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8C71860056;
        Tue, 14 Sep 2021 00:49:30 +0200 (CEST)
Date:   Tue, 14 Sep 2021 00:50:37 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH 1/1] netfilter: ipset: Fix oversized kvmalloc() calls
Message-ID: <20210913225037.GA5737@salvia>
References: <4591ee34-aa44-92d-51a8-22e8be5db20@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4591ee34-aa44-92d-51a8-22e8be5db20@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Sep 06, 2021 at 06:26:34PM +0200, Jozsef Kadlecsik wrote:
> The commit 
> 
> commit 7661809d493b426e979f39ab512e3adf41fbcc69
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Wed Jul 14 09:45:49 2021 -0700
> 
>     mm: don't allow oversized kvmalloc() calls
> 
> limits the max allocatable memory via kvmalloc() to MAX_INT. Apply the
> same limit in ipset.

Applied, thanks Jozsef.
