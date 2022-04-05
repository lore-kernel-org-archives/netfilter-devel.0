Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFD25C4321E
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Apr 2022 21:23:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233109AbiDEVUd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Apr 2022 17:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344911AbiDEUVu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Apr 2022 16:21:50 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 50B246D3A0
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Apr 2022 13:01:42 -0700 (PDT)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id CD5846435D;
        Tue,  5 Apr 2022 21:58:01 +0200 (CEST)
Date:   Tue, 5 Apr 2022 22:01:38 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Lukas Straub <lukasstraub2@web.de>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] meta.c: fix compiler warning in date_type_parse()
Message-ID: <YkygIht7NJPDg1oF@salvia>
References: <20220405164330.0a0be0d3@gecko>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220405164330.0a0be0d3@gecko>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 05, 2022 at 04:43:30PM +0000, Lukas Straub wrote:
> After commit 0210097879 ("meta: time: use uint64_t instead of time_t")
> there is a compiler warning due to comparison of the return value from
> parse_iso_date with -1, which is now implicitly cast to uint64_t.
> 
> Fix this by making parse_iso_date take a pointer to the tstamp and
> return bool instead.

Applied, thanks
