Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DE520B80B;
	Tue, 19 Aug 2025 18:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755628063; cv=none; b=Gof/1MI+3gaaUlRTzG2OApPX1kbBv9Ev2aqM2q9OU1OTlKA0eW4ZyWAtqLStb3lq6xqh3yg6gfGoso4pU0+DYJaBc6jS60VehAQ9+1m+IvLTqcLZNk7heZkHvwd7nwZYNV3eYOD7EqXLm8/bZM7DtvcCQichmuvh+U7Bp/xhheQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755628063; c=relaxed/simple;
	bh=3Fh2wX/RVQYzJdGZtXLIcZseCPOAtwgVM8iDZDfPSIs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qO6rA/1QdRKJTzYKYF/n7qmbuoKwjFBboSEmLyUnuiI0tLDQX1hQJrETQ289MStpFycAty16OZipNmMFABQ8g+/8GIAyxxFLtaapl1JePDx0gDJG6P8yLjP0TNouRFGb3eetCS5DRqBsXkCFLMUgzRczOBGhWCNy0HRDLPL/3FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6E2DC60329; Tue, 19 Aug 2025 20:27:38 +0200 (CEST)
Date: Tue, 19 Aug 2025 20:27:33 +0200
From: Florian Westphal <fw@strlen.de>
To: Qingjie Xing <xqjcool@gmail.com>
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: conntrack: drop expectations before freeing
 templates
Message-ID: <aKTCFTQy1dVo-Ucy@strlen.de>
References: <20250819181718.2130606-1-xqjcool@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819181718.2130606-1-xqjcool@gmail.com>

Qingjie Xing <xqjcool@gmail.com> wrote:
> When deleting an xt_CT rule, its per-rule template conntrack is freed via
> nf_ct_destroy() -> nf_ct_tmpl_free(). If an expectation was created with
> that template as its master, 

Uhm.  How can that happen?  A template isn't a connection, so it should
not be able to create an expectation.
