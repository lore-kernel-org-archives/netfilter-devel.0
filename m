Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073B024E4A1;
	Fri, 24 Oct 2025 16:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761323234; cv=none; b=qjxNId9TG8nUlYwzbbrhHw6hbcg3Xt90ZIG7WwZ3UmRRFEqGge7PGbfTYMPKuTWw1waBrcHY1zBm7bTjWGUtra5UCtyPTbPJTV4JZ4ZiA9g1rXfxZDdKw/MghnlJxpAAr2fq1OPDnX4wEij8nC1IZ2YFU7ujeg0ecgNAZ0tXunM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761323234; c=relaxed/simple;
	bh=FpRiRtMz4XD17hDc+TObHJ2svjHLAl5Cb2aeoQ5n4SM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IdxhZF54ELfk/tlKA38tp3HoQRjS3fWekPf6RLDlUEOrn/jjLZSnf7QbYv2B1qy9CwyAZkYj7tIvHKepKIPe+rRRMVNjgiju2i1OShe34v4Ph2eNTal75DxV1QacK38szTasAn3D+PYSV/iuZ6244Y6aBHj5wRfynKHmMCXyJlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 84CE76017F; Fri, 24 Oct 2025 18:27:09 +0200 (CEST)
Date: Fri, 24 Oct 2025 18:27:07 +0200
From: Florian Westphal <fw@strlen.de>
To: Andrii Melnychenko <a.melnychenko@vyos.io>
Cc: pablo@netfilter.org, kadlec@netfilter.org, phil@nwl.cc,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/1] nft_ct: Added nfct_seqadj_ext_add() for DNAT'ed
 conntrack.
Message-ID: <aPuo22KKi2CtD57q@strlen.de>
References: <20251024162216.963891-1-a.melnychenko@vyos.io>
 <20251024162216.963891-2-a.melnychenko@vyos.io>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251024162216.963891-2-a.melnychenko@vyos.io>

Andrii Melnychenko <a.melnychenko@vyos.io> wrote:
> There is an issue with the missed seqadj extension for NAT'ed
> conntrack setup with nft. Sequence adjustment may be required
> for FTP traffic with PASV/EPSV modes.

Patch looks good, thanks.

> Oct 16 10:24:44 vyos kernel: Missing nfct_seqadj_ext_add() setup call
> Oct 16 10:24:44 vyos kernel: WARNING: CPU: 1 PID: 0 at
> net/netfilter/nf_conntrack_seqadj.c:41 nf_ct_seqadj_set+0xbf/0xe0
> [nf_conntrack]

This is useful.

> configfs(E) virtio_rng(E) rng_core(E) ip_tables(E) x_tables(E)
> autofs4(E) usb_storage(E) ohci_hcd(E) uhci_hcd(E) ehci_hcd(E) sd_mod(E)

[..]

For the future, please consider trimming this to the essentials.
Loaded modules etc or date are not relevant info that needs to be in
the changelog.

I'll trim this before applying, no need to resend.

Thanks for taking the time to track down the root cause of this bug.
