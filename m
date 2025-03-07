Received: from smtpdh20-2.aruba.it (smtpdh20-2.aruba.it [62.149.155.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D723A2417F2
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Mar 2025 17:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.155.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741369240; cv=none; b=ZSMFPQljLCXxBv6PGpD7Myua2IUKtxC7tEyRj46AUlFkQu0eAnr9D5FXa8XwFziJPyRb2UBKzVM1GOiY24aaddEyOvpW9BzXS/K10yLZL4PmDsVEWm2B9u1egnsAYkx/6t7+fCBNS8xNhlO5mfHQYJM9FhCOGeUHXrGLgSHIxCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741369240; c=relaxed/simple;
	bh=oliE88XmSaFGIiR5K5As5Q2vK2GjdspW52lNr2SNHBg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=h6PmpERFAIJEMqDtZFufuDUAFIWxV84kNxyK7BTfXOpcZV7OxBky+sVWv1wAMG9lcQgQE3vOKPr6sLvND8IZEqAMBTPki3ZMnvwNXMFD4oHMKeTVbIYd4gdI6eyDKLPwGSoeuLKuEMOCaAv8pmzJHa7CIkcXT90JGzSFPohKZs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trentalancia.com; spf=pass smtp.mailfrom=trentalancia.com; dkim=temperror (0-bit key) header.d=aruba.it header.i=@aruba.it header.b=D3sdX3se; arc=none smtp.client-ip=62.149.155.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trentalancia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trentalancia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror (0-bit key) header.d=aruba.it header.i=@aruba.it header.b="D3sdX3se"
Received: from [192.168.43.2] ([109.54.139.178])
	by Aruba SMTP with ESMTPSA
	id qbgWtozVBqg4pqbgWtMSAb; Fri, 07 Mar 2025 18:40:32 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1741369232; bh=oliE88XmSaFGIiR5K5As5Q2vK2GjdspW52lNr2SNHBg=;
	h=Subject:From:To:Date:Content-Type:Mime-Version;
	b=D3sdX3seC9qGiFHgdUQdTAXH0uTxp5JKx3qIwwo0utiFe/ACLpNOJr5wmuHvMgFsZ
	 3gccs2jIq+nyZ8jh9UBOoqD8E/QfuXTPCe+kQtWcCu5L609Gtan69eL1b7LdUrWFc5
	 EBpdNduSuRY8MINRN55fX3qvQwKQGJqytENiy/buuOE0pTVmo7uzROgUOdqqmpwxbU
	 G6h61OnPK7L3AhmxJD7Uc9N0dXxHH0M9iNC5Ta/pdgP56NE8iVLf4zYJDUfA8weao0
	 YJwc0VqbD+rzizCl8q2V12OFYXHSJjdylqiq6xnPmGsw36DqoYsqVcMbNOFi24AXrX
	 9WUzkSoPgoVrA==
Message-ID: <1741369231.5380.37.camel@trentalancia.com>
Subject: Re: [PATCH iptables]: xtables: tolerate DNS lookup failures
From: Guido Trentalancia <guido@trentalancia.com>
To: Jan Engelhardt <ej@inai.de>
Cc: netfilter-devel@vger.kernel.org
Date: Fri, 07 Mar 2025 18:40:31 +0100
In-Reply-To: <s4sq15s8-p28r-7o01-03n8-82623p8n3728@vanv.qr>
References: <1741354928.22595.4.camel@trentalancia.com>
	   <qn655027-4830-ps48-87po-r61npps888s5@vanv.qr>
	  <1741361076.5380.3.camel@trentalancia.com>
	  <931rns88-4o59-s61q-6400-4prp16prsqs7@vanv.qr>
	 <1741367396.5380.29.camel@trentalancia.com>
	 <s4sq15s8-p28r-7o01-03n8-82623p8n3728@vanv.qr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfHSMqA0QBqbqW6nrJkG1bmMj19cTuHsGBqxQI9h3n/X7oFl2h0TKetu9ss37+d8v8K/GNGwJ3mF+aA/f4v/EvKasEx6uzLY/il/Uq3oPCdq18gEYh4Ze
 NdkTXOrxXvYZzId7DF5TrtLxr5K4OM0YeuSFMInznJX8c39O5Ouhgf86Dv00xYxabD56qfveNVuj7Uzp3lOt4k0EhIvF47qGL7o1Nl32zm/2ZJnckxGItB5/

I am not familiar with the application layer tools such as
NetworkManager.

The point is that the underlying issue does not change with auxiliary
tools: I believe iptables should not abort setting up all rules, just
because one or more of them fail to resolve in DNS.

As already said, if one or more rules fail then those specific hosts
are most likely unreachable anyway.

Guido

On Fri, 07/03/2025 at 18.21 +0100, Jan Engelhardt wrote:
> On Friday 2025-03-07 18:09, Guido Trentalancia wrote:
> > 
> > The patch solves a well defined problem: when iptables are loaded
> > (usually at system bootup) the network might not be available (e.g.
> > laptop computer with wireless connectivity)
> > 
> > Consider that iptables can always be loaded again when Internet
> > connectivity becomes available (for example, by a script used to
> > turn
> > the wireless connection up).
> 
> When you add/edit rules in Networkmanager hooks (or whatever the
> software in use is), i.e. response to network events,
> then you can just as well use a *deterministic* ruleset during early
> boot.
