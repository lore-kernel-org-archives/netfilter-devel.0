Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F884239E83;
	Tue,  6 May 2025 13:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746538577; cv=none; b=W4MFoqTdLZRIsJxToKiRRT4ROKyfagylHA+wDI6ETrF0g3ahrJKOTfzjcmovHeciXcXeGAfCC1l149vzFJ9Yv1xiP/bzn3E2vMLZhDqSSXdWdThaoJDppl0Fj54D1hYYIY53zaUQlJMzcCcCNnKnNVryfuw153q3SIZoTeSB4YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746538577; c=relaxed/simple;
	bh=dhIFvq/LxVHQoFaVZtR6YcDd9WB+E7GlAwdTir/zKJo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uVWhIPJU1MpL0tntO/K2AV8MJrSRRrG/NjWioXZ8q3opUUJC+PodtR6cskjj7lL322E7+NVszLXWoYn9mLG4Gp77xasGmJWzX25+741Cqmp1Ntvy1f1I1AeTlXmSX+R1Ur6Sc37B1pL523Nhpz3U34TlWo8ELvOTqDOL/7mtEWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1uCISw-0003aF-5c; Tue, 06 May 2025 15:36:10 +0200
Date: Tue, 6 May 2025 15:36:10 +0200
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
	fw@strlen.de, horms@kernel.org
Subject: Re: [PATCH nf-next 2/7] selftests: netfilter: add conntrack stress
 test
Message-ID: <20250506133610.GA12802@breakpoint.cc>
References: <20250505234151.228057-1-pablo@netfilter.org>
 <20250505234151.228057-3-pablo@netfilter.org>
 <20250506061125.1a244d12@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250506061125.1a244d12@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Jakub Kicinski <kuba@kernel.org> wrote:
> This test seems quite flaky on debug kernels:
> 
> https://netdev.bots.linux.dev/contest.html?test=conntrack-resize-sh&executor=vmksft-nf-dbg
> 
> # FAIL: proc inconsistency after uniq filter for nsclient2-whtRtS: 1968 != 1945

I'll have a look.
