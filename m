Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103FA392838
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Sep 2026 07:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790666436; cv=none; b=pI4Guv+B9ns06t9/Ud/6REt5S3U7ceo20w1S0CufKWIuvSOBOzdo7A+UOD208d0d/HQLgLG7Z/A2j9qAW1xi/x63OO6ndrM+uC2qQbbPk+AfuR9Bk/BYUmiF5erINie/kysW1KGqSQO4JvgKuMW+yFkuN39EsmdXhFR3eM/owvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790666436; c=relaxed/simple;
	bh=kCdWgo/03gTHnoBiVR/PqiHWYZlBNm+MidBDdGkX30M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jBjt9LGv2L0z5rb1WODHWAVeN7Xt9U4liEik0H6ngteIBiEh8cw6aeCm9QMqKq9T7m5WpRg2l4JoapU/gs+q4I3cL8HLRzmr3Hb+az5DsSpsLnz7wXYHbVQJB3eC7inpQcMA42ziCvGMQr6KvLieBS2Uvvg9Qaxlv9fvK680Scw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0D01960380; Tue, 29 Sep 2026 09:20:31 +0200 (CEST)
Date: Tue, 29 Sep 2026 09:20:30 +0200
From: Florian Westphal <fw@strlen.de>
To: =?utf-8?B?7ISx67OR7LCs?= <tjdqudcks0424@naver.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, phil@nwl.cc
Subject: Re: [BUG] netfilter: IPv6 conntrack fragment reassembly truncates
 header offset
Message-ID: <artmviCh2h4vYLKG@strlen.de>
References: <622191c6a9b35335b65fdb07f8914b7@cweb016.nm>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <622191c6a9b35335b65fdb07f8914b7@cweb016.nm>

성병찬 <tjdqudcks0424@naver.com> wrote:
> I found a reproducible IPv6 conntrack fragment reassembly bug in:
> 
>   net/ipv6/netfilter/nf_conntrack_reasm.c
> 
> Tested kernel:
> 
>   Linux v7.2.8
>   commit 9a66fdc0d7fd55f54235524a73435af99051e46f
>   x86_64 with KASAN enabled
>
> In find_prev_fhdr(), the previous Next Header offset is stored in u8:
> 
>   u8 prev_nhoff = netoff + offsetof(struct ipv6hdr, nexthdr);

Please send a formal patch, thanks.
