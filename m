Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 656E6C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Jan 2022 01:54:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbiADByp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Jan 2022 20:54:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231895AbiADByp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Jan 2022 20:54:45 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22AEEC061761
        for <netfilter-devel@vger.kernel.org>; Mon,  3 Jan 2022 17:54:45 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id v16so30125108pjn.1
        for <netfilter-devel@vger.kernel.org>; Mon, 03 Jan 2022 17:54:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=Y4plu3WhExwFHyx1iws6PKQBe2PBU56N+8McyX0sfUI=;
        b=W2TU5J5bhLkib8ohQ7BXr6jUcR0eD8yywV/ZGVormdIeiWWGnHhdbl29BZKLx9v+dB
         gWmIywtbG31QpvHSHyYpPN5iL6R1BkN68noghM6Tmn1XpajgDqAoUrZD3kPJejBIxluo
         XOdTlXS5HJWjDX2eWWt15Zclaa5rmXJbZB2z0xlAQkrq58/0XWlizBFhpjYX0yxd6ipI
         ZFwHEWcQTTy2Vlb5cfULJ85vj/xeA0PPZZzQBaaQ8jXWtYlRrIbeLIwW6yFZOIf8YNnq
         1ANXyElS6WE7h41de+SwS4f2cjVlOAAkdlC0OqFCA+1VuqKMSxymJ+G1M1u4+P16cD/C
         dfNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=Y4plu3WhExwFHyx1iws6PKQBe2PBU56N+8McyX0sfUI=;
        b=mgRKzy+yZQr9qo40voASWN6wF4XbBymKZtqgYRwGbO88ZtxjUsUG7BOB+pQndzO/Um
         PHfN8gLfW5zIPKNkiO53d8H4U/GOlPaqBXodiT6vR/f98rBTP902qwMG0ISQ6HcURyRl
         vJqfUA1AJP4Xffggsz1K3sraR//iV/73D7qf+sbrGVQmIXVFQEnEjYiEROPQeBp8ZoQd
         gGyLTVNka0MgPdJBpq0sz8mjU9BMgI8tDLzPjYFnh0As8cRAnu+fRMqKzTEZyC69P2Jl
         CP5LtSYQsMLjHJLF/HPVHANqZhR7ePuM1e/HcZ8qndXYjp8k+ILPiONWmxt0jMubwAIO
         vYAg==
X-Gm-Message-State: AOAM530Nb6BTi0cbQlITpovE3UQsKB9HgpI376VNTq2a4PoY94eu9bjn
        VU8B0bK2Lkccay5lNUlxnkXOZ2cAlJk=
X-Google-Smtp-Source: ABdhPJynAKPN1JV2HBTJ3kS12VLJmTaNsI2BZSgu6/gnYrfB0aIQvwomDn20F/5VoyC1yDQ4HxTcXg==
X-Received: by 2002:a17:902:904b:b0:143:73ff:eb7d with SMTP id w11-20020a170902904b00b0014373ffeb7dmr47611080plz.85.1641261284689;
        Mon, 03 Jan 2022 17:54:44 -0800 (PST)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id l145sm39398750pfd.117.2022.01.03.17.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 17:54:44 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Tue, 4 Jan 2022 12:54:39 +1100
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH libnetfilter_queue v3] build: doc: Update build_man.sh
 for doxygen 1.9.2
Message-ID: <YdOo354VbsdEwkx1@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
References: <20211219010936.25543-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211219010936.25543-1-duncan_roe@optusnet.com.au>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hey Pablo,

On Sun, Dec 19, 2021 at 12:09:36PM +1100, Duncan Roe wrote:
> Function del_def_at_lines() removes lines of the form:
>
>   Definition at line <nnn> of file ...
>
> At doxygen 1.9.2, <nnn> is displayed in bold, so upgrade the regex to match
> an optional bold / normal pair around <nnn>
>
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---
> v2: Expand commit message as pablo requested
> v3: same as v2 but has these vn: lines
>  doxygen/build_man.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/doxygen/build_man.sh b/doxygen/build_man.sh
> index 852c7b8..c68876c 100755
> --- a/doxygen/build_man.sh
> +++ b/doxygen/build_man.sh
> @@ -96,7 +96,7 @@ fix_double_blanks(){
>  del_def_at_lines(){
>    linnum=1
>    while [ $linnum -ne 0 ]
> -  do mygrep "^Definition at line [[:digit:]]* of file" $target
> +  do mygrep '^Definition at line (\\fB)?[[:digit:]]*(\\fP)? of file' $target
>      [ $linnum -eq 0 ] || delete_lines $(($linnum - 1)) $linnum
>    done
>  }
> --
> 2.17.5
>
You didn't apply this yet. Any reason (apart from being too busy)?

On the subject of being too busy, have you considered delegating supervision of
libnetfilter_queue to somebody else in the core team? I notice Florian W.
checked in a new examples/nf-queue.c yesterday.

Cheers ... Duncan.
