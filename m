Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F64534EF05
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Apr 2026 18:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775585337; cv=none; b=l2DttbI1J6PwF8LqZ9ZHvLWX2Jgeu4TWS2UJKZAYDG6dmc3dn25BTbrdYW9BaotGxyewQHiNulHd4V26OXP6cmYX4uo/WH+NqFQyqA5pt5LfbpOLbVk/nc/c6hW3n9M47i4OWfnxRWzicY5YM2aDth3RWgtDMvwEIIE5Kjb16Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775585337; c=relaxed/simple;
	bh=BgP9YTtKtdp11V1qurfEh6r6WWSsqXAYo4cJFs8lW8U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K+m1XSybh+XI4Dxg9jTweABP0ioSE8K7AEXLekbmWkCFcSENJo3/LrZ3/kkhojcbQZCOOs5RRdAxmZ1rVkf6oWUU+A/17FIvj09DrvtyNKmv4LwHgfkWaTjeMNTqNPoi7SI1I652v3m6vgppLxWTTPSGSJBOG1xy+hEf3awtbKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A388B60660; Tue, 07 Apr 2026 20:08:46 +0200 (CEST)
Date: Tue, 7 Apr 2026 20:08:46 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, phil@nwl.cc,
	pablo@netfilter.org
Subject: Re: [PATCH nf] selftests: nft_queue.sh: add a parallel stress test
Message-ID: <adVILlipGGN76rcw@strlen.de>
References: <20260406211831.3758-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260406211831.3758-1-fmancera@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> diff --git a/tools/testing/selftests/net/netfilter/nft_queue.sh b/tools/testing/selftests/net/netfilter/nft_queue.sh
> index ea766bdc5d04..1e1949c6a918 100755
> --- a/tools/testing/selftests/net/netfilter/nft_queue.sh
> +++ b/tools/testing/selftests/net/netfilter/nft_queue.sh
> @@ -11,6 +11,7 @@ ret=0
>  timeout=5
>  
>  SCTP_TEST_TIMEOUT=60
> +STRESS_TEST_TIMEOUT=300

I changed this to 30s, I think the full 5m dance is a bit
too long for the selftest.

I know 30s is likely not enough to trigger the bug reliably but given this
test will run may times per day on netdev infra I think 30s is ok.
