Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6535C303A37;
	Tue,  7 Apr 2026 11:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775562555; cv=none; b=loheEGCmDFUDb1jhJ2sC6EmqfoZ9aD54qWAu6L4lhV2gtScmwspKtf47LDhs0zZ+Oh1PR+/CUAR+PCwlg3C4/1F19bGtVIkbjDY3Gpf9n875hI+G4vqwaNun5IQWkUwpkgCXqwK5UXVGynU0lgje5U6IqAMDoxbxldLV0VdNOFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775562555; c=relaxed/simple;
	bh=MO9im/xFLEozcyFMqpvs9dswnDFDbnWFniJcvlkhh24=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JApeR5ZGTRczuAIRayoCBciR0T65+T5dNjvIK98ymSQ7E8SwEAKakGQiVpn1UAHEOeMstXIx6eAUIoYCXysAvTJFx/U29PavmsbJ8LGD2QSz/E5A6fYQDidj6GmgOMvoM3tB9Ti5nylevana6aSp6DErYFu0d/f0EOflrW1id9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=D5WWuZ/n; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D5WWuZ/n"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=AOiov/rJ08Wqv5Fg1zDIZQIesob5WeDWCeODzqso7UU=; b=D5WWuZ/nlqC5dXoZA7LA0EqEBZ
	OHmSa3QmVSMwpsw4Xzh6SD0HSTXUd5XvG4T7RD3ZuWN/0VRudfvxaoASr7EJfaAQoeZbs660dhgG2
	PMwi2C5BlRpZIk+5totSG8YpwHaCGrFaJ2cUKqZGcNCeVr5MpKaJyL0nZusX7Zn6Om6O/PKYU8oVm
	/ClWQ0naH4ibGkXpwizELgMjsR2UMkrZOAJLc0us4xrVwBAtD+g6VwHeQbzJkILez1nGzow8fh4co
	+a+vj3zrl3z6keKFjEOGlmA0IZMYZnsni2XV3v79SxJ6CIHvb5nHDe7DWHJvN8JSOrK43YACy4ZHI
	tgLHgkig==;
Received: from 2001-1c00-8d85-4b00-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:4b00:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wA4va-00000008AsO-3bg3;
	Tue, 07 Apr 2026 11:49:06 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id D48A63005E5; Tue, 07 Apr 2026 13:49:05 +0200 (CEST)
Date: Tue, 7 Apr 2026 13:49:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Calvin Owens <calvin@wbinvd.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@kernel.org>, John Stultz <jstultz@google.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
	linux-pm@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [patch 01/12] clockevents: Prevent timer interrupt starvation
Message-ID: <20260407114905.GH3738786@noisy.programming.kicks-ass.net>
References: <20260407083219.478203185@kernel.org>
 <20260407083247.562657657@kernel.org>
 <20260407094206.GL2872@noisy.programming.kicks-ass.net>
 <87o6jv57od.ffs@tglx>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o6jv57od.ffs@tglx>

On Tue, Apr 07, 2026 at 01:30:42PM +0200, Thomas Gleixner wrote:
> On Tue, Apr 07 2026 at 11:42, Peter Zijlstra wrote:
> > On Tue, Apr 07, 2026 at 10:54:17AM +0200, Thomas Gleixner wrote:
> >> @@ -324,16 +324,23 @@ int clockevents_program_event(struct clo
> >>  		return dev->set_next_ktime(expires, dev);
> >>  
> >>  	delta = ktime_to_ns(ktime_sub(expires, ktime_get()));
> >>  
> >> +	if (delta > (int64_t)dev->min_delta_ns) {
> >> +		delta = min(delta, (int64_t) dev->max_delta_ns);
> >> +		clc = ((unsigned long long) delta * dev->mult) >> dev->shift;
> >> +		if (!dev->set_next_event((unsigned long) clc, dev))
> >> +			return 0;
> >> +	}
> >>  
> >> +	if (dev->next_event_forced)
> >> +		return 0;
> >>  
> >> +	if (dev->set_next_event(dev->min_delta_ticks, dev)) {
> >> +		if (!force || clockevents_program_min_delta(dev))
> >> +			return -ETIME;
> >> +	}
> >> +	dev->next_event_forced = 1;
> >> +	return 0;
> >>  }
> >
> > Looking at the implementation of clockevents_program_min_delta() doing
> > that dev->set_next_event(dev->min_delta_ticks,) right before it seems a
> > bit daft.
> >
> > But yes, this is effectively also what the old code did.
> 
> yes. I looked at that and didn't come up with a good plan.
> 
> > The only thing that seems to be different, is that the old code would
> > return the ->set_next_event() error code, rather than 0 in the !force
> > case.
> 
> You mean when dev->next_event_forced is set and the set_event() callback
> above failed?

next_event_foced = 0;
force = 0;

Then the old code would return rc (return value of ->set_next_event),
while the new code will return -ETIME.

(not 0 like I said).

I suppose ->set_next_event() will only ever fail with -ETIME?
