Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B33F21019C
	for <netfilter-devel@vger.kernel.org>; Tue, 20 May 2025 10:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747735392; cv=none; b=Shej6zuaMbJxuz+gyNBKg1W1FsZ2pdDHiTvSadyUrcVE1MQxkNnmX/13aWMT9ZoGIJ1Jx8ukQVpUNJg08hXH/sjwP4Z4t157sKtRNrIoR9sJWvzakrPjNSllaixSq5ausNgNV2uZS6Yl7IFVKr+CeBm/8iYVv5DZTqtOP9Q+Ihs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747735392; c=relaxed/simple;
	bh=fkonSYzmnLJxc50tcDdHf7lVzqeU4fJk1Y7JGCXCEdc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mYe3jqEY0/sOsiPVUOnURALBA5NqtNKOlXZ5P2/0t88Cvq1aVdSjatSD8P4uaRDPkdWCOW0P+f87kQM7v/mHwz41nJrCaTY596tUAStPqOOA0rDt3cKWAlUiV88TrtLJ0zT8KSrvEdbCH8Id8rqa9pBAtCK5isHwJjTBlPWW6TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E47516014F; Tue, 20 May 2025 12:03:06 +0200 (CEST)
Date: Tue, 20 May 2025 12:02:13 +0200
From: Florian Westphal <fw@strlen.de>
To: Shaun Brady <brady.1345@gmail.com>
Cc: netfilter-devel@vger.kernel.org, ppwaskie@kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH v5 1/2] netfilter: nf_tables: Implement jump limit for
 nft_table_validate
Message-ID: <aCxTJcL2DnSsquNe@strlen.de>
References: <20250520030842.3072235-1-brady.1345@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250520030842.3072235-1-brady.1345@gmail.com>

Shaun Brady <brady.1345@gmail.com> wrote:
> Observing https://bugzilla.netfilter.org/show_bug.cgi?id=1665, I was
> able to reproduce the bug using linux-stable.  Summarized, when adding
> large/repeated jump chains, while still staying under the
> NFT_JUMP_STACK_SIZE (currently 16), the kernel soons locks up.

LGTM, thanks.
Acked-by: Florian Westphal <fw@strlen.de>
