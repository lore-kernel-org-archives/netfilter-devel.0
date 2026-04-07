Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0963A6F1B;
	Tue,  7 Apr 2026 10:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775556111; cv=none; b=ANtICjBuV139J4eCQsBbrFwaUyCwPEgQblnU+snoO8m2xgmMtfRvG3FbaLd+/hjYOIzHvH5KZh5+DMphq/Dzsbl5hCcZ2AG20l8/8yeuvHcUtG5eazYbQX3MroTz969saMY59v5kmimi4KGOE/3gCcFty3yzV7SlMUjoNiQNFSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775556111; c=relaxed/simple;
	bh=ecyAOrMMrbKEuqB5Firmz5k14myba7ZphTAGIuvqBNo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oQ8+t2Du3RdgXNtkc+GQUsVC19w3e4dKRkK54MVPaFtChQQJk5MdnNcIr+6cECzw7Wxv6Wra5Z9vjw6s5h+bxSNVu6nT/3l/PcW10P7QGV29kec3UZxAJlH9TSzlZ9WCZg2H4ytoryU195wjPuCkB1IQO9Yv+bPJ5QEXKSk4kbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JpBPxme3; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JpBPxme3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vos0tzDhELnTRqLSDlG37t1JXoKtfyXxlsfkTuEGczI=; b=JpBPxme3vwTZFywGzMAPTXOJdA
	tGN2nMsVji6n7YXRgNNXjeuHE7S6vHM617LTxlTy3OebUiZ3lrDTASszjjD+HvnVwQ7c4fUqrRFnj
	GpHB25J6JmMxNQeBKvvXAMB+T8nxAG+wSe8uLSfSojpw5zG+aIlKJl+YPoGdn/27w762hqJjhlox8
	9S+RmB031FUdFz0/xq3ND8tfo3qb4ZoS9oqptrmKSb/AffEp8/wkp59NbWtMTtHBdSD6qHPGurmqv
	q92nkC711qqeHDxnBiB9t0Vg4qDfZVM2kfYiAF2FdUaiq/sZXu3gaPdu4o79BVbSF7++5HWr3vDcZ
	Pz3Wpm3A==;
Received: from 2001-1c00-8d85-4b00-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:4b00:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wA3Fj-00000003P0H-1Epa;
	Tue, 07 Apr 2026 10:01:47 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id D99233005E5; Tue, 07 Apr 2026 12:01:46 +0200 (CEST)
Date: Tue, 7 Apr 2026 12:01:46 +0200
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
Subject: Re: [patch 06/12] posix-timers: Switch to
 hrtimer_start_expires_user()
Message-ID: <20260407100146.GR2872@noisy.programming.kicks-ass.net>
References: <20260407083219.478203185@kernel.org>
 <20260407083247.898494239@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260407083247.898494239@kernel.org>

On Tue, Apr 07, 2026 at 10:54:43AM +0200, Thomas Gleixner wrote:
> Switch the arm and rearm callbacks for hrtimer based posix timers over to
> hrtimer_start_expires_user() so that already expired timers are not
> queued. Hand the result back to the caller, which then queues the signal.
> 
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
