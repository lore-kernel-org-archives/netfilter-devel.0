Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 007D2C4338F
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Aug 2021 10:39:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7E0F610A2
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Aug 2021 10:39:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbhHAKjh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 1 Aug 2021 06:39:37 -0400
Received: from mail.netfilter.org ([217.70.188.207]:47824 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbhHAKjg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 1 Aug 2021 06:39:36 -0400
Received: from netfilter.org (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 389AD60033;
        Sun,  1 Aug 2021 12:38:54 +0200 (CEST)
Date:   Sun, 1 Aug 2021 12:39:23 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libmnl] build: doc: get rid of the need for manual
 updating of Makefile
Message-ID: <20210801103923.GA1103@salvia>
References: <20210718034722.25321-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210718034722.25321-1-duncan_roe@optusnet.com.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jul 18, 2021 at 01:47:22PM +1000, Duncan Roe wrote:
> There used to be 3 things in doxygen/Makefile.am that developers had to update:
> 
> 1. The dependency list (i.e. all C sources)
> 
> 2. The setgroup lines, which renamed each module man page to be the page for the
>    first described function. setgroup also set the target for:
> 
> 3. The add2group lines, which symlinked pages for other documented functions
>    in the group.
> 
> The new system eliminates all of the above.

Applied, thanks.
