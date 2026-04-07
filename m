Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC76A2F690F;
	Tue,  7 Apr 2026 10:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775556071; cv=none; b=nHTS775iLcBSdgOOapBGL9rdEdyFzqx3w6GMtFWuALbHjq/uOxgO9lHLNpdGA2bZncL+S55Z8s5ieIHGx9fWJkdyccceagr5+pQDykY8imz1bt5F31EoWmM0PAaeQfmGdv/qSrMj7pZ6/9NYJGVfemPz6wraFemZgiNJzkQfUqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775556071; c=relaxed/simple;
	bh=SVZvZcW23j5b7OrpPVl9lfpOYgcKGuSaeaxO/0W/Z6I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bmXqdKm6ppXsSSIHxtNdqIny/ckuKzbj4Gwye8VbDK0MqXn2XM3EPGxKkgWwrkekK8beRMXsA+gYU7qdgxDPBlBxYeg4gfczy96+ADzmTbxX9XUTQPNtsU6fK4BFo48Yxte2CGOWeV8RjM2F1zVaM8Hlakr0GB4b4vKqCNSrcw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MEx2UPhZ; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MEx2UPhZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VL2JbSxgAfIh2iradYyQ8JthT9/Jt9Wx2KnswOgunw8=; b=MEx2UPhZGulHZfmKdMkP0k5hUr
	PxmPoqmdD+IgVqSkJF5l8y8X7t6WGVdvWsRO6jjUxDFGG7gvisjFSPpVKVkYHzcSRcSTvtfqKPysp
	dq8osPALbNAqR5rOqwTRnbk8KPctMr43kPt3/BhNeuPLdLvSO4IdERZGgCJ64ami7WXALT2j3SzoU
	vp7pfJIztl7WG1iqHhf7N6qhCulvC8eBjxJ+9M3Qa0VJ0cMG+xBPdObLga7Cxz8O5cwa/O3nQMjGm
	nHWH7U72mN8NYjko4U7r8UZghLqlZ2wlVEn/T3bE6D7pXPy3OZZZYMho6ppn0TLusF0WQ6c89ZT5A
	A+dNRrIA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wA3F3-00000007zZq-2JSP;
	Tue, 07 Apr 2026 10:01:05 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 15FE730035C; Tue, 07 Apr 2026 12:01:05 +0200 (CEST)
Date: Tue, 7 Apr 2026 12:01:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Calvin Owens <calvin@wbinvd.org>, Ingo Molnar <mingo@kernel.org>,
	John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
	linux-pm@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [patch 05/12] posix-timers: Handle the timer_[re]arm() return
 value
Message-ID: <20260407100105.GQ2872@noisy.programming.kicks-ass.net>
References: <20260407083219.478203185@kernel.org>
 <20260407083247.831143104@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260407083247.831143104@kernel.org>

On Tue, Apr 07, 2026 at 10:54:38AM +0200, Thomas Gleixner wrote:
> The [re]arm callbacks will return true when the timer was queued and false
> if it was already expired at enqueue time.
> 
> In both cases the call sites can trivially queue the signal right there,
> when the timer was already expired.
> 
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
