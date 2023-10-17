Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ED07CDB483
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Oct 2023 12:49:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233315AbjJQMt0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Oct 2023 08:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343592AbjJQMtZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2023 08:49:25 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57793B6
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2023 05:49:23 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-6be0277c05bso1655867b3a.0
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2023 05:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697546963; x=1698151763; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3HJljOr/K+n0x/jIBOrmkdv+zmyaQHvP5gQx2bDRUoA=;
        b=Olk6FWGTV6/bJiDWOsEwTvIIqXJRl8oCV8Y5vONjv51PUPVPjrkeK94/MJwgAg0JWf
         AFXittCZ7H8A13p3QztGcId74sbZAa+T7fOYy+5ojuvRyMJ0Jshf11MpGGxJw2HDnwKT
         LENDAvTKEVLhszmNkoNIwa368AlVgqE9pBQbtlogU4UyVc8UzOvGr3zw8JT3I3TJyxOT
         JMZI8cUazBLqukda5s73GPKdObCux4INxejUc2Ka3AxaMVPEsbZu4bKNgyCIlbPcUFJE
         fZPoSsc/5sFjO3j23liuEh8CPARi7UDHYXmYpkirNtX8E5Fz+DAmddKeLNXC2nCeFFw5
         BamA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697546963; x=1698151763;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3HJljOr/K+n0x/jIBOrmkdv+zmyaQHvP5gQx2bDRUoA=;
        b=Te2zFPFSELGM3FWcjKzL32CeV0TJsMAHYO71dqshoAwQF07tTX8DD3sWG+1Fisl5+C
         k55oyHdtgytuJRwWI1YzuW9PfH+q3ITAN5gdlp+aiRNIhcGXGaBK5jAa0JCC2NQauCfe
         ND/L2lEVY+rV1vfxynjtH7tUQK9OnD2JyKDyPSlCijvRDrAZ+kyjj1ke6umrTvNadPoO
         RkHByDUHj3U3Ks/zhWpabbLAn3X1I15FA0Kaa1/pdj6eUJKtY3TFb1ttfxmqUrS0nKdF
         sp46e1kU8AuloaH9bNqS6pGjqhIIXT6o37Qq7n/jF77jQW1laiKLCvLo78XGleDLBbE/
         N0wA==
X-Gm-Message-State: AOJu0YzDdrXuwQaeafEyWqV9Li8T4hpNXeZJc0zvj9+fjgIbBROYRXvj
        u5SG+KEBgNIMxoyPluscuns=
X-Google-Smtp-Source: AGHT+IH/KiQYC5F04Ml6EdsAPORmoIGFDHlqc+K5VBBt5uM0+f2AQ/RXFoDq6hMFw1uCZZlCxrVMGQ==
X-Received: by 2002:a05:6a20:3953:b0:13c:988c:e885 with SMTP id r19-20020a056a20395300b0013c988ce885mr1943283pzg.56.1697546962537;
        Tue, 17 Oct 2023 05:49:22 -0700 (PDT)
Received: from [192.168.42.10] ([23.91.97.158])
        by smtp.gmail.com with ESMTPSA id i13-20020a17090acf8d00b002684b837d88sm1279034pju.14.2023.10.17.05.49.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Oct 2023 05:49:21 -0700 (PDT)
Message-ID: <8586e54f-eb36-dad5-ca1e-8924bc5e23a8@gmail.com>
Date:   Tue, 17 Oct 2023 20:49:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 2/2] netfilter: ipset: fix race condition in ipset swap,
 destroy and test
Content-Language: en-US
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        David Miller <davem@davemloft.net>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, justinstitt@google.com,
        kuniyu@amazon.com, netfilter-devel@vger.kernel.org,
        Linkui Xiao <xiaolinkui@kylinos.cn>
References: <20231016135204.27443-1-xiaolinkui@gmail.com>
 <20231016135204.27443-2-xiaolinkui@gmail.com>
 <3ad078fa-fa61-95a8-dbd2-33d5faa2a8b@netfilter.org>
 <96163a1d-81ed-1739-96da-f1a7b5f63dd7@gmail.com>
 <69e7963b-e7f8-3ad0-210-7b86eebf7f78@netfilter.org>
From:   Linkui Xiao <xiaolinkui@gmail.com>
In-Reply-To: <69e7963b-e7f8-3ad0-210-7b86eebf7f78@netfilter.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

Thanks for your reply.

