Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17E619F420
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Sep 2024 17:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727113311; cv=none; b=fBzs3dWnhEm/b5owO5P6i28pGD454isXuKv3R+tAIv9kth9FqCs9dA00kWV8Gd7r+dIElsVVFlDApUshdzMG/6AVMMgS7NNfImVftsA2URHfPWalSxFVROXsS7XiwZCi7ziRK7c9smaLL5XNtCuLzKZtp4eZj3ZU4bKfuXVwA6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727113311; c=relaxed/simple;
	bh=V8Ear4ffeoyNvjru/LHMkuvvOhrMolGjrFid3n3HA14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dNIMKs7VW8113UuNHYWGJj2sihDJ/JxgGgcgfhCv6OOJzNEPE+qK+EDCOwc65d37+PC38/YabYCDZFRrtTYJZogPIz+BAoUV+IXTYLAGbfzlqyXphFpJbxRAi2mkVC5V45nR7nwCRjCJ881QSyKVpdrcVAb0+zvwb56E3Z9ulLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=48484 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1ssn4A-00EiQS-Om; Mon, 23 Sep 2024 19:41:44 +0200
Date: Mon, 23 Sep 2024 19:41:41 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Chris Mi <cmi@nvidia.com>, Ali Abdallah <aabdallah@suse.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: ct hardware offload ignores RST packet
Message-ID: <ZvGoVXf6thRynmPn@calendula>
References: <704c2c3e-6760-4231-8ac8-ad7da41946d9@nvidia.com>
 <20240923100346.GA27491@breakpoint.cc>
 <5edeab2c-2d36-4cef-b005-bf98a496db2c@nvidia.com>
 <20240923165115.GA9034@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240923165115.GA9034@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Mon, Sep 23, 2024 at 06:51:15PM +0200, Florian Westphal wrote:
> Could you propose a patch? As I said, I dislike tying this to sysctls.

I prefer to remove the sysctl too and try to handle this via the
invalid routine handling as Florian suggests.
