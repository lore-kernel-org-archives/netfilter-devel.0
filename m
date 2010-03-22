From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Netfilter: Fix integer overflow in net/ipv6/netfilter/ip6_tables.c
Date: Mon, 22 Mar 2010 18:07:27 +0100
Message-ID: <4BA7A3CF.8070503@trash.net>
References: <20100320143240.GB2942@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
To: wzt.wzt@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39410 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab0CVRH3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Mar 2010 13:07:29 -0400
In-Reply-To: <20100320143240.GB2942@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

wzt.wzt@gmail.com wrote:
> The get.size field in the get_entries() interface is not bounded
> correctly. The size is used to determine the total entry size.
> The size is bounded, but can overflow and so the size checks may
> not be sufficient to catch invalid size. Fix it by catching size
> values that would cause overflows before calculating the size.
>
> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>
>
> ---
>  net/ipv4/netfilter/ip_tables.c  |    4 ++++
>  net/ipv6/netfilter/ip6_tables.c |    4 ++++
>  2 files changed, 8 insertions(+), 0 deletions(-)
>
> diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
> index 4e7c719..6abd3d2 100644
> --- a/net/ipv4/netfilter/ip_tables.c
> +++ b/net/ipv4/netfilter/ip_tables.c
> @@ -1164,6 +1164,10 @@ get_entries(struct net *net, struct ipt_get_entries __user *uptr, int *len)
>  	}
>  	if (copy_from_user(&get, uptr, sizeof(get)) != 0)
>  		return -EFAULT;
> +
> +	if (get.size >= INT_MAX / sizeof(struct ipt_get_entries))
> +		return -EINVAL;

I can see that the size might cause an overflow in the addition with
sizeof(struct ipt_get_entries), but that would most likely cause a mismatch
with the actual table size and get aborted (should be fixed anyways I
guess). But I fail to find the overflow you're trying to prevent, which
I guess would be the result of a multiplication.

Please point me to the specific line in question. Thanks :)