On 10/17/23 17:26, Jozsef Kadlecsik wrote:
> Hi,
>
> On Tue, 17 Oct 2023, Linkui Xiao wrote:
>
>> On 10/17/23 03:52, Jozsef Kadlecsik wrote:
>>> Hello,
>>>
>>> On Mon, 16 Oct 2023, xiaolinkui wrote:
>>>
>>>> From: Linkui Xiao <xiaolinkui@kylinos.cn>
>>>>
>>>> There is a race condition which can be demonstrated by the following
>>>> script:
>>>>
>>>> ipset create hash_ip1 hash:net family inet hashsize 1024 maxelem 1048576
>>>> ipset add hash_ip1 172.20.0.0/16
>>>> ipset add hash_ip1 192.168.0.0/16
>>>> iptables -A INPUT -m set --match-set hash_ip1 src -j ACCEPT
>>>> while [ 1 ]
>>>> do
>>>> 	ipset create hash_ip2 hash:net family inet hashsize 1024 maxelem
>>>> 1048576
>>>> 	ipset add hash_ip2 172.20.0.0/16
>>>> 	ipset swap hash_ip1 hash_ip2
>>>> 	ipset destroy hash_ip2
>>>> 	sleep 0.05
>>>> done
>>> I have been running the script above for more than two hours and nothing
>>> happened. What else is needed to trigger the bug? (I have been
>>> continuously sending ping to the tested host.)
>> This is an extremely low probability event. In our k8s cluster, hundreds
>> of virtual machines ran for several months before experiencing a crash.
>> Perhaps due to some special reasons, the ip_set_test run time has been
>> increased, during this period, other CPU completed the swap and destroy
>> operations on the ipset.
>> In order to quickly trigger this bug, we can add a delay and destroy
>> operations to the test kernel to simulate the actual environment, such
>> as:
>>
>> @@ -733,11 +733,13 @@ ip_set_unlock(struct ip_set *set)
>>                  spin_unlock_bh(&set->lock);
>>   }
>>
>> +static void ip_set_destroy_set(struct ip_set *set);
>>   int
>>   ip_set_test(ip_set_id_t index, const struct sk_buff *skb,
>>              const struct xt_action_param *par, struct ip_set_adt_opt *opt)
>>   {
>>          struct ip_set *set = ip_set_rcu_get(xt_net(par), index);
>> +       struct ip_set_net *inst = ip_set_pernet(xt_net(par));
>>          int ret = 0;
>>
>>          BUG_ON(!set);
>> @@ -747,6 +749,17 @@ ip_set_test(ip_set_id_t index, const struct sk_buff *skb,
>>              !(opt->family == set->family || set->family == NFPROTO_UNSPEC))
>>                  return 0;
>>
>> +       mdelay(100); // Waiting for swap to complete
>> +
>> +       read_lock_bh(&ip_set_ref_lock);
>> +       if (set->ref == 0 && set->ref_netlink == 0) { // set can be destroyed
>> with ref = 0
>> +               pr_warn("set %s, index %u, ref %u\n", set->name, index,
>> set->ref);
>> +               read_unlock_bh(&ip_set_ref_lock);
>> +               ip_set(inst, index) = NULL;
>> +               ip_set_destroy_set(set);
>> +       } else
>> +               read_unlock_bh(&ip_set_ref_lock);
>> +
>>          ret = set->variant->kadt(set, skb, par, IPSET_TEST, opt);
>>
>>          if (ret == -EAGAIN) {
>>
>> Then run the above script on the test kernel, crash will appear on
>> hash_net4_kadt: (need sending ping to the tested host.)
> I understand the intent but that's a sure way to crash the kernel indeed.
>   
>> [   93.021792] BUG: kernel NULL pointer dereference, address: 000000000000009c
>> [   93.021796] #PF: supervisor read access in kernel mode
>> [   93.021798] #PF: error_code(0x0000) - not-present page
>> [   93.021800] PGD 0 P4D 0
>> [   93.021804] Oops: 0000 [#1] PREEMPT SMP PTI
>> [   93.021807] CPU: 4 PID: 0 Comm: swapper/4 Kdump: loaded Not tainted
>> 6.6.0-rc5 #29
>> [   93.021811] Hardware name: VMware, Inc. VMware Virtual Platform/440BX
>> Desktop Reference Platform, BIOS 6.00 11/12/2020
>> [   93.021813] RIP: 0010:hash_net4_kadt+0x5f/0x1b0 [ip_set_hash_net]
>> [   93.021825] Code: 00 48 89 44 24 48 48 8b 87 80 00 00 00 45 8b 60 30 c7 44
>> 24 08 00 00 00 00 4c 8b 54 ca 10 31 d2 c6 44 24 0e 00 66 89 54 24 0c <0f> b6
>> b0 9c 00 00 00 40 84 f6 0f 84 bf 00 00 00 48 8d 54 24 10 83
>> [   93.021827] RSP: 0018:ffffb0180058c9c0 EFLAGS: 00010246
>> [   93.021830] RAX: 0000000000000000 RBX: 0000000000000002 RCX:
>> 0000000000000002
>> [   93.021832] RDX: 0000000000000000 RSI: ffff956d747cdd00 RDI:
>> ffff956d9348ba80
>> [   93.021835] RBP: ffffb0180058ca30 R08: ffffb0180058ca88 R09:
>> ffff956d9348ba80
>> [   93.021837] R10: ffffffffc102f4f0 R11: ffff956d747cdd00 R12:
>> 00000000ffffffff
>> [   93.021839] R13: 0000000000000054 R14: ffffb0180058ca88 R15:
>> ffff956d747cdd00
>> [   93.021862] FS:  0000000000000000(0000) GS:ffff956d9b100000(0000)
>> knlGS:0000000000000000
>> [   93.021870] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   93.021873] CR2: 000000000000009c CR3: 0000000031e3a006 CR4:
>> 00000000003706e0
>> [   93.021887] Call Trace:
>> [   93.021891]  <IRQ>
>> [   93.021893]  ? __die+0x24/0x70
>> [   93.021900]  ? page_fault_oops+0x82/0x150
>> [   93.021905]  ? exc_page_fault+0x69/0x150
>> [   93.021911]  ? asm_exc_page_fault+0x26/0x30
>> [   93.021915]  ? __pfx_hash_net4_test+0x10/0x10 [ip_set_hash_net]
>> [   93.021922]  ? hash_net4_kadt+0x5f/0x1b0 [ip_set_hash_net]
>> [   93.021931]  ip_set_test+0x119/0x250 [ip_set]
>> [   93.021943]  set_match_v4+0xa2/0xe0 [xt_set]
>> [   93.021973]  nft_match_eval+0x65/0xb0 [nft_compat]
>> [   93.021982]  nft_do_chain+0xe1/0x430 [nf_tables]
>> [   93.022008]  ? resolve_normal_ct+0xc1/0x200 [nf_conntrack]
>> [   93.022026]  ? nf_conntrack_icmpv4_error+0x123/0x1a0 [nf_conntrack]
>> [   93.022046]  nft_do_chain_ipv4+0x6b/0x90 [nf_tables]
>> [   93.022066]  nf_hook_slow+0x40/0xc0
>> [   93.022071]  ip_local_deliver+0xdb/0x130
>> [   93.022075]  ? __pfx_ip_local_deliver_finish+0x10/0x10
>> [   93.022078]  __netif_receive_skb_core.constprop.0+0x6e1/0x10a0
>> [   93.022086]  ? find_busiest_group+0x43/0x240
>> [   93.022091]  __netif_receive_skb_list_core+0x136/0x2c0
>> [   93.022096]  netif_receive_skb_list_internal+0x1c9/0x300
>> [   93.022101]  ? e1000_clean_rx_irq+0x316/0x4c0 [e1000]
>> [   93.022113]  napi_complete_done+0x73/0x1b0
>> [   93.022117]  e1000_clean+0x7c/0x1e0 [e1000]
>> [   93.022127]  __napi_poll+0x29/0x1b0
>> [   93.022131]  net_rx_action+0x29f/0x370
>> [   93.022136]  __do_softirq+0xcc/0x2af
>> [   93.022142]  __irq_exit_rcu+0xa1/0xc0
>> [   93.022147]  sysvec_apic_timer_interrupt+0x76/0x90
>>>> Swap will exchange the values of ref so destroy will see ref = 0 instead
>>>> of
>>>> ref = 1. So after running this script for a period of time, the following
>>>> race situations may occur:
>>>> 	CPU0:                CPU1:
>>>> 	ipt_do_table
>>>> 	->set_match_v4
>>>> 	->ip_set_test
>>>> 			ipset swap hash_ip1 hash_ip2
>>>> 			ipset destroy hash_ip2
>>>> 	->hash_net4_kadt
>>>>
>>>> CPU0 found ipset through the index, and at this time, hash_ip2 has been
>>>> destroyed by CPU1 through name search. So CPU0 will crash when accessing
>>>> set->data in the function hash_net4_kadt.
>>>>
>>>> With this fix in place swap will not succeed because ip_set_test still has
>>>> ref_swapping on the set.
>>>>
>>>> Both destroy and swap will error out if ref_swapping != 0 on the set.
>>>>
>>>> Signed-off-by: Linkui Xiao <xiaolinkui@kylinos.cn>
>>>> ---
>>>>    net/netfilter/ipset/ip_set_core.c | 6 +++++-
>>>>    1 file changed, 5 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/net/netfilter/ipset/ip_set_core.c
>>>> b/net/netfilter/ipset/ip_set_core.c
>>>> index e5d25df5c64c..d6bd37010bfb 100644
>>>> --- a/net/netfilter/ipset/ip_set_core.c
>>>> +++ b/net/netfilter/ipset/ip_set_core.c
>>>> @@ -741,11 +741,13 @@ ip_set_test(ip_set_id_t index, const struct sk_buff
>>>> *skb,
>>>>    	int ret = 0;
>>>>      	BUG_ON(!set);
>>>> +
>>>> +	__ip_set_get_swapping(set);
>>>>    	pr_debug("set %s, index %u\n", set->name, index);
>>>>      	if (opt->dim < set->type->dimension ||
>>>>    	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC))
>>>> -		return 0;
>>>> +		goto out;
>>>>      	ret = set->variant->kadt(set, skb, par, IPSET_TEST, opt);
>>>>    @@ -764,6 +766,8 @@ ip_set_test(ip_set_id_t index, const struct sk_buff
>>>> *skb,
>>>>    			ret = -ret;
>>>>    	}
>>>>    +out:
>>>> +	__ip_set_put_swapping(set);
>>>>    	/* Convert error codes to nomatch */
>>>>    	return (ret < 0 ? 0 : ret);
>>>>    }
>>>> -- 
>>>> 2.17.1
>>> The patch above alas is also not acceptable: it adds locking to a lockless
>>> area and thus slows down the execution unnecessarily.
>> Use seq of cpu in destroy can avoid this issue, but Florian Westphal says
>> it's not suitable:
>> https://lore.kernel.org/all/20231005123107.GB9350@breakpoint.cc/
> No, because there are other, non-iptables usage of ipset in the kernel
> too. And Florian is right that synchonize_rcu() is the proper way to solve
> the issue.
>   
>>> If there's a bug, then that must be handled in ip_set_swap() itself, like
>>> for example adding a quiescent time and waiting for the ongoing users of
>>> the swapped set to finish their job. You can make it slow there, because
>>> swapping is not performance critical.
>> Can we add read seq of cpu to swap to wait for the test to complete? Such as:
>>
>> @@ -1357,6 +1357,7 @@ static int ip_set_swap(struct sk_buff *skb, const struct
>> nfnl_info *info,
>>          struct ip_set *from, *to;
>>          ip_set_id_t from_id, to_id;
>>          char from_name[IPSET_MAXNAMELEN];
>> +       unsigned int cpu;
>>
>>          if (unlikely(protocol_min_failed(attr) ||
>>                       !attr[IPSET_ATTR_SETNAME] ||
>> @@ -1395,8 +1396,21 @@ static int ip_set_swap(struct sk_buff *skb, const
>> struct nfnl_info *info,
>>          swap(from->ref, to->ref);
>>          ip_set(inst, from_id) = to;
>>          ip_set(inst, to_id) = from;
>> -       write_unlock_bh(&ip_set_ref_lock);
>>
>> +       /* wait for even xt_recseq on all cpus */
>> +       for_each_possible_cpu(cpu) {
>> +               seqcount_t *s = &per_cpu(xt_recseq, cpu);
>> +               u32 seq = raw_read_seqcount(s);
>> +
>> +               if (seq & 1) {
>> +                       do {
>> +                               cond_resched();
>> +                               cpu_relax();
>> +                       } while (seq == raw_read_seqcount(s));
>> +               }
>> +       }
>> +
>> +       write_unlock_bh(&ip_set_ref_lock);
>>          return 0;
>>   }
>>
>> Of course, this solution cannot be verified in the test kernel above.
> Also, it does not solve all possible cases, as it was mentioned.
>
> I'd go with using synchonize_rcu() but in the swap function instead of the
> destroy one. The patch below should solve the problem. (The patching above
> is not suitable to verify it at all.):
>
> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> index 35d2f9c9ada0..35bd1c1e09de 100644
> --- a/net/netfilter/ipset/ip_set_core.c
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@ -712,13 +712,18 @@ ip_set_rcu_get(struct net *net, ip_set_id_t index)
>   	struct ip_set_net *inst = ip_set_pernet(net);
>   
>   	rcu_read_lock();
> -	/* ip_set_list itself needs to be protected */
> +	/* ip_set_list and the set pointer need to be protected */
>   	set = rcu_dereference(inst->ip_set_list)[index];
> -	rcu_read_unlock();
>   
>   	return set;
>   }
>   
> +static inline void
> +ip_set_rcu_put(struct ip_set *set __always_unused)
> +{
> +	rcu_read_unlock();
> +}
> +
>   static inline void
>   ip_set_lock(struct ip_set *set)
>   {
> @@ -744,8 +749,10 @@ ip_set_test(ip_set_id_t index, const struct sk_buff *skb,
>   	pr_debug("set %s, index %u\n", set->name, index);
>   
>   	if (opt->dim < set->type->dimension ||
> -	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC))
> +	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC)) {
> +		ip_set_rcu_put(set);
>   		return 0;
> +	}
>   
>   	ret = set->variant->kadt(set, skb, par, IPSET_TEST, opt);
>   
> @@ -764,6 +771,7 @@ ip_set_test(ip_set_id_t index, const struct sk_buff *skb,
>   			ret = -ret;
>   	}
>   
> +	ip_set_rcu_put(set);
>   	/* Convert error codes to nomatch */
>   	return (ret < 0 ? 0 : ret);
>   }
> @@ -780,12 +788,15 @@ ip_set_add(ip_set_id_t index, const struct sk_buff *skb,
>   	pr_debug("set %s, index %u\n", set->name, index);
>   
>   	if (opt->dim < set->type->dimension ||
> -	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC))
> +	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC)) {
> +		ip_set_rcu_put(set);
>   		return -IPSET_ERR_TYPE_MISMATCH;
> +	}
>   
>   	ip_set_lock(set);
>   	ret = set->variant->kadt(set, skb, par, IPSET_ADD, opt);
>   	ip_set_unlock(set);
> +	ip_set_rcu_put(set);
>   
>   	return ret;
>   }
> @@ -802,12 +813,15 @@ ip_set_del(ip_set_id_t index, const struct sk_buff *skb,
>   	pr_debug("set %s, index %u\n", set->name, index);
>   
>   	if (opt->dim < set->type->dimension ||
> -	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC))
> +	    !(opt->family == set->family || set->family == NFPROTO_UNSPEC)) {
> +		ip_set_rcu_put(set);
>   		return -IPSET_ERR_TYPE_MISMATCH;
> +	}
>   
>   	ip_set_lock(set);
>   	ret = set->variant->kadt(set, skb, par, IPSET_DEL, opt);
>   	ip_set_unlock(set);
> +	ip_set_rcu_put(set);
>   
>   	return ret;
>   }
> @@ -882,6 +896,7 @@ ip_set_name_byindex(struct net *net, ip_set_id_t index, char *name)
>   	read_lock_bh(&ip_set_ref_lock);
>   	strscpy_pad(name, set->name, IPSET_MAXNAMELEN);
>   	read_unlock_bh(&ip_set_ref_lock);
> +	ip_set_rcu_put(set);
>   }
>   EXPORT_SYMBOL_GPL(ip_set_name_byindex);
>   
> @@ -1348,6 +1363,9 @@ static int ip_set_rename(struct sk_buff *skb, const struct nfnl_info *info,
>    * protected by the ip_set_ref_lock. The kernel interfaces
>    * do not hold the mutex but the pointer settings are atomic
>    * so the ip_set_list always contains valid pointers to the sets.
> + * However after swapping, an userspace set destroy command could
> + * remove a set still processed by kernel side add/del/test.
> + * Therefore we need to wait for the ongoing operations to be finished.
>    */
>   
>   static int ip_set_swap(struct sk_buff *skb, const struct nfnl_info *info,
> @@ -1397,6 +1415,9 @@ static int ip_set_swap(struct sk_buff *skb, const struct nfnl_info *info,
>   	ip_set(inst, to_id) = from;
>   	write_unlock_bh(&ip_set_ref_lock);
>   
> +	/* Make sure all readers of the old set pointers are completed. */
> +	synchronize_rcu();
> +
>   	return 0;
>   }
>   
>
> Best regards,
> Jozsef
I have tested that swap and destroy cannot be executed simultaneously.
This patch works for me. Thank you again.


Best regards,
Linkui Xiao

