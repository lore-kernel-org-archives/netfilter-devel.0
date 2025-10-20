Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057182FD7B2;
	Mon, 20 Oct 2025 14:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760970047; cv=none; b=RUowt71V8KwrvrWkkKBQPji/h+OXsGz7ZQht8CUZ7se+GErFHZA5Pa/jk0drg32HWVXVvxCnsBMVY05uK1fvvb2wZkLq0A3sBL7KUnqx8jppz6VVHA05O5MzMs2NwmPb+P+MMHdfntX3GaBwQsyh/23UI7hidYIHi3SZVo7CsUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760970047; c=relaxed/simple;
	bh=Svv7NMXFNpj2k34olEOUeJp95lr/GE8kZLjPFyLzbtc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F7KLuMUu5nZhOvO+ZgqHY1H1/rKMhbTzHzAemJxHJSQUHDMUTmzVg2dbgw16Swdh/w04V2ohFZRKvOvcjLDfr840wTLPOnER724ZGr/wmov+WSXd8IE554LwJ7X4WJQsUUo2GGduSsWsaceTnti9bDxBv8/3Dz2xIttU+OVo7V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 95C3A618FC; Mon, 20 Oct 2025 16:20:36 +0200 (CEST)
Date: Mon, 20 Oct 2025 16:20:36 +0200
From: Florian Westphal <fw@strlen.de>
To: Andrii Melnychenko <a.melnychenko@vyos.io>
Cc: pablo@netfilter.org, kadlec@netfilter.org, phil@nwl.cc,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] nf_conntrack_ftp: Added nfct_seqadj_ext_add() for
 ftp's conntrack.
Message-ID: <aPZFNBNXlyq0Q5dM@strlen.de>
References: <20251016104802.567812-1-a.melnychenko@vyos.io>
 <20251016104802.567812-2-a.melnychenko@vyos.io>
 <aPDU6i1HKhy5v-nh@strlen.de>
 <CANhDHd-k2Ros8nFo4fNi=-Mu1DxkK4A2MgLYjuDqPwpfJYYfdw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANhDHd-k2Ros8nFo4fNi=-Mu1DxkK4A2MgLYjuDqPwpfJYYfdw@mail.gmail.com>

Andrii Melnychenko <a.melnychenko@vyos.io> wrote:
> I've researched the issue a bit. Despite the fact that in `nf_nat_ftp()`
> the helper for the expected connection is installed, it isn't executed in
> the following functions - `nf_nat_mangle_tcp_packet()`. Also, shouldn't the
> logic of `nf_nat_follow_master` affect the "upcoming" passive FTP
> connection?

Yes, but we need the seqadj extension on the control connection to
rewrite the announced address to connect to/from.

nf_nat_setup_info() takes care of this but only for template-based
helper assignment, not for the explicit assign done via
nft_ct_helper_obj_eval().

> I've also checked the setup of `nfct_seqadj_ext_add()` in the
> `ft_ct_helper_obj_eval()` routine - it works. However, now the seqadj would
> be added to all "NATed" conntrack helpers.

Yes.

> Maybe it's better to leave the
> seqadj setup in `nf_conntrack_ftp`, so it would apply explicitly to FTP
> traffic, but with an additional `(ct->status & IPS_NAT_MASK)` check?

As-is, almost all the helpers are broken when used with nat and assignment
via nft objref infra.  We could add some annotation to those that don't
need seqadj, but afaics thats just the netbios helper.

> I can prepare a new patch with changes in either `nft_ct` or
> `nf_conntrack_ftp`.
> Any suggestions?

Thanks, please fix nft_ct infra.  Does the above make sense to you?
