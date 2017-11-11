From: Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH RFC,WIP 5/5] netfilter: nft_flow_offload: add ndo hooks
 for hardware offload
Date: Sat, 11 Nov 2017 13:49:29 +0100
Message-ID: <da3043ff-818a-373f-4099-73c09c47e8f0@nbd.name>
References: <20171103152636.9967-1-pablo@netfilter.org>
 <20171103152636.9967-6-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171103152636.9967-6-pablo@netfilter.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 2017-11-03 16:26, Pablo Neira Ayuso wrote:
> This patch adds the infrastructure to offload flows to hardware, in case
> the nic/switch comes with built-in flow tables capabilities.
> 
> If the hardware comes with not hardware flow tables or they have
> limitations in terms of features, this falls back to the software
> generic flow table implementation.
> 
> The software flow table aging thread skips entries that resides in the
> hardware, so the hardware will be responsible for releasing this flow
> table entry too.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Hi Pablo,

I'd like to start playing with those patches in OpenWrt/LEDE soon. I'm
also considering making a patch that adds iptables support.
For that to work, I think it would be a good idea to keep the code that
tries to offload flows to hardware in nf_flow_offload.c instead, so that
it can be shared with iptables integration.

By the way, do you have a git tree where you keep the current version of
your patch set?

Thanks,

- Felix
