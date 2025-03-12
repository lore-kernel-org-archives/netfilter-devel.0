Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8EF41DB356
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 08:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741768641; cv=none; b=l5maNo41HRDKfjaoAaz0em3wW8qdzTjXHNQY3plCV6IBmf1TGkQIZgsRO1FSL2Jz2XLG2uKzseV6Xtjtgi0zb70rdIexaXS/YjSS5kkFyvKUcqg2qS1nDtypvXHRQIbA3IPdkeBeTDa0gMBSOvKTXoe9A2UHwzSZkLR0XoxHQM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741768641; c=relaxed/simple;
	bh=6hk5ORo4r2gkeTIz/wT8ycmO2sGMcUb8FsbmgIt+VBg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oJ+ynlfVCcOY8MsReZ9semR7OWdkOd8f59BNa06REqj3aSs6QdipKrjv64k7cXiG7mNfeXBbAGycIeWJ19+K5/3uNvWdaXLL7fhf4u8rs8FxK1T0p906jSye/On4ZY8HzJuJxPP0JdmHovi6sPQULcMPz69l7bbDwpziaC2XaA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tsHaW-0003kT-Oy; Wed, 12 Mar 2025 09:37:16 +0100
Date: Wed, 12 Mar 2025 09:37:16 +0100
From: Florian Westphal <fw@strlen.de>
To: Corubba Smith <corubba@gmx.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH ulogd2] nfct: add network namespace support
Message-ID: <20250312083716.GA14222@breakpoint.cc>
References: <7d1478b6-ec25-4286-a365-ce28293f4a40@gmx.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d1478b6-ec25-4286-a365-ce28293f4a40@gmx.de>
User-Agent: Mutt/1.10.1 (2018-07-13)

Corubba Smith <corubba@gmx.de> wrote:
> Add a new option which allows opening the netlink socket in a different
> network namespace. This way you can run ulogd in one (management)
> network namespace which is able to talk with your export target (e.g.
> database or IPFIX collector), and import flows from multiple (customer)
> network namespaces.

Makes sense to me.

> This commit only implements it for NFCT. I wanted to gather some
> feedback before also implementing it for the other netlink-based
> plugins.

Does it make sense to have this configured on a per-plugin basis?

>    Input plugins:
>      NFLOG plugin:			${enable_nflog}
>      NFCT plugin:			${enable_nfct}

> +#ifdef NETNS_SUPPORT
> +	if (strlen(target_netns_path) > 0) {
> +		errno = 0;
> +		original_netns_fd = open("/proc/self/ns/net", O_RDONLY | O_CLOEXEC);
> +		if (original_netns_fd < 0) {
> +			ulogd_log(ULOGD_FATAL, "error opening original network namespace: %s\n", strerror(errno));
> +			goto err_ons;
> +		}

I think that in order to not have copypastry in all relevant plugins
it would be better to turn code in the NETNS_SUPPORT ifdefs section
into library helpers.

The helpers would always exist; in case ulogd2 is built without
support they would raise an error.

That would also keep the ifdef out of plugin code.
