Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7EF2837A
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Jun 2024 15:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718378681; cv=none; b=jUrCviecEBHC2BsJ8EAJQHTiLfsTBHXfh5sJJEjLou14ECa0PP/jxD8UsbJINnXQDSaEf9t/Nn6M9buWlklmitnS1BwBmguv/58+2+213J+RZeyGXxeOSA0uZ7w6P2SDh3DnPPA1oqJgLkJagoJIKZWUKLY7QFLblbRcwoEZnnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718378681; c=relaxed/simple;
	bh=Vs1AUgWFJb9UFxVrV8O5yjE885FfPUfhIUnsVFDBGMA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RShxC52bSTNk4ErZ25ZNtV7NrLgGmOKdgN04lQuJ6JFCTPsR6IXJOlc006RgpCDUKs9VcdISWbC2rl4pV8GbUx6tqT1Ha5nG6DR0F+gKqadb8rA5wwRiHczl5SP0PMSb2sX3hs0PZ7iNTvWOFgLeKneF/E1E26qZpDP6rKwwFgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=58328 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sI8n3-007HK8-Dq; Fri, 14 Jun 2024 17:24:35 +0200
Date: Fri, 14 Jun 2024 17:24:32 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Fabio <pedretti.fabio@gmail.com>
Subject: Re: [nf-next PATCH v2 2/2] netfilter: xt_recent: Lift restrictions
 on max hitcount value
Message-ID: <ZmxgsGWJ3IUizwVb@calendula>
References: <20240614151641.28885-1-phil@nwl.cc>
 <20240614151641.28885-3-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240614151641.28885-3-phil@nwl.cc>
X-Spam-Score: -1.9 (-)

On Fri, Jun 14, 2024 at 05:16:41PM +0200, Phil Sutter wrote:
> Support tracking of up to 65535 packets per table entry instead of just
> 255 to better facilitate longer term tracking or higher throughput
> scenarios.

Could you develop a bit more the use case to expand this? Do you have
an example rule for me?

> Requested-by: Fabio <pedretti.fabio@gmail.com>
> Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1745

Hm, original bug report only refer to documentation update?

Is there a way to know what kernel support what value? I guess not,
only probing.

Thanks.

> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  net/netfilter/xt_recent.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
> index 60259280b2d5..588a5e6ad899 100644
> --- a/net/netfilter/xt_recent.c
> +++ b/net/netfilter/xt_recent.c
> @@ -59,9 +59,9 @@ MODULE_PARM_DESC(ip_list_gid, "default owning group of /proc/net/xt_recent/* fil
>  /* retained for backwards compatibility */
>  static unsigned int ip_pkt_list_tot __read_mostly;
>  module_param(ip_pkt_list_tot, uint, 0400);
> -MODULE_PARM_DESC(ip_pkt_list_tot, "number of packets per IP address to remember (max. 255)");
> +MODULE_PARM_DESC(ip_pkt_list_tot, "number of packets per IP address to remember (max. 65535)");
>  
> -#define XT_RECENT_MAX_NSTAMPS	256
> +#define XT_RECENT_MAX_NSTAMPS	65536
>  
>  struct recent_entry {
>  	struct list_head	list;
> @@ -69,8 +69,8 @@ struct recent_entry {
>  	union nf_inet_addr	addr;
>  	u_int16_t		family;
>  	u_int8_t		ttl;
> -	u_int8_t		index;
> -	u_int8_t		nstamps;
> +	u_int16_t		index;
> +	u_int16_t		nstamps;
>  	unsigned long		stamps[];
>  };
>  
> @@ -80,7 +80,7 @@ struct recent_table {
>  	union nf_inet_addr	mask;
>  	unsigned int		refcnt;
>  	unsigned int		entries;
> -	u8			nstamps_max_mask;
> +	u_int16_t		nstamps_max_mask;
>  	struct list_head	lru_list;
>  	struct list_head	iphash[];
>  };
> -- 
> 2.43.0
> 
> 
