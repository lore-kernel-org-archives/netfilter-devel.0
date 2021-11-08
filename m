Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD8CAC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Nov 2021 10:25:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAC1C61207
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Nov 2021 10:25:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236594AbhKHK2e (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 05:28:34 -0500
Received: from mail.netfilter.org ([217.70.188.207]:46754 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238098AbhKHK2Z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 05:28:25 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id DF7146063C;
        Mon,  8 Nov 2021 11:23:41 +0100 (CET)
Date:   Mon, 8 Nov 2021 11:25:36 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, dsahern@kernel.org,
        Eugene Crosser <crosser@average.org>,
        Lahav Schlesinger <lschlesinger@drivenets.com>
Subject: Re: [PATCH nf] selftests: netfilter: add a vrf+conntrack testcase
Message-ID: <YYj7IJVgKAibNl3G@salvia>
References: <20211018123813.17248-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211018123813.17248-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Oct 18, 2021 at 02:38:13PM +0200, Florian Westphal wrote:
> Rework the reproducer for the vrf+conntrack regression reported
> by Eugene into a selftest and also add a test for ip masquerading
> that Lahav fixed recently.
> 
> With net or net-next tree, the first test fails and the latter
> two pass.
> 
> With 09e856d54bda5f28 ("vrf: Reset skb conntrack connection on VRF rcv")
> reverted first test passes but the last two fail.
> 
> A proper fix needs more work, for time being a revert seems to be
> the best choice, snat/masquerade did not work before the fix.

Applied, thanks.

> Link: https://lore.kernel.org/netdev/378ca299-4474-7e9a-3d36-2350c8c98995@gmail.com/T/#m95358a31810df7392f541f99d187227bc75c9963
> Reported-by: Eugene Crosser <crosser@average.org>
> Cc: Lahav Schlesinger <lschlesinger@drivenets.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Lahav, it would be nice if you could check if this
>  is a correct test of the scenario that you fixed with
>  09e856d54bda5f28. Thanks!

No news from Lahav.
