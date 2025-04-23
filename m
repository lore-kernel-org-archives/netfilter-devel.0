Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D69F26E160
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Apr 2025 11:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745407329; cv=none; b=tQrinsohJE75R3Puagtzf/52E0NAgbvjybLPURj5n+1R12uquBrspx/mqkohWL52d2vfVMrEC7tC/w8xQXtIG/tj01CKR/NMAD3PCTYNnqaQ+D2tJZYubnSKJL6/aTm86rxs5lfSkohqL2ke9lnBA/S0eC4GpqpZw5pXSd9GVIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745407329; c=relaxed/simple;
	bh=koOWAHAZq2rd25jwvr/K1loNKy1kq/KGuNdb0sMf+1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HALGk2Zx+uQLfeHQtJ1fu7seUA8VaXlLn7c4Cn5B03BpVtjT4A/BOQl4auWm6ZujTGqLCl4eHfyDeJ94CHxZlxpZHwkEt3FYi+XgHTf7cX2yAwxMLpXOukKlseqf/zDA2apnR/OO/K2jafi6ur1WTVgefJ2ZLnkNJM72tUn0S0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1u7YB2-000217-H8; Wed, 23 Apr 2025 13:22:04 +0200
Date: Wed, 23 Apr 2025 13:22:04 +0200
From: Florian Westphal <fw@strlen.de>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>,
	Slavko <linux@slavino.sk>
Subject: Re: [PATCH ulogd2 2/6] db, IP2BIN: correct `format_ipv6()` output
 buffer sizes
Message-ID: <20250423112204.GA7371@breakpoint.cc>
References: <20250420172025.1994494-1-jeremy@azazel.net>
 <20250420172025.1994494-3-jeremy@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250420172025.1994494-3-jeremy@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)

Jeremy Sowden <jeremy@azazel.net> wrote:
> `format_ipv6()` formats IPv6 addresses as hex-strings.  However, sizing for the
> output buffer is not done quite right.
> 
> `format_ipv6()` itself uses the size of `struct in6_addr` to verify that the
> buffer size is large enough, and the output buffer for the call in util/db.c is
> sized the same way.  However, the size that should be used is that of the
> `s6_addr` member of `struct in6_addr`, not that of the whole structure.

?

In what uinverse is sizeof(struct in6_addr) different from
sizeof(((struct in6_addr) {}).s6_addr)?

> The elements of the `ipbin_array` array in ulogd_filter_IP2BIN.c are sized using
> a local macro, `IPADDR_LENGTH`, which is defined as 128, the number of bits in
> an IPv6 address; this is much larger than necessary.

Agreed.

> +#define FORMAT_IPV6_BUFSZ (2 + sizeof(((struct in6_addr) {}).s6_addr) * 2 + 1)

I'd prefer to not use the .s6_addr, its not needed.

> -		for (unsigned j = 0; i < sizeof(*ipv6); j += 4, i += 8) {
> +		for (unsigned j = 0; i < sizeof(ipv6->s6_addr); j += 4, i += 8) {

I would leave this as-is.

First patch looks good, I'll apply it later today.  Still reviewing the
rest.
