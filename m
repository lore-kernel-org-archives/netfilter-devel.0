From: wenxu <wenxu@ucloud.cn>
Subject: Re: [PATCH v2] netfilter: x_tables: add xt_tunnel match
Date: Fri, 18 Jan 2019 23:41:25 +0800
Message-ID: <55d8a82d-34f6-7b76-8ca6-f8154ce1bca1@ucloud.cn>
References: <1547097368-31835-1-git-send-email-wenxu@ucloud.cn>
 <20190118141855.nahvtvabfysclv55@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190118141855.nahvtvabfysclv55@salvia>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 2019/1/18 下午10:18, Pablo Neira Ayuso wrote:
> On Thu, Jan 10, 2019 at 01:16:08PM +0800, wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> This patch allows us to match on the tunnel metadata that is available
>> of the packet. We can use this to validate if the packet comes from/goes
>> to tunnel and the corresponding tunnel ID in the iptables.
> One more question, we already have support for this in nft_tunnel.c,
> would it be good if we just add the missing pieces to userspace there?
> I have some patches here I need to push out for this...
>
Yes, nftables can do this. I just want the people also can get it through iptables.

Anyway It's  fine for me. 
