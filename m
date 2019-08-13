Return-Path: <SRS0=20ch=WJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A2C2C433FF
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 20:01:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4911D205C9
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 20:01:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h24OF7fP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbfHMUBh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Aug 2019 16:01:37 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35951 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbfHMUBh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Aug 2019 16:01:37 -0400
Received: by mail-pf1-f195.google.com with SMTP id w2so1389566pfi.3
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2019 13:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g5nPc1W/N98xXzSNDQkNTDsAdPrCAi2NWn4AyoXeSj0=;
        b=h24OF7fPd+qWT4zu2n//F7tYH6Z4141YQz4OU9miWMzHahqrt+Rox92s1eZ6xIIJkr
         N18WOE/12Pz1Gnx4ylQMSXmsT/HWrJkuc4R8mFqapxNzV27N7nZDf8WE8RC1tkVUW7B8
         yH9D08xZKDgMWFkKGeCNiPkynGXPts1ij3qhO/SIQp4ZVjk8CvUM5BCHSWJB+c5O+3fG
         MGMDcwj7zzLDAzSyDMYifAIRj/B6Wizj73evQs91SuKvf783xd+SmFkbZkOkGaNaHrQC
         Z01cdwvzzXCbW8TU7OR8DlWONBDrqAXesPJJgAONxNdHGJanxJRVUg837yk1ptcwSiOa
         akLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g5nPc1W/N98xXzSNDQkNTDsAdPrCAi2NWn4AyoXeSj0=;
        b=SHdtjhUNJe24ZWw+bBCMZl4nJXC36WQFvmkTYRghqwumPq7ebWieGBpiwOzdiZP/FF
         Y+qNAfaRbNDGQZsM4STFN75T/jqQ83S1ClDPW2Ev+Elvav3ngynB4a8Rm2hwP1TrJdaz
         jwWV9ievC9WMVVIvzl3vXwJt8uJCelTDH8xl05LzH4gAbdYqo/orScTktDP5IW1CUlRk
         +cpJX/dYwcG1t4OK6jCE0zuMcbHoudiB2lhYvNs9FR0dqjsEMfslvzCWD6DgK2wW0Z9v
         QamKHumTE9WORpQRog3EeN2NvpP+hQv63Y+evYfRs18d7JapFH8rZew+Y3nTm701o8Zj
         ZyLg==
X-Gm-Message-State: APjAAAWKl1b0sK21wI0wBRr6rF6u7zvD4cm12qhlUnVuaGErORY7Kluu
        3SWSq4QUy5mqGWVRNnPg/JpQapNWZyYDCIgQzaceMA==
X-Google-Smtp-Source: APXvYqwZQvFjkxhQ0EhbRfDsU9tXAn1oQ6hGg4N2zFcw01BTQocMY5wVYwZcKkZee6EWiiDMzCUMnVv+59XzgaBDzAY=
X-Received: by 2002:a17:90a:7304:: with SMTP id m4mr3817384pjk.73.1565726496495;
 Tue, 13 Aug 2019 13:01:36 -0700 (PDT)
MIME-Version: 1.0
References: <201908140300.REaRIkQ8%lkp@intel.com>
In-Reply-To: <201908140300.REaRIkQ8%lkp@intel.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 13 Aug 2019 13:01:25 -0700
Message-ID: <CAKwvOdkHTfFzypb04LvKKx5h6QzcSueZeoHaG-RUE=x1jN=Bpg@mail.gmail.com>
Subject: Re: [nf-next:master 5/17] net/netfilter/nft_bitwise.c:138:50:
 warning: size argument in 'memcmp' call is a comparison
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     kbuild@01.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        kbuild test robot <lkp@intel.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

+ Pablo, looks like the closing parens need to be adjusted.

On Tue, Aug 13, 2019 at 12:12 PM kbuild test robot <lkp@intel.com> wrote:
>
> CC: kbuild-all@01.org
> CC: netfilter-devel@vger.kernel.org
> CC: coreteam@netfilter.org
> TO: Pablo Neira Ayuso <pablo@netfilter.org>
>
> tree:   https://kernel.googlesource.com/pub/scm/linux/kernel/git/pablo/nf-next.git master
> head:   105333435b4f3b21ffc325f32fae17719310db64
> commit: bd8699e9e29287b5571b32b68c3dcd05985fa9b1 [5/17] netfilter: nft_bitwise: add offload support
> config: x86_64-rhel-7.6 (attached as .config)
> compiler: clang version 10.0.0 (git://gitmirror/llvm_project 45a3fd206fb06f77a08968c99a8172cbf2ccdd0f)
> reproduce:
>         git checkout bd8699e9e29287b5571b32b68c3dcd05985fa9b1
>         # save the attached .config to linux build tree
>         make ARCH=x86_64
>
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
> >> net/netfilter/nft_bitwise.c:138:50: warning: size argument in 'memcmp' call is a comparison [-Wmemsize-comparison]
>            if (memcmp(&priv->xor, &zero, sizeof(priv->xor) ||
>                                          ~~~~~~~~~~~~~~~~~~^~
>    net/netfilter/nft_bitwise.c:138:6: note: did you mean to compare the result of 'memcmp' instead?
>            if (memcmp(&priv->xor, &zero, sizeof(priv->xor) ||
>                ^
>                                                           )
>    net/netfilter/nft_bitwise.c:138:32: note: explicitly cast the argument to size_t to silence this warning
>            if (memcmp(&priv->xor, &zero, sizeof(priv->xor) ||
>                                          ^
>                                          (size_t)(
>    1 warning generated.
>
> vim +/memcmp +138 net/netfilter/nft_bitwise.c
>
>    131
>    132  static int nft_bitwise_offload(struct nft_offload_ctx *ctx,
>    133                                 struct nft_flow_rule *flow,
>    134                                 const struct nft_expr *expr)
>    135  {
>    136          const struct nft_bitwise *priv = nft_expr_priv(expr);
>    137
>  > 138          if (memcmp(&priv->xor, &zero, sizeof(priv->xor) ||
>    139              priv->sreg != priv->dreg))
>    140                  return -EOPNOTSUPP;
>    141
>    142          memcpy(&ctx->regs[priv->dreg].mask, &priv->mask, sizeof(priv->mask));
>    143
>    144          return 0;
>    145  }
>    146
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation



-- 
Thanks,
~Nick Desaulniers
