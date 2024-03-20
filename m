Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9AA664A3
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2024 17:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710954195; cv=none; b=lYVBy1j1Q7tBhgDRcQDYh9UjX76FdCYBvQCi8lK3Z1bCdKJuXGB991REOBrgEs3VWvExkgmJTexrMktpo+8Wem2fuhBMYqUFqLnE1o5s0xWAdB5KSjdTK6Qmb3zFHuhbCeGzug9sP2OVQ3GQ5hlDwzUNMojhQOANjZn8TusSpoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710954195; c=relaxed/simple;
	bh=vUD9RL4WISC25619fPckHcVEeyAYuHUMW3d5ExGlhp0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QGRdSuOD8DImn+7my2EfqvvRHkzPBrdYqvE5g6CNreaNgMZF+/n36HZToKomGVe/mvg8BQ06eClGlzyqhkFfpfqJIxis+bYel+6q5bxpZ0ksLhnVH1+IIPD6zK7SFSnrBzsck+8FR+tWsMwiQK49NfDTRrL+KgX6f/eYhz4I6gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=m/OZbBC1; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="m/OZbBC1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=FEvLzUKxRMj2zHKZqZW7qQuSGK/kaxbuja8CkgIKf4M=; b=m/OZbBC10fWb9xKpzwMwmO58hk
	kH/wIam9F1DCXtYN4uglJj//HVzwfwuzqFuARgU9Ci0jDLrVXw9QDJMKQPpRE5ujLg00mHPMjC9k5
	jBUjxEuljAGkIAW/Iaf6BZu84RxU0BHGMuPvXug4eGN2KgA3a7aMZKDYNxhW+WuPYMrlhzTU7CPyQ
	JJNj6AZRrl9H89p7uzRgU10tn9E3kQ1CMeP96wzGSMiaDMNVjKaeUR/UtlYrSAbHSfQMHGZ5BXdTM
	sL+UDOCzMaJYqUjm5VkGNrpNdjpShHHOtCQ3VLhWmx9YXhZobkNTYyP8x5V54vAYtt1isShlXDBLy
	GNPriHiQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rmzLE-000000004wP-429E;
	Wed, 20 Mar 2024 18:03:05 +0100
Date: Wed, 20 Mar 2024 18:03:04 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] doc: libnftables-json: Drop invalid ops from match
 expression
Message-ID: <ZfsWyCMeeKX6r6VU@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20240320161255.24129-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240320161255.24129-1-phil@nwl.cc>

On Wed, Mar 20, 2024 at 05:12:55PM +0100, Phil Sutter wrote:
> These make no sense there and are listed again in BINARY OPERATION.
> 
> Fixes: 872f373dc50f7 ("doc: Add JSON schema documentation")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
