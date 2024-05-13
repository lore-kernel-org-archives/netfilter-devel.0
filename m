Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C17D824A3
	for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2024 21:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715635123; cv=none; b=LHP7B7rJ5B+WgWsWPChOu1l2B33gPpmWUdHauxVWFzCgRTNEAAC7xEdJoQ2+dxsW8qnRHZEcJT4ugr5r5Ybqv1T+IjRx5Rp0qN0coEhyZVlvSYUL+HTyEBxR7UgRagdR2aP11GL+MsZDhGiJSBAo8m596qZO2Dr1MkdrutBIEcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715635123; c=relaxed/simple;
	bh=yFGC74gWy76rxJkauas3pUtwJ6yxCLAN07tHyvAeVS8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ih1kbGvUkm3xpizyLZfZcglR9ljZHBdeiEtLWZuEx/wQugOFa20bS1UaOwmh31rFJmmT3aQxelSPLRQ7IaR5anBbxH8mAoBD/WOebuFn10WOgAnwPF1DHXiaIkAOXV8K2owpuFRldCig/ZAn9XhAo3qW8HY4sKQCTqBiEe+tUa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1s6d4B-0004gv-QE; Mon, 13 May 2024 23:18:39 +0200
Date: Mon, 13 May 2024 23:18:39 +0200
From: Florian Westphal <fw@strlen.de>
To: Antonio Ojea <aojea@google.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de
Subject: Re: [PATCH v2 2/2] selftests: net: netfilter: nft_queue.sh: sctp
 checksum
Message-ID: <20240513211839.GB17004@breakpoint.cc>
References: <20240513000953.1458015-1-aojea@google.com>
 <20240513000953.1458015-3-aojea@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240513000953.1458015-3-aojea@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Antonio Ojea <aojea@google.com> wrote:
> +        # ss does not show the sctp socket?

Hmn, it should, maybe INET_SCTP_DIAG=m is missing in kernel?

> +        busywait "$BUSYWAIT_TIMEOUT" sh -c "ps axf | grep -q SCTP-LISTEN" "$ns2"

... but if that works ok then no need to change.
Thanks for adding a test case.
