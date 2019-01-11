From: wenxu <wenxu@ucloud.cn>
Subject: Re: [PATCH v2] netfilter: x_tables: add xt_tunnel match
Date: Fri, 11 Jan 2019 11:09:39 +0800
Message-ID: <2e6b7801-7988-c532-52ca-e6f18a81e341@ucloud.cn>
References: <1547097368-31835-1-git-send-email-wenxu@ucloud.cn>
 <20190110181514.76mkggdfbgdvxkav@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190110181514.76mkggdfbgdvxkav@salvia>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On 1/11/2019 2:15 AM, Pablo Neira Ayuso wrote:
> On Thu, Jan 10, 2019 at 01:16:08PM +0800, wenxu@ucloud.cn wrote:
> [...]
>> +static struct xt_match tunnel_mt_reg __read_mostly = {
>> +	.name           = "tunnel",
>> +	.revision       = 0,
>> +	.family         = NFPROTO_UNSPEC,
>> +	.match          = tunnel_mt,
>> +	.matchsize      = sizeof(struct xt_tunnel_mtinfo),
>> +	.hooks          = ((1 << NF_INET_PRE_ROUTING) |
>> +					  (1 << NF_INET_POST_ROUTING) |
>> +					  (1 << NF_INET_LOCAL_OUT) |
>> +					  (1 << NF_INET_FORWARD)),
> Are you sure this works from the forward chain? This template is
> dropped after the route lookup.
>
> Thanks.

Yes.  NF_INET_FORWARD is also used to match the packet goes to tunnel(IP_TUNNEL_INFO_TX type), After route lookup, the packet send to tunnel through lwtunnel-route.

NF_INET_PRE_ROUTING can be used for 'from' tunnel match, The other three hooks can be used for 'to' tunnel match.
