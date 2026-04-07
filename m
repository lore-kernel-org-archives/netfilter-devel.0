Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C74399359;
	Tue,  7 Apr 2026 10:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775556675; cv=none; b=gNToMYm278pIt+SSYIT0UOXkJYpENVaoyDk5ZRTpGM4dqEX4YiCuWBI2PxydAFRe3xtnytzXepcotdpoTR+J/iKiXnzqw4e/simjU6UlitO/qLgUYn2zkBbdvoc5ifvGmuA52hwYoachnLtPzSBVktrQGov5rCMrk16D+HYDivU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775556675; c=relaxed/simple;
	bh=RlHA1u6L96rCq5B9W/+GG8liPNcCVG0u0WecO4RiASk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AVpM1VcL7dw7UF1aRzMs5qYc/5RgMyr8/y+Nw5FxPac30NNzzWEzYsyBwJMQ3j/ehZpSEPdsJXBA/WSSQZvpbZSxeyj47VahHZw0y5Jh1WGrDcq8ypPwjkf8PoXvgDDQ7K3GMpLTkhwoGqPo1XCnK9gE8yuBzTKLVMCpId7y7AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Jzpb7Pi7; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Jzpb7Pi7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UZcY/c6EyAS1T+MDSRhuofvcR2H+BfmmroqwgZM6Iqo=; b=Jzpb7Pi7DjwuDGpKl4FnFQ/412
	Xj7qk6zkPZicR4EYGErSoyHFVPS92YPwrfgCVtenRomG7BMXHxl5PiwDQ6GWDeSgfCel3Z6Cq/kTE
	rxZMajfgv0e299Z0ylWD6JtoYrMZ1LHSfOsaQ1CVFw4YAlbwkCZYHRzIRWMkCQj7jWRlEAyTYBYgP
	Kq26aNYDPpq4qn2tYwFjtr0x3swd12lEKeeOWHOSfbIoRlTFZsx1QBLRTPg/0O6PjmCpOgUoNswZ/
	xhLDNfENLBakh/112FA5OhVR4rj0zWDW6UbMVZlkCPtEHJOw8XJb5+VgENzYPLtPF/KIPJpwhFpha
	L2U63rTQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wA3Op-00000003Phy-0q2h;
	Tue, 07 Apr 2026 10:11:11 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id BCDE33005E5; Tue, 07 Apr 2026 12:11:10 +0200 (CEST)
Date: Tue, 7 Apr 2026 12:11:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Sebastian Reichel <sre@kernel.org>,
	linux-pm@vger.kernel.org, Calvin Owens <calvin@wbinvd.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@kernel.org>, John Stultz <jstultz@google.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [patch 10/12] power: supply: charger-manager: Switch to
 alarmtimer_start()
Message-ID: <20260407101110.GU2872@noisy.programming.kicks-ass.net>
References: <20260407083219.478203185@kernel.org>
 <20260407083248.169005310@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260407083248.169005310@kernel.org>

On Tue, Apr 07, 2026 at 10:55:03AM +0200, Thomas Gleixner wrote:

> +		exp = ktime_set(wakeup_ms / MSEC_PER_SEC,
>  				(wakeup_ms % MSEC_PER_SEC) * NSEC_PER_MSEC);

Surely we can write this less insane?

  exp = wakeup_ms * NSEC_PER_MSEC;

comes to mind? And yes, we then seem to loose that KTIME_SEC_MAX check,
but urgh.
