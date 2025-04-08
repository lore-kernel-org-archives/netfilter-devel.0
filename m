Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D175122D4F9;
	Tue,  8 Apr 2025 16:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744128180; cv=none; b=kk/WQCzchByJMfjYaKTDToabeCKTytaRwC6+vag2pNywTM7i8VTnqdMB+/P7nYs8EZGj/mCbrjZJShhe2VxB/YjmNNp7q+HqA4Mg1hhf/C/fQSgToed9c4BaKq3y3GxAF6fZot7CxLXiu32hEyOgpMRQlJZ9pamwb2epWMqX9cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744128180; c=relaxed/simple;
	bh=hZt3X6OvWRI5SH/sbZfJe+sNse4XUsMMIFUU1Z1QDtU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ox1GflYq4VMyQWZ/eZlVMEiehzucBbBQ+DR+xlK0NVEdcTWUReTGDRCqPH2Z5dVBvDthkHJlcfuv+WiQ2wy8nwzMLBBO6/giXRHWF2VNVp3NiuEHg67bXL0CXIXQjmRHfSd+sOyOoAS7PWZHlmEcv14vExGVNOJcqWQYFwXJqCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CT4QmlfR; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=f/FWUZle; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CT4QmlfR";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="f/FWUZle"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id D798B603AD; Tue,  8 Apr 2025 18:02:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744128169;
	bh=gJptIUWpJ6UzYtRB0CDxnMyOu8usVQL/RyAHJ2KjoT8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CT4QmlfRF8tqS695IN3rRFXuimmksjfHqU1bRJRHpUmbJJfh/exLTi9MsZLM2XPn8
	 rP7lBrmoiwOGNy9+S0zH9laSNJEeCqc1tWOANyir4AE2y31M4TQtK8u2RyAMlwIMY0
	 r2V2hlZGr7Het3gcXRpNEpIs2ZZNuJh6T1bC5G4t4kxvNA6Ig7g1OC2+qmFur+JXJx
	 pLw7ZYluYfSLFtPveVlgZLq4xYKv5/IKG8lFNoBrAkAQZzAA4N8VUPB4fhgTzg5yhU
	 QPrQCfJXkeDiAMiFdAOlFT+2Lz+ZQaV+P8p6vXj4DGlNM63Fn+d58XjSoG6H5yR6hf
	 dEQbpSNY8KZHQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6FA5860280;
	Tue,  8 Apr 2025 18:02:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744128167;
	bh=gJptIUWpJ6UzYtRB0CDxnMyOu8usVQL/RyAHJ2KjoT8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f/FWUZleyb1H3NjvVG5hbGi3J1WYxnIe3cfT5MAeeJElzclT12Kfi/WIpq2xAcM/2
	 5B3UmJw+6n+bWDa05vwGONRfEn+BTVvKinPQzOAqXoq8/guS7tVpDbI4M2ABzxotfd
	 JdygmZlAFfy7p1YyIVs4XX+Rt/5oKdlO5/IKie8WFjMMO7eK8TrvtamK1Xlt4y15RJ
	 CHnhh57raPF9LpePk4MCxiq8P+8nj0lkiui3k8YzoeSm9gwwIulZPh/KjweTi2b5Si
	 xcjwBcifTMfYtq8lgLZV83SX/MJg5+iKan7SwJiKbTfqjBN0OiZNwus7yo8OXDBuHZ
	 HYUuuPgVKMA3Q==
Date: Tue, 8 Apr 2025 18:02:45 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Michal Ostrowski <mostrows@earthlink.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v11 nf-next 0/2] Add nf_flow_encap_push() for xmit direct
Message-ID: <Z_VIpa9SP05rsW18@calendula>
References: <20250408142425.95437-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250408142425.95437-1-ericwouds@gmail.com>

Hi,

Please, one series at a time. You pick a good target to start with.

I already provided a few suggestions on where to start from.

Thanks.

On Tue, Apr 08, 2025 at 04:24:23PM +0200, Eric Woudstra wrote:
> Patch to add nf_flow_encap_push(), see patch message.
> 
> Added patch to eliminate array of flexible structures warning.
> 
> Changed in v11:
> - Only push when tuple.out.ifidx == tuple.out.hw_ifidx
> - No changes in nft_dev_path_info()
> 
> v10 split from patch-set: bridge-fastpath and related improvements v9
> 
> Eric Woudstra (2):
>   net: pppoe: avoid zero-length arrays in struct pppoe_hdr
>   netfilter: nf_flow_table_offload: Add nf_flow_encap_push() for xmit
>     direct
> 
>  drivers/net/ppp/pppoe.c          |  2 +-
>  include/uapi/linux/if_pppox.h    |  4 ++
>  net/netfilter/nf_flow_table_ip.c | 97 +++++++++++++++++++++++++++++++-
>  3 files changed, 100 insertions(+), 3 deletions(-)
> 
> -- 
> 2.47.1
> 
