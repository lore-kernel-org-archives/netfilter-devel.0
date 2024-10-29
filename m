Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1268B208237
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Oct 2024 22:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730240872; cv=none; b=psosuqiIIBi73TrZeNM876g/ziFHcucUZXVSLEDOwAUgtk4m5HL18BKTWvv4j58KIgycVIlP/2TgGvvsMGbHp1kn7lmm3kD6viV8nOSj5X15lMEbH8hKf2lgSH9KGqx2C7tD/fZY3EzFYOmAVi9nqX8XIG2vBWnR1oNaKscTkXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730240872; c=relaxed/simple;
	bh=WTlKzcZKILEhacywPH0pqtzUQT7AUHLTpyhj9qk4PqY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yp1jNUOzQLZZqsSXq3k52Q3WusJn7maZN4ViFx+ChEAtM8vzWCliRlEgrKQvbAcDVHPsINAIh2oTT0lFeEaeXDaV4Go8ZQR96f4ZDgO0LrqUnGqNk62+3N+vrSHthIPoQU1FygrWCU58Pq15muPmZzfVGEB2Ya5ESXz+2cSiTLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=mfIYCKVw; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="mfIYCKVw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/HgzCHvdUB4A+GbOppCkUonBaVQGbE3lPaPflCH1sdg=; b=mfIYCKVw3UmDQqGFZy7rzVO7tl
	uAPmfgt5qyOZy6nvMnkqFfK7RGfEL35N0nUXKVbqvbuZe+9Xt3iUZlGH5EIoSJlsDD8mj7763LAMR
	r9gRYqeDfyz5c72YvbFk2hICScWpfg79uA1V1otDTBOHYsWljbF5/tWugTxaLrIS6Fsvmm71HqsGb
	EIRqPtWX7DUxwTM4CWiDso9sUdiEMvVGpVqti9xvH1wArFp9iF6ohtUFZ/Dvbjgl33FJBI17aiKx8
	FS68FBbGE1Yb9bia+cvGEhGHAhejC00KvOo2UTB9F4AOW5tGmlzGQhL485D8Mi9Yt4tfmoQrbNKUd
	6YtH0FHA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t5ugl-000000008Jt-1AU6;
	Tue, 29 Oct 2024 23:27:47 +0100
Date: Tue, 29 Oct 2024 23:27:47 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [libnftnl PATCH v4] Introduce struct nftnl_str_array
Message-ID: <ZyFhY-SLt9Au9a0y@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20241029152919.20293-1-phil@nwl.cc>
 <ZyFUUqzGmBnr071n@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyFUUqzGmBnr071n@calendula>

On Tue, Oct 29, 2024 at 10:32:02PM +0100, Pablo Neira Ayuso wrote:
> On Tue, Oct 29, 2024 at 04:28:58PM +0100, Phil Sutter wrote:
> > This data structure holds an array of allocated strings for use in
> > nftnl_chain and nftnl_flowtable structs. For convenience, implement
> > functions to clear, populate and iterate over contents.
> > 
> > While at it, extend chain and flowtable tests to cover these attributes,
> > too.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> 
> Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Patch applied, thanks for your review!
