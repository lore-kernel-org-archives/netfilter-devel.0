Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91E36C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 10:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61ACD60F45
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 10:08:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241522AbhIFKJu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Sep 2021 06:09:50 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39348 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241464AbhIFKJu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Sep 2021 06:09:50 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id CE12A6001C;
        Mon,  6 Sep 2021 12:07:40 +0200 (CEST)
Date:   Mon, 6 Sep 2021 12:08:41 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_log] src: consistently use `gh` in code,
 code snippets and examples
Message-ID: <20210906100841.GA12944@salvia>
References: <20210906041212.28886-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210906041212.28886-1-duncan_roe@optusnet.com.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Sep 06, 2021 at 02:12:12PM +1000, Duncan Roe wrote:
> i.e. rather than `qh` sometimes

Applied, thanks.
