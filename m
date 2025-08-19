Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1D52192E4
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Aug 2025 14:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755614838; cv=none; b=DgrEgsuqH86R3bml8JImq1X1svas/HaJruzQVVJtBfc6T1xIkb450Y6Xh9+dLo+sWfwuOB+o3cMJ+b2X4rNrI0aAnV/4wavoB+MUBoVNttFBDUfjb7LPgqyH9sM3zZ61w7XH63PZJiCBjEkbdoD2uyHWCufG6PjNZIt3QCfxHmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755614838; c=relaxed/simple;
	bh=17M6EULljlhkBDQlSZLXdNRocqjqw//WqssRraxakAg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qQ5ATj5h5r1gXQKgblAfak9FwsFv/fO4hONdzIzkgkF7BWyZ5uA5427V2oinVg/2+tnTvEZhL/z+Qb6k7aBnWPXZ8mTNrQjVJ7Mibt4NRB2fV5HKFa9MzldYGjYHP3SlDmQq6Ks2snSlHHxTY+KjBsnc5JRmeRhW5hu8H8un08g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 62085602AA; Tue, 19 Aug 2025 16:47:08 +0200 (CEST)
Date: Tue, 19 Aug 2025 16:47:08 +0200
From: Florian Westphal <fw@strlen.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH nft-testing v3 1/2] netfilter: nft_set_pipapo*: Move FPU
 handling to pipapo_get_avx2()
Message-ID: <aKSObG_ih5HqGzrK@strlen.de>
References: <20250818110213.1319982-1-bigeasy@linutronix.de>
 <20250818110213.1319982-2-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250818110213.1319982-2-bigeasy@linutronix.de>

Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> Move kernel_fpu_begin_mask()/ _end() to pipapo_get_avx2() where it is
> required.
> This is a preparation for adding local_lock_t to struct
> nft_pipapo_scratch in order to protect the __map pointer. The lock can
> not be acquired in preemption disabled context which is what
> kernel_fpu_begin*() does.

FYI, I ended up squashing this commit into
'netfilter: nft_set_pipapo: use avx2 algorithm for insertions too'.

This way there is no forth-and-back-again.
I added your SoB tag to the commit and a brief note that this
collapse happened.

Result is in nf-next:testing if you want to take a look.
There are no code changes to the previous incarnation of the branch,
only a few spelling fixes in some comments.
