Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3780D2868AB
	for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2025 15:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747842599; cv=none; b=hKF5S0LuMmiOtuhfPU+v6m24J3jYGAWWEinV611XYJdIbnY/cSo+A3P/ERMwqU4cSfQDkGv7P8UaKrUKtg6tdMlA2iF+exbOd2xW2fVgOQoHSsYHYPVBiCP8kn8GugMn/mQcREggXqj0HOYANnZsnzl4DGn8gdFICG7e1HOE1nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747842599; c=relaxed/simple;
	bh=pw/xQ4IqLkxSatfjnlcWt1nKxLEmzF8datldgifbYZU=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l82OLxkXfTtlwj+hTzWoCp9De4/yExPcb2nxdCXojwphxCUJbS9dILxOErVDloppvgq+8QZcvZnSN9JP/zxzcz3W97NEbmdg7rqb0a0p8ENnVlDKe+e0RSOPEg3yeBh7m+Hio0SbIx1beMy8fEqy17+SFEpUeI9nlRuGxOA4aAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=CkZajhUL; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="CkZajhUL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=SNDwoX2pAKG7oVkx7aMFcNV3itoJz62Qw9RICXT+9fs=; b=CkZajhUL0GElN7hzY/gPlo7hsT
	+Fmv5MMvdGCWB5dIz2OX0jXPGOAx3saixOnWfJrGUBPs87H2g8+A7ibKfEFFgDXUASQbiiJJGhi4m
	PsJG7EPyWxg3VSe4Kr9kl8Z48hq7/VNPy4sTJVZ4gZJIkFt0dH0jcCT6EYafyFycrFVzHU4vR5hmb
	SwwdaRu0Q95naSfFhcRGVcQiiMNcJABNOnAOqECt4QFwh0vfA9xcJ/TgXI7O2EZFzC6VtUnTuHU9Z
	CR3EpZeJoTrVOOIcemBGVZz2YAFZf8qd0F3ex0P9FZOmCyGkMev1hoEXbiqTdbSU2AOLpDDz6/rWs
	ZkVH7aeA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uHlha-000000003gh-3ojW;
	Wed, 21 May 2025 17:49:54 +0200
Date: Wed, 21 May 2025 17:49:54 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v6 00/12] Dynamic hook interface binding part 2
Message-ID: <aC32IsDp_CYdRLJj@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Eric Garver <e@erig.me>
References: <20250415154440.22371-1-phil@nwl.cc>
 <aC0B8ZSp8qNzbPqR@calendula>
 <aC3yKSl3u4_zNc4b@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aC3yKSl3u4_zNc4b@orbyte.nwl.cc>

On Wed, May 21, 2025 at 05:32:57PM +0200, Phil Sutter wrote:
> On Wed, May 21, 2025 at 12:28:01AM +0200, Pablo Neira Ayuso wrote:
[...]
> > Maybe add nf_unregister_net_hook_list() helper? It helps to avoid
> > future similar issues.
> 
> ACK, will do!

Scratch that, I was too quick and didn't check: There are exactly two
spots which run 'list_for_each_entry(...) { nf_register_net_hook() }'
without any extras. I'll just fix the one spot instead.

Cheers, Phil
