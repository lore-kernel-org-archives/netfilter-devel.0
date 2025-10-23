Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9431D221542;
	Thu, 23 Oct 2025 12:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761223381; cv=none; b=CYZxjyXvBDwADYmMjjq2ZcHDqa1yGokcZKkqzOzhgct2VobWUAe/5yultUle3wUJH5KM23UQFgr0RI1S+6uQbBKPwMu5yTxZa+4mRO3f79kAYD7mZt3AAdaa+3cY6vNffWcSKA48CcE5qfx3P0rVwozbr25Nc24F5vLsYsFQsxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761223381; c=relaxed/simple;
	bh=9wKWCQB32y1rboXdu3EF5crm/Mmnuab37GpskRkgMCk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a1KDgnh5e5Im6PV8Wkc3GkVBOTE9kiUharFQhRICPHBa6wwd8VxzpJOoLApuXg+FXfrFvK1oAhAFL6WgzWd5CaSEARbucbMZbUKj6lItxuVZ2E1CBIxk85AHFuxMsEy+Xyxh+buHNi2rsj5UBPpXEAu0VTFfjEJBWNtHP7E9ysg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6C9C86031F; Thu, 23 Oct 2025 14:42:57 +0200 (CEST)
Date: Thu, 23 Oct 2025 14:42:57 +0200
From: Florian Westphal <fw@strlen.de>
To: Andrii Melnychenko <a.melnychenko@vyos.io>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, kadlec@netfilter.org,
	phil@nwl.cc, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] nft_ct: Added nfct_seqadj_ext_add() for NAT'ed
 conntrack.
Message-ID: <aPoi0Sozs3C9Ohlc@strlen.de>
References: <20251021133918.500380-1-a.melnychenko@vyos.io>
 <20251021133918.500380-2-a.melnychenko@vyos.io>
 <aPeZ_4bano8JJigk@strlen.de>
 <aPghQ2-QVkeNgib1@calendula>
 <aPi8h_Ervgips4X4@strlen.de>
 <CANhDHd_iPWgSuxi-6EVWE2HVbFUKqfuGoo-p_vcZgNst=RSqCA@mail.gmail.com>
 <CANhDHd_xhYxWOzGxmumnUk1f6gSWZYCahg0so+AzOE3i12bL9A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANhDHd_xhYxWOzGxmumnUk1f6gSWZYCahg0so+AzOE3i12bL9A@mail.gmail.com>

Andrii Melnychenko <a.melnychenko@vyos.io> wrote:
> I've taken a look at the `nat_ftp` test from nftables. It actually
> passes fine, I've tried to modify the test, add IPv4 and force
> PASV/PORT mode - everything works.
> Currently, I'm studying the difference between NFT rulesets.
> Primarily, I'm testing on 2 kernels: 6.6.108 and 6.14.0-33.

I think its this:
    chain POST-srcnat {
        type nat hook postrouting priority srcnat; policy accept;
        ip6 daddr ${ip_sr} ip6 nexthdr tcp tcp dport 21 counter snat ip6 to [${ip_rs}]:16500
    }

This sets up snat which calls nf_nat_setup_info which adds the
seqadj extension.
