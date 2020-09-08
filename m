Return-Path: <SRS0=572t=CR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 633EBC43461
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Sep 2020 09:52:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F9032078B
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Sep 2020 09:52:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728739AbgIHJwS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Sep 2020 05:52:18 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:48032 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728137AbgIHJwS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Sep 2020 05:52:18 -0400
Received: from dimstar.local.net (n49-192-70-185.sun3.vic.optusnet.com.au [49.192.70.185])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id D14913A7DE5
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Sep 2020 19:52:12 +1000 (AEST)
Received: (qmail 15524 invoked by uid 501); 8 Sep 2020 09:52:12 -0000
Date:   Tue, 8 Sep 2020 19:52:12 +1000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue] build: check whether dot is available
 when configuring doxygen.
Message-ID: <20200908095212.GA15387@dimstar.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
References: <20200907012255.GC6585@dimstar.local.net>
 <20200907103904.238656-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200907103904.238656-1-jeremy@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=IuRgj43g c=1 sm=1 tr=0 cx=a_idp_d
        a=zRnOCfNoldqEzXEIOSrMkw==:117 a=zRnOCfNoldqEzXEIOSrMkw==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=RSmzAf-M6YYA:10 a=Vf8oi9PKAAAA:8
        a=PO7r1zJSAAAA:8 a=dtCN6onX1elXJH_x-r0A:9 a=CjuIK1q_8ugA:10
        a=s-HcpGhzF3c4NlUTCjwJ:22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Sep 07, 2020 at 11:39:04AM +0100, Jeremy Sowden wrote:
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> ---
>  configure.ac   | 4 ++++
>  doxygen.cfg.in | 2 +-
>  2 files changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/configure.ac b/configure.ac
> index d8d1d387c773..32e499071b26 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -41,6 +41,10 @@ AC_ARG_WITH([doxygen], [AS_HELP_STRING([--with-doxygen],
>  	    [], [with_doxygen=no])
>  AS_IF([test "x$with_doxygen" = xyes], [
>  	AC_CHECK_PROGS([DOXYGEN], [doxygen])
> +	AC_CHECK_PROGS([DOT], [dot], [""])
> +	AS_IF([test "x$DOT" != "x"],
> +	      [AC_SUBST(HAVE_DOT, YES)],
> +	      [AC_SUBST(HAVE_DOT, NO)])
>  ])
>
>  AM_CONDITIONAL([HAVE_DOXYGEN], [test -n "$DOXYGEN"])
> diff --git a/doxygen.cfg.in b/doxygen.cfg.in
> index 3f13f97ad8ba..c54f534ada3f 100644
> --- a/doxygen.cfg.in
> +++ b/doxygen.cfg.in
> @@ -161,7 +161,7 @@ PERL_PATH              = /usr/bin/perl
>  CLASS_DIAGRAMS         = YES
>  MSCGEN_PATH            =
>  HIDE_UNDOC_RELATIONS   = YES
> -HAVE_DOT               = YES
> +HAVE_DOT               = @HAVE_DOT@
>  CLASS_GRAPH            = YES
>  COLLABORATION_GRAPH    = YES
>  GROUP_GRAPHS           = YES
> --
> 2.28.0
>
Tested-by: Duncan Roe <duncan_roe@optusnet.com.au>
