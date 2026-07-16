Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350123BCD05
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Jul 2026 14:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210761; cv=none; b=nazrjuUMJ71HMdDLEzoJU3KyQSwu7hXMjuWB+ImgBxLzPGsOFheDaVNBof9VFjBt24+0xi5h36XaAvg1Z+44YhiMqSd6N764cnBF1/T3lsU4sOcUcCwKFToZCgFi5s7Xi7rAqErJgOKLftj6AswadpQ/hucKxNx5goXW3mpG7gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210761; c=relaxed/simple;
	bh=Zoz6xfVtBRKhqLFbsXH3989xR0qdUBwcxewfobrAIz8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GeKLkxbX8ysQcTW2YwOWdP9UFzAiTZODOJJOGuHZjLsPhg1Kb/7mRqWElM8P8C8ETndC8pdC6DYFhc0kJ+si4SiNUw04ctAHsk6yBFMhyozsiL9P7Z81RkFsJOpaf8kArkoMHT4IIXaBh2ZTjIpouAmPa23EtZaZ7dc0ca0g/HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4A11960613; Thu, 16 Jul 2026 16:05:53 +0200 (CEST)
Date: Thu, 16 Jul 2026 16:05:52 +0200
From: Florian Westphal <fw@strlen.de>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org
Subject: Re: [PATCH RFC nf-next 09/12] netfilter: ipset: use plain
 rcu_read_lock
Message-ID: <aljlQPvg7yT1zQeW@strlen.de>
References: <20260714131828.10685-1-fw@strlen.de>
 <20260714131828.10685-10-fw@strlen.de>
 <a4c297c0-811d-a02c-2bdc-06b4bedfaf4a@blackhole.kfki.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4c297c0-811d-a02c-2bdc-06b4bedfaf4a@blackhole.kfki.hu>

Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> > No need to disable/reenable softirqs.
> 
> Couldn't then similarly simple spinlocking be used instead the _bh()
> variant? I assume then that there's no need to disable/reenable softirqs in
> those cases either.

I don't think so, the spinlocks are reachable from softirq / timers, so
if you do spin_lock(s) [timer] -> reentry it will deadlock.

rcu_read_lock() can nest, so doesn't have that problem.
