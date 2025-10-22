Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ECD032B998;
	Wed, 22 Oct 2025 11:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761131668; cv=none; b=jAsiGhhZ20R8wvxqHIzRFUIzb3cjAhlm6apZvVHpdYujTLfbQQb+SEjR1+TzBzvXW8mt+gzGJiS2hxaonvXw/7zmd1GWLgUt2BZlqZ/F3cbGPAida+0s8BE6KOJ/ei9QpYnYem+K1kbutj3e26v6ljpbFGivJtfoC86sY/jcnx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761131668; c=relaxed/simple;
	bh=GmYKF+tllvcBNVgbxMIirqobghZMH0caVF7Aa0v/NWs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ya0gC3FcM1BOMIHq+//SHf57iQd31bc2hz//05Zv8wjto6yF3KF9lma7IT1aIf1zNghRPocIupkjPg9R7A3b12LG2VtcbFZ/fbGSXjGMqtepYAB8hW0mYry2soaQETA3J8hV2WHI8eYwuPSj3s+A9beqF2M540F0CHXumjxgz2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C269B6046B; Wed, 22 Oct 2025 13:14:23 +0200 (CEST)
Date: Wed, 22 Oct 2025 13:14:23 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Andrii Melnychenko <a.melnychenko@vyos.io>, kadlec@netfilter.org,
	phil@nwl.cc, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] nft_ct: Added nfct_seqadj_ext_add() for NAT'ed
 conntrack.
Message-ID: <aPi8h_Ervgips4X4@strlen.de>
References: <20251021133918.500380-1-a.melnychenko@vyos.io>
 <20251021133918.500380-2-a.melnychenko@vyos.io>
 <aPeZ_4bano8JJigk@strlen.de>
 <aPghQ2-QVkeNgib1@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPghQ2-QVkeNgib1@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > so client will eventually retransmit the connection request.
> > 
> > I can also mangle this locally, let me know.
> 
> BTW, this fixes DNAT case, but SNAT case is still broken because flag
> is set at a later stage, right?

Hmm, why?  nf_nat_setup_info() will add seqadj extension if a helper
is assigned.  I only see two nat cases:

The helper is assigned, no NAT was requested.

Then, in postrouting, a NAT rule gets triggered.
nf_nat_setup_info() will add the seqadj extension for us.

This case doesn't need this patch.  Broken scenario:

NAT rule gets triggered, no helper is assigned yet.
Then, 'helper set foo' rule gets triggered.

This case missed the seqadj extension add.

An alternative would be to reject 'helper set foo' rule add unless the
expression is called from prerouting or output with a priority that is
after conntrack but before nat.

But its more risky change, it would surely break some setups.
