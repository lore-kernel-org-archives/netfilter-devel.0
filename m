Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE5310A1E;
	Thu, 17 Jul 2025 15:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752765250; cv=none; b=XU2eY4p0WueJvZCYHH06vQpsRKEkMfhxQfYpuWSOIo/l5ksif9PhSgH+GIOOJZtpXFWEjXnyJZft0b1S1k1kaIYHmb7ulfRmgypXcltPI93drbOE+LTc/Y404QkhFo8tBuA8XIrLvHi5tx7VHIVKTLyuTLIkob7JqBgMoQr8/iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752765250; c=relaxed/simple;
	bh=o3eiom8WmqdmzcX0mv+JL7SmANVYrCqOaYoxSqqcXaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=arp4dz1oxXIMXGm1oaPnznJ+ipYDXOxJRK1uSmktPPJ/KaZXXQcG95Sz8xjF2LG4Qj7xwBLrFz4Sfju7TmOw+AiQc0Cwlr8bqSnA2R6kEYjzL5ufWSbx449ENKF4OEZYIMSqImdoomUUFrD8HXVLa0lDy0vx5lsagOePvo4hYPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 18443610C3; Thu, 17 Jul 2025 17:14:06 +0200 (CEST)
Date: Thu, 17 Jul 2025 17:14:05 +0200
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
	horms@kernel.org
Subject: Re: [PATCH net 2/7] selftests: netfilter: add conntrack clash
 resolution test case
Message-ID: <aHkTPfrhLe6q_Vte@strlen.de>
References: <20250717095122.32086-1-pablo@netfilter.org>
 <20250717095122.32086-3-pablo@netfilter.org>
 <20250717062218.380dab89@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250717062218.380dab89@kernel.org>

Jakub Kicinski <kuba@kernel.org> wrote:
> # timeout set to 1800
> # selftests: net/netfilter: conntrack_clash.sh
> # got 128 of 128 replies
> # timed out while waiting for reply from thread
> # got 127 of 128 replies
> # FAIL: did not receive expected number of replies for 10.0.1.99:22111
> # FAIL: clash resolution test for 10.0.1.99:22111 on attempt 2
> # got 128 of 128 replies
> # timed out while waiting for reply from thread
> # got 0 of 128 replies

No idea yet whats happening here, I get 100% success rate even
when running this thing 1000 times in a loop.

I sent a patch to no longer treat '127 of 128' et al
as a hard error, i.e. the test should then either SKIP or pass.

And I added a bit more information, maybe the next test run
will tell more.
