From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 14/16] netfilter: Replace spin_is_locked() with lockdep
Date: Wed, 3 Oct 2018 10:29:57 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1810031028410.30353@blackhole.kfki.hu>
References: <20181003053902.6910-1-ldr709@gmail.com> <20181003053902.6910-15-ldr709@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
To: Lance Roy <ldr709@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181003053902.6910-15-ldr709@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2 Oct 2018, Lance Roy wrote:

> lockdep_assert_held() is better suited to checking locking requirements,
> since it won't get confused when someone else holds the lock. This is
> also a step towards possibly removing spin_is_locked().
> 
> Signed-off-by: Lance Roy <ldr709@gmail.com>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> Cc: Florian Westphal <fw@strlen.de>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: <netfilter-devel@vger.kernel.org>
> Cc: <coreteam@netfilter.org>
> Cc: <netdev@vger.kernel.org>
> ---
>  net/netfilter/ipset/ip_set_hash_gen.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Best regards,
Jozsef

> diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
> index 8a33dac4e805..e287da68d5fa 100644
> --- a/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -15,7 +15,7 @@
>  
>  #define __ipset_dereference_protected(p, c)	rcu_dereference_protected(p, c)
>  #define ipset_dereference_protected(p, set) \
> -	__ipset_dereference_protected(p, spin_is_locked(&(set)->lock))
> +	__ipset_dereference_protected(p, lockdep_is_held(&(set)->lock))
>  
>  #define rcu_dereference_bh_nfnl(p)	rcu_dereference_bh_check(p, 1)
>  
> -- 
> 2.19.0
> 
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
