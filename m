Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE581C19F2D
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Aug 2022 09:07:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241015AbiHIJHX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Aug 2022 05:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233475AbiHIJHX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Aug 2022 05:07:23 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 94006186DE
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Aug 2022 02:07:22 -0700 (PDT)
Date:   Tue, 9 Aug 2022 11:07:19 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jo-Philipp Wich <jo@mein.io>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables] meta: don't use non-POSIX formats in strptime()
Message-ID: <YvIjx02FdKxqkcT8@salvia>
References: <20220808221842.2468359-1-jo@mein.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220808221842.2468359-1-jo@mein.io>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 09, 2022 at 12:18:42AM +0200, Jo-Philipp Wich wrote:
> The current strptime() invocations in meta.c use the `%F` format which
> is not specified by POSIX and thus unimplemented by some libc flavors
> such as musl libc.
> 
> Replace all occurrences of `%F` with an equivalent `%Y-%m-%d` format
> in order to be able to properly parse user supplied dates in such
> environments.

Applied, thanks
