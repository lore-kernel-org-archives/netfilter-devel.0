Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5100AECAAD1
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Sep 2022 07:15:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbiIAHPC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Sep 2022 03:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233714AbiIAHOb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Sep 2022 03:14:31 -0400
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B05CB114C60;
        Thu,  1 Sep 2022 00:14:24 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id DBD36CC00FE;
        Thu,  1 Sep 2022 09:06:06 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Thu,  1 Sep 2022 09:06:04 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 96B81CC00FF;
        Thu,  1 Sep 2022 09:06:03 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 90DC13431DF; Thu,  1 Sep 2022 09:06:03 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id 8F2813431DE;
        Thu,  1 Sep 2022 09:06:03 +0200 (CEST)
Date:   Thu, 1 Sep 2022 09:06:03 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Kees Cook <keescook@chromium.org>
cc:     Jakub Kicinski <kuba@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        syzbot <syzkaller@googlegroups.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Petr Machata <petrm@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2] netlink: Bounds-check struct nlmsgerr creation
In-Reply-To: <20220901064858.1417126-1-keescook@chromium.org>
Message-ID: <5aad4860-b1c3-d78f-583d-26281626a49@netfilter.org>
References: <20220901064858.1417126-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Wed, 31 Aug 2022, Kees Cook wrote:

> For 32-bit systems, it might be possible to wrap lnmsgerr content
> lengths beyond SIZE_MAX. Explicitly test for all overflows, and mark the
> memcpy() as being unable to internally diagnose overflows.
> 
> This also excludes netlink from the coming runtime bounds check on
> memcpy(), since it's an unusual case of open-coded sizing and
> allocation. Avoid this future run-time warning:
> 
>   memcpy: detected field-spanning write (size 32) of single field "&errmsg->msg" at net/netlink/af_netlink.c:2447 (size 16)
> 
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
> Cc: Florian Westphal <fw@strlen.de>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: syzbot <syzkaller@googlegroups.com>
> Cc: netfilter-devel@vger.kernel.org
> Cc: coreteam@netfilter.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> v2: Rebased to -next
> v1: https://lore.kernel.org/lkml/20220901030610.1121299-3-keescook@chromium.org
> ---
>  net/netlink/af_netlink.c | 81 +++++++++++++++++++++++++---------------
>  1 file changed, 51 insertions(+), 30 deletions(-)

Could you add back the net/netfilter/ipset/ip_set_core.c part? Thanks!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
