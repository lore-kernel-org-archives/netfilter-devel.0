Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1C63C872F;
	Fri, 10 Apr 2026 13:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775828789; cv=none; b=ZLTh7yiCqg+TF0tE6oxgtMOsqsErBLtSzN2LddjpF4mb3RQriJrFUH8+iFAcP47dkp+idL9nJrnG4axoZF9+zvSDdylRzVgGPGP/OWISWiKoIBiFqDmtS+IhSvrwmIu7+3Lw9Hq6ps6rbMc0Vf+MOij5VoyH55B/BEJQxDh7zkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775828789; c=relaxed/simple;
	bh=TNdv8AasTn4bhwj7Byh6kLmsxwsGmvbw3eyvcqZxFfw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JLkGqeh5VpKEcJHb9VdfcFt1QhbIasHzcrULaES6G2sjTcwyFfBiA9QF3nIJMaOqgnEIBlSzWLu6K6IsxFBCs4nr5U09M+6euH4Cc/VkiD2iXhZcld1bdSVH3CO1sSlvmHGxhuai2qK0IUB2FZ01GJmMiW5iEz93v+ftqJaE+p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P4gDBByv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P4gDBByv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D792C19421;
	Fri, 10 Apr 2026 13:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775828788;
	bh=TNdv8AasTn4bhwj7Byh6kLmsxwsGmvbw3eyvcqZxFfw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P4gDBByv540dPLfhp5DRYLyG/mcq5Gonx7GOWH7mQEH3Kl7IUs9Kx7MVQUt06uADN
	 73WZ2Zfj6Rqy3kxqRIpbAD8BBcYj8egmZf/c5np1v3iPZlUaiwNxrj0DBsZNxPB153
	 WZfcHaeHFl2kIsH11RKrhzIjjehlkr6BsJCu0DDDUt0yPjEi7TLNcqPDNjg3A76QE2
	 gvV2+vXCREzkIPT9oK8KLg3kihCZqXSFkV48cAoDPJdbb7gOEi7dFVBO8AQrdHzUly
	 LNpTdd5GuvJ1ROtYRSvXSixNOKAFf9GOIjXxT6gZ8QAfDEuqCp/dc06xOfV9kcH3G5
	 mjMxkSKz+ng4g==
Date: Fri, 10 Apr 2026 15:46:25 +0200
From: Frederic Weisbecker <frederic@kernel.org>
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	linux-fsdevel@vger.kernel.org, Calvin Owens <calvin@wbinvd.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>,
	Sebastian Reichel <sre@kernel.org>, linux-pm@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [patch V2 08/11] fs/timerfd: Use the new alarm/hrtimer functions
Message-ID: <adj_MY0JBmJupojP@localhost.localdomain>
References: <20260408102356.783133335@kernel.org>
 <20260408114952.469141112@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260408114952.469141112@kernel.org>

Le Wed, Apr 08, 2026 at 01:54:20PM +0200, Thomas Gleixner a écrit :
> Like any other user controlled interface, timerfd based timers can be
> programmed with expiry times in the past or vary small intervals.
> 
> Both hrtimer and alarmtimer provide new interfaces which return the queued
> state of the timer. If the timer was already expired, then let the callsite
> handle the timerfd context update so that the full round trip through the
> hrtimer interrupt is avoided.
> 
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>
> Cc: Frederic Weisbecker <frederic@kernel.org>
> Cc: linux-fsdevel@vger.kernel.org

Reviewed-by: Frederic Weisbecker <frederic@kernel.org>

-- 
Frederic Weisbecker
SUSE Labs
