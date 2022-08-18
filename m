Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81946C00140
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Aug 2022 16:03:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343655AbiHRQDF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Aug 2022 12:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343623AbiHRQDE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Aug 2022 12:03:04 -0400
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA5CB6D5C
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Aug 2022 09:03:03 -0700 (PDT)
Received: by mail-vs1-xe33.google.com with SMTP id n125so1919813vsc.5
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Aug 2022 09:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=es4UE1ArAOheKl7p0uiizEehMlGRCszcDeK1tttnUaY=;
        b=FFXKux9rwjhtVVw/z0783hrp/gkTTl1wrE9gcx0X8ly3OwsXazDbLUXmTc/TMHq0Y/
         mkxyhlLLjkyMkb9XMmVFy/F1fbnebkHHvH+ndR4oKHUeIZOlwTEucr5WVmLmJOjlnig5
         ZfxgvMSRxhJhzEwyVyGVmGP5eGpvLUg9I8IynRoxGIaJFPa4PmWasguEePji8MlcaICj
         9Xc/sLIaXcsr1CYlNWuHHiYjZr+K6G686EOSQWh72wq39G7za/TfH9zJwUDIyZAmVl/q
         nrZTuzHgAUzIxEr9/lsZUdCV5OrxeUPgXZu9Zara1eRRhSYIzvCjt4QIcJY/LlzBcUug
         Ajpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=es4UE1ArAOheKl7p0uiizEehMlGRCszcDeK1tttnUaY=;
        b=MOK5dEu7Q7Od159XMLhEWjK29Et2g33zlwdgxEXrgz3+JWNWig08dA6EB9lUfQcLgk
         C22lBkj1iJerSEnz9QkYVsOTQj+xN2qApF8GXRsnMU8a3QyEJeCtYVsf4FgewEnNU+7Y
         0oGO+X6jlGlA5O9OeR33tL7gjvvRUmNJjO9OGMyu11asJvq/wfz2fXZYi9zZ4DPG1Rk7
         wdcuKfXRCLKq1WMbUGVTlOcwEu7rUkksLAMgfAI23or7rvd4pc42+gmJchUwLYAdwuYK
         hBhqcf70PfMyQ1+wksMyHmBvWezGrH4pjHmGHJotJwRdCjIB0/77T+xWX77BlVN6XQTT
         9Z7A==
X-Gm-Message-State: ACgBeo0nOreaBGLNOVlffLojtNaz6HTXul44P1n/gj5F9nqwwvdj6vRS
        h4/sgUoWiI01ULf7gAvBIqatbOuvYn9gBS9joed/FyGEbOtuaQ==
X-Google-Smtp-Source: AA6agR560eixS/bQtWWvEGmvUcqQNgnFYJyDs61EBTv4fsCYmMVIy+fvOCs0fGYlWvv5nEHCqm+44qv25Ml/kaMmcmI=
X-Received: by 2002:a67:d90c:0:b0:390:1de4:a64c with SMTP id
 t12-20020a67d90c000000b003901de4a64cmr609999vsj.31.1660838582602; Thu, 18 Aug
 2022 09:03:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220818100623.22601-1-shaw.leon@gmail.com> <20220818133231.GB24008@breakpoint.cc>
In-Reply-To: <20220818133231.GB24008@breakpoint.cc>
From:   Xiao Liang <shaw.leon@gmail.com>
Date:   Fri, 19 Aug 2022 00:02:26 +0800
Message-ID: <CABAhCOR-YpTt6YNhOvnf3dtVEDjx52SfRb-R_YvzntEp=yHb-Q@mail.gmail.com>
Subject: Re: [PATCH nft] src: Don't parse string as verdict in map
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 18, 2022 at 9:32 PM Florian Westphal <fw@strlen.de> wrote:
>
> Can you explain what this is fixing?

See this example:
table t {
    map foo {
        type ipv4_addr : verdict
        elements = {
            192.168.0.1 : bar
        }
    }
    chain output {
        type filter hook output priority mangle;
        ip daddr vmap @foo
    }
}

Though "bar" is not a valid verdict (should be "jump bar" or
something), the string is taken as the element value. Then
NFTA_DATA_VALUE is sent to the kernel instead of NFTA_DATA_VERDICT.
Recent kernel checks the type and returns error, but olders (e.g.
v5.4.x) doesn't, causing a warning when the rule is hit:

[5120263.467627] WARNING: CPU: 12 PID: 303303 at
net/netfilter/nf_tables_core.c:229 nft_do_chain+0x394/0x500
[nf_tables]

>
> This reverts the commit that adds support for defines as aliases:
>
> commit c64457cff9673fbb41f613a67e158b4d62235c09
> src: Allow goto and jump to a variable
>

This patch fixes it by parsing chain names as strings rather than
verdicts, i.e. "jump $var" is a verdict while "$var" is a string.
