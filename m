Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415B31A270
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2024 16:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724086015; cv=none; b=qqtPzAVyxGj+eSp/MflS+nYdYnqgKqkgYuSH53c4YdPaTI0VW2lNs+ZR17xOsP1B65VtKDOXZryskfFamn8qk8AkktotxTsSEB65W/pYRJeqWbLDpqa80ZQNE9J4w3ePCZjp/8/rOmB5jJVSNPX3fzHu+f39hCIXkGcUcP9PDyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724086015; c=relaxed/simple;
	bh=fSuRpDb5l3PhBg6utHf4Q3AWr3P5BMNYO9MoMPerEn0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fLnlDbcZKISdr4IaxHyG+uR9FAN/3nLm+ymdsBKrPtrnbCgs79vSE3OWs+/V2khQOfZPYZrH1f+RogVCKXEr/GJJfRYXY8eatsWGRHZKRCMb34FNFqCMeoPpe+Muaoh+5Gz9aFHmCQ1WzUXk6rWNlB633g/KGwqKDAIf2ELVDoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=36988 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sg5Ws-005apj-8c; Mon, 19 Aug 2024 18:46:52 +0200
Date: Mon, 19 Aug 2024 18:46:49 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Antonio Ojea <aojea@google.com>
Subject: Re: [PATCH nf-next] selftests: netfilter: nft_queue.sh: sctp coverage
Message-ID: <ZsN2-WiSTMrGD818@calendula>
References: <20240702111539.32432-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240702111539.32432-1-fw@strlen.de>
X-Spam-Score: -1.8 (-)

On Tue, Jul 02, 2024 at 01:15:36PM +0200, Florian Westphal wrote:
> From: Antonio Ojea <aojea@google.com>
> 
> Test that nfqueue with and without GSO process SCTP packets correctly.
> 
> Joint work with Florian and Pablo.

applied this to nf-next, including:

  netfilter: nfnetlink_queue: unbreak SCTP traffic
