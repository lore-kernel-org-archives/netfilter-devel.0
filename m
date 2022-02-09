Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FF62C43217
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Feb 2022 11:55:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbiBILzc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Feb 2022 06:55:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbiBILzT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Feb 2022 06:55:19 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1E4EDC1036B3
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Feb 2022 02:49:17 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id EB109601B3;
        Wed,  9 Feb 2022 11:49:05 +0100 (CET)
Date:   Wed, 9 Feb 2022 11:49:14 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v2] netfilter: ecache: don't use nf_conn spinlock
Message-ID: <YgOcKkflWY8sKCd+@salvia>
References: <20220205120004.98531-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220205120004.98531-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Feb 05, 2022 at 01:00:04PM +0100, Florian Westphal wrote:
> For updating eache missed value we can use cmpxchg.
> This also avoids need to disable BH.
> 
> kernel robot reported build failure on v1 because not all arches support
> cmpxchg for u16, so extend this to u32.
> 
> This doesn't increase struct size, existing padding is used.

Applied, thanks
