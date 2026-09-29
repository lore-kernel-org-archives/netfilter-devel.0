Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4413B38CFEF;
	Tue, 29 Sep 2026 02:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790647883; cv=none; b=ZkxLLamXbu85BwZKIzWR9kQmW2lUP9NymUuyI46mJGlzwbaPNbX/xmTX9EKMaGRf4WZ2dC+e/oGzUyKZ0uqApL98AKj9fZ7JrSqrIpkH4epieH2ZnWA5sSgUHhCBz5Cx3RpafUUkqU8VL5b/KMePFCWRryQYKJ6gM6UC5MkcjrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790647883; c=relaxed/simple;
	bh=Ca4bcK8dvEBDR1UmqGwmg0qbgYJucqX/rSGTz/VDpUk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DEZgcrPAgtGIv6SULyNHM3L/RQMYfFhlkDO91iN/Bv2WIM8hU/JZHcGIdPVulH01uKiGgC5EDtdeDxl91ykQVFVMcMJ/1L7vYbVs2XFFR8pudZw7uSYrW6ledp8ra4fSdVhMV5HZ4QWgLCPUMhAeLRrSm4gp51sIDksjg+1veXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DC5pF1Dh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DC5pF1Dh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A43F1F000FF;
	Tue, 29 Sep 2026 02:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790647881;
	bh=Ca4bcK8dvEBDR1UmqGwmg0qbgYJucqX/rSGTz/VDpUk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=DC5pF1DhZlitQFg5x4vuUlbJm3vXD1IFCOezp4uPdzt6Hqg+Z0fe9SWmhhjpmDGlw
	 AjTpoLCXHhhKuLzBPwgdXxfXveW66xSO9jeijAAKvZoCmsxLJdVBBPKT4pltgBLhTs
	 rXRP3AaSDUCFwFksY4a1dUGHWlCRiOHsXRkoOO2foO6/ptuDHMZQq3nI89fMKNCVVc
	 fb7c8ktYVEiXVwEAA3CTSe/0Xh8dTooP7CFIPfAbfi07tkV3kEVP9Na78rU0VP2pvn
	 pN8Hn8teP1lTxtgQ/LQRqtjaid+FOsp3LUXeyqzntEHQEoHTd6y5HxWa+D8C2xbRyA
	 1ZIvgZn0hdn2Q==
Date: Mon, 28 Sep 2026 19:11:20 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
 horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 00/11] Netfilter/IPVS fixes for net
Message-ID: <20260928191120.28c28fdb@kernel.org>
In-Reply-To: <20260927220816.268206-1-pablo@netfilter.org>
References: <20260927220816.268206-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 28 Sep 2026 00:08:05 +0200 Pablo Neira Ayuso wrote:
> The following batch contains Netfilter fixes for net:

I didn't spot anything obviously needing a respin in the AI feedback,
could you confirm that it's good as is? If you have to respin it'd be
good to remove the claim that patch 2 is a nop, Linus is onto us for
sending too many LLM-induced, low impact fixes.
