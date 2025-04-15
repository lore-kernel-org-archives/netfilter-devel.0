Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B8629A3D7
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Apr 2025 15:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744730087; cv=none; b=A4OwwP9TNB3N6aCuKg5AkzJaYCixiImnGJ+58NxIn/8nvKnhwUx0h8r2tVxAp8ylBih+i1bKUEBn54aoKoqSwJw1VZbK/6zWq2mVIlbVtbAyMiGJOGQHTKGGeAxeSvIE1ZSymXzOeLmIr55Le/b4Q7BvqMJJJon1ktFxayHid2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744730087; c=relaxed/simple;
	bh=pql42fK8UCTE0I0nkDe1tqu9cxQr+xVYTV5n2ksdEtU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=swpjefAoxZ94HV11f4YvtfnKtd/Vlvlw7Gda5ZoTpQuEqy5FCkY83/I0R9ezLS8WoLKU77HEW48xZJelC/m6pe61gTRQWW8LY+fAifCAmn1+nHb6CvUd3BLjbXWK3p4kYjSoZ297en9KCWRhf6Okqw6wE/xuGQ5GJvVDIgkWrzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=oniKxiyi; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rsd3q83N; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="oniKxiyi";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rsd3q83N"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id A738460BB4; Tue, 15 Apr 2025 17:14:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744730083;
	bh=K4BwkSwDsYNBSLJ98AleykATE+jvX4fcmUD9asazRcc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oniKxiyiFW4LL45kFq9YnRgyz9Df5SejQajeJkjQ6XuHCgSsmaomFHjJjLCKxy3pr
	 PJHS+zwyV7vwPeyzpW3YUksVHdpRfoXNkpUT5crPlNNjEc8/RpbUz6m5EKUI/+1LKZ
	 uR7HjoOsq5q11NePaC7AKiGT9DWhcLbJOaQx3eoldrwOnx7akTkdp1sYHJ1E1mAsoX
	 ZLlyWVLshgzZZvUftQT4Acn9KABXDvDihmq6HU7R3m80BBMeUhXokmcrTdJ2h2g4lR
	 58V3kLS/EfaP3Sh8cuJOBqfn5VpRj7VObmfo4CmPdhqCTNw+jIDseeHrnR+9/gtks9
	 2FRn+pvqxr4eg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id AAE8060BB4;
	Tue, 15 Apr 2025 17:14:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744730081;
	bh=K4BwkSwDsYNBSLJ98AleykATE+jvX4fcmUD9asazRcc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rsd3q83NT1OzTmBEQOTFQRcnsyb9m9l8KFMA4ZyoyVusYuS9GkpbSqh3imA2n+zSE
	 qgTGAR5+DP74pjLf6MZt3nowLCDWtXvyNpPKP9dUL5ynhKk1cs0KNX45sN4gW88Fdi
	 X0oXcDesDC2p+siM/hHicZKlb3ttUVdB4fS5rfBNTf77Zp9XWUdY9Z5b3kmDULetE3
	 A606zx5AQbt+XJNW60GfaZSQJt8AcoZS/ERm6pOBbCin+Zf59WMkZiM24e5roNgzCA
	 leomZ/vamUeu6k8D4jKKLEYGr+S88iik4U7ntjNj5/ICxOZJ76AbaRdq3ajfr7OuVv
	 etVywzZLeC42w==
Date: Tue, 15 Apr 2025 17:14:39 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev, Florian Westphal <fw@strlen.de>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v4] netfilter: Exclude LEGACY TABLES on PREEMPT_RT.
Message-ID: <Z_5335rrIYsyVq6E@calendula>
References: <20250404152815.LilZda0r@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250404152815.LilZda0r@linutronix.de>

On Fri, Apr 04, 2025 at 05:28:15PM +0200, Sebastian Andrzej Siewior wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> The seqcount xt_recseq is used to synchronize the replacement of
> xt_table::private in xt_replace_table() against all readers such as
> ipt_do_table()
> 
> To ensure that there is only one writer, the writing side disables
> bottom halves. The sequence counter can be acquired recursively. Only the
> first invocation modifies the sequence counter (signaling that a writer
> is in progress) while the following (recursive) writer does not modify
> the counter.
> The lack of a proper locking mechanism for the sequence counter can lead
> to live lock on PREEMPT_RT if the high prior reader preempts the
> writer. Additionally if the per-CPU lock on PREEMPT_RT is removed from
> local_bh_disable() then there is no synchronisation for the per-CPU
> sequence counter.
> 
> The affected code is "just" the legacy netfilter code which is replaced
> by "netfilter tables". That code can be disabled without sacrificing
> functionality because everything is provided by the newer
> implementation. This will only requires the usage of the "-nft" tools
> instead of the "-legacy" ones.
> The long term plan is to remove the legacy code so lets accelerate the
> progress.
> 
> Relax dependencies on iptables legacy, replace select with depends on,
> this should cause no harm to existing kernel configs and users can still
> toggle IP{6}_NF_IPTABLES_LEGACY in any case.
> Make EBTABLES_LEGACY, IPTABLES_LEGACY and ARPTABLES depend on
> NETFILTER_LEGACY. Hide xt_recseq and its users, xt_register_table() and
> xt_percpu_counter_alloc() behind NETFILTER_LEGACY. Let NETFILTER_LEGACY
> depend on !PREEMPT_RT.
> 
> Replace CONFIG_IP6_NF_MANGLE->CONFIG_IP6_NF_IPTABLES for TCPOPTSTRIP and
> add CONFIG_NFT_COMPAT_ARP to the MARK target for the IPv6 and ARP target
> to keep it enabled without the LEGACY code for NFT.

Applied to nf-next.

Thanks for keeping me as author, I don't deserve it.
