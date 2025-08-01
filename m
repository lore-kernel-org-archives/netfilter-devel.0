Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6275E17BA5
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Aug 2025 11:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754049025; cv=none; b=qlWdTs3NHF5t2XUnqXTSzHaAvrbc1gTc7tsVlgUcWY7My1s/EhQaaLNALZgOIHnuieqSDGk5cFunNmqxy9gqrupX46syW/tvhinskW2yHdmeC5rYAHfScT8MfsCgMUlQZE0C3eR9+oN9TapLOONuPXfE2eb/hEVOgh9MIzMVSzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754049025; c=relaxed/simple;
	bh=keJWBYLWOUdktsGqqRVlSZRE6sL0p6WyTL4nDNHjURo=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hC5DJsSLoepnl1zBzSOeZzfWJfEF9GfEk+HpuhV4I82Sr/zFrffLRcdb9dC9SPSmGdKO7jMId2fGG6awi/TAQrSOlX3Sfy29gG44Sbh2s3zsQODtykRttuRX3G1vW/vXma+gQphueTd680O+zC2M3Btirgqc9XEn3LmmVOlf/u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ZB1GAUfS; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ZB1GAUfS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=JDk8OA1tibG2MDhjgu9++F1AMQoL6T7MWVnQ201Da68=; b=ZB1GAUfSNKQ/P91g3GMtlk1KFk
	5GlUSIhrtVdc9dn4e3E0JeBgFMigg8Hcq1qc6WPUl6TptT+2tWeqlu+XUROy18/LC8odTVE3exBwt
	aSrkKkM+kJXm4J/tF3tKeNX9OsLwIIu5QIc/c3dGHdzxVRCxDzw3/dugnBmohWQ626+sVx3Robh9u
	YYvFBACSEs8IFNVLwc9TQMZEl9aC+NR3MYwRhnhHYYkCT/euOBR5uvp1NSAbU4RqD+eiLj7P6ihoe
	zcnfBTJH6jgeg1kLJP4jMs8yfovl0HonhvMqutSW792dnCxedSeJx3Ymk0yvIVJnmY16oyldwYjl4
	AT+OD6AA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uhoHF-000000005dy-2bmB
	for netfilter-devel@vger.kernel.org;
	Fri, 01 Aug 2025 13:50:21 +0200
Date: Fri, 1 Aug 2025 13:50:21 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] doc: nft.8: Minor NAT STATEMENTS section review
Message-ID: <aIyp_aCIQVNwzI20@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
References: <20250801105258.2396-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250801105258.2396-1-phil@nwl.cc>

On Fri, Aug 01, 2025 at 12:52:58PM +0200, Phil Sutter wrote:
> Synopsis insinuates an IP address argument is mandatory in snat/dnat
> statements although specifying ports alone is perfectly fine. Adjust it
> accordingly and add a paragraph briefly describing the behaviour.
> 
> While at it, update the redirect statement description with more
> relevant examples, the current one is wrong: To *only* alter the
> destination port, dnat statement must be used, not redirect.
> 
> Fixes: 6908a677ba04c ("nft.8: Enhance NAT documentation")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
