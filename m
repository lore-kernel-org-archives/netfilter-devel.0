Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C48E4028F1
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Jun 2026 23:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780530040; cv=none; b=htSQ7EhMTKgFeN7ZgboGV5fSL2rQbU7gtUQH+os1ru8MF5T0M3XjT9hpTlT7ZjNpo0sHiNOSk7Er8KHCQ7E937JNQm8rOipH9aLENYw7L9M9ZQHVguL4CGmOEYzoTrolYRIH+5LZIxkkL6RUF9S3MuLnA1RkVTPOn+zdHVtBbZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780530040; c=relaxed/simple;
	bh=4eBleRyW+hhyZxxeRba9/TKg/4oYMDO4S6Ebe3GJyck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UFvwysZM1348w3wFKIJgDZIas5z7pzIe/PupyCPz4Wr+MXMeN1iV2d+DGoaMi2oyIMulBAXq4UW772oBVZrRKH5A4r1FybkljCWav5F+T4rPkYZ2PJwLCUHHh75l3zbzcpCbx8aW7TaxdGLEBZW48eLPJ8Ud3Zf10fQ3Dj6KU6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 591336078A; Thu, 04 Jun 2026 01:40:37 +0200 (CEST)
Date: Thu, 4 Jun 2026 01:40:36 +0200
From: Florian Westphal <fw@strlen.de>
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: netfilter-devel@vger.kernel.org, bridge@lists.linux.dev,
	pablo@netfilter.org, phil@nwl.cc, razor@blackwall.org,
	idosch@nvidia.com, stephen@networkplumber.org,
	sw@simonwunderlich.de, davem@davemloft.net, yuantan098@gmail.com,
	yifanwucs@gmail.com, tomapufckgml@gmail.com, bird@lzu.edu.cn,
	royenheart@gmail.com
Subject: Re: [PATCH nf v2 1/1] bridge: br_netfilter: move fake rtable off
 struct net_bridge
Message-ID: <aiC7dFYZpiEHZeyG@strlen.de>
References: <831936f111e6e1f435f4f6247d07fe6a6624d271.1779680014.git.royenheart@gmail.com>
 <ahagS3rGl2sG0OVS@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahagS3rGl2sG0OVS@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> Ren Wei <n05ec@lzu.edu.cn> wrote:
> > Use rt_dst_alloc() so the fake dst reuses the core IPv4 rtable
> > lifecycle, and release the bridge device reference during teardown via
> > dst_dev_put() before dropping the bridge-owned dst reference.
> 
> I think AI review is mostly correct:
> https://sashiko.dev/#/patchset/831936f111e6e1f435f4f6247d07fe6a6624d271.1779680014.git.royenheart%40gmail.com
> 
> - no need for constant refcount bump
> - I don't think the ipv4 specific functions can be used safely here.

Are you going to send a new version or should this be treated as
a bug report?

Thanks.
