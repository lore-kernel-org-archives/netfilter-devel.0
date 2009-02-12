From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: [PATCH] libxtables: Dont initialize global xt_params
Date: Thu, 12 Feb 2009 16:09:42 +0100
Message-ID: <200902121609.43664.thomas.jarosch@intra2net.com>
References: <1234448162.3271.1.camel@dogo.mojatatu.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Jan Engelhardt <jengelh@medozas.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: hadi@cyberus.ca
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re01.intra2net.com ([82.165.28.202]:58471 "EHLO
	re01.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbZBLPkE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2009 10:40:04 -0500
In-Reply-To: <1234448162.3271.1.camel@dogo.mojatatu.com>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jamal,

On Thursday, 12. February 2009 15:16:02 jamal wrote:
> commit 7aad144ecaf7603b17af5372886fe491c3bc6a2f
> Author: Jamal Hadi Salim <hadi@cyberus.ca>
> Date:   Wed Feb 11 16:19:30 2009 -0500
>
>     Dont initialize global xt_params
>     To quote Jan Engelhardt <jengelh@medozas.de>
>     "
>     Do not initialize static members - this takes up extra space
>     and adds no benefit. (zeroed anyway even in .bss)
>     "
>
>     Signed-off-by: Jamal Hadi Salim <hadi@cyberus.ca>
>
> diff --git a/xtables.c b/xtables.c
> index 8e28d5e..114a393 100644
> --- a/xtables.c
> +++ b/xtables.c
> @@ -48,7 +48,7 @@
>
>  void basic_exit_err(enum xtables_exittype status, const char *msg, ...)
> __attribute__((noreturn, format(printf,2,3)));
>
> -struct xtables_globals *xt_params = NULL;
> +struct xtables_globals *xt_params;

Thanks for your patch. Did you know about zeroing of .bss before?

I see two possible drawbacks using this style:

1. Other people which don't know this "trick" will think
the variable is not initialized -> Hard to read.

2. If that variable gets moved f.e. inside a function, it will become 
uninitialized. Also I'm not sure if the savings are even measurable...

Just my two cents
Thomas

