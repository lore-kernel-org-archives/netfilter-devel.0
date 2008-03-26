From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 2/3] Add event output and make event mask configurable
 in NFCT.
Date: Wed, 26 Mar 2008 01:40:40 +0100
Message-ID: <47E99B88.9090200@netfilter.org>
References: <12057124233723-git-send-email-eric@inl.fr> <12057124232801-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44187 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754649AbYCZAkq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 20:40:46 -0400
In-Reply-To: <12057124232801-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch contains two linked modifications in NFCT input plugin:
>  - event mask is now configurable though the event_mask configuration variable
>  - event type is now stored in the ct.event output key. This can be used to
>  display the information or to use it to implement some tracking algorithm in
>  userspace.

Just minor a cleanup glitch.

> @@ -559,28 +575,38 @@ static int event_handler(void *arg, unsigned int flags, int type,
>  {
>  	struct nfct_conntrack *ct = arg;
>  	struct ulogd_pluginstance *upi = data;
> -	struct ulogd_pluginstance *npi = NULL;
> +	struct ulogd_key *kret = upi->output.keys;
>  	struct nfct_pluginstance *cpi = 
>  				(struct nfct_pluginstance *) upi->private;
> +	struct ct_timestamp *ts = NULL;
> +	struct ulogd_pluginstance *npi = NULL;
>  	int ret = 0;
>  
> +
>  	if (type == NFCT_MSG_NEW) {
> -		if (usehash_ce(upi->config_kset).u.value != 0)
> +		if (usehash_ce(upi->config_kset).u.value != 0) {
>  			ct_hash_add(cpi->ct_active, ct->id);
> +			return 0;
> +		}
>  	} else if (type == NFCT_MSG_DESTROY) {
> -		struct ct_timestamp *ts = NULL;
> -
>  		if (usehash_ce(upi->config_kset).u.value != 0)
>  			ts = ct_hash_get(cpi->ct_active, ct->id);
> +	}
>  
> -		llist_for_each_entry(npi, &upi->plist, plist) {
> -			ret = propagate_ct(npi, ct, flags, ts);
> -			if (ret != 0)
> -				return ret;
> -		}
> -		return propagate_ct(upi, ct, flags, ts);
> +	llist_for_each_entry(npi, &upi->plist, plist) {
> +		kret = npi->output.keys;
> +		kret[NFCT_CT_EVENT].u.value.ui32 = type;
> +		kret[NFCT_CT_EVENT].flags |= ULOGD_RETF_VALID;

Better move this ^^^^ inside propagate_ct()?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
