Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DCD3C5548
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2026 09:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773221994; cv=none; b=DHFa1CJhSo1KU7cRiN0NTDg9s6dPRCJKJwoy2kwDmY1rPDhwCwBic/r+BN8p7d1w/beE3JMzIjLImZmIGSNpDyyBpFpEOp+N6RJozcks5neoAm1B3mnBJz9zxvvmraHl7NQXO6htrAmCJT9EObxlI0gA8Q0VPxPaxG+10AUnNcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773221994; c=relaxed/simple;
	bh=7VRP4Aa9j+K13V8Wgk7jopyPn5I/NAlP2p7fxQUO3Ko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W5CptYm9K/IZyatncQ9TUA4AiYHZpIMm/fM88H33BKHN7nm/C8vw9t+vP2aqKy4TiKXYLIoC87lwVz4pIV5NSoSpJ5dbiRWLx9LBAhdVPfoFNeb/jwPOVbWHpbhtg0uUtC7POm2zNosNQ7rLXnPrgotuvRRHW5F4Ca/q7um0oBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gFWQb70j; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gFWQb70j"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 9466D602B4;
	Wed, 11 Mar 2026 10:39:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773221991;
	bh=YEAvjeAdKxLkQIxCMM3wPS+0MU5VsLgNMj5NUBwqH0Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gFWQb70jfo1QPOTqxDHaGIvpctGGl4krl3jcrNaWwmwCS6P1RCTkVJc+rHkmgzy3L
	 lhscImZvhBb3c6NBuFhK4flNIGYeMx7D3cZDyQ97rrn/GpdMFoz4j+Vn7ox4j6b7d4
	 dnYCdfQRJpdJeHQsOmndnpRJ8GdOoglFWt2IeHZiY1sx/dqaTsFtcu2sKJBHlzCmq8
	 5rsMqW9+KDtSJeXyLHAhgpWCfs46xqNAzCaYIVhudOfhfwHhXm1vN43mBLsopGO5Tq
	 fyedU8Ucz/JECsP73ufpBaJe1FeUNEOTlMza+Yj+HzN6wiOxDbpjhCVtgVoKQdT7f6
	 mnR0P/odbMGuw==
Date: Wed, 11 Mar 2026 10:39:48 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 4/5] cache: Filter for table when listing sets or maps
Message-ID: <abE4ZHagAWhI-8cV@chamomile>
References: <20260310231115.25638-1-phil@nwl.cc>
 <20260310231115.25638-5-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260310231115.25638-5-phil@nwl.cc>

On Wed, Mar 11, 2026 at 12:11:14AM +0100, Phil Sutter wrote:
> Respect an optionally specified table name to filter listed sets or maps
> to by populating the filter accordingly.
> 

Fixes: a1a6b0a5c3c4 ("cache: finer grain cache population for list commands")

> Signed-off-by: Phil Sutter <phil@nwl.cc>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
