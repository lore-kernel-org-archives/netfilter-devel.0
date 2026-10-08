Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3242A491589
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Oct 2026 13:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791466126; cv=none; b=KepbYevXwQ5ZU3ERq4adlCOOqRIlXnAXs1Ec+peBiMcauvLTAXU1Pq3cdsPhcvFitcrfJ0ZzcYypAe2tKApjNl8DTYZRoy1hyzpFYvCHL0dAP+EszWoD2wTcj2ziRv5VWtmAV4+AKhcIEtUsJtPTpW8aVuuNCU2bjyIBG1RHCyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791466126; c=relaxed/simple;
	bh=2AbxY6G7Lik2cRwdXRvJH21J2en2VDw04ewaTmXDz1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L9e8PahwM6WUxsQ4xdutFWyOX/zuO999fII0tXPyhYmRHv5+Vco535eYAugeZMFbDHrtgussoJYTWyt2NTfSkiFqD6CqEqupAHaU3trWnUpM/Fd5PE8Jx3nOqOeKzqJ7drVK7BYw4a9ScCs8jOFftszs/VV2krnmH9+qUJcQmek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=iVgBj32t; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="iVgBj32t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=gCK/u5T4tjInErtv2HgnEem+krAsHu3Blh0qSE4aukw=; b=iVgBj32tg5rD39e4ydsl+7tkoI
	pFkHRUjb36+d0fPoOky/nazoRm87dTNVyx0BWiSPOoKFhKbGeod6v9seIEkvcfx2WY+mpRwwPbfpa
	K1+Q6tvXn8gXN+CkY7wsF8Qzxx5GRnUvljVm28+H/LlRbNFy3aJ4yc2kHdRDQpurT/vqGKITX4zZO
	mEwCKPwaCoQp86/MIvNV6BD3YaJPjj5ff31k3J/ExZqnNMIdZu1bzp6lwfTPLHo0mk46lfW6BuIIc
	D+QU/8mdivo70/eXe71rdKGZdYCDQrAlAeD1M36m5a3U/1/8GiXXUm/CvP+N+fvIO+EdopwxEqbWt
	RMIOtwNw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xEoAk-000000007Is-1QqX;
	Thu, 08 Oct 2026 15:28:34 +0200
Date: Thu, 8 Oct 2026 15:28:34 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Balazs Gulacsi <m2gulbal@gmail.com>
Subject: Re: [iptables PATCH 1/3] extensions: libxt_conntrack: Fix inverted
 ctstate translation
Message-ID: <aseagnQr28fvVWKn@orbyte.nwl.cc>
References: <20261002124916.2264622-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002124916.2264622-1-phil@nwl.cc>

On Fri, Oct 02, 2026 at 02:49:14PM +0200, Phil Sutter wrote:
> Special casing for SNAT/DNAT conntrack states was broken with inverted
> matches:
> 
> - Wrong bit in invert_flags checked (typo?)
> - Missing space after operator (cosmetics!)
> 
> Reported-by: Balazs Gulacsi <m2gulbal@gmail.com>
> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1826
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Series applied.
