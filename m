Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C413358B2;
	Fri,  6 Feb 2026 12:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770381709; cv=none; b=trAO77ZP2t+Rc4HVV0fNZ4L8SNu3O36z2pivFF7PM6Y1/5MZqKgbYfjizWLf9BOZNHiQqBQR79SKQO2bdg1fOE48o9RhsZ3loxgwHen8pogbjAyNR/OLF93Qd/Yff9IHNXMlMU/9h7pHIsaTp9z+pBT1Isz1Q7j63v8/9hWIFvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770381709; c=relaxed/simple;
	bh=vm0zmta+lr6P2nSsIjmRo/LiwG07P0Vd1FMb+z9jRdI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OmD1vlLgKt+72251miw2FyuFaBd2iBDu+vbVXtZqebf9Aaljgy9uWUdaDE0p80nmagN/IDSX+DcVeDc91v8IC4ipy3ScUKvBRnOdvpGbcBa4SvmmWkYixDOg5ba3Q5jyHWBrtp9qG4p+quu3ah3u1134X3Mv2rtTxr+8vZ+nMlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 096EC60345; Fri, 06 Feb 2026 13:41:45 +0100 (CET)
Date: Fri, 6 Feb 2026 13:41:45 +0100
From: Florian Westphal <fw@strlen.de>
To: netdev@vger.kernel.org
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH net-next 00/11] netfilter: updates for net-next
Message-ID: <aYXhiW44LcS7F3Nb@strlen.de>
References: <20260205110905.26629-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205110905.26629-1-fw@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> The following patchset contains Netfilter updates for *net-next*:
> 7-10) update nf_tables rbtree set type to detect partial
>    operlaps.  This will eventually speed up nftables userspace: at this
>    time userspace does a netlink dump of the set content which slows down
>    incremental updates on interval sets.  From Pablo Neira Ayuso.

Pablo has submitted v3 addressing AI detected issues, I will send a v2
in ~3 hrs, no changes except in those 4 patches.
