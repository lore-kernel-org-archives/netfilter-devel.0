Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1EA215798
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Aug 2025 12:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755607437; cv=none; b=CjFgNkpCLg6gslnlOqodMXKTsEhKqPzjofxQTxUEnEbLkTbcdp9ktaMKHQJ/s8H7Spo/MgKSUEBQPTaJG1LvQD08UPw/Qji/g98no4rzYsKMhuXStZZMJgWIIwiklLf/wRF2VIsuPq64lygQrAmw4msGSIagC/e/7ZS8nO1iswM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755607437; c=relaxed/simple;
	bh=Q0f7pSKsOKE23YRND4XZVcSVUyVbLPYyQy+pLrduu0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fFBXe9LCpghvPyrsTuNTvULcr6Y8aPO4Li2hvvC8J63+fg50F6sxEBAVYV47BhKfsypv8y44SviasXt/80UxnU+KQRxJDETMUMn3NOoS2x3Y9w3LxJZYEFE1KSdVBuAKv83irupWhJPQ2cd5t036GINX5tz5fFxTeN8uxb4y0q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SbjJ14X+; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ZFX+1ieS; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SbjJ14X+";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ZFX+1ieS"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 9A673602AE; Tue, 19 Aug 2025 14:43:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755607432;
	bh=Q0f7pSKsOKE23YRND4XZVcSVUyVbLPYyQy+pLrduu0g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SbjJ14X+VfRdvIS2p73fr/blTf15hmx2m8tb2KJAQvD+6r2LJewJCd1BNPIO2clzR
	 mchRqN4dcBcWa+sIvY/eQSetYp19oF/97/K2IKUj+U1v468ZhSxva8JRTX0scPyfYb
	 0T0oFAHXgwQ2pYabkNrUlMao7R9oZvnn8pY1rfosa7nHmU/zNP2QPYroKrcYqDq4sY
	 Hg8CV35ELFN7w/2LJmqmvHBiOivFfFohexddXFo0SEceeUHAwQv4wom+peO6s4Rldu
	 8imDZyehpDURKRS3/aqhRCV2q1QJoE90LbsImACCLKNNKqLcOMJ2RStUrZ74bkXJ8U
	 0TMD0ZgjMgodA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4873F602A4;
	Tue, 19 Aug 2025 14:43:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755607431;
	bh=Q0f7pSKsOKE23YRND4XZVcSVUyVbLPYyQy+pLrduu0g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZFX+1ieS2HQXiaswg2lds434SQ/SmwG20eAv2jmi6w0+fx9Q9TqMYGFO69Jswylti
	 /+MrjZebkzITkVBW8NOvgWdZFsSpZTGa6M7SFN3NztZ5uumGoZkzx6F08PlJqd6sYT
	 8282WCXhoq/GktFqYVfeWb+2ydT6MwLp4L8wWdDmXZ9ZcNkaFXlcMCggICPES+YbRV
	 qOyG6Nfu672phM3YEm2gKkgWzJKN4Sw2Ezgn8nHk5B/yyP7hVUBd5YtDUqXNZHiJqf
	 weXK8E+1wDPicl0H68CgEGckEpno/Yn4z0xN5Kt3tDBBaQX4b1gF7XAwfZMCMv//1K
	 9280PnTvFbb/w==
Date: Tue, 19 Aug 2025 14:43:48 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, fw@strlen.de
Subject: Re: [PATCH 1/2 libnftnl v3] tunnel: rework options
Message-ID: <aKRxhMSDrj8G1l1J@calendula>
References: <20250814105832.5286-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250814105832.5286-1-fmancera@suse.de>

Hi Fernando,

I have pushed out this series to the 'tunnel' branch under libnftnl.

There are one issue pending in nftables userspace, let me change
email thread and report it there.
