Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B07CC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Sep 2021 11:39:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BC5461077
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Sep 2021 11:39:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhITLlH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Sep 2021 07:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbhITLlG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Sep 2021 07:41:06 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 551D0C061574
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Sep 2021 04:39:40 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mSHe4-0006qw-Ha; Mon, 20 Sep 2021 13:39:36 +0200
Date:   Mon, 20 Sep 2021 13:39:36 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue] src: build: Stop build_man.sh from
 deleting short Detailed Descriptions
Message-ID: <YUhy+G6OXJbRI5y6@strlen.de>
References: <20210917084519.15811-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210917084519.15811-1-duncan_roe@optusnet.com.au>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Duncan Roe <duncan_roe@optusnet.com.au> wrote:
> An empty Detailed Description is 3 lines long but a short (1-para) DD is also 3
> lines. Check that the 3rd line really is empty.

applied.
