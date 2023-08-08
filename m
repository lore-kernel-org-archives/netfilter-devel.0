Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 526AEC04A94
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Aug 2023 23:57:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbjHHX5g (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 19:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjHHX5g (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 19:57:36 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3F419A1;
        Tue,  8 Aug 2023 16:57:35 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qTWZt-0005i1-79; Wed, 09 Aug 2023 01:57:29 +0200
Date:   Wed, 9 Aug 2023 01:57:29 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Justin Stitt <justinstitt@google.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] netfilter: x_tables: refactor deprecated strncpy
Message-ID: <20230808235729.GK9741@breakpoint.cc>
References: <20230808-net-netfilter-v1-0-efbbe4ec60af@google.com>
 <20230808-net-netfilter-v1-6-efbbe4ec60af@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230808-net-netfilter-v1-6-efbbe4ec60af@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Justin Stitt <justinstitt@google.com> wrote:
> Prefer `strscpy` to `strncpy` for use on NUL-terminated destination
> buffers.
> 
> This fixes a potential bug due to the fact that both `t->u.user.name`
> and `name` share the same size.

This replacement seems fine.

> Signed-off-by: Justin Stitt <justinstitt@google.com>
> 
> ---
> Here's an example of what happens when dest and src share same size:
> |  #define MAXLEN 5
> |  char dest[MAXLEN];
> |  const char *src = "hello";
> |  strncpy(dest, src, MAXLEN); // -> should use strscpy()
> |  // dest is now not NUL-terminated

This can't happen here, the source string is coming from the kernel
(xt target and matchinfo struct).

But, even if it would it should be fine, this function prepares
the translated 64bit blob which gets passed to translate_table(),
and that function has to check for '\0' presence.

Normally it handles the native (non-compat) data originating from
userspace, so m-->user.name can not be assumed to contain a \0.
