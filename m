Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC936271462;
	Thu, 24 Jul 2025 12:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753359876; cv=none; b=rdtmqYbXgRcDqETpQmX5oALKselvZSQl41kOGEBuRBK7hDBOeOEaIOzfiB4qatJrVBDtlhwHjy5/RrFVD+RkHk1Pti7eDw032TLv7N5B8vV3VBYTE7Pl/nFR960c6uReyQ8MDX1f9Zaq6vL76vMkb17+sOTj78teH+JQmmHqySw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753359876; c=relaxed/simple;
	bh=MfQtmHi5gS8vKYeTkI6ek8YMu3I8smDVAeOswxcH7B0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hiFwNtBjEy0kMW9pHdJ9osg9DCIV6xbqRUb+BrxDLp4qDUKY94oi5ISszs81peS7Os5QObQmZYDRly4NjP34KJMQuXlV+8RrHxPfrq1h5ntA16JO5EKKf/vIuBPiDy3Q2DFgW+60lZFFOSPRzcmavjDUXibGGuCuLDu5cqQoNNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Horz3POC; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=bGUoVqHG; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Horz3POC";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="bGUoVqHG"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id A8D3760276; Thu, 24 Jul 2025 14:24:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753359869;
	bh=GcUgJS0fieAyLE481jCBFHAVS8cIYGKv+0qIlfTBdV4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Horz3POCnLkzxPRJzh5F4NLz9L7BCTfbv2ez7J/nANhqP00RuNhewkUgz3cNWP+/S
	 1GJ2/63Yg64IIeOkFpXNt6lKUfPTLXGP67t3CI2pqOnkw7UVjztF9r5qSsg5SmpJ7P
	 QTTBzES4cK3rHSirbNFmjwiIVlH9wylHO13tCFuaCSogIEwM4gEEwVrNr5BHFTEaQe
	 BGu5ZZ41/RlXuYYQ0Sf/PFAlZeRmCQVuYKbZjPFck5dGgaCg1RIBe5O7Mv6WpepmHM
	 Di6VqVk5qUssKXv87lpQls6JYCk7jI03IDM75h1IZF6hWMLbWgmvxbV1Qy5eKbLWmJ
	 J7yXPxRysiTWg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2697E60265;
	Thu, 24 Jul 2025 14:24:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753359866;
	bh=GcUgJS0fieAyLE481jCBFHAVS8cIYGKv+0qIlfTBdV4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bGUoVqHGhc9F1s8JKAT0ZENviOY7WBpxWaydNPfd30f3S5DSlorK/Vo1/FuEt/Xgc
	 lM4lOW33Us3P+PkdrgyC93pxKQlo31o73gTa2NMX2Uekl2EhqcSzpEBmMI2evnP1I4
	 W272Ggsmc7NLHm0MkNENUUALEAldC9Q91uiNNDKiRPa6QejDlU6SxFouy2rzJhly/p
	 Hc4rcvMCG00nRytBrB7CEaV346cvwVslEDjiV2It2Dg0AnYZ9ZqnFl5y8gXsUUZ8n3
	 1AyGvBLsGeJ+maYuECHxNAXtvxnuudlUesefQICCLDlaVRH1DJ1XI817lNpjjmY4bn
	 +8MorBVcTDJ1Q==
Date: Thu, 24 Jul 2025 14:24:22 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Lance Yang <ioworker0@gmail.com>
Cc: fw@strlen.de, coreteam@netfilter.org, davem@davemloft.net,
	edumazet@google.com, horms@kernel.org, kadlec@netfilter.org,
	kuba@kernel.org, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, zi.li@linux.dev,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v2 1/1] netfilter: load nf_log_syslog on enabling
 nf_conntrack_log_invalid
Message-ID: <aIIl9u1TY84Q9mnD@calendula>
References: <20250526085902.36467-1-lance.yang@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250526085902.36467-1-lance.yang@linux.dev>

Hi,

On Mon, May 26, 2025 at 04:59:02PM +0800, Lance Yang wrote:
> diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
> index 2f666751c7e7..cdc27424f84a 100644
> --- a/net/netfilter/nf_conntrack_standalone.c
> +++ b/net/netfilter/nf_conntrack_standalone.c
> @@ -14,6 +14,7 @@
>  #include <linux/sysctl.h>
>  #endif
>  
> +#include <net/netfilter/nf_log.h>
>  #include <net/netfilter/nf_conntrack.h>
>  #include <net/netfilter/nf_conntrack_core.h>
>  #include <net/netfilter/nf_conntrack_l4proto.h>
> @@ -543,6 +544,29 @@ nf_conntrack_hash_sysctl(const struct ctl_table *table, int write,
>  	return ret;
>  }
>  
> +static int
> +nf_conntrack_log_invalid_sysctl(const struct ctl_table *table, int write,
> +				void *buffer, size_t *lenp, loff_t *ppos)
> +{
> +	int ret, i;
> +
> +	ret = proc_dou8vec_minmax(table, write, buffer, lenp, ppos);
> +	if (ret < 0 || !write)
> +		return ret;
> +
> +	if (*(u8 *)table->data == 0)
> +		return ret;

What is this table->data check for? I don't find any similar idiom
like this in the existing proc_dou8vec_minmax() callers.

> +
> +	/* Load nf_log_syslog only if no logger is currently registered */
> +	for (i = 0; i < NFPROTO_NUMPROTO; i++) {
> +		if (nf_log_is_registered(i))
> +			return ret;
> +	}
> +	request_module("%s", "nf_log_syslog");
> +
> +	return ret;
> +}
> +
>  static struct ctl_table_header *nf_ct_netfilter_header;
>  
>  enum nf_ct_sysctl_index {
> @@ -649,7 +673,7 @@ static struct ctl_table nf_ct_sysctl_table[] = {
>  		.data		= &init_net.ct.sysctl_log_invalid,
>  		.maxlen		= sizeof(u8),
>  		.mode		= 0644,
> -		.proc_handler	= proc_dou8vec_minmax,
> +		.proc_handler	= nf_conntrack_log_invalid_sysctl,
>  	},
>  	[NF_SYSCTL_CT_EXPECT_MAX] = {
>  		.procname	= "nf_conntrack_expect_max",
> diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
> index 6dd0de33eebd..c7dd5019a89d 100644
> --- a/net/netfilter/nf_log.c
> +++ b/net/netfilter/nf_log.c
> @@ -125,6 +125,33 @@ void nf_log_unregister(struct nf_logger *logger)
>  }
>  EXPORT_SYMBOL(nf_log_unregister);
>  
> +/**
> + * nf_log_is_registered - Check if any logger is registered for a given
> + * protocol family.
> + *
> + * @pf: Protocol family
> + *
> + * Returns: true if at least one logger is active for @pf, false otherwise.
> + */
> +bool nf_log_is_registered(u_int8_t pf)
> +{
> +	int i;
> +
> +	/* Out of bounds. */

No need for this comment, please remove it.

> +	if (pf >= NFPROTO_NUMPROTO) {
> +		WARN_ON_ONCE(1);
> +		return false;
> +	}
