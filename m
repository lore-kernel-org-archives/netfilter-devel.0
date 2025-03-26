Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8852B1F4288
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Mar 2025 17:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743009121; cv=none; b=Clg7DhjvRecqJ0VhvLOt2Bcz9f29p/MV31UJTa8OF+CH7C0cqL4gO02f+lfmeXQ/c0YKKwWDT9JGnkczMUbUF4qGEhnCLFB53LxPualToD85nmXhWCY6C4IxqgFYC+JDfCVoX58aE3BjmftGuzac+93kYJ0NTRJ9ZBDImAWG3CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743009121; c=relaxed/simple;
	bh=mirikUUelsYlHfkpjJllmLpQLcoB1ZhBw1NxNeDnfd4=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uWPvdBt1L5lMlvWdSnCIfaHwQbeZo5S8cPJZyh86vQR4PQGHjZ17ctPu91+/NRHYdsZRvTHEBwxugEJisPwXs5nfsPbvdtdOIjd/LU/zI46RJDtJvFFp1HZnydmGkggHWjAg0Dr2IB+p7cp/URXnNICMxUDq26Rg0b5P2mZn1nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=0zg5RUgo; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=b7+qwTqr; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="0zg5RUgo";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="b7+qwTqr"
Date: Wed, 26 Mar 2025 18:11:50 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1743009112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tw9T7Mv6yLNBgt/o8/ziQ6900fngdt3uwiO/mjTlsok=;
	b=0zg5RUgoCvXiJeDMKk+465BcXubKaTrRCyPm+MDBIfWQ/Nl64KenJ7NJaUCRfUOMipyHPz
	mYcw+vyRQHgaapnt6btJ50MXL0Vbo4LCYpOrEVAlpG30Lr1966OxBRHHXU2TjAyXlgCSLt
	5a2jTKTkHiYe1LI/PdZn8Z897oso9x7xNYV0Hp7aMTDUrV3s80R3SMi73BOxHNeT4kF/E5
	U9eHZGREzqmFPYjdqOHEiqGqUxsZsGofA4e0xD6PnQmdjPGMsDNYWODb+I5EGolSI1ov5A
	CzEesuPOzBgZ4q/yPbl3jrKtTNFKRKJVC76RQoRby9fpgllBqXF2uNRXTmm/Sw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1743009112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tw9T7Mv6yLNBgt/o8/ziQ6900fngdt3uwiO/mjTlsok=;
	b=b7+qwTqr1hUVaFd68zAaNJ/4vD8aCRgpgljV3vjX1tjs7xLvmgzTLlTSz11LXYV6YaIizq
	8uxkYW+DiEOt9uAw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-rt-devel@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [net-next v3 1/3] netfilter: replace select by depends on for
 IP{6}_NF_IPTABLES_LEGACY
Message-ID: <20250326171150.WC34AcV1@linutronix.de>
References: <20250325165832.3110004-1-bigeasy@linutronix.de>
 <20250325165832.3110004-2-bigeasy@linutronix.de>
 <Z-Q0vi3r5aHxY8Pv@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z-Q0vi3r5aHxY8Pv@orbyte.nwl.cc>

On 2025-03-26 18:09:18 [+0100], Phil Sutter wrote:
> Hi Bigeasy!
Phil!

> On Tue, Mar 25, 2025 at 05:58:30PM +0100, Sebastian Andrzej Siewior wrote:
> > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > 
> > Relax dependencies on iptables legacy, replace select by depends on,
> > this should cause no harm to existing kernel configs and users can still
> > toggle IP{6}_NF_IPTABLES_LEGACY in any case.
> > 
> > [fw: Replace depends on BRIDGE_NF_EBTABLES_LEGACY with select]
> 
> I don't get this remark: The three chunks dealing with that symbol do
> the opposite, namely replacing 'select ...' with 'depends on ...'. Do I
> miss the point or is this a leftover?

It should have been the other way around. Will replace 'select' with
"depends on".

Sebastian
