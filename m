Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAD50C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Jul 2022 17:43:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234595AbiGRRne (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Jul 2022 13:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbiGRRnd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Jul 2022 13:43:33 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C881B2CDFE
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Jul 2022 10:43:31 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id w12so16301376edd.13
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Jul 2022 10:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b+gmIONhiXxkz2QJGmvVZScE/IgGuCeLYBs+pSoO9pY=;
        b=RGPUIhfoMFuO8Nz6WNTx5S6fXzIrWaujiJ8+ZVTxL0UMEI1w8YjhuXZASMY/1PkOEf
         wrDuh+xkXq2veGdBhkHADlnD4KK3QudpUdUqUjmMlq/vBQKFdgpt1N1bySIrbFRiMqRp
         J4wVHKuRL13W3MVrXhJqtIAOdKm6cxzUE9NHXqi9vJYyBI2WiBMGPxXA2P5dO9iazDwA
         F3iog7f555bBhhktMA8gyzP9Wz3NVFS3Q93ZkRP9hbfl5Loq/B/du4XHpXhcMQbQmvMt
         ZAa/A57EtA/Hz2P8PJkHCI5B/Sf4YdG/SG+J/fMPknvUi8mjM8GKfDPYvzEdQc+XdD97
         oVCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b+gmIONhiXxkz2QJGmvVZScE/IgGuCeLYBs+pSoO9pY=;
        b=gPBS6usXwfM5QJR7tDzn41zO32RMYBWEyAuEQRBPaW8FTmD8s/7KtbMtDe/RNPciZg
         GcXdkIuYfvcoFuaxArWXZvUtu74APIIj1n1fCXEM5+e65li80+Dh06g0SQgNB9G14CVy
         e4KcViv6e23xlNeeF87zdysx6c9n6cOrzu/JAvvd/rDAjn395UGDUa9/3Oo1iyZ1twiI
         geeTOd36/URnALKGNMp3yx5oI8Q3I+824JHLuM+TNAn/3Kh/ojiNW2UQxuHGFUv4WAg4
         RgS2e/sDg8x68hITmNtRtjLv5V1GYgVUZ9Zz27BoI+GNnU4aNrNYArBFqjg+Iquufurv
         NOeQ==
X-Gm-Message-State: AJIora9k3eWlFpPYPZT2sUL8FyIVfdKJBEMSD7F73mOAo/SUb9glWEN0
        TMghEoAQrFi1zSATp2di3u/WJ8LL4p4wx5r7Xx7QJg==
X-Google-Smtp-Source: AGRyM1vE21LyXnyQ/OrPc3rCfEUlrSagjLX1JjDE56Zzri+Os/07JIqlU6uqq/K10QqFVfs4y8jvMIl1/dbEDe2aMQs=
X-Received: by 2002:aa7:d9ce:0:b0:43a:6758:7652 with SMTP id
 v14-20020aa7d9ce000000b0043a67587652mr38817237eds.351.1658166210314; Mon, 18
 Jul 2022 10:43:30 -0700 (PDT)
MIME-Version: 1.0
References: <Ys3DwnYiF9eDwr2T@dev-arch.thelio-3990X> <20220712204900.660569-1-justinstitt@google.com>
In-Reply-To: <20220712204900.660569-1-justinstitt@google.com>
From:   Justin Stitt <justinstitt@google.com>
Date:   Mon, 18 Jul 2022 10:43:17 -0700
Message-ID: <CAFhGd8p2o45-mw50=4dPxmpKe5kZf2t_p=vpy7T5vZt3VUkYiA@mail.gmail.com>
Subject: Re: [PATCH v2] netfilter: xt_TPROXY: remove pr_debug invocations
To:     nathan@kernel.org
Cc:     coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
        fw@strlen.de, kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        ndesaulniers@google.com, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pabeni@redhat.com,
        pablo@netfilter.org, trix@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Any chance a maintainer could take a look at this patch? I am trying
to get it through this cycle and we are so close to enabling the
-Wformat option for Clang. There's only a handful of patches remaining
until the patch enabling this warning can be sent!
