From: Joe Stringer <joe@ovn.org>
Subject: Re: [patch nf] netfilter: nf_tables: Fix nft limit burst handling
Date: Mon, 21 Aug 2017 14:29:13 -0700
Message-ID: <CAPWQB7E1wLt4vuWUt8i8aqu4myxtZ81yEd7-7NVhhgiaCreKrA@mail.gmail.com>
References: <1503344333-9953-1-git-send-email-azhou@ovn.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: netfilter-devel@vger.kernel.org
To: Andy Zhou <azhou@ovn.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:56579 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754035AbdHUV3g (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2017 17:29:36 -0400
Received: from mail-lf0-f49.google.com (mail-lf0-f49.google.com [209.85.215.49])
        (Authenticated sender: joe@ovn.org)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id DACFD17209B
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Aug 2017 23:29:34 +0200 (CEST)
Received: by mail-lf0-f49.google.com with SMTP id f123so22492778lfe.3
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Aug 2017 14:29:34 -0700 (PDT)
In-Reply-To: <1503344333-9953-1-git-send-email-azhou@ovn.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 21 August 2017 at 12:38, Andy Zhou <azhou@ovn.org> wrote:
> Fixes: 96518518cc41 ("netfilter: add nftables")
>
> Current implementation treats the burst configuration the same as
> rate configuration. This can cause the per packet cost to be lower
> than configured. In effect, this bug causes the token bucket to be
> refilled at a higher rate than what user has specified.
>
> This patch changes the implementation so that the token bucket size
> is controlled by "rate + burst", while maintain the token bucket
> refill rate the same as user specified.
>
> Signed-off-by: Andy Zhou <azhou@ovn.org>

Usually "Fixes" tag appears immediately above the signoff lines.

This is the bug that we brought up during NFWS this year in Faro, how
the burst was not acting as a burst but rather it just added to the
rate.

Acked-by: Joe Stringer <joe@ovn.org>
