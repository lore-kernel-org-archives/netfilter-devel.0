Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E404166F3A
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Nov 2024 09:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731319195; cv=none; b=WwqfCeJVK+X1Ott7kGZ8NH7tintMkanfti0lp2ZG8a5MQqx5WjPae3HmrL/DWcpMfqonMWsMhJvm7Bnh33TZaN7P2Qysf8MZcYtal2SCNq8stTRiSgPakRH+Ntar+jFHgSKnc1wLyDSpt6PdvqwgxPhkyYLh8fPhGrIQ1JQ/ZC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731319195; c=relaxed/simple;
	bh=iqC6KeUrTysdAtcU845GP7OWvZx6hNnNnOmQOmLtQxo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hI/fiXPMPS1smNbdz64lVgrmREzpmyQfq96T4wKCLne29iUEA75dnkmXOCXLK60Nh2TlN3SgQwtaYvAlpBuAcROpD0Y7VazbUVB5dGjoXqfWF+f2timF/XHhkygIPBIEIlmztn2oTdH8ZGiQ+gcVHdgUObl5XhrurCkxWgcCHR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=52110 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tARD0-001KYi-Je; Mon, 11 Nov 2024 10:59:48 +0100
Date: Mon, 11 Nov 2024 10:59:45 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH iptables] ip[6]tables-translate: fix test failures when
 WESP is defined
Message-ID: <ZzHVkTfgbIgeMEnT@calendula>
References: <20241108173443.4146022-1-jeremy@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241108173443.4146022-1-jeremy@azazel.net>
X-Spam-Score: -1.9 (-)

On Fri, Nov 08, 2024 at 05:34:43PM +0000, Jeremy Sowden wrote:
> Protocol number 141 is assigned to a real protocol: Wrapped Encapsulating
> Security Payload.  This is listed in Debian's /etc/protocols, which leads to
> test failures:
> 
>   ./extensions/generic.txlate: Fail
>   src: iptables-translate -A FORWARD -p 141
>   exp: nft 'add rule ip filter FORWARD ip protocol 141 counter'
>   res: nft 'add rule ip filter FORWARD ip protocol wesp counter'
> 
>   ./extensions/generic.txlate: Fail
>   src: ip6tables-translate -A FORWARD -p 141
>   exp: nft 'add rule ip6 filter FORWARD meta l4proto 141 counter'
>   res: nft 'add rule ip6 filter FORWARD meta l4proto wesp counter'
> 
>   ./extensions/generic.txlate: Fail
>   src: iptables-translate -A FORWARD ! -p 141
>   exp: nft 'add rule ip filter FORWARD ip protocol != 141 counter'
>   res: nft 'add rule ip filter FORWARD ip protocol != wesp counter'
> 
>   ./extensions/generic.txlate: Fail
>   src: ip6tables-translate -A FORWARD ! -p 141
>   exp: nft 'add rule ip6 filter FORWARD meta l4proto != 141 counter'
>   res: nft 'add rule ip6 filter FORWARD meta l4proto != wesp counter'
> 
> Replace it with 253, which IANA reserves for testing and experimentation.
> 
> Fixes: fcaa99ca9e3c ("xtables-translate: Leverage stored protocol names")
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
