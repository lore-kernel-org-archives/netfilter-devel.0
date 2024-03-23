Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69367249E6
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Mar 2024 21:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.107.17.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711229879; cv=none; b=D18cfVPVS/WEaOcOWCNpnM5Q+zFs6kuPpk5Ubt9Pqe4oOWt316S90BhNUW6oS2rdk7baV0U50w17FTnYxJDphEeWoGbadNGaRUwD8nkdB9zvLHZMcuxFcLUrKFx4H93IL1pQIZJ72KhAP9Gs8m8tqhBym6n/SUony+BHPJvYvs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711229879; c=relaxed/simple;
	bh=wwXIFoxCp2DrdRQPEz6A4O2CpwJn0tuxcpCaCW+Hyts=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RQMpHh08tgN9SFFZkCaQW77lo6qf47651luSsPh1gCnQJTJ1TlMo2yxLmYHJbjQd3YNn13Y7H5O6s+NSYZ/Tqjbvr5JXZBEioTddvEXB11xTluZuZurqQLtqMOdWmz/5DtcfkSIP3i0oo4msHLF4xhSKNmt/RZSjDqN0XLHQ2wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=194.107.17.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
	by vmicros1.altlinux.org (Postfix) with ESMTP id 7206772C8CC;
	Sun, 24 Mar 2024 00:37:53 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
	by imap.altlinux.org (Postfix) with ESMTPSA id 60EDF36D071C;
	Sun, 24 Mar 2024 00:37:53 +0300 (MSK)
Date: Sun, 24 Mar 2024 00:37:53 +0300
From: Vitaly Chikunov <vt@altlinux.org>
To: Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Jan Engelhardt <jengelh@inai.de>,
	Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
Subject: Re: [PATCH iptables] libxtables: Fix xtables_ipaddr_to_numeric calls
 with xtables_ipmask_to_numeric
Message-ID: <20240323213753.cqockivt4fwan52a@altlinux.org>
References: <20240323030641.988354-1-vt@altlinux.org>
 <Zf7fm6b4SC885EcU@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <Zf7fm6b4SC885EcU@orbyte.nwl.cc>

On Sat, Mar 23, 2024 at 02:56:43PM +0100, Phil Sutter wrote:
> On Sat, Mar 23, 2024 at 06:06:41AM +0300, Vitaly Chikunov wrote:
> > Frequently when addr/mask is printed xtables_ipaddr_to_numeric and
> > xtables_ipmask_to_numeric are called together in one printf call but
> > xtables_ipmask_to_numeric internally calls xtables_ipaddr_to_numeric
> > which prints into the same static buffer causing buffer to be
> > overwritten and addr/mask incorrectly printed in such call scenarios.
> > 
> > Make xtables_ipaddr_to_numeric to use two static buffers rotating their
> > use. This simplistic approach will leave ABI not changed and cover all
> > such use cases.
> 
> I don't quite like the cat'n'mouse game this opens, although it's
> unlikely someone calls it a third time before copying the buffer.
> 
> What do you think about the attached solution?

Your approach is indeed much better. But why double underscore prefix
to a function name, this sounds like reserved identifiers.

 https://en.cppreference.com/w/c/language/identifier

Thanks,
  
> 
> Thanks, Phil

> diff --git a/libxtables/xtables.c b/libxtables/xtables.c
> index f2fcc5c22fb61..54df1bc9336dd 100644
> --- a/libxtables/xtables.c
> +++ b/libxtables/xtables.c
> @@ -1511,12 +1511,19 @@ void xtables_param_act(unsigned int status, const char *p1, ...)
>  	va_end(args);
>  }
>  
> +static void
> +__xtables_ipaddr_to_numeric(const struct in_addr *addrp, char *bufp)
> +{
> +	const unsigned char *bytep = (const void *)&addrp->s_addr;
> +
> +	sprintf(bufp, "%u.%u.%u.%u", bytep[0], bytep[1], bytep[2], bytep[3]);
> +}
> +
>  const char *xtables_ipaddr_to_numeric(const struct in_addr *addrp)
>  {
>  	static char buf[16];
> -	const unsigned char *bytep = (const void *)&addrp->s_addr;
>  
> -	sprintf(buf, "%u.%u.%u.%u", bytep[0], bytep[1], bytep[2], bytep[3]);
> +	__xtables_ipaddr_to_numeric(addrp, buf);
>  	return buf;
>  }
>  
> @@ -1583,7 +1590,8 @@ const char *xtables_ipmask_to_numeric(const struct in_addr *mask)
>  	cidr = xtables_ipmask_to_cidr(mask);
>  	if (cidr == (unsigned int)-1) {
>  		/* mask was not a decent combination of 1's and 0's */
> -		sprintf(buf, "/%s", xtables_ipaddr_to_numeric(mask));
> +		buf[0] = '/';
> +		__xtables_ipaddr_to_numeric(mask, buf + 1);
>  		return buf;
>  	} else if (cidr == 32) {
>  		/* we don't want to see "/32" */

