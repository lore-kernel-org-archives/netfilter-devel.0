Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B39FFC001DF
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jul 2023 13:02:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235415AbjG1NC1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Jul 2023 09:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235347AbjG1NC0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Jul 2023 09:02:26 -0400
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2DF35BF
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jul 2023 06:02:24 -0700 (PDT)
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-3fbc54cab6fso21353475e9.0
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jul 2023 06:02:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690549342; x=1691154142;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q+jGkpGvbARzAeVQC2sjUEioPEiA7L/Y+zph2hUUlS8=;
        b=B6TyeLJuZNa/OCOYNfZFvv3Uu/iZi0hsPdVcl+44cpoPPKkQP9GeWYultT0nKIzOUM
         /hn9Q3NZqsCShPDJYwKEDYhZyqqJJx1eqtRqMRKkEJAB8sl9yvGGbNqeRZO0tP/jJbYj
         U4x7+WoS5TQFXUgQIlMLkAGbcso/Nfwf66ih1H8Gqr1+/kpeKLeFEhORIqRUc5c/mtK5
         Cus4t1YcaSWcUGjtE2IoPVowF/d1E9SoCkSwQYhBjM6iIYihXLi4t23BJcPdX8gd6RHQ
         2TWnJFypq+PEWCsz5/S2GhHFFPqUQb7c9PfUinYkCAi1auDsNwiYDeOZxHUhOG2rlnJ+
         7abw==
X-Gm-Message-State: ABy/qLaWuY6huLkvKQIZiRsOVFm+09q+SIyV/zQPTA/RyGFVw/U2aZAB
        Rmz0WIJmpiVKFvi4gWMSTdJI0XJPwKresA==
X-Google-Smtp-Source: APBJJlFzqlre+TygMzVBQ7qWGI2YEDAakH05uQJi0mx7CwNAYnQRWNAMNvS1kEBC9JXWX76ADpo4NQ==
X-Received: by 2002:a05:600c:2a54:b0:3f6:91c:4e86 with SMTP id x20-20020a05600c2a5400b003f6091c4e86mr1671849wme.3.1690549342410;
        Fri, 28 Jul 2023 06:02:22 -0700 (PDT)
Received: from ?IPV6:2a0c:5a85:a105:cd00:d7be:a50b:963e:188e? ([2a0c:5a85:a105:cd00:d7be:a50b:963e:188e])
        by smtp.gmail.com with ESMTPSA id l23-20020a7bc457000000b003fc02219081sm4095498wmi.33.2023.07.28.06.02.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Jul 2023 06:02:21 -0700 (PDT)
Message-ID: <a4a1f734-f182-d85e-86eb-b2bfd0807771@netfilter.org>
Date:   Fri, 28 Jul 2023 15:02:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH nft 2/2] py: remove setup.py integration with autotools
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     jengelh@inai.de
References: <20230718120119.172757-1-pablo@netfilter.org>
 <20230718120119.172757-2-pablo@netfilter.org>
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
In-Reply-To: <20230718120119.172757-2-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 7/18/23 14:01, Pablo Neira Ayuso wrote:
> With Python distutils and setuptools going deprecated, remove
> integration with autotools. This integration is causing issues
> in modern environments.
> 
> Note that setup.py is still left in place under the py/ folder.
> 
> Update INSTALL file to refer to Python support and setup.py.
> 
> Signed-off-by: Pablo Neira Ayuso<pablo@netfilter.org>
> ---
>   INSTALL        |  7 +++++++
>   Makefile.am    |  6 ++----
>   configure.ac   | 26 --------------------------
>   py/Makefile.am | 27 ---------------------------
>   4 files changed, 9 insertions(+), 57 deletions(-)

I think this patch can be merged.

regards.
