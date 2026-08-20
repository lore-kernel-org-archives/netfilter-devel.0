Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F07E42E8E1
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2026 11:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787225495; cv=none; b=G/Le0uHttCUBHhlrCWXFt8oQrhbkEO+hPqdsSQba25sh46QUPZU8Yi3fSnhvK8zF3CzEZgB7OFL/y/2yY+JEZwDuU0PjKUki4vxmMfTFYKBYuLo4uX0ohloZ13SSef2B7uhKS1DOBGwW0beCoEBqGTazJ385sT+V98HFSM1QdTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787225495; c=relaxed/simple;
	bh=Ae9Rn5Rw806JQX+T/nYZk7NejfEJQ9ClcDUtD6lL5Fg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t7t2jjASSkFhtgVpY4317JX9O3UcvNk5eCoejqYqZsFkChUEPs6DrIYH6kjyBgccy0an+V/DFL0I4/n5z8ep/UvKWc77Oy7lYoIAUeXZ9BJ18Uyd/Mcj8/zaowByxgCzuEaivvkptq1JlZxb7+vjvZpAGrosaT2p9G6y/MrmeJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=NQJcrBPp; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="NQJcrBPp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787225488;
	bh=zzI964uD/ylNKlWL+94y5w/4zXPrbLoTaFp9p78hhQg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NQJcrBPpKc/t7MzwvmPI9LBRkqfu74opTp88fWzRk7nZAJ4e27S0/dc7S6qeIZu9z
	 rN2JlGoF4Je4BOWXi1hDSvB3CDu2rDjanPfsKBu2fGfw6bqdV+mAdLytKigQXgkg8t
	 Sm5cJoY+Kqrcnt+IHa88aDkiNBS9wnHo1bdAHPC2F797ZwqLGNOq6RcYtk58L8YRAe
	 9ijqd/6xSF5XXBpotEVvhhqA8OXlcu6Ab72r/wOnHS9Pk0QLJFwzKWvTjAVRf3OcI2
	 u93ltCsSqVrWItfzb9EsXylm2X7yEFTSVwPAtXIJlA9bAzN/5LyY8ElQGw0KIu38uU
	 rveT/amhurBAw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id B28CC6008D;
	Thu, 20 Aug 2026 13:31:28 +0200 (CEST)
Date: Thu, 20 Aug 2026 13:31:26 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Niklas Fiekas <niklas.fiekas@backscattering.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] json: output set/map element count
Message-ID: <aobljm_cLdZ8s_AC@chamomile>
References: <ad31ed84-1ce4-4ec9-b970-6d09f8d69152@app.fastmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ad31ed84-1ce4-4ec9-b970-6d09f8d69152@app.fastmail.com>

On Sun, Apr 19, 2026 at 05:57:30PM +0200, Niklas Fiekas wrote:
> Useful with --terse, when dumping all elements is too expensive.
> 
> Mirrors non-json dumps, which already include "... # count 12345".

Applied, thanks
