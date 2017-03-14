From: Feng Gao <gfree.wind@gmail.com>
Subject: Re: [PATCH net-next 1/1] netfilter: helper: Remove the rcu lock in
 nf_ct_helper_expectfn_find_by_name and nf_ct_helper_expectfn_find_by_symbol.
Date: Tue, 14 Mar 2017 16:45:59 +0800
Message-ID: <CA+6hz4qXNDcCYSDhc5Uzr7g3gnFEDA8cmdtktjvyJFXZ5FZV8w@mail.gmail.com>
References: <1489480145-54411-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Gao Feng <fgao@ikuai8.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, Feng Gao <gfree.wind@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36035 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750824AbdCNIqB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Mar 2017 04:46:01 -0400
Received: by mail-pg0-f68.google.com with SMTP id 25so23045192pgy.3
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Mar 2017 01:46:00 -0700 (PDT)
In-Reply-To: <1489480145-54411-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Palbo,


On Tue, Mar 14, 2017 at 4:29 PM,  <fgao@ikuai8.com> wrote:
> From: Gao Feng <fgao@ikuai8.com>
>
> Because these two functions return the nf_ct_helper_expectfn pointer
> which should be protected by rcu lock. So it should makes sure the
> caller should hold the rcu lock, not inside these functions.
>
> Signed-off-by: Gao Feng <fgao@ikuai8.com>
> ---
>  net/netfilter/nf_conntrack_helper.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
> index 6dc44d9..bce3d1f 100644
> --- a/net/netfilter/nf_conntrack_helper.c
> +++ b/net/netfilter/nf_conntrack_helper.c
> @@ -311,38 +311,36 @@ void nf_ct_helper_expectfn_unregister(struct nf_ct_helper_expectfn *n)
>  }
>  EXPORT_SYMBOL_GPL(nf_ct_helper_expectfn_unregister);
>
> +/* Caller should hold the rcu lock */
>  struct nf_ct_helper_expectfn *
>  nf_ct_helper_expectfn_find_by_name(const char *name)
>  {
>         struct nf_ct_helper_expectfn *cur;
>         bool found = false;
>
> -       rcu_read_lock();
>         list_for_each_entry_rcu(cur, &nf_ct_helper_expectfn_list, head) {
>                 if (!strcmp(cur->name, name)) {
>                         found = true;
>                         break;
>                 }
>         }
> -       rcu_read_unlock();
>         return found ? cur : NULL;
>  }
>  EXPORT_SYMBOL_GPL(nf_ct_helper_expectfn_find_by_name);
>
> +/* Caller should hold the rcu lock */
>  struct nf_ct_helper_expectfn *
>  nf_ct_helper_expectfn_find_by_symbol(const void *symbol)
>  {
>         struct nf_ct_helper_expectfn *cur;
>         bool found = false;
>
> -       rcu_read_lock();
>         list_for_each_entry_rcu(cur, &nf_ct_helper_expectfn_list, head) {
>                 if (cur->expectfn == symbol) {
>                         found = true;
>                         break;
>                 }
>         }
> -       rcu_read_unlock();
>         return found ? cur : NULL;
>  }
>  EXPORT_SYMBOL_GPL(nf_ct_helper_expectfn_find_by_symbol);
> --
> 1.9.1
>
>

Sorry, I misspelled the title. It should be "nf-next", not "net-next".

Regards
Feng
