Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EAD8C19F29
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Aug 2022 03:27:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233267AbiHDD1H (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Aug 2022 23:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbiHDD1F (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Aug 2022 23:27:05 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE91927FEE
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Aug 2022 20:27:02 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id f65so16788162pgc.12
        for <netfilter-devel@vger.kernel.org>; Wed, 03 Aug 2022 20:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc;
        bh=x09574+pXCwiGrXT2tPSSjDuO0yVXoTOMcQhYtQJwjo=;
        b=ip9mIO4HYjcqdfZNUZrLRUPCrU5rL3vBSc+qA79VF7Izx42YyUJb5+kmUzyRRYw2R0
         Hw1iV+7ewMuLrpu+9A25nFGBP+OX+IeE+eJ7BRh8BAQvYWRFAA6TELkJ+RW5t3la5gMl
         gVFF3XNy/WofnOmreO9GvXEe+eUQCTDT5fjWlHM8FgccgACgd0hNnRNs21SmK5O+q5mV
         zP1RsdSEaeVUT2rkWaMCX8GqtLFccGE2Q72jA/e6Hynppc6FNBEapbhfDygXGJyG3oZE
         qElaIcsgBqf3MrgtW93ly1Jm3CLZtltya6zzm1PkOrmycwc1tMKf+y3xxMejmTiwEm7n
         HMXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc;
        bh=x09574+pXCwiGrXT2tPSSjDuO0yVXoTOMcQhYtQJwjo=;
        b=imPVXu7pHtMri9KVR7ikzF3jBkwH9sEJPA3cHi3NTTtEBOlMzAuywK2//bo3I0m4qC
         zXBN/QRmnlBbTpJVE6sZ31dX0I02JV3qIlOQWDbmQrS6+v9nY/9kANFHw8GDJAqdbWC4
         rEkZZJBmoYPdwS22jYD1RRtPBe5fSZHJHls7+XilCBpw4wZATmAShpH9MhnIDQIDOkb0
         Tzgvw5FEWut1O9fmLLJ8R8Rstask96NDK818tUFl7y21sT9rOVjsv3PAQcInUEaFrcQU
         3YCI0cG6jySifDcI7T7NSgWiCxLn/vUW7Ai/GC+v1h4FVNfCht6mCS0QufvL9dRc4V8G
         IFpQ==
X-Gm-Message-State: AJIora+rOu/HWzrXyiQbNVtzLrO+VQuM9owp1GJv7kV8vRQGJ3Zl0LZ2
        6AD8q5QUfvZDNjHmRW+ld58XUy0B2qc=
X-Google-Smtp-Source: AGRyM1sGz8TJD6BDDAWwrqcMCahU6AamjVDl3XZ3i8uUZ9Qe26QoXokBThE48SpFN4N8BUV+KTd1yw==
X-Received: by 2002:a63:4608:0:b0:41a:617f:e194 with SMTP id t8-20020a634608000000b0041a617fe194mr24299827pga.152.1659583621775;
        Wed, 03 Aug 2022 20:27:01 -0700 (PDT)
Received: from slk15.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id a1-20020a170902ecc100b0016be681f008sm2779093plh.290.2022.08.03.20.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 20:27:01 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date:   Thu, 4 Aug 2022 13:26:57 +1000
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Cc:     Mark Mentovai <mark@mentovai.com>
Subject: Re: [PATCH libmnl] build: doc: refer to bash as bash, not /bin/bash
Message-ID: <Yus8gaO78GKDROy1@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Netfilter Development <netfilter-devel@vger.kernel.org>,
        Mark Mentovai <mark@mentovai.com>
References: <20220801172620.34547-1-mark@mentovai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801172620.34547-1-mark@mentovai.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

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
Acked-by: Duncan Roe <duncan_roe@optusnet.com.au>
