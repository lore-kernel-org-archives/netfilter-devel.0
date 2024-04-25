Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1509A208C1
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Apr 2024 10:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714042189; cv=none; b=GqkmbiY3r9/IiaCIdXalh9Xq1TwZfjWJBuq2Djt4dFAC7PpQ1grDTdOlDskZfCZGa1/Sz4Imvu16sygPYXwN33Rcoo4fUhr4zi2B0elXzOxoIhO+xD6UeBxcNANVSAdO4tb1x+fZInQAWf1Ighf3AAQWX4GHvYcYjqj0MwceJs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714042189; c=relaxed/simple;
	bh=TNdHDj2U3mR0mHSkHqdDiqVVWqD6+U4uCRh+pI0EODA=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=teSDvBTxCK5GRMbt2pnRQ2E5Xr+uGAuDTLaFY1/EeLBxz9yypv+9B0pb9yIdNssbCUGto/kDMqvoikgzmbKKtyBuF5gXAHayzl52VFbIlCQtMPpWeDm6zZ01AmlKHLr5JKnWd6CSvAV0TYHbS6i3t/ktmPaNNrjtW5vvIYp6ILw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ny9iz7rT; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ny9iz7rT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=jheQwZXMcyMD30QsUfIWu/16HLlvkAeP4lHwijtHMZ8=; b=ny9iz7rT0VKYA9DEWxPKZix4KD
	Six4qPSW8kDK666he/DWaohCP3EKqGJr9aYL+E7ly2InRZRN14OYVb3an2f13EOzP5bvotDkdaqiT
	Zy/Mgz7nkkMa5xuPGQ1vuXNW8HYJgB0oKbs6EdyJbiEXcx+oYeXMzGc2UmD0gpwUrs7D1NIQF7DFz
	C0v7+FATzA9wbnqvNBUkiX1MXVRS0RBQ+LKfwGCd7rI2bmL8vFIeND+DJ5Or7MQweDSxpMdY9DH+J
	wVD+k5Cs4NN7ZtRXh3sQAHz7u7wB3w0hT80ATxZGaVTSGgxUE6OcjVWHVokBjm69Qn6/3U2mAAOt6
	oWp1tqpw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rzwfg-000000004Se-3zzf
	for netfilter-devel@vger.kernel.org;
	Thu, 25 Apr 2024 12:49:45 +0200
Date: Thu, 25 Apr 2024 12:49:44 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests: shell: Fix for maps/typeof_maps_add_delete
 with ASAN
Message-ID: <Zio1SEASqubq6-sj@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
References: <20240424215952.19589-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240424215952.19589-1-phil@nwl.cc>

On Wed, Apr 24, 2024 at 11:59:52PM +0200, Phil Sutter wrote:
> With both KASAN and ASAN enabled, my VM is too slow so the ping-induced
> set entry times out before the test checks its existence. Increase its
> timeout to 2s, seems to do the trick.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
