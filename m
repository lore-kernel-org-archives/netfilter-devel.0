Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE944C4338F
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Aug 2021 12:15:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B17760FD8
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Aug 2021 12:15:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbhHOMPo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 15 Aug 2021 08:15:44 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53130 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237569AbhHOMPn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 Aug 2021 08:15:43 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id E0E886005D;
        Sun, 15 Aug 2021 14:14:26 +0200 (CEST)
Date:   Sun, 15 Aug 2021 14:15:09 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue v2] build: doc: Fix NAME entry in man
 pages
Message-ID: <20210815121509.GA9606@salvia>
References: <20210810024001.12361-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210810024001.12361-1-duncan_roe@optusnet.com.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 10, 2021 at 12:40:01PM +1000, Duncan Roe wrote:
> Make the NAME line list the functions defined, like other man pages do.
> Also:
> - If there is a "Modules" section, delete it
> - If "Detailed Description" is empty, delete "Detailed Description" line
> - Reposition SYNOPSIS (with headers that we inserted) to start of page,
>   integrating with defined functions to look like other man pages
> - Delete all "Definition at line nnn" lines
> - Delete lines that make older versions of man o/p an unwanted blank line
> - Insert spacers and comments so Makefile.am is more readable
> 
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---
> v2: Delete lines that make older versions of man o/p an unwanted blank line
>  doxygen/Makefile.am | 172 ++++++++++++++++++++++++++++++++++++++++++++

Time to add this to an independent fixup shell script for
doxygen-based manpages that Makefile.am could call instead?

This script could be imported by other libraries too, so it only needs to
be downloaded from somewhere to be refreshed to keep it in sync with
latest.

The git tree could cache a copy of this script.

Could you have a look into this?

Thanks.
