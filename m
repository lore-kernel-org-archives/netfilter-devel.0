Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D74A6C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Sep 2021 10:50:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE4B1610FC
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Sep 2021 10:50:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240189AbhI1Kvx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Sep 2021 06:51:53 -0400
Received: from mail.netfilter.org ([217.70.188.207]:57176 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239895AbhI1Kvx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Sep 2021 06:51:53 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 29C8763595;
        Tue, 28 Sep 2021 12:48:49 +0200 (CEST)
Date:   Tue, 28 Sep 2021 12:50:08 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_log 1/2] utils: nfulnl_test: Agree with man
 pages
Message-ID: <YVLzYO7SNAdljzSg@salvia>
References: <20210921085315.4340-1-duncan_roe@optusnet.com.au>
 <20210921085315.4340-2-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210921085315.4340-2-duncan_roe@optusnet.com.au>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Sep 21, 2021 at 06:53:14PM +1000, Duncan Roe wrote:
> Use the same variable name as the man pages / html for functions in the Parsing
> module (e.g. nflog_get_msg_packet_hdr(nfad)).

Applied, thanks.
