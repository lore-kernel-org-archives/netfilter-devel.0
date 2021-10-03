Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B63B8C433EF
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Oct 2021 02:35:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EF736120A
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Oct 2021 02:35:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbhJCChQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Oct 2021 22:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhJCChQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Oct 2021 22:37:16 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10233C0613EC
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Oct 2021 19:35:30 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id y5so8805401pll.3
        for <netfilter-devel@vger.kernel.org>; Sat, 02 Oct 2021 19:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=ChJfR6V8GIrwPeBgIIgXHtBMaNc2fC4M2iApmr1aj4c=;
        b=hfN6vPAYDXFwj5BhSEg+Vp0n5a+Gv+5Nc1UBI04wWphCCE6Ge3Lp+ClsHUk/hloBi7
         1xdQb9Fg9vse1uoDxSGVseEGXWqAbALom7ZJY7zEHAIfo1iw2gb+EtsTmNrQijMnXkzo
         ntGyVNesdRgOdEyTxYHgodNXhj4efuUk34fWsxWEzawfDfhThaaL7PfHGr4p1aS7GoNz
         S3CiypkVosm5zUjPVb6PtoW4qLKjKUMPof4UHcFRCOlTV81tOVeK93wbGwKEbU+T0Twr
         6PNPE+4N2WbF7Nu2Ua+KK2yfjNu/JWi6oM7Q28lBl5Hh9DV8RSlaiUiMY+XNViPnMyx1
         XdoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=ChJfR6V8GIrwPeBgIIgXHtBMaNc2fC4M2iApmr1aj4c=;
        b=dXPPJKhHyJXGiP5sf16dXwBva5gicpVCsmFZajwSvok9MahY1v//jiHCpYGjxsRObI
         jabCfGbh0rYDl+jpR/ACr4kJWzzijRb/bo/XfL3of8zkuk5Hnp4msYz0pPTfi0I5OTyF
         0iT7G0QT7v+2MiBgQK8RZHbwefqOfZzKaDYGU2vG3MGH25JAvMFYGIO7xPt4qFI55JkU
         tPJp2Pz01v6c+TAyTW4R/DHZrxKdW2iuqj9N1u8Lhy1nOwWGWnsnNQAlgDE5FFgIbdM9
         dqDDZTvbHCaxXVmUSTUDakN06HStgGHDSnNU3vUJb/O5/Z5jge9vTiFaLfRMKE8iwBKY
         l+SA==
X-Gm-Message-State: AOAM533Pc1rxvONxVXlk+DkqhOQIH3M94ZMP9OkL5Z3lIzMJIOvn+boP
        iQUjKKZ0Np6xMJKOh6uXjgmjMOqKUiw=
X-Google-Smtp-Source: ABdhPJwHjFrFOPUHLYMfQS80EJsh43Qu7DhK1xLAw1mxjERV2HJZsD2cJibyGEk6B7Ddgju1fY7IdA==
X-Received: by 2002:a17:90a:e7cd:: with SMTP id kb13mr28767395pjb.52.1633228529610;
        Sat, 02 Oct 2021 19:35:29 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id b20sm10018212pfp.26.2021.10.02.19.35.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 19:35:28 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Sun, 3 Oct 2021 13:35:25 +1100
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_log v2] build: doc: `make` generates
 requested documentation
Message-ID: <YVkW7a8ZiEHuHDYo@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210928022813.12582-1-duncan_roe@optusnet.com.au>
 <YVkRoxgmydehb4cu@slk1.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVkRoxgmydehb4cu@slk1.local.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

s +--enable-html-doc\+--enable-html-doc \+
