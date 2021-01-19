Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C59A9C433DB
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Jan 2021 08:02:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E6AC20773
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Jan 2021 08:02:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731361AbhASICT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Jan 2021 03:02:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731510AbhASICH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Jan 2021 03:02:07 -0500
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B97C061575
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Jan 2021 00:01:27 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 4D9286740186;
        Tue, 19 Jan 2021 09:01:24 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Tue, 19 Jan 2021 09:01:22 +0100 (CET)
Received: from localhost.kfki.hu (mentat.szhk.kfki.hu [148.6.240.32])
        (Authenticated sender: kadlecsik.jozsef@wigner.mta.hu)
        by smtp0.kfki.hu (Postfix) with ESMTPSA id 0145E674016D;
        Tue, 19 Jan 2021 09:01:21 +0100 (CET)
Received: by localhost.kfki.hu (Postfix, from userid 1000)
        id E2B7130024A; Tue, 19 Jan 2021 09:01:21 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by localhost.kfki.hu (Postfix) with ESMTP id DFE5D3001B5;
        Tue, 19 Jan 2021 09:01:21 +0100 (CET)
Date:   Tue, 19 Jan 2021 09:01:21 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Neutron Soutmun <neo.neutron@gmail.com>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] ipset: fix print format warning
In-Reply-To: <YAUVdnEg6OMPsUet@hydrogen>
Message-ID: <78385ce0-e237-4281-476e-b21e33a6169@netfilter.org>
References: <YAUVdnEg6OMPsUet@hydrogen>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Mon, 18 Jan 2021, Neutron Soutmun wrote:

> * Use PRIx64 for portablility over various architectures.
> * The format string for the 64bit number printing is incorrect,
>   the `%` sign is missing.
> * The force types casting over the uint32_t and uint64_t are unnecessary
>   which warned by the compiler on different architecture.
> 
> Signed-off-by: Neutron Soutmun <neo.neutron@gmail.com>

Thanks, patch is applied in the ipset git tree.

Best regards,
Jozsef

> ---
>  lib/print.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/print.c b/lib/print.c
> index 0d86a98..a7ffd81 100644
> --- a/lib/print.c
> +++ b/lib/print.c
> @@ -431,10 +431,10 @@ ipset_print_hexnumber(char *buf, unsigned int len,
>  				*(const uint16_t *) number);
>  	else if (maxsize == sizeof(uint32_t))
>  		return snprintf(buf, len, "0x%08"PRIx32,
> -				(long unsigned) *(const uint32_t *) number);
> +				*(const uint32_t *) number);
>  	else if (maxsize == sizeof(uint64_t))
> -		return snprintf(buf, len, "0x016lx",
> -				(long long unsigned) *(const uint64_t *) number);
> +		return snprintf(buf, len, "0x%016"PRIx64,
> +				*(const uint64_t *) number);
>  	else
>  		assert(0);
>  	return 0;
> --
> 2.30.0
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
