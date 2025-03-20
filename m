Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2131E1308
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Mar 2025 15:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742485186; cv=none; b=TWva9Z1GiFuvVUEKkV59yPX983GxbQAtFU50DrughbX7BskCazSL763UxBjTKHlK6/g4nQ6OB1W921+G8yX6H9U5eyGblk+H0KdON3i6pPXGrkYYxci7FZPyn353DckS8lBpsacSXyW22xbLjchGdBWGd50dMr4eIj6FEXxZvYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742485186; c=relaxed/simple;
	bh=leyNnFkOUlC53e55UIdq/pbaRuhD6AgorOpJcoYKfys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=go0eUzOdC2ubDk+RBjGfztJruO9h4jQ5az224GrYOGa+5MhW7cSjprLrp5bh8tPI7ygX9smKQxCM/G8F8yeAJsx0b+/pbbCipa12KyooNw84hFlSlg7L/NVGZ+vrRXYegrgKzj/2JLP1EWVbEdUZI3vbIagIvQFsDzNa4ja+e0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=aaCGk1ST; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="aaCGk1ST"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=U19HLXG3ayevhnvtfas6O5uHNq5V/YGQYDYWpo7FQUc=; b=aaCGk1STQ/svItja2nei7td7Ar
	hV5JKcrmJNGHqx3/mjEf3AxXF0l7Klj0Dn/qGixTZre6IdS+myW62t4PhCzroHaAsiQlcFyFxL4hS
	0AzZ3XjhFRtdR3LFs3IgdZl2mqyCNWHD9BTNUpb0USCdaRUHBb8i0xrYYdDf5WZxgY/CKZDN9Tp4E
	ClqtQj2NxlibdGlXXu5SBP2s3woYIENXoeiIWNHOE1cVS26110mNhy3qT3ysaeqf3n64UcwpJX4ho
	i+QKOysMuYR3k60wqz/zpEJEOQAfS/fjKKDgqjaJ1x28gp67sh8N3Jv1DgablLoatNqCFmtkBOcAV
	MLXO9KpA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tvHzg-0000000014F-0k10;
	Thu, 20 Mar 2025 16:39:40 +0100
Date: Thu, 20 Mar 2025 16:39:40 +0100
From: Phil Sutter <phil@nwl.cc>
To: Guido Trentalancia <guido@trentalancia.com>
Cc: Jan Engelhardt <ej@inai.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables]: xtables: tolerate DNS lookup failures
Message-ID: <Z9w2vLdyQfWepMET@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Guido Trentalancia <guido@trentalancia.com>,
	Jan Engelhardt <ej@inai.de>, netfilter-devel@vger.kernel.org
References: <1741354928.22595.4.camel@trentalancia.com>
 <qn655027-4830-ps48-87po-r61npps888s5@vanv.qr>
 <1741361076.5380.3.camel@trentalancia.com>
 <931rns88-4o59-s61q-6400-4prp16prsqs7@vanv.qr>
 <1741367396.5380.29.camel@trentalancia.com>
 <s4sq15s8-p28r-7o01-03n8-82623p8n3728@vanv.qr>
 <1741369231.5380.37.camel@trentalancia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1741369231.5380.37.camel@trentalancia.com>

On Fri, Mar 07, 2025 at 06:40:31PM +0100, Guido Trentalancia wrote:
> I am not familiar with the application layer tools such as
> NetworkManager.
> 
> The point is that the underlying issue does not change with auxiliary
> tools: I believe iptables should not abort setting up all rules, just
> because one or more of them fail to resolve in DNS.

There is consensus amongst Netfilter developers that skipping rules or
even parts of them when loading a ruleset is a critical flaw in the
software because loaded ruleset behaviour is not deterministic anymore.
The usual security context demands that behaviour is exactly as
requested by the user, any bit flipped could disable the whole security
concept. "We printed a warning" is not an excuse to this.

In order to implement the desired behaviour, just call iptables
individually for each rule and ignore failures. You could also cache IP
addresses, try a new lookup during firewall service startup and fall
back to the cached entry if it fails.

My personal take is this: If a DNS reply is not deterministic, neither
is a rule based on it. If it is, one may well hard-code the lookup
result.

> As already said, if one or more rules fail then those specific hosts
> are most likely unreachable anyway.

No, it just means DNS has failed. The resulting rules use IP addresses
and there is no guarantee these are not reachable. You are making
assumptions based on your use-case, but the proposed behaviour will
affect all use-cases (and there is always that special one ... ;).

Cheers, Phil
