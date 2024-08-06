Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04711BE23E;
	Tue,  6 Aug 2024 11:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722943729; cv=none; b=c2Df9LhSIKE1PMFDYGQthE4wS+/rWoxoIqwF9NxlhiPIr6wOXGdF3i5bJQmFzq6yhZIToBLw4std9rG2y/uougWwjE8XHwhS2SyG/QXr1pQykxM8PBvGs84KVaOY8cDXZFVIcFBjU//80j/IPhwzsH/Ctqm5VWW6mGYTuGBWbgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722943729; c=relaxed/simple;
	bh=vmBGnSaJiKjNLYlBMOXg5ITMaRt2cwoDy+YWvk+HywY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UySshCvxOnXWg83RHwOV/+YEBN1GZZ1jU2A3Q354F/mVXwUz4gH1tuEHdW771FChQPS5kDlKajGEs+2YE283Xz9L4FQsMKcZuEpqgznTKhP2bMK6ISdfVtsNTDmIV9N9RrbAfRQtyBVIZV5rzlRaxnU5zQCWRMHufW6vk75wPrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sbIMt-0000kg-Mq; Tue, 06 Aug 2024 13:28:43 +0200
Date: Tue, 6 Aug 2024 13:28:43 +0200
From: Florian Westphal <fw@strlen.de>
To: Tom Hughes <tom@compton.nu>
Cc: pablo@netfilter.org, kadlec@netfilter.org,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: allow ipv6 fragments to arrive on different
 devices
Message-ID: <20240806112843.GB32447@breakpoint.cc>
References: <20240806105751.3291225-1-tom@compton.nu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240806105751.3291225-1-tom@compton.nu>
User-Agent: Mutt/1.10.1 (2018-07-13)

Tom Hughes <tom@compton.nu> wrote:
> Commit 264640fc2c5f4 ("ipv6: distinguish frag queues by device
> for multicast and link-local packets") modified the ipv6 fragment
> reassembly logic to distinguish frag queues by device for multicast
> and link-local packets but in fact only the main reassembly code
> limits the use of the device to those address types and the netfilter
> reassembly code uses the device for all packets.
> 
> This means that if fragments of a packet arrive on different interfaces
> then netfilter will fail to reassemble them and the fragments will be
> expired without going any further through the filters.
> 
> Signed-off-by: Tom Hughes <tom@compton.nu>

Probably:
Fixes: 648700f76b03 ("inet: frags: use rhashtables for reassembly units")

?

Before this nf ipv6 reasm called ip6_frag_match() which ignored ifindex
for types other than mcast/linklocal.
