From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nf_log_ipv6: correct typo in module description
Date: Fri, 28 Nov 2014 17:29:25 +0100
Message-ID: <20141128162925.GA3729@salvia>
References: <1417155739-5263-1-git-send-email-steven@uplinklabs.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Steven Noonan <steven@uplinklabs.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50901 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117AbaK1Q1W (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:27:22 -0500
Content-Disposition: inline
In-Reply-To: <1417155739-5263-1-git-send-email-steven@uplinklabs.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 27, 2014 at 10:22:19PM -0800, Steven Noonan wrote:
> It incorrectly identifies itself as "IPv4" packet logging.

Applied.

Please, Cc netfilter-devel@vger.kernel.org in your future patches.

Thanks.

> Signed-off-by: Steven Noonan <steven@uplinklabs.net>
> ---
>  net/ipv6/netfilter/nf_log_ipv6.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/netfilter/nf_log_ipv6.c b/net/ipv6/netfilter/nf_log_ipv6.c
> index 7b17a0b..41b9ade 100644
> --- a/net/ipv6/netfilter/nf_log_ipv6.c
> +++ b/net/ipv6/netfilter/nf_log_ipv6.c
> @@ -412,6 +412,6 @@ module_init(nf_log_ipv6_init);
>  module_exit(nf_log_ipv6_exit);
>  
>  MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
> -MODULE_DESCRIPTION("Netfilter IPv4 packet logging");
> +MODULE_DESCRIPTION("Netfilter IPv6 packet logging");
>  MODULE_LICENSE("GPL");
>  MODULE_ALIAS_NF_LOGGER(AF_INET6, 0);
> -- 
> 2.1.3
> 
