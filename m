Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA6882499
	for <netfilter-devel@vger.kernel.org>; Sat, 27 Jul 2024 12:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722083646; cv=none; b=ZR+qwocHIY1kMSAqosgnftNTKQNSTk0BrbRlbl483tuSSMM6tfcv3CZg/Mc5YlUpj7QUodk8hMCOpskIOaFRzo3MpxBDyA58KYnCrF+lxzLxJGs4yHSgVQrx+ZypT2huHTFiRQpQTYFiHvdHHn/t/u8367qNULW3eGZH5gLmFwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722083646; c=relaxed/simple;
	bh=0xpmh1HUiweTqpQlu1QrC78lJpWr+ipNqeIwCeOAdx4=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=brguWXMkzACZv4P+IxLfdWQ12+vTBrdbeQcBQzkFQCdH9RZjNAL0Xg+tkA0r8U6sKcjVvlMVr+YvOyRVXvhwbOK4B4udmlyH+uAZ/xK4P3XuKn2+kNikHA4usBbUNx2vcN/8HRZ7o5TZ0kR6zOIqQjUN40yijRHeAtLRxGt112s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Ql+sX7a1; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Ql+sX7a1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=HonPidaAxQ+qJ1vCMkGEBKiHowVp3qPur9aiPX9zT3I=; b=Ql+sX7a1Q1LBNBwkg0lY+uupA+
	bwVxPuCFrvF0wsYiL+P4HBzRqZKA57c4Qqfbl4Bc03FOie1sWrz8b8mGfr9ur42YGnDQv5vMm0HY3
	2pAv6DhgaSnbAsF60uUNlZa0Nc7W2NRNgL45HW2SukmkoKIlf9Umnw1+Wy/YvUGgPWD0hPSGvc7cp
	fEPiPE0bxM7Wr+tJomQceqhJICAUmmpq50AD+kk7RWiahTUPRlfBQd+Cw9Fbz77cdheDO+6OmVd8+
	DVDmLYc9xJvWWS2RkBg88iaGdGlmuJquv/doFX+Rw0lLdT4cb7QDAb8ZjSAwodaw/0xNFbGrm7laM
	9j3oxa/w==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sXgcd-000000002r6-0fK6
	for netfilter-devel@vger.kernel.org;
	Sat, 27 Jul 2024 14:34:03 +0200
Date: Sat, 27 Jul 2024 14:34:03 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] extensions: recent: New kernels support 999 hits
Message-ID: <ZqTpO1iCVufO-PAt@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
References: <20240720002627.14556-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240720002627.14556-1-phil@nwl.cc>

On Sat, Jul 20, 2024 at 02:26:27AM +0200, Phil Sutter wrote:
> Since kernel commit f4ebd03496f6 ("netfilter: xt_recent: Lift
> restrictions on max hitcount value"), the max supported hitcount value
> has increased significantly. Adjust the test to use a value which fails
> on old as well as new kernels.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Also applied.
