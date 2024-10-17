Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB061DED6A
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2024 15:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729180348; cv=none; b=hTSTxOpRzbqtKzf/Zr8rxNRL+I0qkFdMoED5EkUDlf40Gl25rUTKcojEEQ7es6o5fESWXV6aWYN80TFPb2LbyRAV+0Z2bxuygGvqmFMr9yvQGBkH8jzhcNLxqmtNFxkgZBU14xLZ5RtIvhb+NRYlo53v0KrhRoHbTs+jLQ1Dgl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729180348; c=relaxed/simple;
	bh=B7QJFcHL+/J+LArZnTcmD6xqNooVFRvrytfOR6np0v8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FWLdcQH341jvYmnA8mYasTRrSBZI740hztj5IUXheacw0pNEG4R+cr4nEBYeH8V8dlF5o4S6YjBxGeqDN0VaTWXx/7djBhmq++kI/dRtnM4VRc3p6azU9jIX5mpXeLcCu4yaliyoD3QWb3xyCwch9OcOadz79rJ1GF1za/bRSb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Z0E8r8c9; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Z0E8r8c9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uAWpiz5lzF5H2m8aE2jWtRgKkGSpbr7SLE2lek7WURo=; b=Z0E8r8c9AGSx1HCN3Oo5NVgOdH
	Fu1k9D4jWEjm+pUU5h50ylTbFTyI13F5HQxNKp2CWheZDvtxo2OQfSQoU7rodIsRCq29Mk5Sg1m+G
	LyKIZ6NQFLr3swEHcgKXStJ2pq+UdAohtxy3eKC/LM5XXupDogNj+Y0jE7Q7fs98ygSPJqplKegdt
	Y09KGAtj2E6u44x1oCntGO7BNB1SQOB/y3wT5Fb98NLremQMKi9EqfTPBphEN4LRthSue6pa5xDA6
	RMf3QWpKUZXoXAeI7YCQKx6UyKUs8iCqSLSYvD9PcDB4VoVqPoJYE3EsXOF585CS39/HcY6UPZ72A
	VA7eSOkQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t1SnO-000000001lZ-2tfx;
	Thu, 17 Oct 2024 17:52:14 +0200
Date: Thu, 17 Oct 2024 17:52:14 +0200
From: Phil Sutter <phil@nwl.cc>
To: i@hack3r.moe
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables] libnftables-json: fix raw payload expression
 documentation
Message-ID: <ZxEyrg_iGZZupTkI@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, i@hack3r.moe,
	netfilter-devel@vger.kernel.org
References: <20241017-libnftables-json-doc-fix-v1-1-c0d2efca1ab2@hack3r.moe>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241017-libnftables-json-doc-fix-v1-1-c0d2efca1ab2@hack3r.moe>

On Thu, Oct 17, 2024 at 11:33:17PM +0800, Eric Long via B4 Relay wrote:
> From: Eric Long <i@hack3r.moe>
> 
> Raw payload expression accesses payload data in bits, not bytes.

Patch applied after adding your Signed-off-by and a Fixes: tag. Please
keep in mind at least the former is required for submitted patches, and
the latter not just a nuisance since tooling may depend on it for
backporting.

Thanks, Phil
