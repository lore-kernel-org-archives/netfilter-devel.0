From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH] netfilter: fix int overflow in xt_alloc_table_info()
Date: Sat, 6 Jan 2018 15:07:06 +0100
Message-ID: <CACT4Y+a5Tvu8XSSLKE-aUiz5=qbJ0fRmt=Q5yCj+bShc8OYpTA@mail.gmail.com>
References: <20171228084854.247843-1-dvyukov@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Dmitry Vyukov <dvyukov@google.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:46579 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753276AbeAFOH2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Jan 2018 09:07:28 -0500
Received: by mail-pl0-f68.google.com with SMTP id i6so4860173plt.13
        for <netfilter-devel@vger.kernel.org>; Sat, 06 Jan 2018 06:07:27 -0800 (PST)
In-Reply-To: <20171228084854.247843-1-dvyukov@google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 28, 2017 at 9:48 AM, Dmitry Vyukov <dvyukov@google.com> wrote:
> syzkaller triggered OOM kills by passing ipt_replace.size = -1
> to IPT_SO_SET_REPLACE. The root cause is that SMP_ALIGN() in
> xt_alloc_table_info() causes int overflow and the size check passes
> when it should not. SMP_ALIGN() is no longer needed leftover.
>
> Remove SMP_ALIGN() call in xt_alloc_table_info().
>
> Reported-by: syzbot+4396883fa8c4f64e0175@syzkaller.appspotmail.com
> Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> Cc: Florian Westphal <fw@strlen.de>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: netfilter-devel@vger.kernel.org
> Cc: coreteam@netfilter.org
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  net/netfilter/x_tables.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> index 55802e97f906..e02a21549c99 100644
> --- a/net/netfilter/x_tables.c
> +++ b/net/netfilter/x_tables.c
> @@ -39,7 +39,6 @@ MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
>  MODULE_DESCRIPTION("{ip,ip6,arp,eb}_tables backend module");
>
> -#define SMP_ALIGN(x) (((x) + SMP_CACHE_BYTES-1) & ~(SMP_CACHE_BYTES-1))
>  #define XT_PCPU_BLOCK_SIZE 4096
>
>  struct compat_delta {
> @@ -1000,7 +999,7 @@ struct xt_table_info *xt_alloc_table_info(unsigned int size)
>                 return NULL;
>
>         /* Pedantry: prevent them from hitting BUG() in vmalloc.c --RR */
> -       if ((SMP_ALIGN(size) >> PAGE_SHIFT) + 2 > totalram_pages)
> +       if ((size >> PAGE_SHIFT) + 2 > totalram_pages)
>                 return NULL;
>
>         info = kvmalloc(sz, GFP_KERNEL);


Ping.

Dave, will this go into net/net-next?
