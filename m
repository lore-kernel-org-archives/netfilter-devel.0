From: David Miller <davem@davemloft.net>
Subject: Re: tproxy related crash in inet_hashtables
Date: Sat, 14 Aug 2010 22:16:11 -0700 (PDT)
Message-ID: <20100814.221611.15248639.davem@davemloft.net>
References: <4C65432F.4030809@exinda.com>
	<1281707736.4470.53.camel@edumazet-laptop>
	<4C661D09.8030709@exinda.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: eric.dumazet@gmail.com, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, kaber@trash.net, hidden@sch.bme.hu
To: stephen.buck@exinda.com
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <4C661D09.8030709@exinda.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Stephen Buck <stephen.buck@exinda.com>
Date: Sat, 14 Aug 2010 14:35:21 +1000

> +		}
> +		if (!node)
> +			tb = inet_bind_bucket_create(table->bind_bucket_cachep,
> +						     sock_net(sk), head, port);
> +	}
>  	sk_add_bind_node(child, &tb->owners);

inet_bind_bucket_create() can fail due to memory allocation failure,
you're therefore going to have to find a way to handle that.

And in doing so you're going to find out that there is no easy
way out of this code path in such an error, this code was
absolutely not designed to be able to handle cases like this.
