Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016841E411C
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Oct 2024 23:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730330961; cv=none; b=WSdfKiNjYnLHPXqCERSC/g1vjp9vHMLJfmmJITusSnuY11u5tvnXfcaiKV5HSvkt74jzpY+uvdYCAFTedNjpmolCGths8I5/+HSnRRu5wiJcs3TZJmP052YriysYsc25JTHPxrohIdjcvmitLCJ0q0jWcblWUL5cdPSrmbgKaaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730330961; c=relaxed/simple;
	bh=FIdwbBm1clXZYtnzhLzKh/UwciCwiiDFPLxLWrRhpW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Krhs67geANn83EFXiUQQZ4UflBL4psziGD9Vxmq6H1uVvtX4WoPdo+h/PBPxIJ8qKsPu/F67gKxgqjEe1GHacma1uCpfochn3owJA49IwyHRv0OIc93iUHwxQoOYcu00axcIDHPYw5fkhAIoLR+52mu3jpvuyBxNzBr6yDC+1vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t6I7m-00085u-AN; Thu, 31 Oct 2024 00:29:14 +0100
Date: Thu, 31 Oct 2024 00:29:14 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: monitor: fix up test case breakage
Message-ID: <20241030232914.GA31019@breakpoint.cc>
References: <20241029201221.17865-1-fw@strlen.de>
 <ZyJ4w02pdiv2LpvW@orbyte.nwl.cc>
 <ZyKnPxdGwh1X3AwT@calendula>
 <ZyKxY6WZJrKioMDt@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyKxY6WZJrKioMDt@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> I can also revert the patch if you don't like, but it is saving _a
> lot_ of memory from userspace for the silly one element per line case.

I think your patch is fine, the question is if we should ditch the
test case instead of reordering the expected output.
