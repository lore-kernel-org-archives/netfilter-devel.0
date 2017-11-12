From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v4 12/18] nfnetlink_gueue: exit_net cleanup check added
Date: Sun, 12 Nov 2017 09:52:32 +0100
Message-ID: <20171112085232.GJ5512@breakpoint.cc>
References: <9dfa013e-9098-e155-9c47-a73753338288@virtuozzo.com>
 <c0d49d64-d46b-21e6-02e4-4c445600bd39@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Vasily Averin <vvs@virtuozzo.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c0d49d64-d46b-21e6-02e4-4c445600bd39@virtuozzo.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Vasily Averin <vvs@virtuozzo.com> wrote:
> Be sure that instance_table array initialized in net_init hook
> was return to initial state.

> +	for (i = 0; i < INSTANCE_BUCKETS; i++)
> +		if (WARN_ON_ONCE(!hlist_empty(&q->instance_table[i])))
> +			break;

This looks strange, why if/break?

Plain WARN_ON_ONCE should be enough, but thats a nit so:

Acked-by: Florian Westphal <fw@strlen.de>
