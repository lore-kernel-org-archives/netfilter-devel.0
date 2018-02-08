From: Xin Long <lucien.xin@gmail.com>
Subject: Re: [PATCH net] netfilter: on setsockopt() acquire sock lock only in
 the required scope
Date: Thu, 8 Feb 2018 19:04:45 +0800
Message-ID: <CADvbK_cRXP4NRjQYAQYS6CwRf7z+aRkFP8_df6ZF+SutukCVnQ@mail.gmail.com>
References: <0faf65d7a9b102fbe107d1bb75b5d97e4622ee3e.1518084409.git.pabeni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: network dev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
To: Paolo Abeni <pabeni@redhat.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <0faf65d7a9b102fbe107d1bb75b5d97e4622ee3e.1518084409.git.pabeni@redhat.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Feb 8, 2018 at 6:38 PM, Paolo Abeni <pabeni@redhat.com> wrote:
> The Syzbot reported a possible deadlock in the netfilter area caused by
> rtnl lock, xt lock and socket lock being acquired with a different order
> on different code paths, leading to the following backtrace:
>
> ======================================================
> WARNING: possible circular locking dependency detected
> 4.15.0+ #301 Not tainted
> ------------------------------------------------------
> syzkaller233489/4179 is trying to acquire lock:
>   (rtnl_mutex){+.+.}, at: [<0000000048e996fd>] rtnl_lock+0x17/0x20
> net/core/rtnetlink.c:74
>
> but task is already holding lock:
>   (&xt[i].mutex){+.+.}, at: [<00000000328553a2>]
> xt_find_table_lock+0x3e/0x3e0 net/netfilter/x_tables.c:1041
>
> which lock already depends on the new lock.
> ===
>
> Since commit 3f34cfae1230 ("netfilter: on sockopt() acquire sock lock
> only in the required scope"), we already acquire the socket lock in
> the innermost scope, where needed. In such commit I forgot to remove
> the outer-most socket lock from the getsockopt() path, this commit
> addresses the issues dropping it now.
>
> Fixes: 202f59afd441 ("netfilter: ipt_CLUSTERIP: do not hold dev")
> Fixes: 3f34cfae1230 ("netfilter: on sockopt() acquire sock lock only in the required scope")
> Reported-by: syzbot+ddde1c7b7ff7442d7f2d@syzkaller.appspotmail.com
> Suggested-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  net/ipv4/ip_sockglue.c   |  7 +------
>  net/ipv6/ipv6_sockglue.c | 10 ++--------
>  2 files changed, 3 insertions(+), 14 deletions(-)
>
> diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
> index 008be04ac1cc..9c41a0cef1a5 100644
> --- a/net/ipv4/ip_sockglue.c
> +++ b/net/ipv4/ip_sockglue.c
> @@ -1567,10 +1567,7 @@ int ip_getsockopt(struct sock *sk, int level,
>                 if (get_user(len, optlen))
>                         return -EFAULT;
>
> -               lock_sock(sk);
> -               err = nf_getsockopt(sk, PF_INET, optname, optval,
> -                               &len);
> -               release_sock(sk);
> +               err = nf_getsockopt(sk, PF_INET, optname, optval, &len);
>                 if (err >= 0)
>                         err = put_user(len, optlen);
>                 return err;
> @@ -1602,9 +1599,7 @@ int compat_ip_getsockopt(struct sock *sk, int level, int optname,
>                 if (get_user(len, optlen))
>                         return -EFAULT;
>
> -               lock_sock(sk);
>                 err = compat_nf_getsockopt(sk, PF_INET, optname, optval, &len);
> -               release_sock(sk);
>                 if (err >= 0)
>                         err = put_user(len, optlen);
>                 return err;
> diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
> index d78d41fc4b1a..24535169663d 100644
> --- a/net/ipv6/ipv6_sockglue.c
> +++ b/net/ipv6/ipv6_sockglue.c
> @@ -1367,10 +1367,7 @@ int ipv6_getsockopt(struct sock *sk, int level, int optname,
>                 if (get_user(len, optlen))
>                         return -EFAULT;
>
> -               lock_sock(sk);
> -               err = nf_getsockopt(sk, PF_INET6, optname, optval,
> -                               &len);
> -               release_sock(sk);
> +               err = nf_getsockopt(sk, PF_INET6, optname, optval, &len);
>                 if (err >= 0)
>                         err = put_user(len, optlen);
>         }
> @@ -1409,10 +1406,7 @@ int compat_ipv6_getsockopt(struct sock *sk, int level, int optname,
>                 if (get_user(len, optlen))
>                         return -EFAULT;
>
> -               lock_sock(sk);
> -               err = compat_nf_getsockopt(sk, PF_INET6,
> -                                          optname, optval, &len);
> -               release_sock(sk);
> +               err = compat_nf_getsockopt(sk, PF_INET6, optname, optval, &len);
>                 if (err >= 0)
>                         err = put_user(len, optlen);
>         }
> --
> 2.14.3
>
Patch looks good to me, the better way to fix this deadlock,
just the subject should be 'getsockopt' instead.

Thanks.
