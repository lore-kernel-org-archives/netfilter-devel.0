Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10C75C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Dec 2021 00:25:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbhLHA2z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Dec 2021 19:28:55 -0500
Received: from mail.netfilter.org ([217.70.188.207]:38864 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhLHA2y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Dec 2021 19:28:54 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3571D605BA;
        Wed,  8 Dec 2021 01:23:00 +0100 (CET)
Date:   Wed, 8 Dec 2021 01:25:19 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     fw@strlen.de, lschlesinger@drivenets.com, dsahern@kernel.org,
        crosser@average.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH nf] vrf: don't run conntrack on vrf with !dflt qdisc
Message-ID: <Ya/7b85COMY2702t@salvia>
References: <20211126143612.11262-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211126143612.11262-1-nicolas.dichtel@6wind.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Nov 26, 2021 at 03:36:12PM +0100, Nicolas Dichtel wrote:
> After the below patch, the conntrack attached to skb is set to "notrack" in
> the context of vrf device, for locally generated packets.
> But this is true only when the default qdisc is set to the vrf device. When
> changing the qdisc, notrack is not set anymore.
> In fact, there is a shortcut in the vrf driver, when the default qdisc is
> set, see commit dcdd43c41e60 ("net: vrf: performance improvements for
> IPv4") for more details.
> 
> This patch ensures that the behavior is always the same, whatever the qdisc
> is.
> 
> To demonstrate the difference, a new test is added in conntrack_vrf.sh.

Applied
