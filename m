Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8480FC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Feb 2022 14:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235350AbiBXO7I (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Feb 2022 09:59:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbiBXO7I (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Feb 2022 09:59:08 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A103919D74F
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Feb 2022 06:58:37 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id A4352642F2;
        Thu, 24 Feb 2022 15:57:28 +0100 (CET)
Date:   Thu, 24 Feb 2022 15:58:33 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_queue: don't assume sk is full socket
Message-ID: <YhedGbZ/1HfA498r@salvia>
References: <20220223201004.30615-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220223201004.30615-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Feb 23, 2022 at 09:10:04PM +0100, Florian Westphal wrote:
> There is no guarantee that state->sk refers to a full socket.
> 
> If refcount transitions to 0, sock_put calls sk_free which then ends up
> with garbage fields.
> 
> I'd like to thank Oleksandr Natalenko and Jiri Benc for considerable
> debug work and pointing out state->sk oddities.

Applied, thanks
