Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954D7396B68;
	Thu, 23 Jul 2026 18:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784831858; cv=none; b=LIjEMBmnhGYEPg37DG4eMp+pDbcHXxPPpp8jL9jRE/UcFYg0LsahpN47ePz5aeAW7iO4wGU0EZJPP0A28OV6od49qMB7fcuZE/gRE2ZHzvjchDnoS1Mvo607LDJYPKZwRxuFy9VxMtqW56IMGYZwNWZV2dai5bCaRjOeZ10pw1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784831858; c=relaxed/simple;
	bh=p0gawN+awB5lMFp2s+1t5mCEBlS4ttPJEWcruJQ7Ioo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lOS1Hk+1wkreQRAIWzVNkTB8abHPdH/6P7IkR7WZY+OzRwTXnfd8Kz/DC6iiKO+SQvxKG0hZuFLq7g3NDE8hQGqmhnlbHO2M+8VQbp/iPrh4zPVk+VxOTnwD254zX+89+jLDffKq2jPCbJptLt5RsEhgTwVCEYafPRsURi3v4o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IYsr6sMi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IYsr6sMi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDDC71F000E9;
	Thu, 23 Jul 2026 18:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784831847;
	bh=SB7NnqTkBsM0Jc/sluIHPDXAEj7LPJMsqJ5VeTHDGHg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=IYsr6sMiyt1fAvCoY50+fyZ3TchZJXUZ1DT9NzoeISS4QRnUmrJbfED5gspW75sSO
	 wb8xHy4z6ZcHS0GY2tm8HOMKiRP8IJr4fMnMVAF0s5cW1K375ny1H9v8bcXhw6cDmt
	 FKx+K4ivNDZPTplwzbUdSzm7MvGMWhGaXwPaTy6De/DXuah1pGjmynCbNeyHxx1j6W
	 cmcNQqWGbo9A4wjxEujXNasVnUjD4U8Jy4Tg81//gc2jRje7+uniS9tdhTvovZfwdg
	 G1kKpM648hfK7WW2E3BWwyCmfUz67AnHmm4Ly0uGARlHfKVWUfIv4ZSnm1w0oCouEO
	 3kRSUgBCbbSCw==
Date: Thu, 23 Jul 2026 11:37:26 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
 fw@strlen.de, horms@kernel.org
Subject: Re: [PATCH net 09/13] ipvs: fix the checksum validations
Message-ID: <20260723113726.225a92a7@kernel.org>
In-Reply-To: <amI1logAep3vSkfF@chamomile>
References: <20260722211420.153933-1-pablo@netfilter.org>
	<20260722211420.153933-10-pablo@netfilter.org>
	<20260723070845.7855a0f1@kernel.org>
	<amI1logAep3vSkfF@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 23 Jul 2026 17:39:02 +0200 Pablo Neira Ayuso wrote:
> Hi,
> 
> On Thu, Jul 23, 2026 at 07:08:45AM -0700, Jakub Kicinski wrote:
> > On Wed, 22 Jul 2026 23:14:16 +0200 Pablo Neira Ayuso wrote:  
> > > +/**
> > > + * ip_vs_checksum_common_check - validate checksum for TCP/UDP/ICMP
> > > + */  
> > 
> > this not-really-kdoc comment causes a bunch of new warnings,
> > and this file was previously warning free. Which in turn
> > makes our AI reviewer ignore the series. Could you respin?  
> 
> Yes, I can drop the patches that have the kdoc issues and respin.

Thanks! We're seeing extra delays due to lore outage overnight
and a lot of submissions suddenly appearing in the pipeline.
Looks like this will have to wait for rc6 :(
