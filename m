Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0351E5721;
	Wed, 30 Oct 2024 11:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730289007; cv=none; b=Gml7MchiMPxe52PbK29nCj2TCjI0FqbNDke9cXZ7VbqnQ0Jbp7Be7duiBAcbIQZgsFnSF3yypjqVsMco9Fm8hWW3R5BLE7OtqiHgYPBQelNvp6g7rZY5VPadvzmYifl8FGWOwlhs4TaTHKw5M07zh+ydBtDyq1ISXaigvRXPTXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730289007; c=relaxed/simple;
	bh=d0kd0jAZjDfvdx2IVI7ZaowE37ofAER+TSsmwCWFYcc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VyhCOYYHkEqrQPQgLtGpd21Po8j9J91wmkjUWHlg5SVP2da9yCl1yn9m5LLK1qNhB+j3SYjy4Mjk3MO4J2GehuK1f2zCQgtVACEv/e2/UzGHFRFJv9GmNFhqKoxZY3M2V4v9y+023jwhuN4LobgD0wNh+ivJLrQvtPMKZL/cDTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=52500 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t67D5-00B74S-3s; Wed, 30 Oct 2024 12:50:01 +0100
Date: Wed, 30 Oct 2024 12:49:58 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Dumazet <edumazet@google.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	eric.dumazet@gmail.com, syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH nf] netfilter: nf_reject_ipv6: fix potential crash in
 nf_send_reset6()
Message-ID: <ZyIdZlw8Tu2nxJ6l@calendula>
References: <20241025080229.184676-1-edumazet@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241025080229.184676-1-edumazet@google.com>
X-Spam-Score: -1.8 (-)

On Fri, Oct 25, 2024 at 08:02:29AM +0000, Eric Dumazet wrote:
> I got a syzbot report without a repro [1] crashing in nf_send_reset6()
> 
> I think the issue is that dev->hard_header_len is zero, and we attempt
> later to push an Ethernet header.
> 
> Use LL_MAX_HEADER, as other functions in net/ipv6/netfilter/nf_reject_ipv6.c.

Thanks, I will include this in the next PR with netfilter fixes.
