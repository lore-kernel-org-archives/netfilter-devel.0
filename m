Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 629AEC4332F
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Oct 2021 17:00:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D46B615A7
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Oct 2021 17:00:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbhJURCx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Oct 2021 13:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbhJURCw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Oct 2021 13:02:52 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A072C061243
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Oct 2021 10:00:36 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id f5so850358pgc.12
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Oct 2021 10:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5RyUrXEQJgkpkS3LgGmg7QZzk/Xp6vh/AxqTCLe3xyo=;
        b=KrRrga5C/YO2dLe0TvqzGlGSYEQLjNmER7uhbG0b9kkxrtdRmWn1Nr9EZRKoCnCX6I
         t4NUngrX6gaK3GG/PDiRpl8xDbd2VtNkJLVHb7tdhwFJ+uypWCHF38OcH5/A2L2fMC6I
         vu+ScOMVCSX4SUjMU26XP9cvq+DRQoarq3J98=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5RyUrXEQJgkpkS3LgGmg7QZzk/Xp6vh/AxqTCLe3xyo=;
        b=Gih1QI9UpEsJy2WPfhjZcdFY8TcAYXwRBXs9OGHV25A5kraFZUnqy5QDjCr+rnClh9
         xuawIcIBCjPH0UyqMzAv0OxYL58FKPbpMvpvmM77l/CHZ+unvFK/B1v0YQ3i6SuR/DwC
         1EadKPCiDG7s7Q/5UPwJz7QAylph7KTjoHdSB0XoYaei4P1c6lJaNJ6Rr4xRjj4x4pg3
         aTrqMpQJNToyiJACmnCkdMM2BHEK7GOMQmlCM0jugnEfPPMLfrt9RR2SUdYeSd9Sx1HU
         ZMt3kBZZjqio0nd+1O8YVUGzna2rLMBJTxoQ6uQrAKl4kAjeOMCKwYLn8Y0oZwpNcESp
         wOWg==
X-Gm-Message-State: AOAM530+o+AIyjbw/Df+kaFDcOC+rNpfU3GOHCiNQzo7eGIXd8wZmi6s
        G/6AwAux4Vp47AUe7J8KuvxYeA==
X-Google-Smtp-Source: ABdhPJyp07wPRl6ojFhBTknpEQr+udO/xRkU+FJi/ud9R/y5lOsFr0ekXZoY1cF/hAYFZ5chiWTJxg==
X-Received: by 2002:a62:7a8b:0:b0:44d:47e2:99bf with SMTP id v133-20020a627a8b000000b0044d47e299bfmr6821186pfc.64.1634835635924;
        Thu, 21 Oct 2021 10:00:35 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id c12sm6843823pfc.161.2021.10.21.10.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 10:00:35 -0700 (PDT)
Date:   Thu, 21 Oct 2021 10:00:34 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][net-next] netfilter: ebtables: use array_size() helper
 in copy_{from,to}_user()
Message-ID: <202110210958.6626A30@keescook>
References: <20210928200647.GA266402@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928200647.GA266402@embeddedor>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Sep 28, 2021 at 03:06:47PM -0500, Gustavo A. R. Silva wrote:
> Use array_size() helper instead of the open-coded version in
> copy_{from,to}_user().  These sorts of multiplication factors
> need to be wrapped in array_size().
> 
> Link: https://github.com/KSPP/linux/issues/160
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks!

Reviewed-by: Kees Cook <keescook@chromium.org>

I see that this is marked "Awaiting Upstream" (for an ebtables
maintainer ack?)
https://patchwork.kernel.org/project/netdevbpf/patch/20210928200647.GA266402@embeddedor/

-- 
Kees Cook
