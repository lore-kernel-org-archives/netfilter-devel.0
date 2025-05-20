Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD61C26F468
	for <netfilter-devel@vger.kernel.org>; Tue, 20 May 2025 10:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747737357; cv=none; b=roBoVsXHI3Tiw9vP41reeEnqCX7ECbSm8Rg6HrTvgI/CcK9+UyhZF8Rcd857eGdrSPj+QHI7entZKNB6lTHKqxV4HYCvAs3Oh/4YxTQxLcg8VkRnvIwFC6TczODCvAaxpKXanhk3U/fjeDoUS0gdvaqu4X4nNsZu6RpB7Sknh4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747737357; c=relaxed/simple;
	bh=NJhPXHy4DGl7r1XpSA5x899/sU3/fqsfHJxZAwrL44c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cpcUcoezRrWTxNHw0kjgtkxFojEd6I8eThKeCbw8wKbYH6yAHhKm2xOh9kJg6IXjzyy39h3AqRnMaqS5V7yktbxL2LdbArWTwlBT4GmLk1Ow9RWAStluMPFRl/u3nvTOfIUXqHihp9aKyI+tT6C5R8Rnjvn0s/bYgPcfvduU7M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6B09B6005E; Tue, 20 May 2025 12:35:51 +0200 (CEST)
Date: Tue, 20 May 2025 12:34:58 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 0/2] Sanitize two error conditions in netlink code
Message-ID: <aCxa0jpNVApPQyLP@strlen.de>
References: <20250516182533.2739-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250516182533.2739-1-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> While reviewing netlink deserialization code I noticed these two
> potential issues. Submitting them separately from other work as they are
> clear fixes (IMO).

Thanks Phil, please push them out.
