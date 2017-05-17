From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: linux-next: build failure after merge of the netfilter tree
Date: Wed, 17 May 2017 01:02:10 -0400
Message-ID: <CA+FuTSfKpNj6kAfEGVnE=SN-OK0+8vbFiZTr1kaHd1x+9HEYdw@mail.gmail.com>
References: <20170517134536.3ce21d47@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35521 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751005AbdEQFCo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 May 2017 01:02:44 -0400
Received: by mail-wm0-f65.google.com with SMTP id v4so776803wmb.2
        for <netfilter-devel@vger.kernel.org>; Tue, 16 May 2017 22:02:43 -0700 (PDT)
Received: from mail-wr0-f169.google.com (mail-wr0-f169.google.com. [209.85.128.169])
        by smtp.gmail.com with ESMTPSA id h70sm9912934wma.14.2017.05.16.22.02.41
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 May 2017 22:02:41 -0700 (PDT)
Received: by mail-wr0-f169.google.com with SMTP id w50so811513wrc.0
        for <netfilter-devel@vger.kernel.org>; Tue, 16 May 2017 22:02:41 -0700 (PDT)
In-Reply-To: <20170517134536.3ce21d47@canb.auug.org.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 16, 2017 at 11:45 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> After merging the netfilter tree, today's linux-next build (i386
> defconfig) failed like this:
>
> net/netfilter/x_tables.c: In function 'xt_match_to_user':
> net/netfilter/x_tables.c:303:13: error: implicit declaration of function 'COMPAT_XT_ALIGN' [-Werror=implicit-function-declaration]
>     C_SIZE ? COMPAT_XT_ALIGN(C_SIZE) :  \
>              ^
> net/netfilter/x_tables.c:310:9: note: in expansion of macro 'XT_DATA_TO_USER'
>          XT_DATA_TO_USER(u, m, match, 0);
>          ^
>
> Caused by commit
>
>   324318f0248c ("netfilter: xtables: zero padding in data_to_user")
>
> In the !CONFIG_COMPAT case C_SIZE will always be zero, but the compiler
> is still looking for the macro :-(

Apologies for the breakage.

> I added this cludge patch (I am sure it can be done better):
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 17 May 2017 13:36:26 +1000
> Subject: [PATCH] netfilter: xtables: fix for zero padding in data_to_user
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  net/netfilter/x_tables.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> index d17769599c10..2b1785993a92 100644
> --- a/net/netfilter/x_tables.c
> +++ b/net/netfilter/x_tables.c
> @@ -296,12 +296,20 @@ int xt_data_to_user(void __user *dst, const void *src,
>  }
>  EXPORT_SYMBOL_GPL(xt_data_to_user);
>
> +#ifdef CONFIG_COMPAT
>  #define XT_DATA_TO_USER(U, K, TYPE, C_SIZE)                            \
>         xt_data_to_user(U->data, K->data,                               \
>                         K->u.kernel.TYPE->usersize,                     \
>                         C_SIZE ? : K->u.kernel.TYPE->TYPE##size,        \
>                         C_SIZE ? COMPAT_XT_ALIGN(C_SIZE) :              \
>                                  XT_ALIGN(K->u.kernel.TYPE->TYPE##size))
> +#else
> +#define XT_DATA_TO_USER(U, K, TYPE, C_SIZE)                            \
> +       xt_data_to_user(U->data, K->data,                               \
> +                       K->u.kernel.TYPE->usersize,                     \
> +                       C_SIZE ? : K->u.kernel.TYPE->TYPE##size,        \
> +                       C_SIZE ? : XT_ALIGN(K->u.kernel.TYPE->TYPE##size))
> +#endif
>

I will send a patch to the netfilter to define a separate
COMPAT_XT_DATA_TO_USER inside the CONFIG_COMPAT region further down
the file. This also allows simplifying XT_DATA_TO_USER by removing
those ternary statements.

-#define XT_DATA_TO_USER(U, K, TYPE, C_SIZE)                            \
+#define XT_DATA_TO_USER(U, K, TYPE)                                    \
        xt_data_to_user(U->data, K->data,                               \
                        K->u.kernel.TYPE->usersize,                     \
-                       C_SIZE ? : K->u.kernel.TYPE->TYPE##size,        \
-                       C_SIZE ? COMPAT_XT_ALIGN(C_SIZE) :              \
-                                XT_ALIGN(K->u.kernel.TYPE->TYPE##size))
+                       K->u.kernel.TYPE->TYPE##size,                   \
+                       XT_ALIGN(K->u.kernel.TYPE->TYPE##size))

and

+#define COMPAT_XT_DATA_TO_USER(U, K, TYPE, C_SIZE)                     \
+       xt_data_to_user(U->data, K->data,                               \
+                       K->u.kernel.TYPE->usersize,                     \
+                       C_SIZE,                                         \
+                       COMPAT_XT_ALIGN(C_SIZE))
+
