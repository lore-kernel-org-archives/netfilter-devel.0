Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C69F1C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 10:03:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A506060E94
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 10:03:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241733AbhIFKE7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Sep 2021 06:04:59 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39306 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241464AbhIFKE7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Sep 2021 06:04:59 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 017566001C;
        Mon,  6 Sep 2021 12:02:48 +0200 (CEST)
Date:   Mon, 6 Sep 2021 12:03:51 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_log 1/1] src: doc: Eliminate doxygen warnings
Message-ID: <20210906100351.GB12705@salvia>
References: <20210901082212.20830-1-duncan_roe@optusnet.com.au>
 <20210901082212.20830-2-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210901082212.20830-2-duncan_roe@optusnet.com.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 01, 2021 at 06:22:12PM +1000, Duncan Roe wrote:
> Most of these are functions that return a requested datum in an arg now,
> but when the documentation was written they returned the datum directly.
> Now these functions return 0 for success otherwise -1, so insert the new arg
> and fix the \return

Applied, thanks.
