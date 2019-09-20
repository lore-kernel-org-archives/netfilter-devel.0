Return-Path: <SRS0=NOIG=XP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4158C49ED7
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Sep 2019 10:19:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A619D2086A
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Sep 2019 10:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408642AbfITKTI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Sep 2019 06:19:08 -0400
Received: from correo.us.es ([193.147.175.20]:37746 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408634AbfITKTH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Sep 2019 06:19:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6F23517989F
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2019 12:19:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5EA3CB8001
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2019 12:19:03 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5420DDA72F; Fri, 20 Sep 2019 12:19:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 46F94DA7B6;
        Fri, 20 Sep 2019 12:19:01 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 20 Sep 2019 12:19:01 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [5.182.56.138])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E717B42EE38E;
        Fri, 20 Sep 2019 12:19:00 +0200 (CEST)
Date:   Fri, 20 Sep 2019 12:19:01 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Sebastian Priebe <sebastian.priebe@de.sii.group>
Subject: Re: [PATCH RFC nftables 4/4] cli: add linenoise CLI implementation.
Message-ID: <20190920101901.tvnec3seyaonhmts@salvia>
References: <4df20614cd10434b9f91080d0862dd0c@de.sii.group>
 <20190916124203.31380-1-jeremy@azazel.net>
 <20190916124203.31380-5-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916124203.31380-5-jeremy@azazel.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Sep 16, 2019 at 01:42:03PM +0100, Jeremy Sowden wrote:
[...]
> diff --git a/configure.ac b/configure.ac
> index 68f97f090535..347f3b0cc772 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -68,14 +68,23 @@ AC_CHECK_LIB([gmp],[__gmpz_init], , AC_MSG_ERROR([No suitable version of libgmp
>  AM_CONDITIONAL([BUILD_MINIGMP], [test "x$with_mini_gmp" = xyes])
>  
>  AC_ARG_WITH([cli], [AS_HELP_STRING([--without-cli],
> -            [disable interactive CLI (libreadline support)])],
> -            [], [with_cli=yes])
> -AS_IF([test "x$with_cli" != xno], [
> +            [disable interactive CLI (libreadline or linenoise support)])],
> +            [], [with_cli=readline])
> +
> +AS_IF([test "x$with_cli" = xreadline], [
>  AC_CHECK_LIB([readline], [readline], ,
> -	     AC_MSG_ERROR([No suitable version of libreadline found]))
> +        AC_MSG_ERROR([No suitable version of libreadline found]))
>  AC_DEFINE([HAVE_LIBREADLINE], [1], [])
> +],
> +      [test "x$with_cli" = xlinenoise], [
> +AH_TEMPLATE([HAVE_LINENOISE], [])
> +AC_DEFINE([HAVE_LINENOISE], [1], [])
> +],
> +      [test "x$with_cli" != xno], [
> +AC_MSG_ERROR([unexpected CLI value: $with_cli])
>  ])
>  AM_CONDITIONAL([BUILD_CLI], [test "x$with_cli" != xno])
> +AM_CONDITIONAL([BUILD_CLI_LINENOISE], [test "x$with_cli" = xlinenoise])
>  
>  AC_ARG_WITH([xtables], [AS_HELP_STRING([--with-xtables],
>              [Use libxtables for iptables interaction])],
> @@ -118,6 +127,7 @@ AM_CONDITIONAL([HAVE_PYTHON], [test "$enable_python" != "no"])
>  AC_CONFIG_FILES([					\
>  		Makefile				\
>  		libnftables.pc				\
> +		linenoise/Makefile			\
>  		src/Makefile				\
>  		include/Makefile			\
>  		include/nftables/Makefile		\

You also have to update this code after AC_OUTPUT in configure.in to
display libnoise, right?

echo "
nft configuration:
  cli support:                  ${with_cli}
  enable debugging symbols:     ${enable_debug}
  use mini-gmp:                 ${with_mini_gmp}
  enable man page:              ${enable_man_doc}
  libxtables support:           ${with_xtables}
  json output support:          ${with_json}"
