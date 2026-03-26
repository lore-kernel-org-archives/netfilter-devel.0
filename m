Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85ADA24E4D4;
	Thu, 26 Mar 2026 21:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774560654; cv=none; b=ssDoJHivYEdyprDBsBUk7ss2qJHdqEGyJccruI3W7Ar0EORb0nhpzqsdjqgyeIq1I2XPtNMgTnGz/8RPi/RVY1GWMAovoUV0PMrIwwTpLvmqE3uCXGYsfhTHA3xARos6QGeCTLcp3wdKQMMR1y6drSRCFrIWk+mGqM8UOQGwSMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774560654; c=relaxed/simple;
	bh=ogxlmDn6490Ce9rAmnGmMhTUEeDvoOenfONTCkjxYHE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s+DBSgE1zgoCHVF6jPv45TSRB/ekn3pRXVY0qMz1UmUzRj0DSe/XGjYij/JimBuSNqYtAzuu2CzMHQsmMULGEMcBUWRswY8advGRtkaps9lIg64mHKfqvn51uV/M0toUQNoPv/CrOIbcvft/7Dg9KDGXz15AtKqhICkm+1rB+dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=nG4Ao0dK; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="nG4Ao0dK"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id DBB1A600B5;
	Thu, 26 Mar 2026 22:30:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774560650;
	bh=5GF0efwMxYfSyWX+mBkvAr63+42z+pl/Mp8LI0uB6Tc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nG4Ao0dK3sQSOeHaehHRn0lBZiug2p6M0iinneRG9k9VWRlvvZTynmkRj9dYOHlFy
	 w0RctZXM+y/myjz2FX3k9LwV8RG0/HCssJcVP6A3hX5T4FM6WOirH6Vqr+iwocr9nu
	 /xY52Wn38+tn5fH3mjMIsPCqUBVdI84N/btkKitfPrn8eT0asJbH9G7RzzMY1UdKqa
	 GRe77+CpOlFkpPg3uFOZETEVgW3WdzrGRy6OLElSPXp5n2sjv6wbypZ9r21UlMYgWK
	 /bHiCUeFfnMsk773HHzZcVSKAjTi3m9BztMiCAikpretlkAPMv62q3Xj3oRZDfQqdY
	 xATgoxdlYelew==
Date: Thu, 26 Mar 2026 22:30:47 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: fw@strlen.de, phil@nwl.cc, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH net] netfilter: ctnetlink: fix use-after-free of
 exp->master in single expectation GET
Message-ID: <acWlhw9SprIgzs7C@chamomile>
References: <aaxehlr7zbTj7dbe@v4bel>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aaxehlr7zbTj7dbe@v4bel>

On Sun, Mar 08, 2026 at 02:21:10AM +0900, Hyunwoo Kim wrote:
> ctnetlink_get_expect() in the non-dump path calls
> nf_ct_expect_find_get() which only takes a reference on the expectation
> itself, not on exp->master.  It then calls ctnetlink_exp_fill_info()
> which dereferences exp->master extensively (tuplehash, ct->ext via
> nfct_help()).
> 
> A concurrent conntrack deletion through NFNL_SUBSYS_CTNETLINK (a
> different nfnetlink subsystem mutex than NFNL_SUBSYS_CTNETLINK_EXP) can
> free the master conntrack while the single GET is in progress, leading
> to use-after-free.  In particular, kfree(ct->ext) is immediate and not
> RCU-deferred.
> 
> Fix this by taking a reference on exp->master under rcu_read_lock
> (required for SLAB_TYPESAFE_BY_RCU) before calling
> ctnetlink_exp_fill_info() and releasing it afterwards.

For the record, this was fixed by expanding the nf_conntrack_lock
section in ctnetlink_get_expect(). The observation is that
nf_ct_remove_expectations() holds the nf_conntrack_expect_lock while
called from the ct object release path, so the ct->ext area does not
go away until the nf_conntrack_expect_lock is released.

I'm archiving this patch.
