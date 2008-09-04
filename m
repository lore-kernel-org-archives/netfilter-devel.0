From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 03/38] netns nf: ip6table_mangle in netns for real
Date: Thu, 04 Sep 2008 18:03:43 +0200
Message-ID: <48C006DF.1070202@trash.net>
References: <20080821215739.GC31136@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	containers@lists.linux-foundation.org
To: adobriyan@gmail.com
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20080821215739.GC31136@x200.localdomain>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

adobriyan@gmail.com wrote:
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Applied, thanks.

> @@ -108,7 +120,7 @@ ip6t_local_hook(unsigned int hook,
>  	/* flowlabel and prio (includes version, which shouldn't change either */
>  	flowlabel = *((u_int32_t *)ipv6_hdr(skb));
>  
> -	ret = ip6t_do_table(skb, hook, in, out, init_net.ipv6.ip6table_mangle);
> +	ret = ip6t_do_table(skb, hook, in, out, dev_net(out)->ipv6.ip6table_mangle);

I've fixed this to stay under the 80 char limit.

