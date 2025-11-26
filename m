Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512E5224AEF
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Nov 2025 16:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764174959; cv=none; b=iDz6aOZt5zhSTAuC5zK2V7iyU8esJ1YoDx+l/tikPi0fndVzeP6i0bMRWkBQYxkM6XR5e6PwNpJVfIXekBCznqTPfLYjQq+kPhE0XeE4hnewbydc02De548piMvA8JHRYoPO7qNWuxsZgPNq+Nw2a8LVkJErNt4Af/RyUzJMaGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764174959; c=relaxed/simple;
	bh=hXVgxXmadBbq36NxDF98TrHDKvrJaezh75o+5ZeA59M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JUw3CEivdUiXys5qaOp8P2XK8iRXwJC2BBcqPe2aK3+t6+yrHbq/zROpCGFK0xz86DknXdH4aaKOJziNvfNFjIEyZFGlPJHTVDR3R3DNwTf+mkM1sNEB7TjKb0Wu0MCrDVrEOC42NmsqRrDY68jyTIQJ6vmTQuPKMwd8dn+sTxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=RScphvYV; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="RScphvYV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NNKAHXV89DIvc1EDa2HVYt77ASkPeHh+NAO/ZpisvY8=; b=RScphvYVZmJAQt2j464tongXxM
	Dc4DGvu55bG9+T+TQv7me3hgMbA44IN72MU5cT4hgQLvJfFnR2YLyxZlnyddObxfo5x7+bMKw931G
	q2C4HutTlMj8QchS2gpoCbciWkG4nHcmSn9kzCuEnrdMqmB+ntBmzj4+NFpw4FlrDnX93TOS+kYEI
	RfALbYA8GFvPt5qsY+DSGZ1XMulOMWyAO7cQ0vfCmpVPI3D72Qxh42wJCrRU4jTmyYAEROfkPsycY
	seYlo2XQ819T1jHNRx/wkOSw/ve5vt9/vSwrH6EpJB/+BqRyLVo1f8wrJZlELvYbOFABaCMOPpWAR
	6S+R/TGg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vOIUk-000000006WS-0ckw;
	Wed, 26 Nov 2025 17:35:54 +0100
Date: Wed, 26 Nov 2025 17:35:53 +0100
From: Phil Sutter <phil@nwl.cc>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH nft v3] src: add connlimit stateful object support
Message-ID: <aScsaQxELgnDDzHp@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
References: <20251124173557.4345-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124173557.4345-1-fmancera@suse.de>

On Mon, Nov 24, 2025 at 06:35:57PM +0100, Fernando Fernandez Mancera wrote:
> Add support for "ct count" stateful object. E.g
> 
> table ip mytable {
> 	ct count ssh-connlimit { until 4 }
> 	ct count http-connlimit { over 1000 }
>         chain mychain {
>                 type filter hook input priority filter; policy accept;
>                 ct count name tcp dport map { 22 : "ssh-connlimit", 80 : "http-connlimit" } meta mark set 0x1
>         }
> }
> 
> The kernel code has been there for a long time but never used.
> 
> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>

Reviewed-by: Phil Sutter <phil@nwl.cc>

Thanks, Phil
