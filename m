From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH ipset 1/2] lib: fix ifname 'physdev:' prefix parsing
Date: Thu, 13 Feb 2014 11:10:05 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1402131105220.16734@blackhole.kfki.hu>
References: <1392197240-9389-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:57633 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519AbaBMKKK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Feb 2014 05:10:10 -0500
In-Reply-To: <1392197240-9389-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Wed, 12 Feb 2014, Florian Westphal wrote:

> hash:net,iface supports matching on the bridge port as well,
> but userspace currently doesn't handle it correctly as it passes
> in 'physdev:eth0' instead of 'eth0'+IPSET_OPT_PHYSDEV.

I think the userspace does handle the case: looking at your patch, it's
exactly the same as the original one. It is nicer, so I'm happy to apply 
it, but the description - as far as I see - doesn't fit.

Maybe your kernel is not compiled with BRIDGE_NETFILTER enabled? That's 
required for the functionality at the kernel side.

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  lib/parse.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/parse.c b/lib/parse.c
> index f1c1f0e..4db872e 100644
> --- a/lib/parse.c
> +++ b/lib/parse.c
> @@ -1753,14 +1753,15 @@ ipset_parse_iface(struct ipset_session *session,
>  {
>  	struct ipset_data *data;
>  	int offset = 0, err = 0;
> +	static const char pdev_prefix[]="physdev:";
>  
>  	assert(session);
>  	assert(opt == IPSET_OPT_IFACE);
>  	assert(str);
>  
>  	data = ipset_session_data(session);
> -	if (STREQ(str, "physdev:")) {
> -		offset = 8;
> +	if (STRNEQ(str, pdev_prefix, strlen(pdev_prefix))) {
> +		offset = strlen(pdev_prefix);
>  		err = ipset_data_set(data, IPSET_OPT_PHYSDEV, str);
>  		if (err < 0)
>  			return err;
> -- 
> 1.8.1.5

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
