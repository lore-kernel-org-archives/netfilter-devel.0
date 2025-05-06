Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062B242AA9
	for <netfilter-devel@vger.kernel.org>; Tue,  6 May 2025 20:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746563076; cv=none; b=s7Nhu6igjfCc1PR58h+6X8Q8Y3cDq95V8MJ33pElH2XWjuleMXAz7o+KdTKIIx0dtK4kynEPQ8RvkVBG1hxbp6d/CHSSs9wZ4xaKB647sKFJCfYbvIY6L8FgccnYEIlSPqCS/geDOaZSdMX8JaQwg4VIwMb1FM6xO54Zf+uEbls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746563076; c=relaxed/simple;
	bh=tBXZe1Q7kV5sxPdu1ZbWZkqjHDV6TfcxiaFAimbiQFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sfK4HFfc28jSzfFopwqWb97TzrFOjkD+p0HmnFB8y5Q9K8D2FLxFgJDA59gZyeswD0B3TcV/Dm3mvLaYshWIsL4dDO+F5oyvxDlcCAHo4lwhEn/P+jpTtW1LamNMxu1rOURJeMLoI4q33Wqmts56thSq13wMuGE8aTBY/YY9chM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MMySRAkz; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=JhhKqvSq; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MMySRAkz";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="JhhKqvSq"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 29220602D0; Tue,  6 May 2025 22:24:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746563065;
	bh=t7b5K4/DGa8ZcuxpUPhOXA/07rDpdd6C+s0EtccW3yA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MMySRAkzR5EuQdX5S6tnRr8pGez7ZNzNxPrig4TDW1aFKvhdAMlCOwy35vzo1g2bn
	 RNiJhb5IJ4RdtpwhfcU3sd6FJzYofEc2XaTVyyrmSFoO96pDYtyacv9+BLUjHVPiRb
	 lhgr+qK6QK/N1jpShKz6EbLnW3VD3incDvDYFa5JBTAl4nVV2x1+dw+fImFdCYDFXT
	 S0ld7w2wXKyEGV6ZcadQZ5tqd1Z2Z94hxa91r8htJy+hagEfEbKtq5bPkKjfkxuoCO
	 mTxDOlaB8Lb7VbeG+F+WlZgaiCffeUGcJvtzblOI9yfucUVxB3LyDcByYrhey2MoLZ
	 5DknlHhZSVcow==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8BD9E602B6;
	Tue,  6 May 2025 22:24:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746563064;
	bh=t7b5K4/DGa8ZcuxpUPhOXA/07rDpdd6C+s0EtccW3yA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JhhKqvSqfjpMRo2pSlOXeKyr+fZPbvEEwruBOXZaf5Wh8tGYi5cF/leYzEXxofo2u
	 Dv/U/b8uo693FnrtXu4ipdLKNxYoocU2rnSLY4Kvb0dmzsZsSqJtb6pdIdVk34Unj2
	 zEwZZ5LiWJrnjV2kGa+lL5uXsLuj8Fdflp2HPuG8KnDx+YFSAe5Ic++gUenzQ8THhE
	 2cGeFs92Ia5kOJ82r/OlAlqeVGfwlUZMg+nNK33SxbqdJGApbtiduUAO4ZBsD9g9nd
	 oXOhfd1T+7KqAX3VZqMvhvpy3tiMnWwctIMaLrrFXkqJcqN104IW7J+WiwBVONFGtQ
	 76/vo90NgnpXg==
Date: Tue, 6 May 2025 22:24:22 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Monib <monib619@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: nftables netlink cache initialization failure with dnsmasq
Message-ID: <aBpv9rBirbFkpWvB@calendula>
References: <CAJV_tgbKEHTn9T+AZSduNe4YdxQxe8aeriteuYzBmjUm9vNnyg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJV_tgbKEHTn9T+AZSduNe4YdxQxe8aeriteuYzBmjUm9vNnyg@mail.gmail.com>

Hi,

On Tue, May 06, 2025 at 03:57:23PM +0500, Monib wrote:
> Hello,
> 
> An OpenWRT user here who has been trying to set up split tunneling
> using https://docs.openwrt.melmac.net/pbr/, which uses dnsmasq and
> nftables, but I am having some issues.
> 
> I am encountering an error — "netlink: Error: cache initialization
> failed: Protocol error" — which seems to be produced by nftables. This
> error message was introduced in the following commit:
> https://git.netfilter.org/nftables/commit/?id=a2ddb38f7eb818312c50be78028bc35145c039ae.
> The commit message says: "cache initialization failure (which should
> not ever happen) is not reported to the user."

This commit you refer above is exposing an existing issue.

> The issue starts happening semi-randomly but seems to occur when too
> many DNS requests are made in a short period. Once it appears, the
> relevant nftables sets stop being populated by dnsmasq.
> 
> Here is what I see in the logs:
> 
> Sun Mar 23 17:52:24 2025 daemon.err dnsmasq[4]: nftset inet fw4
> pbr_wg_xray_4_dst_ip_cfg066ff5 netlink: Error: cache initialization
> failed: Protocol error

EPROTO can be reported by libmnl with netlink sequence problems.

Quickly browsing dnsmasq code, it looks like there is a pool of child
processes that are sharing a single nft_ctx handle to handle events,
two or more child processes are racing.

I can expand libnftables(3) manpage to clarify this.

Thanks for reporting.
