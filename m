Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D663624CF
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Mar 2026 22:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772749077; cv=none; b=HmyZ3rB+T/ofXzPWsY4k582mSUo51tp3b5Ivt7CY+fDPJuF0k1hagiofVBhV+In4qNZW8wvHq/e59XoHZoa8Ot3Vq1AaOt7REa5rMURLgsTtzPzWQOeqHDbTXZzcSkbDzGESpKeE3rDk4d+uYo6iogAt+VYElMjdpvArCbYLuHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772749077; c=relaxed/simple;
	bh=JqXssD5gsSejIwOqrswoyz4QrNTSpEnH6Xl72JI3QO4=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QEWaXGTIiJfPFLId9rzucQxOsGq/4I6wtLqFVk27X6dTKM7Vpa8tAGxJaU6wz+ZraNiA2KRxQtGoEsuI4wlxRfM+FcDvL6ZDk884n0ZV0DO2SivB/Gh2ZCk47AEGMfFH3kCuFBkKojfvz3so3iKeDoSaUddrecEA4BPbHXGu2IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=FLEG36SP; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="FLEG36SP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=WpcibYYw2ysKWXJruxVfrWTRYmmxpsl/N+feVSMbsWA=; b=FLEG36SPdAXarCVgJroQiBqmHd
	WOypCDNMoOcWtybxC/CO0AEFDyCheqPH03z0m7XGWAsPRVo430ezhLXGJzU4LOzSCfgx7AAd4HlE9
	5hs9WlnWzreXksCeDRPM91uNh6K1PaIW2rZTd8l4HpG+jwxc+9BgWy3wAiOPaYaLkSnaNMGYEErPk
	XKWsg8mWueHRmg4IDzGGJDIXEEwuxON9cGXv4sO6rNEgxB/v1uIfe8quB97USk4IYi2bi+1Uam8cp
	YhHQ4GPBgpXsCmAHK94ZhOdgsyI+t/fcEr2sNcOMJP2d2gXgGilHqQ/SR4VuVwgRlpwAke+y51cx5
	Fn2jxoqg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vyH0z-000000000M1-1h5g
	for netfilter-devel@vger.kernel.org;
	Thu, 05 Mar 2026 23:17:53 +0100
Date: Thu, 5 Mar 2026 23:17:53 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 1/2] include: linux: nf_tables.h: Sync with
 current kernel UAPI headers
Message-ID: <aaoBEVHSsN2VwRu-@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
References: <20260305111513.13910-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260305111513.13910-1-phil@nwl.cc>

On Thu, Mar 05, 2026 at 12:15:12PM +0100, Phil Sutter wrote:
> We want NFT_BITWISE_MASK_XOR, use the occasion to sync it entirely.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Series applied.
