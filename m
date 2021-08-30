Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BCE3C432BE
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Aug 2021 00:18:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60EEF6023F
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Aug 2021 00:18:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236117AbhH3ATI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 29 Aug 2021 20:19:08 -0400
Received: from mail.netfilter.org ([217.70.188.207]:38498 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236165AbhH3ATH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Aug 2021 20:19:07 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 5963E600A1;
        Mon, 30 Aug 2021 02:17:15 +0200 (CEST)
Date:   Mon, 30 Aug 2021 02:18:09 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue v2] build: doc: Eliminate warning from
 ./autogen.sh
Message-ID: <20210830001809.GA17206@salvia>
References: <20210828033508.15618-6-duncan_roe@optusnet.com.au>
 <20210829034551.16865-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210829034551.16865-1-duncan_roe@optusnet.com.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Aug 29, 2021 at 01:45:51PM +1000, Duncan Roe wrote:
> Replace shell function call with a list of sources

Applied, thanks.
