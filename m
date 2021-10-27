Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14959C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Oct 2021 08:35:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF5B060F9D
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Oct 2021 08:35:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235813AbhJ0Ihp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Oct 2021 04:37:45 -0400
Received: from mail.netfilter.org ([217.70.188.207]:47620 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233389AbhJ0Iho (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Oct 2021 04:37:44 -0400
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 5526763F04;
        Wed, 27 Oct 2021 10:33:31 +0200 (CEST)
Date:   Wed, 27 Oct 2021 10:35:15 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_log v5 1/1] build: doc: `make` generates
 requested documentation
Message-ID: <YXkPQ//pcN1QtDYU@salvia>
References: <20211017013951.12584-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211017013951.12584-1-duncan_roe@optusnet.com.au>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Oct 17, 2021 at 12:39:51PM +1100, Duncan Roe wrote:
> Generate man pages, HTML, neither or both according to ./configure.
> Based on the work done for libnetfilter_queue

Applied, thanks.

I have cached a copy of build_man.sh in the git tree.
