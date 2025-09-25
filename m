Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554B0322539
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Sep 2025 21:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758836618; cv=none; b=mEIg0dJFIDsr3v6CllQzXqSHCBCN+BoeJzHTTmRofbfaJTyk8UPZYGa8q2gR80zEeiqiJqzzhoFYZLT3ByK7rKxH+ui20Mbqw4K16IqN5o1efOiDsgP1LLIxVYxH1wBechTrTu+S2AY9kdh+h5SSh8o86OQBopsSavMjdlusshM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758836618; c=relaxed/simple;
	bh=HRjYIPQ6CIvY7Jd3AXBEqdS97gsexFvbnbA0BxIWXiU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rzS4YZuRPE0l98HtA4MvYi8xUAHaLyLc6nFtovmtg1Kz8wQHuWumocvzRQb7kFnRX1eJH1RCQ6ZqPqYBjmsTh/l6uZtQpephBx/GLGz3SwqrWyq++HraJpMtWgezA71XJsxDxYSEkWpfN9UgUFAkEdAUxa5YeXbrdWO/ywEiPHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=EAEyctSI; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=EAEyctSI; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="EAEyctSI";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="EAEyctSI"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id BC1B16026C; Thu, 25 Sep 2025 23:43:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1758836613;
	bh=yiROxeBvKaWN/NF2xtUyOg+dLnclZe8/BKEI5qbdI+g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EAEyctSIqNK03bhM1b0GhBpMqzjuEpK2fZGwu6GjRSMH+H0D4H+kYVJVMHL0isQ+/
	 AFYcljcxfm2MFbL44JI+i3IOkosR5bTCzXxM2+O19i68OtkypPxl6IZPh6wHFiY5s6
	 j+Sj88qi/ue2vsruG5ET9tqbkADIf3qpvLqIdQn9tFy9JDViJ8Gu9qNajAv2kvydAq
	 quwVuYpWn0zamRpUKLSsIhmzPHNHobtmC7Dxj2iivXdmLZ2T8yZpRSC1XMOgduf8gf
	 x016N5VQdaSbm8yJpMqPUJEMkvenmb/vfQb9IPPfMx4m0F1Zmr9yqIlm+EQzDPwTN7
	 Tp5vMjJTZdGoA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 294326026C;
	Thu, 25 Sep 2025 23:43:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1758836613;
	bh=yiROxeBvKaWN/NF2xtUyOg+dLnclZe8/BKEI5qbdI+g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EAEyctSIqNK03bhM1b0GhBpMqzjuEpK2fZGwu6GjRSMH+H0D4H+kYVJVMHL0isQ+/
	 AFYcljcxfm2MFbL44JI+i3IOkosR5bTCzXxM2+O19i68OtkypPxl6IZPh6wHFiY5s6
	 j+Sj88qi/ue2vsruG5ET9tqbkADIf3qpvLqIdQn9tFy9JDViJ8Gu9qNajAv2kvydAq
	 quwVuYpWn0zamRpUKLSsIhmzPHNHobtmC7Dxj2iivXdmLZ2T8yZpRSC1XMOgduf8gf
	 x016N5VQdaSbm8yJpMqPUJEMkvenmb/vfQb9IPPfMx4m0F1Zmr9yqIlm+EQzDPwTN7
	 Tp5vMjJTZdGoA==
Date: Thu, 25 Sep 2025 23:43:30 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] build: disable --with-unitdir by default
Message-ID: <aNW3gjiVZ8GuwH7x@calendula>
References: <20250827140214.645245-1-pablo@netfilter.org>
 <aK8aN4h2XsLnTdT6@calendula>
 <20250829154350.GE3204340@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250829154350.GE3204340@azazel.net>

On Fri, Aug 29, 2025 at 04:43:50PM +0100, Jeremy Sowden wrote:
> On 2025-08-27, at 16:46:15 +0200, Pablo Neira Ayuso wrote:
> > Cc'ing Phil, Jan.
> > 
> > Excuse me my terse proposal description.
> > 
> > Extension: This is an alternative patch to disable --with-unitdir by
> > default, to address distcheck issue.
> > 
> > I wonder also if this is a more conservative approach, this should
> > integrate more seamlessly into existing pipelines while allowing
> > distributors to opt-in to use this.
> > 
> > But maybe I'm worrying too much and it is just fine to change defaults
> > for downstream packagers.
> 
> The upshot of this is that the service file is not installed by default, but
> the related man-page and the example main.nft still are.  Gueesing this is an
> oversight?  If so, I will send a patch.

Yes, it is an oversight. Thanks.
