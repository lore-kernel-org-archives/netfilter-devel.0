Return-Path: <SRS0=t5ds=XV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 749C6C432C2
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Sep 2019 00:06:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 529B0206B7
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Sep 2019 00:06:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387641AbfIZAGN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Sep 2019 20:06:13 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:59331 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387632AbfIZAGN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Sep 2019 20:06:13 -0400
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 3B45743E12D
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2019 10:05:59 +1000 (AEST)
Received: (qmail 27153 invoked by uid 501); 26 Sep 2019 00:05:58 -0000
Date:   Thu, 26 Sep 2019 10:05:58 +1000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libmnl] src: fix doxygen function documentation
Message-ID: <20190926000558.GA27134@dimstar.local.net>
Mail-Followup-To: Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel@vger.kernel.org
References: <20190925131418.7711-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190925131418.7711-1-ffmancera@riseup.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=PO7r1zJSAAAA:8 a=bBqXziUQAAAA:8 a=Q06VdbQw8Vxj73pipncA:9
        a=CjuIK1q_8ugA:10 a=BjKv_IHbNJvPKzgot4uq:22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 25, 2019 at 03:14:19PM +0200, Fernando Fernandez Mancera wrote:
> Currently clang requires EXPORT_SYMBOL() to be above the function
> implementation. At the same time doxygen is not generating the proper
> documentation because of that.
>
> This patch solves that problem but EXPORT_SYMBOL looks less like the Linux
> kernel way exporting symbols.
>
> Reported-by: Duncan Roe <duncan_roe@optusnet.com.au>
> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
> ---
>  src/attr.c     | 145 +++++++++++++++++++++----------------------------
>  src/callback.c |  14 ++---
>  src/internal.h |   3 +-
>  src/nlmsg.c    |  68 +++++++++--------------
>  src/socket.c   |  42 ++++++--------
>  5 files changed, 113 insertions(+), 159 deletions(-)
>
Why do we need EXPORT_SYMBOL anyway?

Cheers ... Duncan.
