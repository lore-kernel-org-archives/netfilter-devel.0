Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0BB26D4E9
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Jul 2025 10:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751366749; cv=none; b=FnW+k2TThrRKWkOGecmE7MfOuMovnRBoR2wq4jz6yVcvYxdBOewTl6Ys/V0OLEjj6+VqKzQF16G4PAqJ3A9rgmhN6PX8+H/NspvSWTWAGJW6NXxhEbXxHHbGIL8PwY43bGeZ/XKb4olSmQmzX77/p3eLUQrm2IZdrmtyVtlOwlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751366749; c=relaxed/simple;
	bh=MCkWhHExPt0NI1h78HUpR4kZZtwcvrwYl4tf2eWUMks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NCy6gTiukLgtECgZ7lqPNUWrVACY72xmNKkpB6fQB6hxIYYFSHzFuUUeET7A/jBOvTKyuD0YpZNPvF1P/qDwb8XBhrDyyKmgDOxVq8EAChkYEuGARrWBbBG06WJoXd9Oz67UUwWBk5FLzAlD6100vMZM3/qe83bmykhC2ul+2Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6BE50602AC; Tue,  1 Jul 2025 12:45:45 +0200 (CEST)
Date: Tue, 1 Jul 2025 12:45:45 +0200
From: Florian Westphal <fw@strlen.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v5 0/3] netfilter: Exclude LEGACY TABLES on PREEMPT_RT.
Message-ID: <aGO8WbwbstF4Gc0K@strlen.de>
References: <20250630154425.3830665-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250630154425.3830665-1-bigeasy@linutronix.de>

Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> This is v5 of the "exclude legacy tables".
>
> I retested the config fragments individually and as part of
> kselftest-merge to ensure none of the requested option is lost.
> The last patch in the series fixes up non-existing option which was
> noticed during that exercise. The other finding has been sent to net.
>
> Patch #2 has been split out from Florian's patch, hopefully as
> requested.

LGTM, thanks for the re-spin.  I think we should try again to get this
merged.

Series: Reviewed-by: Florian Westphal <fw@strlen.de>
