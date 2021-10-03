Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B93C7C433EF
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Oct 2021 02:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C8BB615A4
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Oct 2021 02:12:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbhJCCOn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Oct 2021 22:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhJCCOn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Oct 2021 22:14:43 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7866C0613EC
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Oct 2021 19:12:56 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id s75so2292905pgs.5
        for <netfilter-devel@vger.kernel.org>; Sat, 02 Oct 2021 19:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=8bpRBiS53DEuO+1KzJSWRE1iyoWkXlLFUD2gMAk6Lz0=;
        b=WfxDJ6+RO4hKQUYWJImRl2oYz/Gh3iXeNTLOcc66tPH1+CDLybtHJzft93SBdlBt4G
         +Ohh3xz5VSqRAzlU3Iwun2IU2kCXft2K/zPV41x75OWN44JkCT/pfGzXzpyR7logyWbD
         8Q5MYVklPlXueNkINL7MUkqt2wfrcEi0Hp4b1bEVIpiSfDOvfcu82z42PO0VuwOILvae
         LVH6ORFFuCkWw+qNe9+yS6HD6D759+hZVRERLS1fpMHmKS0XKXh6PDSmcsCQiDz7rTwj
         AHIfAxx+sHIvbfh30j09c2JI/krFhaCCb6UDvNHU3K6diM1B7XfNgs29KBYOtvcOa6ar
         1OYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=8bpRBiS53DEuO+1KzJSWRE1iyoWkXlLFUD2gMAk6Lz0=;
        b=51pBC4EltIKm2Dq8oGmJxjdo8w2nv4UoJS9NJiTt63++87BU8kjbgSHgPSClFPriVb
         lvVJ/r2S0WI6yqO05crV9B23p+r6cYUcDGQehwFpYcjScmOvRUAguIvjoHb7rMeWOPWX
         ey/8ZspG+u0PxcUfuaOzFyQZvRar2BiUExwoSNIE30C7y8dakfT/Zu5p8RfhF6gVlcNa
         i03VNvxaXGDIAjPrvd7wd4zeQwX3ciYIKAnsz6vxxFJZjjxhO+4CEwz9xtTXQrtoAZli
         uGd+z2+3983mjFGBb2EdINZhZxBRSTiG5niMMZm3zAC2oXm2p1X4L06U40u45/0xDo9W
         mMGQ==
X-Gm-Message-State: AOAM533XPOJ5Z1rveZveLVhz/9wSheYHTwCFHP7WKj5/A5dTnj2qp8+U
        eOCGUnpDEp0ly1fTfaiSBnqVfzYB5Es=
X-Google-Smtp-Source: ABdhPJy7GQcB9qijfsvBVBGIZmfudjinbE+NWVljPzJ5UntZUhtNmPQ8gvSm13cigLFH1NhB8QCT6g==
X-Received: by 2002:a05:6a00:194e:b0:44c:bd:4f58 with SMTP id s14-20020a056a00194e00b0044c00bd4f58mr14797785pfk.7.1633227176148;
        Sat, 02 Oct 2021 19:12:56 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id g3sm10571232pgf.1.2021.10.02.19.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 19:12:55 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Sun, 3 Oct 2021 13:12:51 +1100
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_log v2] build: doc: `make` generates
 requested documentation
Message-ID: <YVkRoxgmydehb4cu@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210928022813.12582-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928022813.12582-1-duncan_roe@optusnet.com.au>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

This patch
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20210928022813.12582-1-duncan_roe@optusnet.com.au/
is all that's standing in the way of the next release of libnetfilter_log.

The size increase for defaulting man pages is modest:

> Configure command                  Installed package size (KB)
> ========= =======                  ========= ======= ==== ====
> ./configure --disable-man-pages    208
> ./configure                        260
> ./configure --enable-html-doc      848
> ./configure --enable-html-doc\
>             --disable-man-pages    800

I can see from the mailing list that you've been really busy. Perhaps someone
else could test or even review the patch?

Cheers ... Duncan.
