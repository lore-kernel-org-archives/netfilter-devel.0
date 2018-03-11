From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [RFC] netfilter: cttimeout: remove VLA in
 ctnl_timeout_parse_policy
Date: Sun, 11 Mar 2018 17:12:09 -0500
Message-ID: <20df6b07-b3e7-7733-ee05-b12589bd287f@embeddedor.com>
References: <20180306184755.GA7628@embeddedgus>
 <20180311220414.feda33aw72zw2rko@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180311220414.feda33aw72zw2rko@salvia>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Pablo,

On 03/11/2018 05:04 PM, Pablo Neira Ayuso wrote:
> On Tue, Mar 06, 2018 at 12:47:55PM -0600, Gustavo A. R. Silva wrote:
>> In preparation to enabling -Wvla, remove VLA and replace it
>> with dynamic memory allocation.
> 
> Looks good but...
> 
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>> ---
>>   net/netfilter/nfnetlink_cttimeout.c | 12 ++++++++++--
>>   1 file changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
>> index 95b0470..a2f7d92 100644
>> --- a/net/netfilter/nfnetlink_cttimeout.c
>> +++ b/net/netfilter/nfnetlink_cttimeout.c
>> @@ -52,18 +52,26 @@ ctnl_timeout_parse_policy(void *timeouts,
>>   			  struct net *net, const struct nlattr *attr)
>>   {
>>   	int ret = 0;
>> +	struct nlattr **tb = NULL;
> 
> I think we don't need to initialize this, right?
> 

We actually do have to initialized it because in the unlikely case that 
the code block inside the 'if' below is not executed, then we will end 
up freeing an uninitialized pointer.

Thanks
--
Gustavo

>>   
>>   	if (likely(l4proto->ctnl_timeout.nlattr_to_obj)) {
>> -		struct nlattr *tb[l4proto->ctnl_timeout.nlattr_max+1];
>> +		tb = kcalloc(l4proto->ctnl_timeout.nlattr_max + 1, sizeof(*tb),
>> +			     GFP_KERNEL);
>> +
>> +		if (!tb)
>> +			return -ENOMEM;
>>   
>>   		ret = nla_parse_nested(tb, l4proto->ctnl_timeout.nlattr_max,
>>   				       attr, l4proto->ctnl_timeout.nla_policy,
>>   				       NULL);
>>   		if (ret < 0)
>> -			return ret;
>> +			goto err;
>>   
>>   		ret = l4proto->ctnl_timeout.nlattr_to_obj(tb, net, timeouts);
>>   	}
>> +
>> +err:
>> +	kfree(tb);
>>   	return ret;
>>   }
>>   
>> -- 
>> 2.7.4
>>
