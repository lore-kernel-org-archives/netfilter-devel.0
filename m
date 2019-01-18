From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v3] netfilter: nft_meta: Add NFT_META_I/OIFKIND meta type
Date: Fri, 18 Jan 2019 07:27:48 -0700
Message-ID: <a1a3c7cc-cdd5-3409-8296-f057c6e869c6@gmail.com>
References: <1547596431-31824-1-git-send-email-wenxu@ucloud.cn>
 <20190118142430.rsnru4hyrbsodobf@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: fw@strlen.de, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>, wenxu@ucloud.cn
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190118142430.rsnru4hyrbsodobf@salvia>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 1/18/19 7:24 AM, Pablo Neira Ayuso wrote:
> 
> There is no other way to identify a vft device rather than this
> string? The only l3mdev that exists if vrf, right?

ipvlan uses some of the hooks.

> 
> If there is no other alternative, we can just place this in the tree,
> but probably it would be better to have a numeric way to identify a
> vrf device?

IFF_L3MDEV_MASTER and IFF_L3MDEV_SLAVE are used via netif_is_l3_master
and netif_is_l3_slave in all of the code. This was done because of
requests to not bleed 'vrf' all over core kernel code.
