Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05C2EC4332D
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Mar 2021 17:13:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C707264EB9
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Mar 2021 17:13:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234888AbhCORMe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Mar 2021 13:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235074AbhCORMM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Mar 2021 13:12:12 -0400
Received: from mail.netfilter.org (mail.netfilter.org [IPv6:2001:4b98:dc0:41:216:3eff:fe8c:2bda])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A677CC06174A
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Mar 2021 10:12:12 -0700 (PDT)
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 36AFA63534;
        Mon, 15 Mar 2021 18:12:11 +0100 (CET)
Date:   Mon, 15 Mar 2021 18:12:09 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v3 3/8] conntrack: per-command entries counters
Message-ID: <20210315171209.GA24883@salvia>
References: <20210129212452.45352-1-mikhail.sennikovskii@cloud.ionos.com>
 <20210129212452.45352-4-mikhail.sennikovskii@cloud.ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210129212452.45352-4-mikhail.sennikovskii@cloud.ionos.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Mikhail,

On Fri, Jan 29, 2021 at 10:24:47PM +0100, Mikhail Sennikovsky wrote:
> As a multicommand support preparation entry counters need
> to be made per-command as well, e.g. for the case -D and -I
> can be executed in a single batch, and we want to have separate
> counters for them.

How do you plan to use the counters? -F provides no stats though.

It should be possible to do some pretty print for stats.

There is also the -I and -D cases, which might fail. In that case,
this should probably stop processing on failure?

I sent another round of patches based on your that gets things closer
to the batch support.
