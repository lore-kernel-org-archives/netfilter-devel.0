Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6B8FC433EF
	for <netfilter-devel@archiver.kernel.org>; Sun, 17 Oct 2021 13:58:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C23E760FE3
	for <netfilter-devel@archiver.kernel.org>; Sun, 17 Oct 2021 13:58:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343776AbhJQOA6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 17 Oct 2021 10:00:58 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53056 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343772AbhJQOA5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 17 Oct 2021 10:00:57 -0400
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4BDC063EE1;
        Sun, 17 Oct 2021 15:57:08 +0200 (CEST)
Date:   Sun, 17 Oct 2021 15:58:45 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 2/2] conntrack: use same nfct handle for all entries
Message-ID: <YWwsFduko5Qtxidn@salvia>
References: <20210823155715.81729-1-mikhail.sennikovskii@ionos.com>
 <20210823155715.81729-3-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210823155715.81729-3-mikhail.sennikovskii@ionos.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Mikhail,

On Mon, Aug 23, 2021 at 05:57:15PM +0200, Mikhail Sennikovsky wrote:
> For bulk ct entry loads (with -R option) reusing the same nftc handle
> for all entries results in ~two-time reduction of entries creation
> time. This becomes signifficant when loading tens of thouthand of
> entries.

This is showing on of the limitations of the original API, I started
sketching a patch to update this code to use libmnl, I'd rather follow
this path.

Would you have the time to take it over and look into it?

> E.g. in the tests performed with the tests/conntrack/bulk-load-stress.sh
> the time used for loading of 131070 ct entries (2 * 0xffff)
> was 1.05s when this single nfct handle adjustment and 1.88s w/o it .

What is making things go faster? What is introduding the extra
overhead?

Thanks
