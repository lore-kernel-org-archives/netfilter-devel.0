Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25144C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Oct 2021 23:40:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F358960F22
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Oct 2021 23:40:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235735AbhJKXmj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Oct 2021 19:42:39 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39364 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhJKXmj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Oct 2021 19:42:39 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3E88563F09;
        Tue, 12 Oct 2021 01:39:03 +0200 (CEST)
Date:   Tue, 12 Oct 2021 01:40:34 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH ulogd] XML: support nflog pkt output
Message-ID: <YWTLctYBfLHAIjd5@salvia>
References: <20210917220822.37012-1-chamas@h4.dion.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210917220822.37012-1-chamas@h4.dion.ne.jp>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Sep 18, 2021 at 07:08:23AM +0900, Ken-ichirou MATSUZAWA wrote:
> plugin input type ULOGD_DTYPE_RAW was missing

Applied, thanks
