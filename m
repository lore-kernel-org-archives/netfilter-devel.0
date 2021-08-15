Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75B74C4338F
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Aug 2021 12:11:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4311060EB2
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Aug 2021 12:11:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236645AbhHOMLd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 15 Aug 2021 08:11:33 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53110 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbhHOMLd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 Aug 2021 08:11:33 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 7FE346005D;
        Sun, 15 Aug 2021 14:10:17 +0200 (CEST)
Date:   Sun, 15 Aug 2021 14:10:59 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue v3 1/1] src: doc: Insert SYNOPSIS
 sections for man pages
Message-ID: <20210815121059.GA26159@salvia>
References: <20210813044436.16066-1-duncan_roe@optusnet.com.au>
 <20210813044436.16066-2-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210813044436.16066-2-duncan_roe@optusnet.com.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Aug 13, 2021 at 02:44:36PM +1000, Duncan Roe wrote:
> In order to work with the post-processing logic in doxygen/Makefile.am,
> SYNOPSIS sections must be inserted at the end of the module description
> (text after \defgroup or \addtogroup)
> (becomes Detailed Description in the man page).

Applied, thanks.
