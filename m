Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C9D4C4338F
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Aug 2021 03:52:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D842861185
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Aug 2021 03:52:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbhHGDwc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Aug 2021 23:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbhHGDwc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Aug 2021 23:52:32 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86390C0613CF
        for <netfilter-devel@vger.kernel.org>; Fri,  6 Aug 2021 20:52:15 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id pj14-20020a17090b4f4eb029017786cf98f9so20925846pjb.2
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Aug 2021 20:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=tXcdy8hm7HKlC5Y5cFaR+kT8difu2mjIyTPQ+OXqO6s=;
        b=g2zVPAVnce71UKnSymW75fQ5ThEXZ6ku1HyRCqxo/hk+nnq+Ib0Lb45rkHubB0XpJC
         2hGMNgxGdZlqmKDldbb3tz/btzh5ijMssDYjDA+UOYxUyMyINH8GFp8KewNbkFa6COAK
         q3A0+YZNqnzlJgq0sCCBGt+0kq1nbN8WI/hhff5oxVjVjRPdm77EC2GFP7Kr5OjTrrOW
         XCuZMorUO1XSK9aSZjxvMMEUeHdF6FwLPVxvWfWokFL0c3kun+xBsvYvOEskNoquoUR5
         Wrh1IsXBirF8+BN8x6wz4IoRc8NaWi7PLmX4Nv/WDFnqhx7FfMlyZZbTHjUj1HGfN4ju
         Or2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=tXcdy8hm7HKlC5Y5cFaR+kT8difu2mjIyTPQ+OXqO6s=;
        b=QThWmozEoP03sYVrSaQmlzIVQ9A04TNtgPOiHIjTPVutY+G1x9AX9hNlUVzWu0obRV
         HBQx5T8ahZTj9dW9iSPpRTXbWGjv012MQUP7zTtUDSpwnpNbPqFLkEz+ZP6ejmMBstxH
         PKSCxK9gzCguU7bpo0PyS6a0xXilmWEqbw0G3Jy1iVxSB82H+5baVwFV0vhVIywM/Wny
         gKuhLcl4cg9iT4Wp7m5H19aiMsF/ficBfZp+c3s4CpPW6zmiTOXBPuTjxrMcl3/x7JB1
         Ftv78xwAN2D3Sc+FSPX/irna74pna5SQrfWX21bAcAj/mBWx4Z78o2Rv13dFDg0j4YN4
         8rDw==
X-Gm-Message-State: AOAM530RGO3WMkM/q8WHnzrZLVOv4ZaG+AK5GaPE0aXlMKETmBmqy6oN
        IcErJPr3n6xl7369yqCkBwo=
X-Google-Smtp-Source: ABdhPJxZpmeCRSZXSsUNI5sMpX7uLTyJz7ZR1wMcGwSHUvEBYRt5Q0/nJZW4MsEEpX8TCKghRvzzSA==
X-Received: by 2002:a17:902:b78b:b029:12c:6f89:51aa with SMTP id e11-20020a170902b78bb029012c6f8951aamr11426650pls.3.1628308335146;
        Fri, 06 Aug 2021 20:52:15 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id w10sm14363239pgl.46.2021.08.06.20.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 20:52:14 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Sat, 7 Aug 2021 13:52:10 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue] build: If doxygen is not available,
 be sure to report "doxygen: no" to ./configure
Message-ID: <YQ4DaoPKEO+OHgkj@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210806083840.440-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806083840.440-1-duncan_roe@optusnet.com.au>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Aug 06, 2021 at 06:38:40PM +1000, Duncan Roe wrote:
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---
>  configure.ac | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/configure.ac b/configure.ac
> index bdbee98..cf50003 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -52,6 +52,7 @@ AM_CONDITIONAL([HAVE_DOXYGEN], [test -n "$DOXYGEN"])
>  AS_IF([test "x$DOXYGEN" = x], [
>  	dnl Only run doxygen Makefile if doxygen installed
>  	AC_MSG_WARN([Doxygen not found - continuing without Doxygen support])
> +	with_doxygen=no
>  ])
>  AC_OUTPUT
>
> --
> 2.17.5
>
Scrub this - v2 on its way (Bogus warning on --without-doxygen)
