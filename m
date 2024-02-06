Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F891CD31
	for <netfilter-devel@vger.kernel.org>; Tue,  6 Feb 2024 23:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707261320; cv=none; b=PFPO8W4x7MkPRxt4oKd7/yFv7FPNxWCxGvhvOZ5u60COIpEJqvDcWbTGN9AbGWnPWx38CIOk0Hn6zV/mYa9HWrX35Zlgckx4W2xnfVmg+NM8/cTUI5rn54GN2Z8q+p1+zSJtgIE5znvo4AYPmq4hkaT2L28jrcaqn5f22On9D4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707261320; c=relaxed/simple;
	bh=O/vQebyc+iKGw+//xA+gJ20YERI7ZHuBZCDTUfSKP+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aOORXT7Ql9PAH88NsDOeY6rPFK/WFpsu/Uj9I18uTdZTD5f2D0SC/Z+n5WKhNR8YrZzLMFBNsoImbkNS0RBzktKnkZBxy7PgXViuYN8xy2c8aoPxmpIEPS0WK7VsXdWyD5+PQv1YFwAVDgJ0yUUqhD30k/9BtuqZaYqikoqzO/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=NWJ7oFmE; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="NWJ7oFmE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=plJag9YSxsFkd/HNA1ig6y37xeL/bxJK8Iq/G2twAD0=; b=NWJ7oFmErTDAKbaBXknRx28acD
	cx3s/EPPbu1gRbuC87cOb1rDFXUA9ptmzpUNDrsXPBBaxKwxIqCiAm/XtkgJ/xgMePjJm1DGIF45U
	tAPiUQMfK/Q5DCiBoQOj+CUMPVwFqTXK+mWrscygIBJLelOp6+skvxvp6EfVPzVQybr5o0TMVLmjR
	KhcNVN+u32D/zMgUT681wmg30867osJcSjbjyQf1VR0Gq1mY5SovRb3Qu6Ph3KCNYA43S+zEHUqVD
	Ee0htN81sR4LmxW0cNGD/Cphz9P8BD+Dxwav0xiaZv+DPZ60nlHBGYdWVlRiR7F4saDg+ULEpHCea
	J3OBotGA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rXUem-0000000047c-2STG;
	Wed, 07 Feb 2024 00:15:12 +0100
Date: Wed, 7 Feb 2024 00:15:12 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH 0/7] A number of ASAN-identified fixes
Message-ID: <ZcK9gIX8JN8Mf3IS@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
References: <20240201135057.24828-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240201135057.24828-1-phil@nwl.cc>

On Thu, Feb 01, 2024 at 02:50:50PM +0100, Phil Sutter wrote:
> Many thanks to Pablo for pointing me at ASAN reporting issues with the
> code valgrind had missed so far. This series fixes all reports so make
> check passes also when compiled with -fsanitize=address.
> 
> Patch 1 is not quite related but rather a shortcoming in
> iptables-test.py I decided to fix while being at it.
> 
> The remaining patches are actual fixes apart from patch 4 which pulls
> out unrelated (but sensible) changes from patch 5.
> 
> Phil Sutter (7):
>   tests: iptables-test: Increase non-fast mode strictness
>   nft: ruleparse: Add missing braces around ternary
>   libxtables: Fix memleak of matches' udata
>   xtables-eb: Eliminate 'opts' define
>   xshared: Fix for memleak in option merging with ebtables
>   xshared: Introduce xtables_clear_args()
>   ebtables: Fix for memleak with change counters command

Series applied.
