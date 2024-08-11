Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01836AB8
	for <netfilter-devel@vger.kernel.org>; Sun, 11 Aug 2024 08:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723365750; cv=none; b=ayEahOEa/INJowx6GyaSgdUo/XvZwJsJEffhD2Eg/qj6iAVBVkUkLCZ2c0W8a6oI1sbHi3WdKC/rD5/GiQ+tViuEC+uxUJtq2HiCybg768WFgtiyl4PSfyl4OdjZJtpVIP8STgv7WDIgZ5oaBfwTHcQ2IQ56VVz9+dGiexMNWMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723365750; c=relaxed/simple;
	bh=aqGzi0Zqf1738q8JENxmTu94Hj93j2pGUNafn42QJ7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uDOf+dslgc0IEXorG/pQlJTv0UAWvb7xIr4ZwLu3jDUZ+Z9F4JYHrqTOYzzueoDlqLSnvo5kiqsqpYzSJZQ7wDvu3r+zy27YQMTCfzE79XghCGcxmq0MsvvB+MmVrHQIPTGRMmcgMdy3OM7g/eZkkGiHa2VXv/1fpNYcXIfdXUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sd49a-0002tt-7c; Sun, 11 Aug 2024 10:42:18 +0200
Date: Sun, 11 Aug 2024 10:42:18 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH v4 0/3] Add locking for NFT_MSG_GETOBJ_RESET requests
Message-ID: <20240811084218.GA10741@breakpoint.cc>
References: <20240809130732.13128-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240809130732.13128-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> Analogous to getrule reset locking, prevent concurrent resetting of
> named objects' state.

Reviewed-by: Florian Westphal <fw@strlen.de>
