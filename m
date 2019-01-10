From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: Re: [PATCH v2] netfilter: account ebt_table_info to kmemcg
Date: Thu, 10 Jan 2019 12:22:09 +0300
Message-ID: <2d8f28cb-8620-be05-21bc-dcf3009b2774@virtuozzo.com>
References: <20190103031431.247970-1-shakeelb@google.com>
 <5cc8efad-9d3d-3136-3ddc-1f8a640cb1f8@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        syzbot+7713f3aa67be76b1552c@syzkaller.appspotmail.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org
To: Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Westphal <fw@strlen.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5cc8efad-9d3d-3136-3ddc-1f8a640cb1f8@virtuozzo.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 06.01.2019 14:00, Kirill Tkhai wrote:
> On 03.01.2019 06:14, Shakeel Butt wrote:
>> The [ip,ip6,arp]_tables use x_tables_info internally and the underlying
>> memory is already accounted to kmemcg. Do the same for ebtables. The
>> syzbot, by using setsockopt(EBT_SO_SET_ENTRIES), was able to OOM the
>> whole system from a restricted memcg, a potential DoS.
>>
>> By accounting the ebt_table_info, the memory used for ebt_table_info can
>> be contained within the memcg of the allocating process. However the
>> lifetime of ebt_table_info is independent of the allocating process and
>> is tied to the network namespace. So, the oom-killer will not be able to
>> relieve the memory pressure due to ebt_table_info memory. The memory for
>> ebt_table_info is allocated through vmalloc. Currently vmalloc does not
>> handle the oom-killed allocating process correctly and one large
>> allocation can bypass memcg limit enforcement. So, with this patch,
>> at least the small allocations will be contained. For large allocations,
>> we need to fix vmalloc.
>>
>> Reported-by: syzbot+7713f3aa67be76b1552c@syzkaller.appspotmail.com
>> Signed-off-by: Shakeel Butt <shakeelb@google.com>
>> Cc: Florian Westphal <fw@strlen.de>
>> Cc: Michal Hocko <mhocko@kernel.org>
>> Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
>> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
>> Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
>> Cc: Roopa Prabhu <roopa@cumulusnetworks.com>
>> Cc: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Linux MM <linux-mm@kvack.org>
>> Cc: netfilter-devel@vger.kernel.org
>> Cc: coreteam@netfilter.org
>> Cc: bridge@lists.linux-foundation.org
>> Cc: LKML <linux-kernel@vger.kernel.org>
>> ---
>> Changelog since v1:
>> - More descriptive commit message.
> 
> Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com>
> 
>>
>>  net/bridge/netfilter/ebtables.c | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
>> index 491828713e0b..5e55cef0cec3 100644
>> --- a/net/bridge/netfilter/ebtables.c
>> +++ b/net/bridge/netfilter/ebtables.c
>> @@ -1137,14 +1137,16 @@ static int do_replace(struct net *net, const void __user *user,
>>  	tmp.name[sizeof(tmp.name) - 1] = 0;
>>  
>>  	countersize = COUNTER_OFFSET(tmp.nentries) * nr_cpu_ids;
>> -	newinfo = vmalloc(sizeof(*newinfo) + countersize);
>> +	newinfo = __vmalloc(sizeof(*newinfo) + countersize, GFP_KERNEL_ACCOUNT,
>> +			    PAGE_KERNEL);

Do we need GFP_HIGHMEM here?

>>  	if (!newinfo)
>>  		return -ENOMEM;
>>  
>>  	if (countersize)
>>  		memset(newinfo->counters, 0, countersize);
>>  
>> -	newinfo->entries = vmalloc(tmp.entries_size);
>> +	newinfo->entries = __vmalloc(tmp.entries_size, GFP_KERNEL_ACCOUNT,
>> +				     PAGE_KERNEL);
>>  	if (!newinfo->entries) {
>>  		ret = -ENOMEM;
>>  		goto free_newinfo;
>>
> 
