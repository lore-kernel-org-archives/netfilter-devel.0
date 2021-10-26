Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15247C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Oct 2021 12:36:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA6BF60527
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Oct 2021 12:36:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbhJZMi6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Oct 2021 08:38:58 -0400
Received: from mail.netfilter.org ([217.70.188.207]:45508 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbhJZMi5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Oct 2021 08:38:57 -0400
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id DF0E563ED7;
        Tue, 26 Oct 2021 14:34:44 +0200 (CEST)
Date:   Tue, 26 Oct 2021 14:36:28 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        lschlesinger@drivenets.com, dsahern@kernel.org, crosser@average.org
Subject: Re: [PATCH v2 net-next 2/2] vrf: run conntrack only in context of
 lower/physdev for locally generated packets
Message-ID: <YXf2TJivC1Tp3Tfj@salvia>
References: <20211025141400.13698-1-fw@strlen.de>
 <20211025141400.13698-3-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211025141400.13698-3-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

One question about this.

On Mon, Oct 25, 2021 at 04:14:00PM +0200, Florian Westphal wrote:
> The VRF driver invokes netfilter for output+postrouting hooks so that users
> can create rules that check for 'oif $vrf' rather than lower device name.

If the motion for these hooks in the driver is to match for 'oif vrf',
now that there is an egress hook, it might make more sense to filter
from there based on the interface rather than adding these hook calls
from the vrf driver?

I wonder if, in the future, it makes sense to entirely disable these
hooks in the vrf driver and rely on egress hook?
