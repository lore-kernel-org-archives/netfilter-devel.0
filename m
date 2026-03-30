Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD28C3C73C8
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Mar 2026 11:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774870881; cv=none; b=GXM2JeFAE/Lgp1EZyi/lMd25XL1CeIdoB8U8yzYlcISUWuX6QbUu/FuUVC7J9j/+7BEjkqxUd5o6tk2nkDaY3Urg+0Gnv7NNzQ3NiKEztHOiFZ7EWp5LqteME2Ct1FvF0KtODHxT4nfNfKKdtCGyjh3LMPZHxtdyuHEURigItuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774870881; c=relaxed/simple;
	bh=Yl5XnyOBY32dOSmF9aQXrBaN9y6EoKgGHTrGsxCd0aU=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hitqQuK9W3ybU6Z82nqnVve7sCZ8cgDiog4uNThbVrV4QB+mrNMRIxSEJ11tWx7Aq9q5B/p7CGn1OpiIyd6dMwvEox/X6lQJ+Stw15EjZk5N54hnhiWxlUyE3Xs6qUtnWdjOrqaWxY8P0qERFreIi95Lqh6MzBlilKFfjZ00Ue0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=T0SddZaz; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="T0SddZaz"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 7A6D5600B5
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Mar 2026 13:41:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774870877;
	bh=6rsS5aZALb9BTKQkT0sCLnCjWCfBbE8uU3TaiMw01r8=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=T0SddZaz6gAU7g8cwLMlpI2YJMiVK5Q9rUeunTPrtjLPkHojnw3oI2uYxGoKhC4Cu
	 qRPHIf2FphPjruqxPpIlI/vP0+9h0cpYb9pqqFGabZQNfj3D8wpQ3g4iRbHmyKcpIz
	 wrlzMhnsvBE78oImCsL2eA+xIHxDRGNyw2tp4ObCYG56imBMiAn0MVUkXb3oO57+/7
	 xCHKDtFbsoLZVzGK4iItyIv2KSOcT29ETqitVfsxI4pfo7gP5eey3GloyrZfxoKYCJ
	 SjJp8eaTxBM94kaH9y8Lughf9V73nsXeICM14zJ3irNTVYqeyjqUgv/yVufsMdE4vY
	 AeogeyGxPcVeA==
Date: Mon, 30 Mar 2026 13:41:14 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_tables_offload: add
 nft_flow_action_entry_next() and use it
Message-ID: <acphWsMJrQlyDBhm@chamomile>
References: <20260330090153.809877-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260330090153.809877-1-pablo@netfilter.org>

On Mon, Mar 30, 2026 at 11:01:53AM +0200, Pablo Neira Ayuso wrote:
> Add a new helper function to retrieve the next action entry in flow
> rule, check if the maximum number of actions is reached, bail out in
> such case.
> 
> Replace existing opencoded iteration on the action array by this
> helper function.

Same patch as before, apologies for this duplicate.
