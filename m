Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180D51B3948
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Nov 2024 11:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731671845; cv=none; b=ZU2K1qNrLd1jPo2NByEQlmEyUy8IE0RoMtWLEX0NfoyLZwNKOyTzzHaT5+isWfbEc9N5b/h9CQJcjde7/L+aoSTGllJ0twFC7bAreFY+T/fpvXd1GrH/2cZQSGrQxbW8SwleTb400QNESvaPftMwGTM7o5QXhIrvIaDSXfTViQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731671845; c=relaxed/simple;
	bh=PxszF+wk2NzuqnL+n8A5smw7kz46uQHGD2oKaXH1d88=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J2QR1Bmj54kjIvc9Se4gtHDeKdQH2ZNSdPtNBBmtm0+NJOBLGRNyxxBEavjNtWs4BD8U75Z/odC8zHa+vlyYOEL+GAw5gz2a+C+KQkPUk31IHo8RxBxKgr6kRCzD+uPixpLFXhJm28dCuq3SKiYOkNynTunm3I+ro814EdjEMR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=41826 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tBuwo-007svI-5y; Fri, 15 Nov 2024 12:57:12 +0100
Date: Fri, 15 Nov 2024 12:57:09 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v6 0/7] Dynamic hook interface binding part 1
Message-ID: <Zzc3FV4FG8a6px7z@calendula>
References: <20241023145730.16896-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241023145730.16896-1-phil@nwl.cc>
X-Spam-Score: -1.9 (-)

Hi Phil,

Sorry for slowness.

On Wed, Oct 23, 2024 at 04:57:23PM +0200, Phil Sutter wrote:
> Changes since v5:
> - Extract the initial set of patches making netdev hooks name-based as
>   suggested by Florian.
> - Drop Fixes: tag from patch 1: It is not correct (the pointless check
>   existed before that commit already) and it is rather an optimization
>   than fixing a bug.
> 
> This series makes netdev hooks store the interface name spec they were
> created for and establishes this stored name as the key identifier. The
> previous one which is the hook's 'ops.dev' pointer is thereby freed to
> vanish, so a vanishing netdev no longer has to drag the hook along with
> it. (Patches 2-4)
> 
> Furthermore, it aligns behaviour of netdev-family chains with that of
> flowtables in situations of vanishing interfaces. When previously a
> chain losing its last interface was torn down and deleted, it may now
> remain in place (albeit with no remaining interfaces). (Patch 5)
> 
> Patch 6 is a cleanup following patch 5, patches 1 and 7 are independent
> code simplifications.

Patch 1-4 can be integrated, they are relatively small.

Patches 5-6 will need a rebase due to my fix in that path.

Patch 7 is probably uncovering an issue with flowtable hardware
offload support, because I suspect _UNBIND is not called from that
path, I need to have a look.

I am inclined to postpone this batch to the next development cycle.
