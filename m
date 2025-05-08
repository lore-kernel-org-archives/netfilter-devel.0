Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A8522425C
	for <netfilter-devel@vger.kernel.org>; Thu,  8 May 2025 21:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746741063; cv=none; b=GHIgIj9hFD1Xi4gcNlcFeu98IDWoJe/Ab0klzEnGpBun2q1G+a2Y9LN7QBo4zPzTCM01Zg7mHB8sPwZG3n9sKy85Iyqla2mVlH6yENZ9HkLDpoeYjBYurjKhG0S1P29wFXJOvjNUEBtCmCyGX0LvK2wi1mP0nln1bHOAMkYPA+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746741063; c=relaxed/simple;
	bh=ylQ4FHWa/wkAXWXt0zda2GUEqSLuriv8reCwegZo4Co=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dFHTJg2NHsqBGchxGJaRbBsEUrlBdBm2K043p2MaBYobIb+AylZ7V8UT77WC9rPZvVb0U+bosTuq+SmmwsE+zAdF+GiYDF0qzWoqRiEpbSKFAQwGkwzJNgwXu6FRMF4mBpWi+Qii+RMX5+6rIAoQEomWa2XQMzVlPLlyhbGc/Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=lbahydgp; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="lbahydgp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=I9NwKSoNNh6U5o6HSFSAoVnfio9A7X7AN25jXol6H7c=; b=lbahydgpEFWu6Ff/tkke7V1FWT
	6ntDu1VGdykoAudlnpLoojxiyPFDFxrWZxaEEHKHg1ehielyaPDObQFvFXimtwNSSKrRrY/WhhjQz
	Ge3ld6AgLPq+K5S3BedW5eLEkVKmo0Br74Y3hEGjln28D43O8uxxR1K9PlPLKoBYgtXXLvBUU/Sr7
	pPlc3MzKZjlTypaxuGs7R4CDO8tAvfDxHyIngkFcuKcv0vDsc2iGkEH0/RjvUnARvfkZM4VZ+XGMJ
	adlfw0BHGQa5ABEScGlV+4DFEROvuXhq/8SFoMYjqx3hsY3hTW1oH/eNnAGTFzx2j5H+OU46xEFLg
	iBjWe58Q==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uD98t-000000000sl-3phQ;
	Thu, 08 May 2025 23:50:59 +0200
Date: Thu, 8 May 2025 23:50:59 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests/shell: Skip netdev_chain_dev_addremove on
 tainted kernels
Message-ID: <aB0nQ_4JRyFWQhFp@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250508102654.17077-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250508102654.17077-1-phil@nwl.cc>

On Thu, May 08, 2025 at 12:26:54PM +0200, Phil Sutter wrote:
> The test checks taint state to indicate success or failure. Since this
> won't work if the kernel is already tainted at start, skip the test
> instead of failing it.
> 
> Fixes: 02dbf86f39410 ("tests: shell: add a test case for netdev ruleset flush + parallel link down")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
