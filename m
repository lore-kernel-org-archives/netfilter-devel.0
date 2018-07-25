From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH][v2] netfilter: use kvzalloc to allocate memory for
 hashtable
Date: Tue, 24 Jul 2018 22:44:37 -0700
Message-ID: <c86c7a1d-863d-229c-0383-c2e50aa6c5a2@gmail.com>
References: <1532496894-17200-1-git-send-email-lirongqing@baidu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Li RongQing <lirongqing@baidu.com>, netdev@vger.kernel.org,
        pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        edumazet@google.com
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1532496894-17200-1-git-send-email-lirongqing@baidu.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org



On 07/24/2018 10:34 PM, Li RongQing wrote:
> nf_ct_alloc_hashtable is used to allocate memory for conntrack,
> NAT bysrc and expectation hashtable. Assuming 64k bucket size,
> which means 7th order page allocation, __get_free_pages, called
> by nf_ct_alloc_hashtable, will trigger the direct memory reclaim
> and stall for a long time, when system has lots of memory stress

...

>  	sz = nr_slots * sizeof(struct hlist_nulls_head);
> -	hash = (void *)__get_free_pages(GFP_KERNEL | __GFP_NOWARN | __GFP_ZERO,
> -					get_order(sz));
> -	if (!hash)
> -		hash = vzalloc(sz);
> +	hash = kvzalloc(sz, GFP_KERNEL);


You could remove the @sz computation and call 

hash = kvcalloc(nr_slots, sizeof(struct hlist_nulls_head), GFP_KERNEL);

Thanks to kvmalloc_array() check, you also could remove the :

if (nr_slots > (UINT_MAX / sizeof(struct hlist_nulls_head)))
    return NULL;

That would remove a lot of stuff now we have proper helpers.
