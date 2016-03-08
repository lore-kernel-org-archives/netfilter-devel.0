From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH 1/1] netfilter: ipset: Check IPSET_ATTR_ETHER netlink
 attribute length
Date: Tue, 08 Mar 2016 21:26:59 +0100
Message-ID: <56DF3593.7020507@iogearbox.net>
References: <1457466260-20373-1-git-send-email-kadlec@blackhole.kfki.hu> <1457466260-20373-2-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:53390 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbcCHU1D (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Mar 2016 15:27:03 -0500
In-Reply-To: <1457466260-20373-2-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

On 03/08/2016 08:44 PM, Jozsef Kadlecsik wrote:
> Julia Lawall pointed out that IPSET_ATTR_ETHER netlink attribute length
> was not checked explicitly, just for the maximum possible size. Malicious
> netlink clients could send shorter attribute and thus resulting a kernel
> read after the buffer.
>
> The patch adds the explicit length checkings.
>
> Reported-by: Julia Lawall <julia.lawall@lip6.fr>
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> ---
>   net/netfilter/ipset/ip_set_bitmap_ipmac.c | 2 ++
>   net/netfilter/ipset/ip_set_hash_mac.c     | 3 ++-
>   2 files changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
> index 29dde20..9a065f6 100644
> --- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
> +++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
> @@ -267,6 +267,8 @@ bitmap_ipmac_uadt(struct ip_set *set, struct nlattr *tb[],
>
>   	e.id = ip_to_id(map, ip);
>   	if (tb[IPSET_ATTR_ETHER]) {
> +		if (nla_len(tb[IPSET_ATTR_ETHER]) != ETH_ALEN)
> +			return -IPSET_ERR_PROTOCOL;

Any reason to not just remove the 'NLA_BINARY' from the policy?

include/net/netlink.h +191:

  * Meaning of `len' field:
[...]
  *    NLA_BINARY           Maximum length of attribute payload
[...]
  *    All other            Minimum length of attribute payload

validate_nla() will just do the right thing and check for minlen.

Thanks,
Daniel

>   		memcpy(e.ether, nla_data(tb[IPSET_ATTR_ETHER]), ETH_ALEN);
>   		e.add_mac = 1;
>   	}
> diff --git a/net/netfilter/ipset/ip_set_hash_mac.c b/net/netfilter/ipset/ip_set_hash_mac.c
> index f1e7d2c..8f004ed 100644
> --- a/net/netfilter/ipset/ip_set_hash_mac.c
> +++ b/net/netfilter/ipset/ip_set_hash_mac.c
> @@ -110,7 +110,8 @@ hash_mac4_uadt(struct ip_set *set, struct nlattr *tb[],
>   	if (tb[IPSET_ATTR_LINENO])
>   		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
>
> -	if (unlikely(!tb[IPSET_ATTR_ETHER]))
> +	if (unlikely(!tb[IPSET_ATTR_ETHER] ||
> +		     nla_len(tb[IPSET_ATTR_ETHER]) != ETH_ALEN))
>   		return -IPSET_ERR_PROTOCOL;
>
>   	ret = ip_set_get_extensions(set, tb, &ext);
>

