Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7706F1A8F6D
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Jul 2025 13:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752672410; cv=none; b=PlPqDUVjHQkdWsu2bw7bGRBTBISjxSQzAHCDgfR4+zz1TrS1DulejV2KdE9yF599yO2B69eEVIUceth971kr8zqRLZr2eOgQr1+wH/FaA9VHqxYIN4qdzWk2FxbpZ+xXMcPU/nuo6+UToL3hMsYfMh0j6vaDpu9CZoAztxSXLWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752672410; c=relaxed/simple;
	bh=s3GvV8SPrUYv6CFfx+FKblHkYmMawSOBC5Yw8fkPDY8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DFoOpkWbtJoUJF3sBd+paB53gBB+ZnkAsgUXLZYImyJAZ/D8RFZD2bpno7zGcRKBejrLuiXeWXP8e1EVJe1bDJz0NeB1vORput/XxXdg+KLWtdHX1qRxgSkx9V3PZ+Pc4AqG3KEf8V9QMJ8OFv0iaAR23vQRgxXzTjLjUSvu3J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=UTGmfzpJ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="UTGmfzpJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LuuZghn8/x2SDL8LazdJAYeyZlSgtgm4lR7lMMe5ZkE=; b=UTGmfzpJB+AMynn/3fhmBv/O7O
	xXET7/0oj1FW8NWtZ+1YMq5Sw5xAM7fEsEjthcHnpfsPUj7225tgpBfURD1vaBYx6KXsyzdF9W9qB
	qtPfcIaaKLY0Gp1d+BUA7usa+3cMZ7TQG7QB/dRptDRbsqr00uMtxZa9f3a1uJT20OTnItCr6hhqf
	M9WG/4AQc4zR/sObQCG3HqJnRpfIgk9mRTvpkidkZ8qqSWE20aH8/bnkLL7svtFFRhJBR9gNuRb5U
	yxgH7mBEbQERHvYu1wGvaR8yUVqAo+R9eFpJMqfsmvfySLTiW3IwXbBrGYpoK/YRoO90sO1mVbXI0
	T5L9wBPA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uc29m-000000004vu-3iGj;
	Wed, 16 Jul 2025 15:26:46 +0200
Date: Wed, 16 Jul 2025 15:26:46 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v3 1/4] mnl: Call mnl_attr_nest_end() just once
Message-ID: <aHeoln_cUBJLzQSR@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250716124020.5447-1-phil@nwl.cc>
 <20250716124020.5447-2-phil@nwl.cc>
 <aHefwHoC5Uapg5bJ@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aHefwHoC5Uapg5bJ@strlen.de>

On Wed, Jul 16, 2025 at 02:49:04PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Calling the function after each added nested attribute is harmless but
> > pointless.
> 
> Thanks, feel free to push it out.

Patch applied, but ...

> Reviewed-by: Florian Westphal <fw@strlen.de>

forgot the tag. Gna!
