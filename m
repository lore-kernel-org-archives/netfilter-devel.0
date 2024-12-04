Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C378920B20D
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Dec 2024 14:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733323525; cv=none; b=dCsTt7edn3k5ku3YmJC1DJlARA08AkkJ6wODbfhnRSxgIY25IuKa+DxTZrijzu6q1XT9VyCxt3ivy4ot2wLrTQOzLLlbkyj7iu9lO8GZjHgJzaiHgldPC9OSDsuWsnFHIhQu1aNterThSGxQP7kkL45KJnAxIsJbzrK3/78LNh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733323525; c=relaxed/simple;
	bh=FzBkthNtuGa/QjQYo2xdcAIi9pkafutrldPwvpwu40U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FaP7uu6rc4xHl5glgBeQ9g2CvWnGdwCUh5YdK5JGrCmZnC+JRwYQ9NalY2PBax0eA/bS6pCRfbWHqR7EK9EM4xwin9E9Cp9FXLOOwyAPGzOEg3QJkceABglwtZeV+1aUboPmrrV2mEwE+FMC2pRZ12YhF1geUuQvNP4O4gXU3SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=dW9Ar/IP; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="dW9Ar/IP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=E4gW3clEzB1YOrp6+ZHPlLwxVuaT3Qdck7GG1GtIe8k=; b=dW9Ar/IPdymeFfhseOLU0WPP+l
	k1xvlkdx+hqhGqhAe/C30aaA3dRLjswAt6dtJUzDUPmju/cYrsZCeo9oFWB1Tbp4j+4rhOtAnztWI
	kDeAa5gM3YiRVi42Q1gaG+Bwr4+1qK5A0C9HzU+Tht2hWt1afI5jfeSQ2eJAiNclMSFf8TgfaaSBU
	fAUoxeo8GVhhJxd3FXyl/blSS8lamBo8p56ZUrbIdXUt6jZnE0ZWrLDtmNgCef9ull94rqycCTze0
	zj8zFCQghrF8kaj4sJNSgT4Han6YxiNdGW2Y7PxqJHYQUs7tWUJteMl5onTqGHIS0mQGGT8pRrYqy
	iBJ0M0IA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tIqcs-000000003Qz-2KJm;
	Wed, 04 Dec 2024 15:45:14 +0100
Date: Wed, 4 Dec 2024 15:45:14 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH 1/3] set: Fix for array overrun when setting
 NFTNL_SET_DESC_CONCAT
Message-ID: <Z1Bq-oBCmBjRwOJC@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20241127180103.15076-1-phil@nwl.cc>
 <Z1BnoHnLGem-1KFV@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1BnoHnLGem-1KFV@calendula>

On Wed, Dec 04, 2024 at 03:30:56PM +0100, Pablo Neira Ayuso wrote:
> Hi Phil,
> 
> On Wed, Nov 27, 2024 at 07:01:01PM +0100, Phil Sutter wrote:
> > Assuming max data_len of 16 * 4B and no zero bytes in 'data':
> > The while loop will increment field_count, use it as index for the
> > field_len array and afterwards make sure it hasn't increased to
> > NFT_REG32_COUNT. Thus a value of NFT_REG32_COUNT - 1 (= 15) will pass
> > the check, get incremented to 16 and used as index to the 16 fields long
> > array.
> > Use a less fancy for-loop to avoid the increment vs. check problem.
> 
> for-loop is indeed better.
> 
> Patch LGTM, thanks.
> 
> > Fixes: 407f616ea5318 ("set: buffer overflow in NFTNL_SET_DESC_CONCAT setter")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> 
> Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Series applied, thanks!
