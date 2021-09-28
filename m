Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70340C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Sep 2021 10:50:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 557FC6101E
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Sep 2021 10:50:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240211AbhI1Kw1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Sep 2021 06:52:27 -0400
Received: from mail.netfilter.org ([217.70.188.207]:57192 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239895AbhI1Kw1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Sep 2021 06:52:27 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3C07963595;
        Tue, 28 Sep 2021 12:49:24 +0200 (CEST)
Date:   Tue, 28 Sep 2021 12:50:44 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_log 2/2] utils: nfulnl_test: Add rather
 extensive test of nflog_get_packet_hw()
Message-ID: <YVLzhH8mxSpPaPF3@salvia>
References: <20210921085315.4340-1-duncan_roe@optusnet.com.au>
 <20210921085315.4340-3-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210921085315.4340-3-duncan_roe@optusnet.com.au>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Sep 21, 2021 at 06:53:15PM +1000, Duncan Roe wrote:
> Wasn't expecting length in NBO, so code caters for it being either way

For the record: I have written a different patch and push it out.
