Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50523A3817;
	Tue,  7 Apr 2026 10:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775556271; cv=none; b=fnS8nqA0BcJG1PoKiu9auix7L3okqNrcWnbToEuaXEH8JRL07rbubuM4eSTtAnNIM0z/E/bx3ELXh9a0erCjO1FxMrDO7Pocv26pCEKml4tvYLM+of00QSP8J8Xbo65Iir0dRrSybRO1n3c6SqyosUmfiwdxEcT4Gcxun0UPsPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775556271; c=relaxed/simple;
	bh=yOY7+KmRjtyw8Q72hV54JYZywu94r/DU9OedaN0htSA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HiNf8OBxKnnegJJfPw5CfzcIrinQBCybSP1HM2gyTMoVHYQjWqwgNq3Lf40TNjIXckQWH59PLFFGTiTKTrGZj5KUlI8p62FqlXbPADqElh4WhicVyb8rynamCJKX4lEJ188NSscTHarYSW+n/uizRcBmTRy+QauNiyaJKXIfPZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=a8FiwdAm; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="a8FiwdAm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=T8HUZX93ODTWp3PC34SKmXA5tERstb9SD8VY+5Ru9Yw=; b=a8FiwdAmfzbJJUl3Ffp9Q8g23e
	UkjGMD8OHR7D9YD+uzyoPa4Ucigbk52PNJfKKav0gLxT/lI95rzDTTmixVoG+Sj12s76LfYVOpiVF
	rMXiJoIkcjxVAl5sWoUEcmysVOxgQ5d6BVL19ZGhKLPN/agyGg0hcMos9AnO0Gmy6I8Uc0p4h2+9n
	8QRSkh7OPiEvl5LdK/rI7lgbgJfVfFZoYMD2NQQMEiA3f6WZZvJEOhmTf+jAZB6FQE60O6K9keeIq
	A+qJqrG6gv82NziEXTrXaOSttQWJr0j6DgTmW4ybqcZ+hNOfjR+7OJcq73eXPDJSWiYJxAgC6cYsI
	FHT3569g==;
Received: from 2001-1c00-8d85-4b00-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:4b00:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wA3IJ-00000003P8r-2or4;
	Tue, 07 Apr 2026 10:04:27 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 3CF6E3005E5; Tue, 07 Apr 2026 12:04:27 +0200 (CEST)
Date: Tue, 7 Apr 2026 12:04:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <jstultz@google.com>,
	Stephen Boyd <sboyd@kernel.org>, Calvin Owens <calvin@wbinvd.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
	linux-pm@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [patch 07/12] alarmtimer: Provide alarmtimer_start()
Message-ID: <20260407100427.GS2872@noisy.programming.kicks-ass.net>
References: <20260407083219.478203185@kernel.org>
 <20260407083247.965539525@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260407083247.965539525@kernel.org>

On Tue, Apr 07, 2026 at 10:54:48AM +0200, Thomas Gleixner wrote:
> Alarm timers utilize hrtimers for normal operation and only switch to the
> RTC on suspend. In order to catch already expired timers early and without
> going through a timer interrupt cycle, provide a new start function which
> internally uses hrtimer_start_range_ns_user().
> 
> If hrtimer_start_range_ns_user() detects an already expired timer, it does
> not queue it. In that case remove the timer from the alarm base as well.
> 
> Return the status queued or not back to the caller to handle the early
> expiry.
> 
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>

Not familiar with this code, but my head hurts from the:

alarm_
alarm_timer_
alarmtimer_

prefixes, what's what?
