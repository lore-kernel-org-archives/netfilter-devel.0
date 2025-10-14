Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE63749C;
	Tue, 14 Oct 2025 13:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760450065; cv=none; b=IZ+XN4HOWFarCAfNgYmDaid/qSO0VBLsjIgKMWPALHo56gZ+81QxZz4I8OLnHSe7A0JETdjIKoi51s6kpqQtwP1IeyaoBsOfWVLs79dzs0HefbvBYPQBK9l0eYsHi09qoYRUudpFPXQWL6g5RyTZkBbOEMncFFO5USnvrF7ZYHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760450065; c=relaxed/simple;
	bh=TawJvEMXzd24vJapw7Um3IOxiGFos3PJtw04S/I5obw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QOhYXvSpa3su0+cwrt5VtM0Jtf5g7NFORT4CZ2tpYVDpfoZT89B+WyfDFky8X4PHwTZkA6PhOi/dIZE+GvM0LhgXZ9Yd8YpwNmDQA43lM5gniCD2ml8BFTcrKsdOmRooUuypYChD4Pkj0V1vlmNQD1pR2iLIZlsChhmCPaaZq5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4529160104; Tue, 14 Oct 2025 15:54:21 +0200 (CEST)
Date: Tue, 14 Oct 2025 15:54:21 +0200
From: Florian Westphal <fw@strlen.de>
To: lvxiafei <xiafei_xupt@163.com>
Cc: pablo@netfilter.org, coreteam@netfilter.org, davem@davemloft.net,
	edumazet@google.com, horms@kernel.org, kadlec@netfilter.org,
	kuba@kernel.org, linux-kernel@vger.kernel.org,
	lvxiafei@sensetime.com, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH V6] netfilter: netns nf_conntrack: per-netns
 net.netfilter.nf_conntrack_max sysctl
Message-ID: <aO5WDcNAegXi1Umg@strlen.de>
References: <aC-B1aSmjDvLEisv@calendula>
 <20250523092129.98856-1-xiafei_xupt@163.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250523092129.98856-1-xiafei_xupt@163.com>

lvxiafei <xiafei_xupt@163.com> wrote:
> > > Wether its time to disallow 0 is a different topic and not related to this patch.
> > >
> > > I would argue: "yes", disallow 0 -- users can still set INT_MAX if they
> > >  want and that should provide enough rope to strangle yourself.
> 
> > The question is how to make it without breaking crazy people.
> 
> It seems that we need a new topic to discuss the maximum value that the system can
> tolerate to ensure safety:
> 
> 1. This value is a system limitation, not a user setting
> 2. This value should be calculated based on system resources
> 3. This value takes precedence over 0 and other larger values that the user sets
> 4. This value does not affect the value of the user setting, and 0 in the user
> setting can still indicate that the user setting is unlimited, maintaining
> compatibility with historical usage.

I've applied a variant of this patch to nf-next:testing.

Could you please check that I adapted it correctly?
https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git/commit/?h=testing&id=b7bfa7d96fa5a7f3c2a69ad406ede520e658cb07

(I added a patch right before that rejects conntrack_max=0).

I wonder if we should update the sysctl path to reflect the
effective value, i.e., so that when netns sets

nf_conntrack_max=1000000

... but init_net is capped at 65536, then a listing
shows the sysctl at 65536.

It would be similar to what we do for max_buckets.

I also considered to make such a request fail at set time, but it
would make the sysctl fail/not fail 'randomly' and it also would
not do the right thing when init_net setting is reduced later.
