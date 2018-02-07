From: syzbot <syzbot+@syzkaller.appspotmail.com>
Subject: Re: WARNING: proc registration bug in clusterip_tg_check
Date: Wed, 07 Feb 2018 02:42:27 -0800
Message-ID: <001a114372a68e749405649cf352@google.com>
References: <945c8517a87c671825b61223088064ea2ad0a8cb.1517999262.git.pabeni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Cc: coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@blackhole.kfki.hu, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pabeni@redhat.com,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com, yoshfuji@linux-ipv6.org
To: Paolo Abeni <pabeni@redhat.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <945c8517a87c671825b61223088064ea2ad0a8cb.1517999262.git.pabeni@redhat.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git  
> master

Can't find the corresponding bug.


> I can't reproduce the issue locally, so asking the syzbot to test the
> tentive fix for me (and hoping I did not mess with the tag/format)

> ---
>   net/ipv4/netfilter/ipt_CLUSTERIP.c | 30 +++++++++++++++---------------
>   1 file changed, 15 insertions(+), 15 deletions(-)

> diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c  
> b/net/ipv4/netfilter/ipt_CLUSTERIP.c
> index 3a84a60f6b39..db103cd971a9 100644
> --- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
> +++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
> @@ -230,17 +230,6 @@ clusterip_config_init(struct net *net, const struct  
> ipt_clusterip_tgt_info *i,
>   	refcount_set(&c->refcount, 1);
>   	refcount_set(&c->entries, 1);

> -	spin_lock_bh(&cn->lock);
> -	if (__clusterip_config_find(net, ip)) {
> -		spin_unlock_bh(&cn->lock);
> -		kfree(c);
> -
> -		return ERR_PTR(-EBUSY);
> -	}
> -
> -	list_add_rcu(&c->list, &cn->configs);
> -	spin_unlock_bh(&cn->lock);
> -
>   #ifdef CONFIG_PROC_FS
>   	{
>   		char buffer[16];
> @@ -257,20 +246,31 @@ clusterip_config_init(struct net *net, const struct  
> ipt_clusterip_tgt_info *i,
>   	}
>   #endif

> +	spin_lock_bh(&cn->lock);
> +	if (__clusterip_config_find(net, ip)) {
> +		spin_unlock_bh(&cn->lock);
> +		err = -EBUSY;
> +		goto err_remove_pte:
> +	}
> +
> +	list_add_rcu(&c->list, &cn->configs);
> +	spin_unlock_bh(&cn->lock);
> +
>   	c->notifier.notifier_call = clusterip_netdev_event;
>   	err = register_netdevice_notifier(&c->notifier);
>   	if (!err)
>   		return c;

> +	spin_lock_bh(&cn->lock);
> +	list_del_rcu(&c->list);
> +	spin_unlock_bh(&cn->lock);
> +
> +err_remove_pte:
>   #ifdef CONFIG_PROC_FS
>   	proc_remove(c->pde);
>   err:
>   #endif
> -	spin_lock_bh(&cn->lock);
> -	list_del_rcu(&c->list);
> -	spin_unlock_bh(&cn->lock);
>   	kfree(c);
> -
>   	return ERR_PTR(err);
>   }

> --
> 2.14.3

> --
> You received this message because you are subscribed to the Google  
> Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an  
> email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit  
> https://groups.google.com/d/msgid/syzkaller-bugs/945c8517a87c671825b61223088064ea2ad0a8cb.1517999262.git.pabeni%40redhat.com.
> For more options, visit https://groups.google.com/d/optout.
