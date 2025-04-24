Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8E0202C5C;
	Thu, 24 Apr 2025 21:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745529961; cv=none; b=NCfli+U71f0iEvWRJ21i5NEL5kAtHw8IFASWlssq1bjQURH1Ie1D1qSqIq/aOMcK9IQWK2lK6M0kTXYMB5hc3WfvwP2qYIaciQcpR1jkvfEuhEe0JEXXpfYwbQcLgvV1/vnEzJKX2eMpccIH6lLMAiM3M9RlW8tJNpBUdu8DHbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745529961; c=relaxed/simple;
	bh=b/0+yurGv1ACW+6C36BhVgC/X61hgTJAj/RwtvOObx4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TCAoNiyDUhim1GG8mXvaQH2PXEd+P5lHOhpBTi7CMHSt9dQ7SAURWe8MdqdY0Fk1rGbQdeG3xiT6klg7K+GR/lpMpKvT3Kh7+XlLrFvtHTxGSNYLFfm/pmpD150ubA1jFgEnzFAZ7nUioKMVKojVVEhUJePSKFFKHDCI4JNFIag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=IlFdIO4d; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gEBZPTRC; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="IlFdIO4d";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gEBZPTRC"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 69ADF60686; Thu, 24 Apr 2025 23:25:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745529958;
	bh=3AKJ0o15XjVsSUO1ySJBAwGn/VtjV0+jASv1w9bnHUI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IlFdIO4dR/AEDiINjv5It3oI8AtkIeN9HYWcuArDJogkMy/PbiCKWCScC8htR8XtA
	 o5/FYub7TkcKIMEkMh33gh2HohDcRbzN7OvtL8jLnitBoJvprn7c9jjIwNbgg2d9NO
	 yaCohm4lXbRrEKwAgHiPumYC5AJbnqXKUuXmeaLu6CM+WCM0+9p5N4WC9d/Z2LRr+Y
	 MeV0XIfgg2Q+QhVKzMKyGauuy16ycIVL5L/+bVVroNHpDDevw+uPQAplQrJNw+3NYH
	 T0jZxgD4mC8Z4CEp16Uev18ua5hKA0LiShaf7xwB+3qewbe1BYzo2cDmKo4Jg2KfEJ
	 oyxpka0olKtbQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C06AE60581;
	Thu, 24 Apr 2025 23:25:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745529954;
	bh=3AKJ0o15XjVsSUO1ySJBAwGn/VtjV0+jASv1w9bnHUI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gEBZPTRCX50VNlbMKODscp4KGeLWCZOcEzk6ZljEDACdCT/Rr5W1t+53eO7WMLPpx
	 020I2H9/hzYcLTtS23bFAZj0LMtD2X/zIdtWE+Emv1nWFhxuX5INAJDQaluZw9YpYl
	 VZVki8gklpabUg7C7Su9/XNE8tftNvT0YV54RNUKbjipdc/OeX8NsbcCcnvREFkUnT
	 9188YTV4DfL4yiJXu9jZSDddrLAWkTOshdTRXuxi1pTYl3WToCWHlR0iqIfeNdjPOh
	 TTDPd/bmv7Ymv1Vk0SLTFY9fcYlMtAuiaou2ncHIT4h5HeHa0qMYgPo9GCCC4JuNLf
	 XYPSjEHxDaHEA==
Date: Thu, 24 Apr 2025 23:25:52 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Huajian Yang <huajianyang@asrmicro.com>, kadlec@netfilter.org,
	razor@blackwall.org, idosch@nvidia.com, davem@davemloft.net,
	dsahern@kernel.org, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	bridge@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Move specific fragmented packet to slow_path
 instead of dropping it
Message-ID: <aAqsYBIlbhdtnblW@calendula>
References: <20250417092953.8275-1-huajianyang@asrmicro.com>
 <aAEMPbbOGZDRygwr@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aAEMPbbOGZDRygwr@strlen.de>

On Thu, Apr 17, 2025 at 04:12:13PM +0200, Florian Westphal wrote:
> Huajian Yang <huajianyang@asrmicro.com> wrote:
> > The config NF_CONNTRACK_BRIDGE will change the bridge forwarding for
> > fragmented packets.
> > 
> > The original bridge does not know that it is a fragmented packet and
> > forwards it directly, after NF_CONNTRACK_BRIDGE is enabled, function
> > nf_br_ip_fragment and br_ip6_fragment will check the headroom.
> > 
> > In original br_forward, insufficient headroom of skb may indeed exist,
> > but there's still a way to save the skb in the device driver after
> > dev_queue_xmit.So droping the skb will change the original bridge
> > forwarding in some cases.
> 
> Fixes: 3c171f496ef5 ("netfilter: bridge: add connection tracking system")
> Reviewed-by: Florian Westphal <fw@strlen.de>
> 
> This should probably be routed via Pablo.
> 
> Pablo, feel free to route this via nf-next if you think its not an
> urgent fix, its been like this since bridge conntrack was added.

Thanks, I will include this in the nf-next batch.
