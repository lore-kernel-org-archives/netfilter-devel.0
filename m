Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AD62C432BE
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Aug 2021 09:10:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E2786115B
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Aug 2021 09:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233446AbhH1JLS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 28 Aug 2021 05:11:18 -0400
Received: from mail.netfilter.org ([217.70.188.207]:49384 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233661AbhH1JLQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 28 Aug 2021 05:11:16 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 440EA60119;
        Sat, 28 Aug 2021 11:09:28 +0200 (CEST)
Date:   Sat, 28 Aug 2021 11:10:21 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue v3 2/6] build: doc: Add a man page
 post-processor to build_man.sh
Message-ID: <20210828091021.GB31560@salvia>
References: <20210828033508.15618-1-duncan_roe@optusnet.com.au>
 <20210828033508.15618-2-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210828033508.15618-2-duncan_roe@optusnet.com.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Aug 28, 2021 at 01:35:04PM +1000, Duncan Roe wrote:
> - If there is a "Modules" section, delete it
> - If "Detailed Description" is empty, delete "Detailed Description" line
> - Reposition SYNOPSIS (with headers that we inserted) to start of page,
>   integrating with defined functions to look like other man pages
> - Delete all "Definition at line nnn" lines
> - Delete lines that make older versions of man o/p an unwanted blank line
> For better readability, shell function definitions are separated by blank
> lines, and there is a bit of annotation.

Also applied, thanks.

Please, in the future, let's try to avoid this multi-item patches, one
thing at a time the best for traceability.

Thanks.
