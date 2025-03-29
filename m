Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F27D1EB3D
	for <netfilter-devel@vger.kernel.org>; Sat, 29 Mar 2025 13:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743255091; cv=none; b=jiEDeiENY94n6+7Gw0hJcGDwChgRl2IJrZjWPWf5IqVtz9qJSdZYISCRcnGlh8Nrm+5tfIIMaLByrsR7rQvDF8KZNRbrlgDi2fXOIXeqcb9t3jrSTDcR3jsjKrr3qWI0b3AfbFk6niPQ/MX7+jSDNc2ESKxAV3gvHGE/pmhya1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743255091; c=relaxed/simple;
	bh=2amVWsCFI4gvav3X0068zDb6QS4yh0iTO+BIJ7wY6jQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LKX/+ky7NEqPVVJYuYj9lUEbziPHT8obL2maLAaL2ZVVNOFIyZCaWNrrg6dTYcRs5zLBl/9yQ/yZEQtaR2lV+9vncneO8t9kFfQspwB3hL7RrpJmegdnI0+QpnL12/VeLSpdW9jqDdlKat6LhrvbXQVIEgZa7e5a7BnqyIvwW1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tyWHR-0005Wy-IS; Sat, 29 Mar 2025 14:31:21 +0100
Date: Sat, 29 Mar 2025 14:31:21 +0100
From: Florian Westphal <fw@strlen.de>
To: Corubba Smith <corubba@gmx.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH ulogd2 1/2] ulog: remove input plugin
Message-ID: <20250329133121.GA19898@breakpoint.cc>
References: <23db0352-9525-427b-a936-c8ef87e4d5b7@gmx.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23db0352-9525-427b-a936-c8ef87e4d5b7@gmx.de>
User-Agent: Mutt/1.10.1 (2018-07-13)

Corubba Smith <corubba@gmx.de> wrote:
> The ULOG target was removed from the linux kernel with 7200135bc1e6
> ("netfilter: kill ulog targets") aka v3.17, so remove the input plugin
> for it. It's successor NFLOG should be used instead, which has its own
> input plugin.

Your email client is reformattig parts of the diff:
% git am ~/Downloads/ulogd2-1-2-ulog-remove-input-plugin.patch
Applying: ulog: remove input plugin
error: patch failed: doc/ulogd.sgml:132
error: doc/ulogd.sgml: patch does not apply
Patch failed at 0001 ulog: remove input plugin
hint: Use 'git am --show-current-patch=diff' to see the failed patch

https://patchwork.ozlabs.org/project/netfilter-devel/patch/23db0352-9525-427b-a936-c8ef87e4d5b7@gmx.de/

Can you send the pach to yourself and make sure "git am" can apply it
again?

Thanks.
