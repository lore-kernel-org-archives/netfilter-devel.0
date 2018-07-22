From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH] netlink: fix memory leak
Date: Sun, 22 Jul 2018 07:00:47 +0200
Message-ID: <CAHmME9pLNd5GeR4kq_KHcarPKh3mkS5Cv-2s-tiQsPG6GcZ6sw@mail.gmail.com>
References: <20180722024925.3176-1-cscnull@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, kadlec@blackhole.kfki.hu,
        Florian Westphal <fw@strlen.de>,
        David Miller <davem@davemloft.net>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        kstewart@linuxfoundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dsahern@gmail.com, lucien.xin@gmail.com, ktkhai@virtuozzo.com,
        Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Netdev <netdev@vger.kernel.org>
To: cscnull@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180722024925.3176-1-cscnull@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sun, Jul 22, 2018 at 4:51 AM Shaochun Chen <cscnull@gmail.com> wrote:
> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> index 393573a99a5a..7b85176cf9bb 100644
> --- a/net/netlink/af_netlink.c
> +++ b/net/netlink/af_netlink.c
> @@ -2275,6 +2275,7 @@ int __netlink_dump_start(struct sock *ssk, struct sk_buff *skb,
>         struct netlink_callback *cb;
>         struct sock *sk;
>         struct netlink_sock *nlk;
> +       bool cb_running = false;
>         int ret;
>
>         refcount_inc(&skb->users);
> @@ -2317,6 +2318,7 @@ int __netlink_dump_start(struct sock *ssk, struct sk_buff *skb,
>
>         nlk->cb_running = true;
>         nlk->dump_done_errno = INT_MAX;
> +       cb_running = true;
>
>         mutex_unlock(nlk->cb_mutex);
>
> @@ -2339,6 +2341,8 @@ int __netlink_dump_start(struct sock *ssk, struct sk_buff *skb,
>         mutex_unlock(nlk->cb_mutex);
>  error_free:
>         kfree_skb(skb);
> +       if (cb_running)
> +               netlink_dump_start_fail(control);

cb_running is never true here, since nothing jumps to error_free after
you set it to be true. Pasting more code for context:


       nlk->cb_running = true;
       nlk->dump_done_errno = INT_MAX;
1) ----> cb_runnning = true;

       mutex_unlock(nlk->cb_mutex);

       ret = netlink_dump(sk);

       sock_put(sk);

       if (ret)
A)               return ret;

       /* We successfully started a dump, by returning -EINTR we
        * signal not to send ACK even if it was requested.
        */
B)       return -EINTR;

error_put:
       module_put(control->module);
error_unlock:
       sock_put(sk);
       mutex_unlock(nlk->cb_mutex);
error_free:
       kfree_skb(skb);
2) ----> if (cb_running) netlink_dump_start_fail(control);
       return ret;


After (1) is set, the function exits via (A) or (B), and so (2) is never hit.


But even if you moved it somehow to the if(ret), I'm still not sure
it'd be correct; start cbs should either succeed, or they should error
out and cleanup entirely after themselves.


>         return ret;
>  }
>  EXPORT_SYMBOL(__netlink_dump_start);
> --
> 2.17.1
>
