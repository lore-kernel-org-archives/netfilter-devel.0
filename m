Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3561E832A
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Feb 2026 20:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770841304; cv=none; b=f1KCqsT/O2tkoLPCOT+XWpUaZuDn7qp/nlbdSlsKeq3jzPj0qA1raKoEDpyUorWx46EDJgCPlBPYCPX8uBfZNZBTX/x1KXMKfUy2S6hedrqLjUzcZdi3b7TpueTEuoT2TIGnhrdTvGDvegZOzS5AXbnpvpcANd5NnfM9X4F2SBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770841304; c=relaxed/simple;
	bh=nWf6yr9izLiHD69u10CLiN3g33i/fryqtc3iMDbha4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XySTht9pjpRq4hCNkJApKNKnuyn4l/EbfXZjXSA94HKXuNEjifhd2yuJEAbNvRhJUjiIT9KHJ+MPxkcyeUd/if2EiHAKP4pzrUMD6C/4qHVWF/3xSOgV1gIWI6Q5fTUOT0SoJhbTVTIN7qdjW3D6AhZ0KAyawTy1mPBCyV/rsB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=XVAOCDwJ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="XVAOCDwJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=C7UJT42UeQnIjRpCMDmDP6/fB0j/jObXsnxUSrfcO9g=; b=XVAOCDwJmxJIPdXPB3Cknvr6N4
	SPvrb0gzZNQ4mg2w9SksaZh+NtHfopquBUePsaeTXXj5/34cHr2fE1N4TElVkG8g7xGU1XVLn7Fkf
	FFnfu13pGc4/wQeN9g4drapZw7s53wQHQIrPmTysx3KMp242MV9KTLoPu1bM1wUZudl8ZpqfglJX/
	foc2BRIkP3wmBBUF22GTMv1NPodcRwy0Xd+9bkBCvGtjtV+qH5p7grprZBbCDib9zuHm1V16f4YDI
	I3hhMeUAVcN9TI9+f3pWFR8OPgpWJ7eHuhepE3X4nGX4AGflUuJwlp1RPYOjBIc4614OrQbwwcvZ2
	1Fzsgqrg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vqGiT-000000008TP-2wOu;
	Wed, 11 Feb 2026 21:21:41 +0100
Date: Wed, 11 Feb 2026 21:21:41 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org,
	Ilia Kashintsev <ilia.kashintsev@gmail.com>
Subject: Re: [ebtables PATCH] useful_functions: Fix for buffer overflow in
 parse_ip6_mask()
Message-ID: <aYzk1VSy00VhLZHN@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Ilia Kashintsev <ilia.kashintsev@gmail.com>
References: <20260211194203.6383-1-phil@nwl.cc>
 <aYzfgfEVjenfc_9v@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYzfgfEVjenfc_9v@strlen.de>

On Wed, Feb 11, 2026 at 08:58:57PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > This patch contains a simplified version of his fix:
> > 
> > - The original code attempted to div_round_up() for the second memset(),
> >   to zero the fully empty mask bytes. It used the term '(bits / 8) + 1'
> >   which misbehaves if bits is equal to 8.
> > 
> > - Addressing p at offset 'bits / 8' is illegal if bits has the legal max
> >   value of 128. Also, zeroing this byte is needed only if bits is not
> >   divisible by 8.
> 
> Thanks, feel free to push this out.

Patch applied.
