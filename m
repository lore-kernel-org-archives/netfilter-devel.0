Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C26322256D
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Mar 2025 08:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741595690; cv=none; b=PiZ8nvm5CBQ9YyH7DbuN4wZgoI+0HlTCn321m0K/TMezRkrBDihiCBOYI8ci8HH1mqP1LOk7Ag7scSP+ehVqz71Dq/1XvokgkCGYgaV41dOslgk9qpnQ/RoLtp7KyIoFw+sz7n4pRWEQ1UYk+51l06C4zpzbnFKaQS7+GHBz76E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741595690; c=relaxed/simple;
	bh=eNlpM6K/Ub44HpRbdgDu1pRkl5DDoVcyizaBNvaPWd0=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oiDheAc+SwW2Q84qZVCUGOhKtvDPQG4FKgg6DoJig+6XpEiuSsZgzm5U0x4cAQetIZC3XEdnlNgHIsaN5ckJI3Ms/U0tr/6OVCj/fJx9G9hWkpdqySeF8NB8ZMpikneTempoCP0TAHG4ZGS7o16foIkkE/ArcmKH8Bzzkaxs8sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1trYb0-0002Gk-Cu; Mon, 10 Mar 2025 09:34:46 +0100
Date: Mon, 10 Mar 2025 09:34:46 +0100
From: Florian Westphal <fw@strlen.de>
To: Florian Westphal <fw@strlen.de>,
	Netfilter Development <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnetfilter_log] autoconf: don't curl build script
Message-ID: <20250310083446.GA8451@breakpoint.cc>
References: <20250309105529.42132-1-fw@strlen.de>
 <Z85FG/1qImu3tiSS@slk15.local.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z85FG/1qImu3tiSS@slk15.local.net>
User-Agent: Mutt/1.10.1 (2018-07-13)

Duncan Roe <duncan_roe@optusnet.com.au> wrote:
> | This is a bad idea; cloning repo followed by "./autogen.sh" brings
> | repository into a changed state.
> 
> Agree with the above, except IMHO the "bad idea" is to have a frozen version of
> build_man.sh in the repository at all.

I absolutely hate the idea of fetching stuff at build time.
And in this case, we fetch an exectuable shell script from
untrusted location.

It has backdoor written all over it.
