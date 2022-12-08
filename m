Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4417FC4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 20:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbiLHU3g (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Dec 2022 15:29:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiLHU3Q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Dec 2022 15:29:16 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7391485D37
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Dec 2022 12:29:15 -0800 (PST)
Date:   Thu, 8 Dec 2022 21:29:11 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, Jan Engelhardt <jengelh@inai.de>
Subject: Re: [libmnl PATCH] Makefile: Create LZMA-compressed dist-files
Message-ID: <Y5JJFyZSW9OhYuUl@salvia>
References: <20221208001339.21578-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221208001339.21578-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil

On Thu, Dec 08, 2022 at 01:13:39AM +0100, Phil Sutter wrote:
> Use a more modern alternative to bzip2.

I tested this one for libmnl specifically and it works fine with `make
distcheck`. I can quickly update the release script here to refer to
tar.xz instead of tar.bz2.

I have seen other projects offering both .tar.bz2 and .tar.xz, the
reason for this for me is unknown, I guess using .tar.xz should be
fine for everyone?

Please go ahead push out these patches, thanks.
