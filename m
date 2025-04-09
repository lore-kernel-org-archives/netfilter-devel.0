Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA7425D214;
	Wed,  9 Apr 2025 09:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744191744; cv=none; b=IkFyPEa6GxoXqS/Agu8+IlagK9mFyy98DoceYa2u2rxfMjhR4whHFTTqWvmibx6iVzNxGoL05QNadV6ESKB0RJzQTnPuCKqEhRaX5jtRrVmLYWUR4elKnENcAJDs0B39OHgnFGZHjEFTzOpDKy+jwTfUxUgi0nQbxeS4OlSslHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744191744; c=relaxed/simple;
	bh=43REFmZRu18CN3j2GspN90f2p0rdAUcbTvNtIutpiKw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N9qtkjTq6iFea9rAAUO0ATB9ftLjp5B9oQ/Q/+CJ8LGCmECPVIWzZ8CerQrYUiHhYkM8J9HUN+oXru1y/hZ/hannRbCPy4Npk9w/7j523vMlmWRrhqO+/LqxY2idY+sgR6KqwNfR7ghV4pzhlp1toxkjNe/P7UF3m61OX+kMRH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1u2Rwc-000527-Qs; Wed, 09 Apr 2025 11:42:06 +0200
Date: Wed, 9 Apr 2025 11:42:06 +0200
From: Florian Westphal <fw@strlen.de>
To: lvxiafei <xiafei_xupt@163.com>
Cc: fw@strlen.de, coreteam@netfilter.org, davem@davemloft.net,
	edumazet@google.com, horms@kernel.org, kadlec@netfilter.org,
	kuba@kernel.org, linux-kernel@vger.kernel.org,
	lvxiafei@sensetime.com, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, pabeni@redhat.com,
	pablo@netfilter.org
Subject: Re: [PATCH V3] netfilter: netns nf_conntrack: per-netns
 net.netfilter.nf_conntrack_max sysctl
Message-ID: <20250409094206.GB17911@breakpoint.cc>
References: <20250409072028.GA14003@breakpoint.cc>
 <20250409091319.17856-1-xiafei_xupt@163.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409091319.17856-1-xiafei_xupt@163.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

lvxiafei <xiafei_xupt@163.com> wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > Whats the function of nf_conntrack_max?
> > After this change its always 0?
> 
> nf_conntrack_max is a global (ancestor) limit, by default
> nf_conntrack_max = max_factor * nf_conntrack_htable_size.

Argh.

net.netfilter.nf_conntrack_max
is replaced by init_net.nf_conntrack_max in your patch.

But not net.nf_conntrack_max, so they are now different and not
related at all anymore except that the latter overrides the former
even in init_net.

I'm not sure this is sane.  And it needs an update to
Documentation/networking/nf_conntrack-sysctl.rst

in any case.

Also:

-       if (nf_conntrack_max && unlikely(ct_count > nf_conntrack_max)) {
+       if (net->ct.sysctl_max && unlikely(ct_count > min(nf_conntrack_max, net->ct.sysctl_max))) {


... can't be right, this allows a 0 setting in the netns.
So, setting 0 in non-init-net must be disallowed.

I suggest to remove nf_conntrack_max as a global variable,
make net.nf_conntrack_max use init_net.nf_conntrack_max too internally,
so in the init_net both sysctls remain the same.

Then, change __nf_conntrack_alloc() to do:

unsigned int nf_conntrack_max = min(net->ct.sysctl_max, &init_net.ct.sysctl_max);

and leave the if-condition as is, i.e.:

if (nf_conntrack_max && unlikely(ct_count > nf_conntrack_max)) { ...

It means:
each netns can pick an arbitrary value (but not 0, this ability needs to
be removed).

When a new conntrack is allocated, then:

If the limit in the init_net is lower than the netns, then
that limit applies, so it provides upper cap.

If the limit in the init_net is higher, the lower pernet limit
is applied.

If the init_net has 0 setting, no limit is applied.

This also needs an update to Documentation/networking/nf_conntrack-sysctl.rst
to explain the restrictions.

Or, alternative, try the other suggestion I made
(memcg charge at sysctl change time,
 https://lore.kernel.org/netfilter-devel/20250408095854.GB536@breakpoint.cc/).

Or come up with a better proposal.
