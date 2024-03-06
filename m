Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D35F133425
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Mar 2024 18:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709749092; cv=none; b=HMA/R5WCTbp6CJQ/0LzZpR3M7dIaoAARyHXUzINhuhyPQjPUVgEXliuoJR/RVzakZIs7HxynaaTYP2GSxISfmc5Abd3iSr3qKQnuxS59/M6ukLovhdGZ2zGP7B8iV4qvDMjpHlLitvwPZl658ArxRuHIu409X0fz73IV+YusBNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709749092; c=relaxed/simple;
	bh=vKNO2U2ICK+0EXnWf3d2aKjFjqsb1Ey+ZTFbTlgPAkM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=To+Vzf30nAxJCJypUUEuE04M9PwqmCbjKC4Eve6uWAGfDTZCnQW+vBZFFB9xyhhODp47mdwpNI0U86HhA5cLAMzTgtRvlFO3bhFFeREbPS1r3RLeoDJQRGoOv/xL4Z2SiuZw+GefpBmcoaqAl0sRsFdDKF2k13ZZt/ZJvoawRzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.33.11] (port=60586 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rhvq0-00FnFL-N1; Wed, 06 Mar 2024 19:17:58 +0100
Date: Wed, 6 Mar 2024 19:17:55 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Daniel Mack <daniel@zonque.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: Issues with netdev egress hooks
Message-ID: <ZeizUwnSTfN3pkB-@calendula>
References: <ba22c8bd-4fff-40e5-81c3-50538b8c70b5@zonque.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ba22c8bd-4fff-40e5-81c3-50538b8c70b5@zonque.org>
X-Spam-Score: -1.9 (-)

Hi Daniel,

On Wed, Mar 06, 2024 at 04:43:02PM +0100, Daniel Mack wrote:
> Hi,
> 
> I am using the NFT egress hook in a netdev table with 'set' statements
> to adjust the source MAC and IP addresses before duplicating packets to
> another interface:
> 
> table netdev dummy {
>   chain egress {
>     type filter hook egress device "dummy" priority 0;
>     ether type ip ether saddr set 01:02:03:04:05:06 ip saddr set 1.1.1.1
> dup to "eth0"
>   }
> }

Is this a dummy device created via: ip link add dummy type dummy or
just a coincidence?

> Does this rule look okay or am I holding it wrong?

Rule looks correct.

> The modification of the sender's MAC address works fine. However, the
> adjustment of the source IP is applied at the wrong offset. The octets
> in the raw packet that are being modified are 13 and 14, which would be
> the correct offset within an IP header, but it seems that the prefixed
> Ethernet header is not taken into account.
> 
> For the same reason, attempting to filter based on any details beyond
> the Ethernet header also fails. The following rule does not match any
> packets, even though there is a significant amount of UDP traffic:
> 
> table netdev dummy {
>   chain egress {
>     type filter hook egress device "dummy" priority 0;
>     ether type ip ip protocol udp dup to "eth0"
>   }
> }
> 
> At this point, I'm not sure where to start digging to be honest and
> would appreciate any guidance on how to resolve this issue.

I guess you are running a kernel with

commit 0ae8e4cca78781401b17721bfb72718fdf7b4912
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Thu Dec 14 11:50:12 2023 +0100

    netfilter: nf_tables: set transport offset from mac header for netdev/egress

so this is a different bug?
