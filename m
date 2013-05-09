From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH nf-next] netfilter: conntrack: remove the central spinlock
Date: Thu, 9 May 2013 05:43:57 +0000 (UTC)
Message-ID: <kmfd2s$e2m$1@ger.gmane.org>
References: <1368068665.13473.81.camel@edumazet-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 09 May 2013 at 03:04 GMT, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>  
> +#if 0
> +	for (i = 0; i < ARRAY_SIZE(nf_conntrack_locks); i++)
> +		arch_spin_lock_init(&nf_conntrack_locks[i]);
> +#endif
> +

Is this intentional?
