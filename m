Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13223C5827;
	Mon, 17 Aug 2026 21:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787000507; cv=none; b=kvyUEOmQtVPWCvpCZ7niw3cO4W+Unym3s+9haCeLcO6hdoxu6DwXwNBi1BXS34Mxeo5+xl/P6QWb2+ooclYpUlQY9W8ZnuiWzcK9l+bgkVjgrY/8PNN2AAawRUC+HQJm3iWEf0IfbbSD9LYiXAlagFhtg44Gk28u1cq8829/QRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787000507; c=relaxed/simple;
	bh=2cbr6na+ZTM5svrzCCO0SfBXUQGofdWeZxUfG2JpabY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HWqlSqmlCd0u1jBBcGKAcmIo3MyucwObqYDMgdCVAoK5p1H4KtBTogMjT7FDtxh/lKf3620jsX6LEPLlFUTxGn6MIekci9tqyz/ig4AUudn+Rg7pHsAEYmKcBHHRjmKwLNV9eNnHIWaKct3mcGosWF496hqfMdkNgILeKmj1fnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=A5sD3cWK; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="A5sD3cWK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=H37KXwW7bbeTt69RENbuPKZTQxTdS5bOb1mp2xT1ICs=; b=A5sD3cWKNEfBHrQuj05YweQ6CW
	RNmsjrgeEmncyNTSKtRVfnVtKKinS/8HqFJ0NJKK9fRFN1lS2GHLpT91zOT3ciZfH7MqlRctdnH2x
	6Vnh1pxRNPJliFc7V1bU6ncps79Dh1FUyyqQIBHd86z+UtsD05K6tNpbwV2EvHGR0Zp4djzVHL8QT
	M2d+HiaTWcEPYO/i81/2lAE2d35kvxKAR908UR1N7QF06+1pC5KLHwWjknj8qBQBKc/4vKyvPEk9y
	A5GWe1Snl8OXE34lI9EijwO1IOoEFWOL+G9s0CE8Lp7cy4obl8hknLvP4K/YGklnSjUJ//k7YagmY
	KPfvfE0Q==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1ww4S7-000000015EY-1jJD;
	Mon, 17 Aug 2026 21:01:03 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 9C9CD3006DD; Mon, 17 Aug 2026 23:01:00 +0200 (CEST)
Date: Mon, 17 Aug 2026 23:01:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: jim.cromie@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Boqun Feng <boqun@kernel.org>, netfilter-devel@vger.kernel.org,
	bpf@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH 6/9] locking/lockdep: Fallback to folio_pool in
 alloc_list_entry when static pool is full
Message-ID: <20260817210100.GC687043@noisy.programming.kicks-ass.net>
References: <20260817-folio-pool-v1-v1-0-0c1d230aa3af@gmail.com>
 <20260817-folio-pool-v1-v1-6-0c1d230aa3af@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817-folio-pool-v1-v1-6-0c1d230aa3af@gmail.com>

On Mon, Aug 17, 2026 at 11:22:20AM -0600, Jim Cromie via B4 Relay wrote:
> From: Jim Cromie <jim.cromie@gmail.com>
> 
> Use struct folio_pool to dynamically expand lock dependency storage when
> the static list_entries pool is exhausted, avoiding premature lockdep
> disabling.

Since that thing has locks itself, no.

NAK.
