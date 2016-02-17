From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 1/7] netfilter: fix IS_ERR_VALUE usage
Date: Wed, 17 Feb 2016 02:31:27 +0000
Message-ID: <20160217023127.GG17997@ZenIV.linux.org.uk>
References: <1455546925-22119-1-git-send-email-a.hajda@samsung.com>
 <1455546925-22119-2-git-send-email-a.hajda@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	"David S. Miller" <davem@davemloft.net>,
	Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
	James Morris <jmorris@namei.org>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Andrzej Hajda <a.hajda@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1455546925-22119-2-git-send-email-a.hajda@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Feb 15, 2016 at 03:35:19PM +0100, Andrzej Hajda wrote:
> IS_ERR_VALUE should be used only with unsigned long type.
> Otherwise it can work incorrectly. To achieve this function
> xt_percpu_counter_alloc is modified to return unsigned long,
> and its result is assigned to temporary variable to perform
> error checking, before assigning to .pcnt field.

	Wrong fix, IMO.  Just have an anon union of u64 pcnt and
struct xt_counters __percpu *pcpu in there.  And make this

> +static inline unsigned long xt_percpu_counter_alloc(void)
>  {
>  	if (nr_cpu_ids > 1) {
>  		void __percpu *res = __alloc_percpu(sizeof(struct xt_counters),
>  						    sizeof(struct xt_counters));
>  
>  		if (res == NULL)
> -			return (u64) -ENOMEM;
> +			return -ENOMEM;
>  
> -		return (u64) (__force unsigned long) res;
> +		return (__force unsigned long) res;
>  	}
>  
>  	return 0;

take struct xt_counters * and return 0 or -ENOMEM.  Storing the result of
allocation in ->pcpu of passed structure.

I mean, look at the callers -

> -	e->counters.pcnt = xt_percpu_counter_alloc();
> -	if (IS_ERR_VALUE(e->counters.pcnt))
> +	pcnt = xt_percpu_counter_alloc();
> +	if (IS_ERR_VALUE(pcnt))
>  		return -ENOMEM;
> +	e->counters.pcnt = pcnt;

should be
	if (xt_percpu_counter_alloc(&e->counters) < 0)
		return -ENOMEM;

and similar for the rest of callers.  Moreover, if you look at the _users_
of that fields, you'll see that a bunch of those actually want to use
->pcpu instead of doing all those casts.

Really, that's the point - IS_ERR_VALUE is a big red flag saying "we need
to figure out what's going on in that place", which does include reading
through the code.  Mechanical "solutions" like that only hide the problem.
