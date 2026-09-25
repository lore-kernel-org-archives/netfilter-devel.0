Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0904423E99;
	Fri, 25 Sep 2026 05:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790314213; cv=none; b=SBDoHft9DT8K0mxtak6VKb4yAodJGKHqqFQ8kvtWUi9a4PV7QgoZsnb/cKqG6tkC68cYnzBl+HLNnz0QLUzJJjNE2RrKe7MmBkDcFtzahKdCz26k22smjF2SdGrx/SYO2cuUbRy4NPwd8DFp10pHqOGzdRudtxUsVt8j3ihwIjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790314213; c=relaxed/simple;
	bh=yoUxKi8JUPJIyK/KEFMIPw0wimmz85pODRqc5HhUaHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M6JWUD6qD1q9VVlbtHeY+hXH7eecGePD1Fr5sPkGN09eDvAohNySqci/esj4uzCUlHG2NdYEYJDQ3dscoLjZJ0UToAjiw1xUGtIq0E37whKamA5pCuFTj1gkYsBItThAOV2SolfuygeAZGULHgRTRvyNeYNkKuQbQ+F5K789Bes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b86fLO7Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b86fLO7Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730061F000FF;
	Fri, 25 Sep 2026 05:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790314212;
	bh=3RmlODuzkxey3JAlt+g/XTeruuwUDidB0YIJbJuh7wE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=b86fLO7ZrNe0O1mVJloa216v1KvJPmLc47Ut2eFD7W7e+UwoLjkCYlDhRn1tpHW4z
	 c0mSb7M/nMp540cbhW32dNFjeGV4JBZcmvlknvg7ossJ+aMXq/Zt3HOC0ygYIz8e9S
	 t4grWoLKIMxxlLOXnvAoTybIpJxcqGOIzAMU51BQ=
Date: Fri, 25 Sep 2026 07:07:02 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Yu Junzhe <junzheyu1@gmail.com>
Cc: stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH request stable 6.12 6.6 6.1] netfilter:
 nf_tables_netdev_event UAF of binding chain
Message-ID: <2026092558-grime-yahoo-6b34@gregkh>
References: <20260925020025.616-1-junzheyu1@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925020025.616-1-junzheyu1@gmail.com>

On Fri, Sep 25, 2026 at 02:00:25AM +0000, Yu Junzhe wrote:
> Hello,
> 
> Please consider a backport of the following use-after-free to the
> longterm trees that still have it: 6.12, 6.6, and 6.1. 6.18 and newer
> are not affected.
> 
> There is no single upstream commit to cherry-pick. On current linux.git
> the netdev notifier no longer calls __nft_release_basechain(); it only
> unregisters the per-device hook. That change arrived as part of the
> netdev-hook rework and does not apply to these stable trees.

Great, please provide a working, and tested, patch and we will glad to
review it and apply it if it passes review.

Or you can just submit the same upstream patches backported, which is
probably easier.

thanks,

greg k-h
