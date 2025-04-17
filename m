Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A111ACECB;
	Thu, 17 Apr 2025 14:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744899539; cv=none; b=DXiVSBQkOcdXb6ioc0R9iUrX6BSCiegAktyreuID6lTGS42cJB050mU726fhg5EdR6pOXm7/93a92j2LZVZDop7kgjY6cqmjdkUZPwF45o9kIkVb2AxvDCkAqTFLX91ua2szpaOQ/pGlVBN2JfJQ3mMCliO29MaQa7yhkq0jtDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744899539; c=relaxed/simple;
	bh=HR6KsENF0Cfsw/MHd1GhQ429Ep+hk7+/lHvNCX94JgI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lqFcxXKuRPWu7dFkUlWQFXcqKVHiRQSbuNdw9bIeBpziM04HteSkWd096m1WGZunHt51jy7ZKPxJ8qmhxGUVx+lPiA1gJUZnjTmQ0giCWlk+ivTMWigshuCtwe4hSuewqphY34EWFKNPfcmI8LALHA5Gt4/khzt+XbY85IIyDaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1u5Q4e-0008SU-0K; Thu, 17 Apr 2025 16:18:40 +0200
Date: Thu, 17 Apr 2025 16:12:13 +0200
From: Florian Westphal <fw@strlen.de>
To: Huajian Yang <huajianyang@asrmicro.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, razor@blackwall.org,
	idosch@nvidia.com, davem@davemloft.net, dsahern@kernel.org,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, bridge@lists.linux.dev,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Move specific fragmented packet to slow_path
 instead of dropping it
Message-ID: <aAEMPbbOGZDRygwr@strlen.de>
References: <20250417092953.8275-1-huajianyang@asrmicro.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250417092953.8275-1-huajianyang@asrmicro.com>

Huajian Yang <huajianyang@asrmicro.com> wrote:
> The config NF_CONNTRACK_BRIDGE will change the bridge forwarding for
> fragmented packets.
> 
> The original bridge does not know that it is a fragmented packet and
> forwards it directly, after NF_CONNTRACK_BRIDGE is enabled, function
> nf_br_ip_fragment and br_ip6_fragment will check the headroom.
> 
> In original br_forward, insufficient headroom of skb may indeed exist,
> but there's still a way to save the skb in the device driver after
> dev_queue_xmit.So droping the skb will change the original bridge
> forwarding in some cases.

Fixes: 3c171f496ef5 ("netfilter: bridge: add connection tracking system")
Reviewed-by: Florian Westphal <fw@strlen.de>

This should probably be routed via Pablo.

Pablo, feel free to route this via nf-next if you think its not an
urgent fix, its been like this since bridge conntrack was added.
