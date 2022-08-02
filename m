Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00B90C00144
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Aug 2022 00:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235439AbiHBAjY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Aug 2022 20:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235427AbiHBAjX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Aug 2022 20:39:23 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19DA1115B
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Aug 2022 17:39:21 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id 17so12164200pfy.0
        for <netfilter-devel@vger.kernel.org>; Mon, 01 Aug 2022 17:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc;
        bh=2PZ9MZHEEcehgk+QcOf0/abE6T0OJ9WkR3iYnwhkk74=;
        b=oad6bzm+CRqbHB/+IVkXN4enpHKebxmspH7xABEj1b1l5GifrV5H9NRi2I3rWqnDd5
         sOdMuw/wUediu1weVrO+RdEI68vjCeiRZJpOl2GON9jcYLBEVQMjmbWy7VhSb5rNSmxE
         SYYn9TfGLP4ONVmUnSPhfwyDT8+cywrTfTxYjoNEcXly2bc6PSw2HhjF5u0MERwtHs0F
         ffhZywL9eMFlTOA0j3gQS6cis0vRuyAdQuNwSyBtLTFmc+nvavcHvaQYAXW92bkZb6JZ
         cslxXAewm6cFiWgKDggh5BfBfZmlmaozQlWeXSCggekTPEFZ8r+/Ityt2pLv75reOFCU
         6CeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc;
        bh=2PZ9MZHEEcehgk+QcOf0/abE6T0OJ9WkR3iYnwhkk74=;
        b=SKuOCL25P2e4EuszEr7MAXmajI3VPGnIzyJzC9P3xGxI02Se6wRlAfQn2etiNbWIW7
         f1rpKQTjUmt2LS7ka8Qo5+uO8wUeApUsS5WiYrCwC8RSVjsJxxLLvRN5/jkJX+L3aYvW
         lknfUxfSZ77oYX5wNkCjMSEQtYr4f6dEa4m0VlDxNfkt0nhA07Xr+zXUT+rCPkPL/qcm
         6SieAJ7Cs2nppYeRBZPF9Bad2ZxiWcWFHSC/C71L5Sc/hu1Zq62CfMfLbJ8WpX1yyiFk
         RLSo1yoLRyxCUQcBxskgJptnhdKk2i2X6e9BIBDdmuiLONpb7IUDMWXEW5BXzQPBFL+S
         Ll9A==
X-Gm-Message-State: AJIora8ic1OysuZBLxJt6cIIU4RNgg9rQDoBfYBuk5sR/BG8UWpjUUTd
        RwJO8Qoa6Mzuz7xSUYtd08dIPyPB3As=
X-Google-Smtp-Source: AA6agR4HLmk248nb2444RzrIox96RXM8ySk6BmYemCm7TAhjgqV0P87JWzqL1jKQrahZ6okC8kanPQ==
X-Received: by 2002:a05:6a00:27a1:b0:52b:a08:fe02 with SMTP id bd33-20020a056a0027a100b0052b0a08fe02mr18367083pfb.75.1659400761123;
        Mon, 01 Aug 2022 17:39:21 -0700 (PDT)
Received: from slk15.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id d197-20020a621dce000000b0052dbd779bdbsm1285035pfd.168.2022.08.01.17.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 17:39:19 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date:   Tue, 2 Aug 2022 10:39:15 +1000
To:     Mark Mentovai <mark@mentovai.com>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libmnl] build: doc: refer to bash as bash, not /bin/bash
Message-ID: <YuhyM1TE7a/vTjFu@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Mark Mentovai <mark@mentovai.com>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20220801172620.34547-1-mark@mentovai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801172620.34547-1-mark@mentovai.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Mark,

On Mon, Aug 01, 2022 at 01:26:20PM -0400, Mark Mentovai wrote:
> This locates bash according to its presence in the PATH, not at a
> hard-coded path which may not exist or may not be the most suitable bash
> to use.
>
> Signed-off-by: Mark Mentovai <mark@mentovai.com>
> ---
>  doxygen/Makefile.am | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
> index 29078dee122a..189a233f3760 100644
> --- a/doxygen/Makefile.am
> +++ b/doxygen/Makefile.am
> @@ -21,7 +21,7 @@ doxyfile.stamp: $(doc_srcs) Makefile.am
>  # The command has to be a single line so the functions work
>  # and so `make` gives all lines to `bash -c`
>  # (hence ";\" at the end of every line but the last).
> -	/bin/bash -p -c 'declare -A renamed_page;\
> +	bash -p -c 'declare -A renamed_page;\
>  main(){ set -e; cd man/man3; rm -f _*;\
>    count_real_pages;\
>    rename_real_pages;\
> --
> 2.37.1
>
I would not apply this patch unless it's actually necessary for some
distribution.

If you have discovered a distribution where /bin/bash doesn't work, please let
us know.

Scripts that start "#!/bin/bash" are not uncommon, and Netfilter already has a
couple of these, in libnetfilter_queue and libnetfilter_log.

I somehow omitted to update libmnl to replace the cumbersome embedded script in
Makefile.am with a stand-alone script, but you've reminded me.

Cheers ... Duncan.
