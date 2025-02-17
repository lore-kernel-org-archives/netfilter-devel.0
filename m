Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7BF21CA07;
	Mon, 17 Feb 2025 14:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739801148; cv=none; b=vBOINE31yPxQ7Z6U4WVQJD8mXGok2y6IvlasJSBUvfTWXh4CAWn7G/ITg+YhKqpLl4oqaSZe+qP8oQl5u52fDovGd/eXTkg2WyXS3L6uYK4p/3FwdNI9eroWbhP4PRIFFVtQgjFNYLu6RenWX/L3hraG6A4HBQeG7Wef/QNohP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739801148; c=relaxed/simple;
	bh=yuCXyHljZTXUYJajXKpugmZD44Hgy0uk2tT8PfkL4UU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ehXCTAqotiiPwqevYziqj9Yr/EKRgeL22Yod6bJUU8eg4SLSbTO6+eXIePatN4JvNET7A5RRHiZtH5ZQ+rNTy5BhP1StkvxcYCYGV0x8kd0+QTxOX+f5vbg8rE47xbLIQPixqfLOV0ZJ7R+D5Mqy0sJGnqEO/q/GgMfcfQq7M1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tk1kg-0004OB-LC; Mon, 17 Feb 2025 15:05:38 +0100
Date: Mon, 17 Feb 2025 15:05:38 +0100
From: Florian Westphal <fw@strlen.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next 1/3] netfilter: Make xt_table::private RCU
 protected.
Message-ID: <20250217140538.GA16351@breakpoint.cc>
References: <20250216125135.3037967-1-bigeasy@linutronix.de>
 <20250216125135.3037967-2-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250216125135.3037967-2-bigeasy@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)

Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> The seqcount xt_recseq is used to synchronize the replacement of
> xt_table::private in xt_replace_table() against all readers such as
> ipt_do_table(). After the pointer is replaced, xt_register_target()
> iterates over all per-CPU xt_recseq to ensure that none of CPUs is
> within the critical section.
> Once this is done, the old pointer can be examined and deallocated
> safely.
> 
> This can also be achieved with RCU: Each reader of the private pointer
> will be with in an RCU read section. The new pointer will be published
> with rcu_assign_pointer() and synchronize_rcu() is used to wait until
> each reader left its critical section.

Note we had this before and it was reverted in
d3d40f237480 ("Revert "netfilter: x_tables: Switch synchronization to RCU"")

I'm not saying its wrong, but I think you need a plan b when the same
complaints wrt table replace slowdown come in.

And unfortunately I can't find a solution for this, unless we keep
either the existing wait-scheme for counters sake or we accept
that some counter update might be lost between copy to userland and
destruction (it would need to use rcu_work or similar, the xt
target/module destroy callbacks can sleep).
