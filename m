Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97994189905
	for <netfilter-devel@vger.kernel.org>; Thu, 22 May 2025 17:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747934301; cv=none; b=Sjs7a6bXGokndW8LkF3Nx3L0waBArQ8cfWq6WJJP+4uRdvRjE278WaeKZLV8QCi/jl31cUtKJHgGXN6sHo71WE6So/teTfvDosAlUJ7qNuRTsOgtM4M67KfrvGduB1eKhX1vTzbx6wvOVoTGlmeq5mNLu3jNPQFc6P0Cvjdvwzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747934301; c=relaxed/simple;
	bh=TQkik62yutER4Ke6goT9MBH34coJ7XTVFaLzUWzwJBQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PuwOfQIaRnGPfxCfMC+XB1E4clhy+Yq0W71VMrRFDBXGGnBE7M30qDMeAR6aZAmA6TU0FqR5Z41um1a6BFxkVnnyfdgbfKE4YC+8zA5vVt76CCL1YN/ToY8b1jcOl4aa1a5MWKhYFnEDuPZEwkilNoNyLY76wwoxHlQBUvOGF5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=oUmrw3iP; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=drcw8nAA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="oUmrw3iP";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="drcw8nAA"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 0099660294; Thu, 22 May 2025 19:18:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747934298;
	bh=zjdNLPuoiz6WdbJa6DHICcIfwoA2ZjyIYlk32hkZwHc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oUmrw3iPNr0g1k51lz36wQl2i23RegHcsFhjIOhheA5acq590aVzT1ywnTZcoEZic
	 hGsVgAWPNVA/GM121cN8nY3eh72Rx4TC2rxLChIfy5/1/ajvPc/wgruIY9bmAnQVFB
	 s8zZdQe7fUcJEkooNJDx4YgqDqSMvLE0q/R8F///wuIqDOFgW0czXCfxJu4pACQZ6t
	 5vH9Srx1hBUQ/bLiykBv1naeTUtGP4hi+kVF6BpyaNZSYe2O55XzWCPhEywfJDs0Jr
	 nYxgaIa0jDisCIXVismcVPVufVoXWTGXm8glLR00U7WLIAx7I+5hoLkeXGRtwtVJ+Q
	 leyonMkLLZm5Q==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 79D5E6028A;
	Thu, 22 May 2025 19:18:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747934297;
	bh=zjdNLPuoiz6WdbJa6DHICcIfwoA2ZjyIYlk32hkZwHc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=drcw8nAAcqsra4xwjDsE/ogFaLnjLu0j6cQY5JZ2tNenehV9RWx25YiAxRREWkBs5
	 kmy1NIhcALtcOVWSHW+Kw5178ayq3OEmm34WX3LuKRnNKP2UHwNeVeU9PIoiENA058
	 LPK9FNbkt8tCObihVk0w97GEyQlAAN/qvZ2rHs9CEzjYdrDwNdfpss4hZJWGuycxB9
	 DNRlQlYf4gV3ZU6yH2ivmbt0v073vQulnJGG5VQxg1dB0wMhz8WZc+38TupA/pn43u
	 uv1cnOB+A+rcGquLdAm3ZmukAUQRteyO4g03GmAzPNFwAMeGSlJfm9nQODwlYWsqmp
	 aLH9P7xA1ORsg==
Date: Thu, 22 May 2025 19:18:14 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 0/4] Continue upon netlink deserialization failures
Message-ID: <aC9cVrmOpQKNs1MW@calendula>
References: <20250521131242.2330-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250521131242.2330-1-phil@nwl.cc>

On Wed, May 21, 2025 at 03:12:38PM +0200, Phil Sutter wrote:
> Faced with unexpected values or missing attributes, most of the netlink
> deserialization code would complain, drop the nftables object being
> constructed and carry on. Some error paths though instead call BUG() or
> assert(0) instead. This series eliminates at least the most prominent
> ones among those (patches 1 and 3).
> 
> Patch 4 prevents object deserialization from aborting upon the first one
> with unexpected data. If netlink_delinearize_obj() returns NULL, an
> error message has been emitted already so just return 0 to the foreach
> loop so it continues with the next object.
> 
> Patch 2 is just preparation work for patch 3.

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
