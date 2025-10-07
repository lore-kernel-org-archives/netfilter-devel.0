Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B144921A94F
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Oct 2025 11:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759835373; cv=none; b=B0zjMDfAFTAjBi8tYtr3RGUkqM+nBfH7BxdhIIg/5xiQt3xpDqVyd/E/1ueAPQK2zPQmyYfLauvgD/LRxkygP47g0BKSI21uVvE6C44wEVPZRLYMLk8HySzABrcboLmWutDxMtWEOl+aOj6zW+enWRedff8jyNLhnHO2CWgOTAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759835373; c=relaxed/simple;
	bh=reVgwGWVl5aaP30KEaO9v46ZE4/x3kmeQqH/e7ogNN8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KdRtoW9ZFIVmzhQU2c/nYOV3wiNTYvMkbPL0VM8Pm4tD/ZUL1Xs/ybEfh3TPq90hVSahLTmxLV6gboZTiXu9JqQpK115xCgl2vo/P5TWyrbo5QUo1d/Ju5IbGZmbjdeeSNwbHaXUaa59+HNRPh4eFDFj7oGCec/7Z04swR+7OdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=wHEo9Fpg; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ZXl0454O; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="wHEo9Fpg";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ZXl0454O"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 2CAD66026D; Tue,  7 Oct 2025 13:09:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1759835370;
	bh=Nj/bMRvIhaoU2Y4maCAjpb9amInmQYFBJ01LHZ3VVZE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=wHEo9FpgDnUQ6NHWxjbgCwJ2s5sjbxRwbyT6naUwLY0TfQpbGcStV1nEGzQgbtQCH
	 ErZOIJfDfeGMfaA+zGVUsqTHpGvG4SF/cwje/qFfVOidegXPGSiWL4E3C9vg9xJ76M
	 jBSZB/dTDxPmdHFjtmB0v00UdL2t7jdPQN0lV/8bRnDU5dFVkKEP2BmKJjMcTB9yDE
	 DBFumANBz73MzemdHdK0XJ9dqnmeZh6OXoScxW7v1/9Pt7bzIAJnmzlB2A0hhG5I63
	 /l3VcnF6Cc+0H+2e/FoEC8nERFxsttk7j6lT15fPx+x/17Xa8ajswkBQ6k8fNacDps
	 hj+TtipDSVvOw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A710160269;
	Tue,  7 Oct 2025 13:09:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1759835369;
	bh=Nj/bMRvIhaoU2Y4maCAjpb9amInmQYFBJ01LHZ3VVZE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZXl0454OxwQT4vxXdageXDCgzN9CPHzeLDrdlO2E1iIFLsinvmzEUMpcKaq4wdUi9
	 CSnUIlNflQ9baADN/3+97ojJJKhyraWj/1hAzmdXPOYngowx0Q1lJqq7qy4QEeiHUn
	 +TVIlQxvxHpDbrLWXHRVsuWRMnBOj1a3ffvozt9Z6foerIXUPC6IHh0L2HknwPMRal
	 hDoqrnFLhKMErXTw1nTqKWWRM9d399U5CFv65dZpUEK2wR2hRUok8iGExHF4ReR37J
	 +jhaogJQlwZdSZpQe7HIb0+qAeFxMzIi/v9kqwU24FTryoSxMF12mGajJYDaE6rsCT
	 VwEXb8mRBQXpA==
Date: Tue, 7 Oct 2025 13:09:27 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: tunnel: handle tunnel delete command
Message-ID: <aOT051MR-o9cClt3@calendula>
References: <20251007110634.5143-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251007110634.5143-1-fw@strlen.de>

On Tue, Oct 07, 2025 at 01:06:31PM +0200, Florian Westphal wrote:
> 'delete tunnel foo bar' causes nft to bug out.
> 
> Fixes: 35d9c77c5745 ("src: add tunnel template support")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks.
