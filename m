From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Android netfilter patches (xt_IDLETIMER) [3/3]
Date: Tue, 26 Mar 2013 13:48:31 +0100
Message-ID: <20130326124831.GB5434@localhost>
References: <5150CB1E.7050409@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: dmitry pervushin <dpervushin@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54583 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755621Ab3CZMsf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Mar 2013 08:48:35 -0400
Content-Disposition: inline
In-Reply-To: <5150CB1E.7050409@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 25, 2013 at 11:09:34PM +0100, dmitry pervushin wrote:
> Changes to iptables to use updated kernel IDLETIMER structures
> 
> Signed-off-by: dmitry pervushin <dpervushin@gmail.com>
> 
> diff --git a/extensions/libxt_IDLETIMER.c b/extensions/libxt_IDLETIMER.c
> index 21004a4..fc7a18c 100644
> --- a/extensions/libxt_IDLETIMER.c
> +++ b/extensions/libxt_IDLETIMER.c
[...]
>  static struct xtables_target idletimer_tg_reg = {
>  	.family	       = NFPROTO_UNSPEC,
>  	.name	       = "IDLETIMER",
>  	.version       = XTABLES_VERSION,
> -	.revision      = 0,
> -	.size	       = XT_ALIGN(sizeof(struct idletimer_tg_info)),
> -	.userspacesize = offsetof(struct idletimer_tg_info, timer),
> +	.revision      = 1,
> +	.size	       = XT_ALIGN(sizeof(struct idletimer_tg_info_v1)),
> +	.userspacesize = offsetof(struct idletimer_tg_info_v1, timer),
>  	.help	       = idletimer_tg_help,
>  	.x6_parse      = xtables_option_parse,
>  	.print	       = idletimer_tg_print,

We still need the old revision 0 in the iptables user-space code.
There is people that may be using new iptables versions with old
kernels.
