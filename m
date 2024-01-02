Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC12CA38
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Jan 2024 02:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="S/1j9Ayd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=jaskImS5nZtmr0YDAMzjFr1/FDukznoEBqrKjLZgdR0=; b=S/1j9AydOeoIH4V1b0WK1fv0VH
	FgqXs9yeL9mNbJdHZVoQPLFLueRoFNR4ujS9ujBZX2iG1qU2mxnxW6LIoMA6oYTXp8Frq6svqOUvc
	LZR0AhdK2c4rJLnC4iPVxT0z33nN1jQ1RSLP1YZXgT5JjOnHtLMWA3CF4HlbqmCp7Ai/s9D481Xu3
	i5LEMz/r1dU9G2iKu2Rez6a+8o/SyKkw8vMHgqzgw/pN3tGkZVy+SenIUR+4ALqQGAshGVY2aJYY1
	GML6nCiPLJScCjV+0LrW6ixIJXcYufsoOXJ28jRlMVgpslTE3UYUQM7yVC6AkJmGuVzKrDWewv4dk
	VjwwNx/A==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rKUDs-000000005H2-2hQh;
	Tue, 02 Jan 2024 03:09:40 +0100
Date: Tue, 2 Jan 2024 03:09:40 +0100
From: Phil Sutter <phil@nwl.cc>
To: Turritopsis Dohrnii Teo En Ming <teo.en.ming@protonmail.com>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"ceo@teo-en-ming-corp.com" <ceo@teo-en-ming-corp.com>
Subject: Re: GUI Frontend for iptables and nftables Linux firewalls
Message-ID: <ZZNwZEZtspTDLglp@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Turritopsis Dohrnii Teo En Ming <teo.en.ming@protonmail.com>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"ceo@teo-en-ming-corp.com" <ceo@teo-en-ming-corp.com>
References: <F2UgPsJY77kOox0aLlaT8ezVQQdgsDcsP95OPo5wyKzn230KLtlp1R_NHDRcM2FzpUByrp72jC2s1qu-7aV6kNmig0Rxn1Bly-ci51RE7t4=@protonmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F2UgPsJY77kOox0aLlaT8ezVQQdgsDcsP95OPo5wyKzn230KLtlp1R_NHDRcM2FzpUByrp72jC2s1qu-7aV6kNmig0Rxn1Bly-ci51RE7t4=@protonmail.com>

Hi,

On Mon, Dec 25, 2023 at 03:26:13PM +0000, Turritopsis Dohrnii Teo En Ming wrote:
> Subject: GUI Frontend for iptables and nftables Linux firewalls
> 
> Good day from Singapore,
> 
> Besides Webmin, are there any other good GUI frontends for iptables and nftables?

This is a question better asked on netfilter@vger.kernel.org.

> The GUI frontend needs to allow complex firewall configurations. I think Webmin only allows simple firewall configurations.

I was once told fwbuilder[1] is a nice tool for that purpose but I never
really used it and it seems dead ("Last Update: 2013-07-03", if sf.net
is to be trusted).

Cheers, Phil

[1] https://fwbuilder.sourceforge.net/
