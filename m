Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55CB1442F2
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Nov 2024 12:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732364472; cv=none; b=CiZ7KO1KFhXX0mULBo3NRwa5fXtLD5JgUX2BpV/3Pj709fJV/pmbhC0GNQGTYWZY+UOy9moCjonfAb8bu2CoR8ALEZ3hDl5D8t9L0fjAFVgr9rSksrsnagH8jQayQyPiRy6t4o8GWDc5+n8omkNcJZVwb25jUc04hpRDc4Veio8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732364472; c=relaxed/simple;
	bh=lrCXUjfr8fCGOohe6uxHNtUpB8XIr6y6vk3w43hbxy4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XicoxSPrp6CWSjKPblgrcL0gth7bNRGypi00piZmr+YKmYF7xxVYisHC1XNFE1O/A+nH9Xrncwf2ihMySNCyQc9achT4B0juAIR6ny4me58giRQQcC1c7oMNCafqMBbv0PTPdAjvt0cf4DnQ0jAoxuSolcupyHqGWE3unX1V2cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=fzIUjyY/; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="fzIUjyY/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=G7xksopM4i9SSwI1/fVog4N+/OHfEH9Q/Ezapp4XMcw=; b=fzIUjyY/daMGVnn6Xkk3ZdjzMu
	mGRht1IfJxNX24pR80EMR3Z1Ser2DncRRqeWQULR69wAvdEHepsgBBRwFKzHzcVU2Zq2OotixO0gb
	N9SZfjuNBEFgOQI3AbgqUIq417JkPKCXZbJFfEDqkDvHxw8mlJ2el2z59485a8H2FOmTbA4ybpzZI
	UvkhnOTH/D7s+0nbA9KeWoJ3H/xMv/PS91qnkv+Z9lJr/EsWfapYdR8HPkWq+sKCV7sAA+zAcLwTD
	McYonYU8ST3DYVOB+yfnba1OBn+KOMi8xln8zCMWetYZMGM6blKyn+VpHP+RVaay5WCx5sIgvZ5mF
	7t//DPVg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tEp8N-000000006w2-1rEb;
	Sat, 23 Nov 2024 13:21:07 +0100
Date: Sat, 23 Nov 2024 13:21:07 +0100
From: Phil Sutter <phil@nwl.cc>
To: Donald Yandt <donald.yandt@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] mnl: fix basehook comparison
Message-ID: <Z0HIs1JMJgbOjyUZ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Donald Yandt <donald.yandt@gmail.com>,
	netfilter-devel@vger.kernel.org
References: <20241122220449.63682-1-donald.yandt@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241122220449.63682-1-donald.yandt@gmail.com>

On Fri, Nov 22, 2024 at 05:04:49PM -0500, Donald Yandt wrote:
> When comparing two hooks, if both device names are null,
> the comparison should return true, as they are considered equal.
> 

Fixes: b8872b83eb365 ("src: mnl: prepare for listing all device netdev device hooks")

> Signed-off-by: Donald Yandt <donald.yandt@gmail.com>

Acked-by: Phil Sutter <phil@nwl.cc>
