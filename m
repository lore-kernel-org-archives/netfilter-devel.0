Return-Path: <SRS0=ECQ/=X7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FB44C4360C
	for <netfilter-devel@archiver.kernel.org>; Sun,  6 Oct 2019 20:45:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06C1C2077B
	for <netfilter-devel@archiver.kernel.org>; Sun,  6 Oct 2019 20:45:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbfJFUpR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 6 Oct 2019 16:45:17 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:48257 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725865AbfJFUpR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 6 Oct 2019 16:45:17 -0400
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 2467643FA1D
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Oct 2019 07:45:04 +1100 (AEDT)
Received: (qmail 16784 invoked by uid 501); 6 Oct 2019 20:45:04 -0000
Date:   Mon, 7 Oct 2019 07:45:04 +1100
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, ffmancera@riseup.net
Subject: Re: [PATCH] libmnl: doxygen: remove EXPORT_SYMBOL from the output
Message-ID: <20191006204504.GA4779@dimstar.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, ffmancera@riseup.net
References: <20191006174658.14069-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191006174658.14069-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=XobE76Q3jBoA:10
        a=3HDBlxybAAAA:8 a=PO7r1zJSAAAA:8 a=ka6nVi-J5l0Biw0LpC8A:9
        a=CjuIK1q_8ugA:10 a=laEoCiVfU_Unz3mSdgXN:22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Oct 06, 2019 at 07:46:58PM +0200, Pablo Neira Ayuso wrote:
> Add input filter to remove the internal EXPORT_SYMBOL macro that turns
> on the compiler visibility attribute.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  doxygen.cfg.in | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/doxygen.cfg.in b/doxygen.cfg.in
> index ee8fdfae97ce..31f01028aff6 100644
> --- a/doxygen.cfg.in
> +++ b/doxygen.cfg.in
> @@ -77,7 +77,7 @@ EXAMPLE_PATH           =
>  EXAMPLE_PATTERNS       =
>  EXAMPLE_RECURSIVE      = NO
>  IMAGE_PATH             =
> -INPUT_FILTER           =
> +INPUT_FILTER           = "sed 's/EXPORT_SYMBOL//g'"
>  FILTER_PATTERNS        =
>  FILTER_SOURCE_FILES    = NO
>  SOURCE_BROWSER         = YES
> --
> 2.11.0
>
Just tried this. Looks good.

Acked-by: Duncan Roe <duncan_roe@optusnet.com.au>
