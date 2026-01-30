Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2E72D061B
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Jan 2026 16:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769790358; cv=none; b=Ca3sehhhMuMyyqZSEZDjT30+72PYfJ9Xk7ME4IuwL3NrjIMHkAA/aokd7Q8lkJVBXIL6AvhSLMt1omVmjuRgsmKNz1Te9vppebAK6orXEN82XpBAZjkJhU6stq+N6rAtEsKM4fnq3j/qPAhblup+BnG9dBV/Ihp5e8GqtD571x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769790358; c=relaxed/simple;
	bh=NfXG2BpWal6Du0C1xySsDcjriOLR4TEF4SqtA0lRSuc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VccnxyFsXjnDEyTzSEZzPQ9MSzRxvQ9NtzJFlQ9Oj85jdgsMyMrDcAfjtsW8xjD8+E8ndimLqQ6sKL1Ysa11fxUeCJWjWZIbmCmvi/KRHnw+zGrUIkItQ8LcT4bG7a+XnbIXfVUCwHNu9moo7Ew223GIT4vFe3BpPPG/SicIkCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=CYo6ylAo; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="CYo6ylAo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ZzicJXpr0e8hd/9auUABzFs0QOINECSkwXY7OLHrsXQ=; b=CYo6ylAoQhxrVGoI2rcfZWVUdh
	sj12aZtiNtZ5PHaRDATt5ZCzWIrOvq3FNcXR+umrhWKLZGjC8xitmqCuYR27/gmTAS7jLOgIpLDh4
	B5MTBOY2YFvllQ7DxG5Bnfw9k6THVIUqcbmo0LcyJ8fOo3AlmhXlKv10L+YeH9ID6WKTTqyqsviTG
	bh0ZvqYmL3fgAumycQFwbAMOLQLkOWqWMQq0BCBNCI3EXKYXal1OlrzCGgZxKj3T1DAaYJmZz8fDr
	Uoh410ASnKF3bwWXBupuCycYWpeZ7iy+2Dt2HRkeMUjGp0V0QufbC3FgEHcDryP2LA7sfG0/M+X4P
	rjO4or3w==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vlrJj-000000001qR-221L;
	Fri, 30 Jan 2026 17:25:55 +0100
Date: Fri, 30 Jan 2026 17:25:55 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH] configure: Auto-detect libz unless explicitly
 requested
Message-ID: <aXzbk27yzNNa9xDO@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
References: <20260129195836.13988-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129195836.13988-1-phil@nwl.cc>

On Thu, Jan 29, 2026 at 08:58:36PM +0100, Phil Sutter wrote:
> If user did not pass --with-zlib and it is not available, simply turn
> off rule compat expression compression. It is not strictly necessary and
> users may not care.
> 
> While at it, drop the conditional AC_DEFINE() call: In fact,
> AC_CHECK_LIB() does that already.
> 
> Fixes: ff5f6a208efcc ("nft-ruleparse: Fallback to compat expressions in userdata")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Also applied.
