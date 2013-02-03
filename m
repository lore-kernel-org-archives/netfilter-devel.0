From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH] netfilter: fix missing dependencies for NETFILTER_XT_MATCH_CONNLABEL
Date: Sun, 03 Feb 2013 08:04:35 -0800
Message-ID: <510E8A93.6050300@infradead.org>
References: <510DC976.7000008@infradead.org> <1359890647-25846-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1359890647-25846-1-git-send-email-fw@strlen.de>
Sender: linux-next-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 02/03/13 03:24, Florian Westphal wrote:
> It was possible to set
> NF_CONNTRACK=n
> NF_CONNTRACK_LABELS=y
> 
> via NETFILTER_XT_MATCH_CONNLABEL=y:
> 
> warning: (NETFILTER_XT_MATCH_CONNLABEL) selects NF_CONNTRACK_LABELS which has
> unmet direct dependencies (NET && INET && NETFILTER && NF_CONNTRACK)
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
> diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
> index eb2c8eb..d4dd702 100644
> --- a/net/netfilter/Kconfig
> +++ b/net/netfilter/Kconfig
> @@ -860,6 +860,7 @@ config NETFILTER_XT_MATCH_CONNBYTES
>  config NETFILTER_XT_MATCH_CONNLABEL
>  	tristate '"connlabel" match support'
>  	select NF_CONNTRACK_LABELS
> +	depends on NF_CONNTRACK
>  	depends on NETFILTER_ADVANCED
>  	---help---
>  	  This match allows you to test and assign userspace-defined labels names
> 


-- 
~Randy
