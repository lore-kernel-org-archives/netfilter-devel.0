Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F69F13C8F9
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Jul 2024 09:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721984467; cv=none; b=YBWi1PZbwTM2GB36IMBv6mljhm2iprO9eVXqvjtVH66PkhDZTPiLNXXQmTvpJF+ALjdrtQdayKzJJSsYaLUMA1SoRnNqz77WUgbdIluiZL4mDtVmMpwXqHmJSwWujUxFUf46/hIqJ64BTpUdP8u5hYCFYzGAeZ0gVKHuix5L0oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721984467; c=relaxed/simple;
	bh=P0QSDO/0TSliyPbG9Kx7RMQ75dc0KaWEcZ/GbOkCc8c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AlX8yTzu67WnCx6BGLl7Za/kFlmcel9o8iT7JVU5srxhhYyJDDQ7uwoCU3poNV+fpf6FFQcAxKG4lA8xgdRnWat+3UFvb4PqdWy9Mp5q2unR+3TXuyX5/LLDZUz84Roy6N0rFiBRguQOHeje/ppPzXthTyjgqBQwj/dJeB2/sCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [37.29.213.51] (port=3344 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sXGoi-004nna-LO; Fri, 26 Jul 2024 11:00:51 +0200
Date: Fri, 26 Jul 2024 11:00:46 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nft 1/4] doc: add documentation about list hooks feature
Message-ID: <ZqNlvkJ2YSc-KIKb@calendula>
References: <20240726015837.14572-1-fw@strlen.de>
 <20240726015837.14572-2-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240726015837.14572-2-fw@strlen.de>
X-Spam-Score: -1.9 (-)

On Fri, Jul 26, 2024 at 03:58:28AM +0200, Florian Westphal wrote:
> Add a brief segment about 'nft list hooks' and a summary
> of the output format.
> 
> As nft.txt is quite large, split the additonal commands
> into their own file.
> 
> The existing listing section is removed; list subcommand is
> already mentioned in the relevant statement sections.
> 
> Reported-by: Phil Sutter <phil@nwl.cc>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Makefile.am                 |   1 +
>  doc/additional-commands.txt | 115 ++++++++++++++++++++++++++++++++++++
>  doc/nft.txt                 |  63 +-------------------
>  3 files changed, 117 insertions(+), 62 deletions(-)
>  create mode 100644 doc/additional-commands.txt
> 
> diff --git a/Makefile.am b/Makefile.am
> index 9088170bfc68..ef198dafcbc8 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -322,6 +322,7 @@ A2X_OPTS_MANPAGE = \
>  ASCIIDOC_MAIN = doc/nft.txt
>  
>  ASCIIDOC_INCLUDES = \
> +	doc/additional-commands.txt \
>  	doc/data-types.txt \
>  	doc/payload-expression.txt \
>  	doc/primary-expression.txt \
> diff --git a/doc/additional-commands.txt b/doc/additional-commands.txt
> new file mode 100644
> index 000000000000..dd1b3d2d87d4
> --- /dev/null
> +++ b/doc/additional-commands.txt
> @@ -0,0 +1,115 @@
> +LIST HOOKS
> +~~~~~~~~~~
> +
> +This shows the low-level netfilter processing pipeline, including
> +functions registered by kernel modules such as nf_conntrack. +
> +
> +[verse]
> +____
> +*list hooks* ['family']
> +*list hooks netdev device* 'DEVICE_NAME'
> +____
> +
> +*list hooks* is enough to display everything that is active
> +on the system, however, it does currently omit hooks that are
> +tied to a specific network device (netdev family). To obtain
> +those, the network device needs to be queried by name.

IIRC, the idea is to display the ingress path pipeline according to
the device (if specified)

        list hooks netdev eth0

as for egress, as it is not possible to know where the packet is
going, it is probably good to allow the user to specify the output
device, so it gets the entire pipeline for ingress and egress
paths, ie.

list hooks netdev eth0 eth1

Note that this is not implemented. This has limitations, discovering
eth{0,1} belongs to bridge device would need more work (not asking to
do this now, but it could be a nice usability feature to discover the
pipeline?).
