Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84669C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Sep 2021 11:26:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A1CA606A5
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Sep 2021 11:26:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236804AbhITL2P (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Sep 2021 07:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236823AbhITL2O (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Sep 2021 07:28:14 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F98C061760
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Sep 2021 04:26:48 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mSHRd-0006my-RH; Mon, 20 Sep 2021 13:26:45 +0200
Date:   Mon, 20 Sep 2021 13:26:45 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Topi Miettinen <toiwoton@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] libnetfilter_queue: src/nlmsg.c: SECCTX can be of any
 length
Message-ID: <YUhv9Yubid6ZY2nn@strlen.de>
References: <20210910095845.54611-1-toiwoton@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210910095845.54611-1-toiwoton@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Topi Miettinen <toiwoton@gmail.com> wrote:
> Typically security contexts are not 'u32' sized but strings, for example
> 'system_u:object_r:my_http_client_packet_t:s0'.
> 
> Fix length validation check to allow any context sizes.

LGTM, applied, thanks.
