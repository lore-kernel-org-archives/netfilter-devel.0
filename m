From: wenxu <wenxu@ucloud.cn>
Subject: Re: [PATCH] netfilter: nft_meta: Add NFT_META_L3MASTER meta type
Date: Tue, 15 Jan 2019 23:19:23 +0800
Message-ID: <487a3378-da1b-8c7e-4e86-6ac82aa418ac@ucloud.cn>
References: <1547529039-26786-1-git-send-email-wenxu@ucloud.cn>
 <20190115111738.luy6pmhkvbb42dio@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org, dsahern@gmail.com,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190115111738.luy6pmhkvbb42dio@breakpoint.cc>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 2019/1/15 下午7:17, Florian Westphal wrote:
> wenxu@ucloud.cn <wenxu@ucloud.cn> wrote:
>> From: wenxu <wenxu@ucloud.cn>
>> so with this patch userspace can add the 'don't re-do entire ruleset for vrf' policy
>> itself like the following
>>
>> nft add rule firewall rules-all meta l3master true counter accept
> I wonder if we need to support this also for output interface, and if
> this should be specific to vrf or not.
>
> Example:
>
> meta iifl3master exists accept
> meta oifl3master exists accept
> or
> meta iifkind "vrf" accept
> meta oifkind "vrf" accept
>
> (the latter could e.g. place rtnl_op ".kind" in the register)
>
> Not sure if that would ever be useful beyond vrf.
>
yes, iifkind type mus useful for most other cases.
