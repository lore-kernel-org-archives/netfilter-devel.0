Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C30FC001B0
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Aug 2023 20:18:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235602AbjHJUSv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Aug 2023 16:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234996AbjHJUSu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Aug 2023 16:18:50 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14634272C
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Aug 2023 13:18:50 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1bc0d39b52cso9747205ad.2
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Aug 2023 13:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1691698729; x=1692303529;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3kJtbeMd1DC0iwf7dIt5vaIqCFoNN1NxlZ/NfDv5F7k=;
        b=FCF+Wwv3S/8SqhDJAVj3HEgDOxOPixLgcJvqdYQAH1j+YW245ZFcnvNZjGujwYtR0Q
         pn2gvaHu8I+Ng7lyB5MFXtbXBmVybora9cdXqKw8ZPiDnqRcELg9poV0ZQDoytGeUxh/
         NyhU472SfwlDvshlui960Ud23rM35VCRAtME8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691698729; x=1692303529;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3kJtbeMd1DC0iwf7dIt5vaIqCFoNN1NxlZ/NfDv5F7k=;
        b=TyQGGQLUccYYVJBnONchnqcHW+ZUS795uQL30QPLhG4Sb3sHkQ8RtjlzEvvr7VGwKG
         r8wFBf8TTaA3IZKtQa8E3oJMHcPCmiaDBrzvofG04hybPkAqvRz1HqpKzPo1oPHMigGe
         eppMSueSxovXW4S7XkjG1uMWEeORnv0vJWIPKho2KLVJ3rAiQ6MBx6JuRIMq8dytLIgc
         IH09iFgS70p0IKl3oEeeAgjstWfepGor1VqM8EC6UXbT4CEbhTElwGVSXBZyXCqVxqQR
         ccMjnguQkP8IlaIBUYNCPOyC1UUMgRa2Jcs23cn5ZoljZkymLHccpEypQNoGi2P10Zl2
         gPYQ==
X-Gm-Message-State: AOJu0YxLEXQAjKlOeMpneHLkIVbBENb2Yu4J8B+CkatL1T7LsNT+MxW4
        PUN+OYnRoqisXRfaz3WhH6tLhA==
X-Google-Smtp-Source: AGHT+IFT1Y7VV5nno22ITJV4ENgNNpdHnyB1CYiMpLWZvConebc8vMlqaaHPcnrsW/4L73D14eVMcQ==
X-Received: by 2002:a17:903:2285:b0:1b8:9044:b8ae with SMTP id b5-20020a170903228500b001b89044b8aemr3583313plh.11.1691698729615;
        Thu, 10 Aug 2023 13:18:49 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id x20-20020a170902ea9400b001b9de67285dsm2190933plb.156.2023.08.10.13.18.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 13:18:49 -0700 (PDT)
Date:   Thu, 10 Aug 2023 13:18:48 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "GONG, Ruiqi" <gongruiqi@huaweicloud.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-hardening@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Wang Weiyang <wangweiyang2@huawei.com>,
        Xiu Jianfeng <xiujianfeng@huawei.com>, gongruiqi1@huawei.com
Subject: Re: [PATCH] netfilter: ebtables: replace zero-length array members
Message-ID: <202308101317.7AAED4DF6A@keescook>
References: <20230809075136.1323302-1-gongruiqi@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230809075136.1323302-1-gongruiqi@huaweicloud.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 09, 2023 at 03:51:36PM +0800, GONG, Ruiqi wrote:
> From: "GONG, Ruiqi" <gongruiqi1@huawei.com>
> 
> As suggested by Kees[1], replace the old-style 0-element array members
> of multiple structs in ebtables.h with modern C99 flexible array.
> 
> [1]: https://lore.kernel.org/all/5E8E0F9C-EE3F-4B0D-B827-DC47397E2A4A@kernel.org/
> 
> Link: https://github.com/KSPP/linux/issues/21
> Signed-off-by: GONG, Ruiqi <gongruiqi1@huawei.com>

In theory, this should be fine. It is possible there are userspace tools
that are doing (already) buggy things that will now turn into build
failures. If the userspace ebtable tools still build happily with these
UAPI changes, I imagine that would be a sufficient test.

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
