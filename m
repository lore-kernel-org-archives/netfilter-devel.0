Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C01383
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Nov 2024 23:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730847834; cv=none; b=ED/GkV/ZpDIsdIo/IaCxEjqyZhOHXSouXj03qROoa/tAvRUtrGpie7p6dmctL+t/9XxMYHlibM8Ibj5KkC58x/HpzATAP5Q8yyBNGTOUr5sKBLrCnAaETrP9bFAnT3JysUmljdqJotTpvAiB6d49Y5BCA04PgZGRnjQeKDx/BQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730847834; c=relaxed/simple;
	bh=7rOYFiej2DzW9/XMLF/bHp+APUELGAo3jNsb64uz9gk=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GoYxb3izn7C4OzQopE52j1yzqKlWbhTZ4yacMYGjEAnlyAsg2MtObEarb9mEPySjjvnEuFEZFglh3mgHQcCj7ywnvWdsH+u2OX8pFF+sQJg8VsXTrsH8GyWj/rrs72c+SfLvJmgSzFrSDOxog8OyVlQyPGqBtUr5XFXZR63gcsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=KMbiNYXc; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="KMbiNYXc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=C9Ic7Z17dRMdfA9ZVLaIs6IFhOwCBb59smYCd3DV758=; b=KMbiNYXcuhxSF90A3ILH2FjAzF
	DXIqPpWbYgs+vnUgSV76P6IB4yjUuyATFWUfejUzI6qjmonRjPGLKvg0q0Xi/bxXcB/356hSUdO8G
	SRikDFIhy9B0OcD6SW0Ywi+N48TKl0bGvmaKpY9japBrpRwWFU8UIHGquewm94eYdLmS4r8NhDM0Y
	d51yBXfY3+eYWlvBZ7qz2rcu6Ezm4tMmf+v/riA3JylDopi2+vs+5JYJ5PUx/2fkokILkVEK/SPT2
	q8USqLMHFoKQTfdNy/nEXhsPbdhDBDZ04edoO2RWz/L931BsFBXLOn2IHiZTU+/F5o5SzliEnZyiZ
	E0KnlgXA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t8SaV-000000005M5-0Etp
	for netfilter-devel@vger.kernel.org;
	Wed, 06 Nov 2024 00:03:51 +0100
Date: Wed, 6 Nov 2024 00:03:51 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 1/2] tests: iptables-test: Properly assert rule
 deletion errors
Message-ID: <ZyqkV3Po3zf27ROp@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
References: <20241105203611.11182-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241105203611.11182-1-phil@nwl.cc>

On Tue, Nov 05, 2024 at 09:36:10PM +0100, Phil Sutter wrote:
> Capture any non-zero return code, iptables not necessarily returns 1 on
> error.
> 
> A known issue with trying to delete a rule by spec is the unsupported
> --set-counters option. Strip it before deleting the rule.
> 
> Fixes: c8b7aaabbe1fc ("add iptables unit test infrastructure")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Series applied.
