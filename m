Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2781A265E
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Jun 2025 20:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749759815; cv=none; b=C6R2jcnRsWjQ+8nrLAxx3LcUx75ag3ysboNezBCUxq8VEO7vOSEfrSqAhkqN0HZe1jgQ2d0iVUpl4t2tgGTjI3lDKizttS89E+cl7rciQ9J18Sg85f7S3ke+Eu5mJbS9ZNFTwGue8WMgCN/gU8xsq6+ldhhVMXfalBgllnG1ico=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749759815; c=relaxed/simple;
	bh=dZLmsgxh6Trj92jQPk57F9tCpU4cCM1nDJ18uM/VDO8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ehtTXmojnda9XvSRtdrZAiomh/ywx5yd0PIZjxcRDfBeiCiYrr9z+eduvQkva+74HH1pFAO/r+gLR+wryNBpxP06Kb2OTHWxB935zHpGl1ocU1lKfIs1qzteB+ERFl7OZR5OxGnclZL1bbV+2wdcID7mahnm34Vcf3DgYZF0nqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=L7Z9EKeO; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=tKm+iv52; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="L7Z9EKeO";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="tKm+iv52"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 5CF9A602BF; Thu, 12 Jun 2025 22:23:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749759810;
	bh=64Yf0tuGbdm1Kdj3dxrkQaXUQGSsyMLuwoPWNlBnKPU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L7Z9EKeOC26TTI7T/eRBY7xtMQiBa7ywD8D+153n6ZBbzvf7qv3vd+UuVXtIWDl0W
	 tV9r7mDkOfACbvhBuDAeC1HrlNfihx70REVEQDnocblq95Iu0hbmICIA7J+z7A5EmK
	 7BJYG78glWgwwC7er129FLMYLvN128YEup3deXkSSLaZ6iJb0F2cOhK7+2TehyS80H
	 ONkgeD9vZvvaF4nLZZEGzFJk1WOQyPrtKdxbGqcUW72GtkoKkHInhDV1saAslXuOg0
	 b1SbdNiRd9Zp1WBQevU0/g8Tw6qsFflVBvL60apB4KZ9jIbwxRUzoflUkSaN1K8dMW
	 IikifDKuXydNg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C6EFA602BF;
	Thu, 12 Jun 2025 22:23:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749759809;
	bh=64Yf0tuGbdm1Kdj3dxrkQaXUQGSsyMLuwoPWNlBnKPU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tKm+iv52mReUIeYxxE/KmMBG5MIayakQpHmdZgf26mqtUKA7sCR5lXTN+5JVS2NUg
	 GbmDkYFHNS3PzEzSjHylpS5b08aJIxQ5xXD5oEUaZPvBL6fdO+xe49qFhpuksKtjZC
	 2XardeeRttxljjj2dzzWbxJcBr3XJ9TRRdnVQSJZueSxIq0QM2gLJG0s58luICRo30
	 p+FIqP1NFBEJr1QTk2xuuuhuZug/yQh+QdnU55zAMMMR+QxwyG1KXrVksYye/I+YqR
	 xXFWD5sGsvsBBNfQYLBS0P/7gXbyBqwo5KoYDoKPn6gD6Tf9rSzXCxGCU0ImZDRYmb
	 XSYvLMoRGrQxg==
Date: Thu, 12 Jun 2025 22:23:27 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] netlink: Avoid crash upon missing
 NFTNL_OBJ_CT_TIMEOUT_ARRAY attribute
Message-ID: <aEs3P6EGuVNkQbj8@calendula>
References: <20250612183937.3623-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250612183937.3623-1-phil@nwl.cc>

On Thu, Jun 12, 2025 at 08:36:35PM +0200, Phil Sutter wrote:
> If missing, the memcpy call ends up reading from address zero.
> 
> Fixes: c7c94802679cd ("src: add ct timeout support")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
