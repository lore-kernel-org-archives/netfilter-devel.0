Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7E96C433ED
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 May 2021 20:42:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A73A9611C9
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 May 2021 20:42:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbhECUnC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 May 2021 16:43:02 -0400
Received: from mail.netfilter.org ([217.70.188.207]:40936 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbhECUnB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 May 2021 16:43:01 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0BD6E63088;
        Mon,  3 May 2021 22:41:25 +0200 (CEST)
Date:   Mon, 3 May 2021 22:42:04 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v4 0/5] conntrack: save output format
Message-ID: <20210503204204.GA11817@salvia>
References: <20210406100947.57579-1-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210406100947.57579-1-mikhail.sennikovskii@ionos.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Mikhail,

On Tue, Apr 06, 2021 at 12:09:42PM +0200, Mikhail Sennikovsky wrote:
> Hi Pablo & all,
> 
> Here is the updated version of the "save output format"
> patches adjusted in accordance with our latest discussion with Pablo.

I have applied this series with changes.

Please, just follow up with incremental fixes in case you find any
bug of mine.

Thanks for your patience.
