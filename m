Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58634C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jan 2022 01:11:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243952AbiARBLs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jan 2022 20:11:48 -0500
Received: from mail.netfilter.org ([217.70.188.207]:60662 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243926AbiARBLs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jan 2022 20:11:48 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 61CA160028;
        Tue, 18 Jan 2022 02:08:50 +0100 (CET)
Date:   Tue, 18 Jan 2022 02:11:43 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     Florian Westphal <fw@strlen.de>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v3 1-5/5] src: Speed-up
Message-ID: <YeYTzwpxiqLz8ulb@salvia>
References: <20220109031653.23835-1-duncan_roe@optusnet.com.au>
 <20220109031653.23835-6-duncan_roe@optusnet.com.au>
 <YeYClrLxYGDeD8ua@slk1.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YeYClrLxYGDeD8ua@slk1.local.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Duncan,

On Tue, Jan 18, 2022 at 10:58:14AM +1100, Duncan Roe wrote:
> Guys,
> 
> Withot this patchset it remains an embarassing fact that any nfq program that
> uses the deprecated libnfnetlink interface and examines packet data will use
> more CPU if rewritten to use the libmnl interface.

We should untagged as deprecated libnetfilter_queue old interface in
the documentation, it's fine to keep it there, it should be possible
to make it work over libmnl.

> Please apply the set or give feedback on it as a matter of urgency.

There is absolutely no urgency.

This patch have a number of showstoppers such as exposing structure
layout on the header files.

I think the goal is to avoid the memcpy() I posted a patch sketch
time ago to follow a more simple approach that we can resurrect,
polish and upstream to remove the extra copy.

Thanks.
