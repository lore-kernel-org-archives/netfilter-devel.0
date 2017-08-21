From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATH nft v2 11/18] libnftables: move iface_cache_release to
 deinit
Date: Mon, 21 Aug 2017 10:33:18 +0200
Message-ID: <20170821083317.GH2982@salvia>
References: <20170819152420.22563-1-eric@regit.org>
 <20170819152420.22563-12-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:53237 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751088AbdHUIdq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2017 04:33:46 -0400
Content-Disposition: inline
In-Reply-To: <20170819152420.22563-12-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Aug 19, 2017 at 05:24:13PM +0200, Eric Leblond wrote:
> Signed-off-by: Eric Leblond <eric@regit.org>
> ---
>  src/libnftables.c | 1 +
>  src/main.c        | 1 -
>  2 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/libnftables.c b/src/libnftables.c
> index 19d539c..2228156 100644
> --- a/src/libnftables.c
> +++ b/src/libnftables.c
> @@ -50,6 +50,7 @@ void nft_global_init(void)
>  
>  void nft_global_deinit(void)
>  {
> +	iface_cache_release();

Is this a leftover?

With git interactive rebase you can move this patch where it belongs
and squash it to original.

>  	ct_label_table_exit();
>  	realm_table_rt_exit();
>  	devgroup_table_exit();
> diff --git a/src/main.c b/src/main.c
> index 2cb7e6f..08d77d0 100644
> --- a/src/main.c
> +++ b/src/main.c
> @@ -307,7 +307,6 @@ int main(int argc, char * const *argv)
>  
>  out:
>  	xfree(buf);
> -	iface_cache_release();
>  	nft_context_free(nft);
>  	nft_global_deinit();
>  
> -- 
> 2.14.1
> 
