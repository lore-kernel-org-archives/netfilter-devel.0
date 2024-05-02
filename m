Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5941925634
	for <netfilter-devel@vger.kernel.org>; Thu,  2 May 2024 08:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714638645; cv=none; b=c1TRvPUKeKt3XOb8Y8tg6TiCVyDQsScgA7Q9anE0vvrxpdeq/vCVFS+yTvymdDs8arSA+izw6VhEFijW9Sd8dGWG8Yt1zCAZPNJayGMZTsRs27LNy28brxrLFB/UxsMiSvYTCc5gOw4JjcwrHfhfw0aJiONmb67jwoynA292UQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714638645; c=relaxed/simple;
	bh=NbMMrnOIjmONF91X9rZTeA+jj1XYRFGPvfhxG3ktjCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ctPUDKl0pSqATSMlYnHkU2wvGe5yq5xE1pnE6WCzW86ft2YC1rEyHRcNQvcA0b82kOF5DggYHP8EPltF3o2DHx3nVERqYScXhTIGfIQnQOcr1qeynY5SJEz/E6OvzyeinxJlIUOFUFzcuGUnWcuYqyHoXoPRt1zEUvU84pOZ3lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Thu, 2 May 2024 10:30:31 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: bre Breitenberger Markus <bre@keba.com>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] conntrackd: Fix signal handler race-condition
Message-ID: <ZjNPJ_dEJXwU_8-o@calendula>
References: <AS8PR07MB7176A6FE25478A7C1BA4BF29CD3C2@AS8PR07MB7176.eurprd07.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AS8PR07MB7176A6FE25478A7C1BA4BF29CD3C2@AS8PR07MB7176.eurprd07.prod.outlook.com>

On Thu, Apr 04, 2024 at 10:39:39AM +0000, bre Breitenberger Markus wrote:
> Install signal handlers after everything is initialized as there is a
> race condition that can happen when the process gets terminated after
> the signal handler is installed but before all fields in the global
> state are set up correctly, leading to a SIGSEGV as the cleanup code
> dereferences uninitialized pointers.

Applied, thanks
