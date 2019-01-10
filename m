From: wenxu <wenxu@ucloud.cn>
Subject: Re: [PATCH] netfilter: x_tables: add xt_tunnel match
Date: Thu, 10 Jan 2019 12:46:35 +0800
Message-ID: <30391cb7-d35d-c474-5e85-b4e77461a223@ucloud.cn>
References: <1545387144-5796-1-git-send-email-wenxu@ucloud.cn>
 <20190109164143.d6gqky7dvxfxg7jr@salvia>
 <5dfb9bb4-5148-9288-dcee-22b7d3997a1a@ucloud.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <5dfb9bb4-5148-9288-dcee-22b7d3997a1a@ucloud.cn>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On 1/10/2019 12:05 PM, wenxu wrote:
> On 1/10/2019 12:41 AM, Pablo Neira Ayuso wrote:
>> On Fri, Dec 21, 2018 at 06:12:24PM +0800, wenxu@ucloud.cn wrote:
>> [...]
>>> +static struct xt_match tunnel_mt_reg __read_mostly = {
>>> +	.name           = "tunnel",
>>> +	.revision       = 0,
>>> +	.family         = NFPROTO_UNSPEC,
>>> +	.match          = tunnel_mt,
>>> +	.matchsize      = sizeof(struct xt_tunnel_mtinfo),
>> Does this work away from the prerouting hook?
> Yes, I just test all the hooks. It can work for ingress packet match for PREROUTING and INPUT.
>
> egress packet (output go through a lwtunnel) on FORWARD, OUTPUT and POSTROUTING.
sorry I check that the INPUT hook can't be work for this
