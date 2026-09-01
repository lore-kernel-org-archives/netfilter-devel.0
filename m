Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E304119F3
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Sep 2026 14:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788274619; cv=none; b=YQcH7VWnB6ovglkb1d8iGwzVgKGyy5ZOQTI0mb2I14l493+TWJCfCUUsm5ButHsteYnbLO8mw+8Ntc8pp/MjhbX0i7e8UamkA0o0xp3ZGfcaJoM2uSQcs4hJY/f8c7xAuei+7AyLMvmszK5lD7j1+A4+khjJW/92ACenJdu2wBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788274619; c=relaxed/simple;
	bh=YMoKQsjT1J/uLF3sEHiv0ZHZ69yyDrvnjq8JwEgASe0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nxfdq432GazajTghVaLf14BM8gjEP1S8WPP2+S0KEp92FEiSIu9OJ+odrSV7I9DrQornJhiokWgVyl46Un7zFfyXZ5MzQsHEtv0bE2/qqcmRk7kG3DUihXjIhfxt5hO1pG0jYWT5VaDDXiRyE7FRYZOYbkfjikG7PW/UTMD5Wxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rvyFX3H4; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rvyFX3H4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788274614;
	bh=fI0tUFLKAjHV0V/P/hBZ3nPybBLDU2o1eML/g22F2zc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rvyFX3H4hjoymRfJakQ0OuhZo3XquU8MvBeao+EksSwUh8RVnTbryuaGxLZm/nKYh
	 PUGShU0fMJMPhDmq3T9DMUhxRT18k+dx6BdI72SgXheAI5gBaaUzHU9i1Bfv0+DOY+
	 6MYwxRnkPNZAq/eCUqf1b2NWr6lpgzpj8JZdFK1XwWXbP4QvvHJ/FjHNxbqqH9q/BN
	 hdGfV0ECZPE/ypYhUSJKN/9jWuqGw35+2C3CCnS6htdL7j7//iMRjFEBxFXMlz0Rvx
	 Q7z2peLfky27jdcCDJ/X2pcKU1C6BAK7bhsvGDPMIcFkInb7R1sgg46Q4tfEcIrZtZ
	 2h68WpSEr1E+Q==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 4769260093;
	Tue,  1 Sep 2026 16:56:54 +0200 (CEST)
Date: Tue, 1 Sep 2026 16:56:51 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests: shell: Test odd netdev hook updates
Message-ID: <apbns1SLfAn5zClE@chamomile>
References: <20260827204255.274666-1-phil@nwl.cc>
 <2fa302ed-71bc-4136-8955-cddb234b5e24@suse.de>
 <apagf_aZh7-dre1O@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <apagf_aZh7-dre1O@orbyte.nwl.cc>

On Tue, Sep 01, 2026 at 11:53:03AM +0200, Phil Sutter wrote:
> On Tue, Sep 01, 2026 at 09:54:27AM +0200, Fernando Fernandez Mancera wrote:
> > On 8/27/26 10:42 PM, Phil Sutter wrote:
> > > These should cover what Fernando fixes in his kernel patch "netfilter:
> > > nf_tables: fix device name and prefix match in hook lookup" as well as
> > > some bonus cases I came up with.
> > > 
> > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > 
> > Thanks Phil! These tests cover a lot of different cases.
> > 
> > Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
> 
> Thanks for your review, Fernando!
> 
> Pablo, I'll push this out now, which means we'll get two failing test
> cases until kernel fixes are ready and deployed. Fine with you?

We usually wait for fixes to propagate upstream before applying tests
to userspace.
