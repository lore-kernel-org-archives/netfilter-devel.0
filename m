Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC064206A
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2024 15:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710946815; cv=none; b=U+7nkeoxI1XGAZa6vUUfro+ADfrQnmwpuJ/zXQwEmbug6nIRIEmlqPhwS9NE9DZh8QTG405kWDdal3+YuFIHJMxduEayMN46/0NGvuzNy+Ow9TNTvETYmyDw59ZOI/xkZ3a5Mc8HvTWdO4jyUj3jVJh/yCmeDfavOSe2zwM+EYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710946815; c=relaxed/simple;
	bh=oUnCEhfKymlBbXWGb8QeqHGqVe5LU0viM+Szlhtsui8=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j32iMC4Ha8aJnjp7aiSNiv8LZPmWsKvHBH+FRUMpJF9wV9063y9D6pdR3XgSXK+FYawV3w8cs21i7q1KP7AkNL6SPr4DvDfQGORI7JYLFpyg/Ogu0HvQXje8mMVDlyrBLm+EZ8RpgpkdXvl/9B2BbOpfTQHPeng0bnY/ZF6YrBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=KXHGkz85; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="KXHGkz85"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XgvtdU8wcL8RmhqbpG0cfFtT8sSd35Te6O5vQ7oJLek=; b=KXHGkz85ll04wOipP+RvQxMh7W
	ma+kTuM9ulFH9Z164J85i0CMMZTsCRsXCFn8dvdntJ0ZVVmKM9m3xdwNiSgKI3NN6xPn4YiCm1IT5
	O7NUPehjA2pHIqG9WcWLJA6wAcliWjBbn/z2CoIF0jaGSXAwELli93A9LzbIzF9MkK221eBd6cMX3
	0fvfZQWDiehbDzkmHk7pjTShdIfQiaE7DAOhLA1X2leU2k1yijuG/ysoeCWMxbhbP4AB3RHzSx1mK
	4HdLg4XNZs6dEtcqoqlcXRS+bzG3E0YBj9H1urfBnV4WdGhlZn6luKtky8qeTKGtCDwR+PuhhfFbj
	u1GBWcQw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rmxQJ-000000003lz-2A8X
	for netfilter-devel@vger.kernel.org;
	Wed, 20 Mar 2024 16:00:11 +0100
Date: Wed, 20 Mar 2024 16:00:11 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests: shell: Fix one json-nft dump for reordered
 output
Message-ID: <Zfr5-z4PwI-jzzR-@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
References: <20240320145746.3844-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240320145746.3844-1-phil@nwl.cc>

On Wed, Mar 20, 2024 at 03:57:46PM +0100, Phil Sutter wrote:
> Missed this one when regenerating all dumps.
> 
> Fixes: 2a0fe52eca32a ("tests: shell: Regenerate all json-nft dumps")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
