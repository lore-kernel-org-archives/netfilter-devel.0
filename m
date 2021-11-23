Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B16BCC4332F
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Nov 2021 13:51:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbhKWNye (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Nov 2021 08:54:34 -0500
Received: from mail.netfilter.org ([217.70.188.207]:60648 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231683AbhKWNyd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Nov 2021 08:54:33 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id D72406009B;
        Tue, 23 Nov 2021 14:49:13 +0100 (CET)
Date:   Tue, 23 Nov 2021 14:51:20 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH ulogd] XML: show both nflog packet and conntrack
Message-ID: <YZzx2Kbo12bb7Qif@salvia>
References: <20211012111706.81484-1-chamas@h4.dion.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211012111706.81484-1-chamas@h4.dion.ne.jp>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 12, 2021 at 08:17:07PM +0900, Ken-ichirou MATSUZAWA wrote:
> This patch enables to show "ct" as well as "raw" if output type is
> ULOGD_DTYPE_RAW and "ct" input exists.

Applied, thanks.

This is the patch I was referring to in my previous email.
