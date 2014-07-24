From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: don't output error message redundantly
Date: Thu, 24 Jul 2014 13:49:46 +0200
Message-ID: <20140724114946.GA21812@salvia>
References: <53CF53DD.6020308@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44413 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbaGXLth (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jul 2014 07:49:37 -0400
Content-Disposition: inline
In-Reply-To: <53CF53DD.6020308@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 23, 2014 at 02:19:09PM +0800, Duan Jiong wrote:
> 
> The function led_trigger_register() will only return -EEXIST when
> error arises.
> 
> Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
> ---
>  net/netfilter/xt_LED.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/xt_LED.c b/net/netfilter/xt_LED.c
> index 993de2b..b47a58c 100644
> --- a/net/netfilter/xt_LED.c
> +++ b/net/netfilter/xt_LED.c
> @@ -133,9 +133,7 @@ static int led_tg_check(const struct xt_tgchk_param *par)
>  
>  	err = led_trigger_register(&ledinternal->netfilter_led_trigger);
>  	if (err) {
> -		pr_warning("led_trigger_register() failed\n");
> -		if (err == -EEXIST)
> -			pr_warning("Trigger name is already in use.\n");
> +		pr_warning("Trigger name is already in use.\n");

This should be pr_err() since the rule fails to be loaded if
led_trigger_register() fails.

