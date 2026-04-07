Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5F13A63E1;
	Tue,  7 Apr 2026 10:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775556017; cv=none; b=fghyxlJ88Go0zRIhEDbpDjxAHoKexiwzmPPoZ0pqGqE/71wA63VOGkwDwhmztb03QKq08ebZ0cIb4Bj6PLVVdMZGMI8moVCNGakl2QGdXFSGtj294kCxi5Z+5Z8wbGQZ0qM6V1QyOw5tMhxz8kZTPqPM7In4thdSxFwU9gCGN6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775556017; c=relaxed/simple;
	bh=7KaX7O3HmYfC3kYnsgVyuyQ7jFu7vds3HZKpyIgBL7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Obu7L4f/zQQxoSauvDenkhscvsghiUqZVOKcboYW6I71yH+Y6uZgxudKcPdjaCWw6a3mbFJKVaeoOE+JXVsCUVHamZfNiPxfuWmzNfk/+ozRKXEgcfExCq/WqdiWz9Sckray/Y/yPtnHjDJE0GDotHIUiZcsDnHpIgtsLDjGixk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wUIaoSxA; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wUIaoSxA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HtVPDSs0A8WVW/1TIqqF6iHDY4S6Th4lmUmYx5fszb8=; b=wUIaoSxAaqbBo95gXEuRSB/aW3
	LFGTeA/e4xE/r0SqY57iSHawqLf5VbIX56xiSvCWkLbe+0sKYT9IKHLnnUwcbbVWXzeChTttIiX3f
	e54gn7/PQhXt7M0C5ysEiBgRudwxCzWUw3uK19eVly4MQlZWGVUFm3Nmh/Ep8NAUnwrur4Hita0zo
	zV42BVuIOest5eS3/guDjhqd9+CHMZs0sAMA58FL18tbnr/3KaNHKt+vJcHpIvO41YEs1g2Tbt+yY
	dV7HbyluwZlzpaHO7rcb2ay3eXsMF5XBfGop2m3qYMdVbnwyYdPbppop0HdS4tpUVXeqlEcB9pCA7
	960PunFg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wA3EC-00000003Otz-0oVY;
	Tue, 07 Apr 2026 10:00:12 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id CE5FB30035C; Tue, 07 Apr 2026 12:00:11 +0200 (CEST)
Date: Tue, 7 Apr 2026 12:00:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <jstultz@google.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Calvin Owens <calvin@wbinvd.org>, Ingo Molnar <mingo@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
	linux-pm@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [patch 04/12] posix-timers: Expand timer_[re]arm() callbacks
 with a boolean return value
Message-ID: <20260407100011.GP2872@noisy.programming.kicks-ass.net>
References: <20260407083219.478203185@kernel.org>
 <20260407083247.763539663@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260407083247.763539663@kernel.org>

On Tue, Apr 07, 2026 at 10:54:33AM +0200, Thomas Gleixner wrote:
> In order to catch expiry times which are already in the past the
> timer_arm() and timer_rearm() callbacks need to be able to report back to
> the caller whether the timer has been queued or not.
> 
> Change the function signature and let all implementations return true for
> now. While at it simplify posix_cpu_timer_rearm().
> 
> No functional change intended.
> 
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
