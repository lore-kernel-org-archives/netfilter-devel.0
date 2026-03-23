Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4FE3CAE69
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Mar 2026 17:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774288557; cv=none; b=pSuo8xgkPyC2PPGeCyIoqDc8l6mEhRMRjCWmfn7pq4d7Mwl6707I2RN37aKWXkwAYAlQuuLvXnXrk1bJzr4CYv5IOptnX60yoAJEvM03AC1ppPu8xtV3svNlW7llo6Z7XN0NMWo8oglp+nAIDpnG+FqIS022oRyUSVW7zt9Xl1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774288557; c=relaxed/simple;
	bh=3oKnXU3W8vxgSYikM4dK+uqplrJ3VQ405WHpNUzZklo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i+KnL5Phwl0I17HUrrq2ahy5h/4iCvVhttrWAaBOdwmPBff9hfaAS553u7coouTE4Onn/y0yTjraRA3CZUWnIa9tW+MVy7DJzZvmB5AnHBUTSHZr1QdxkoIXKf/wMFq6JoqpLKNp8F6hjp9cIfytWYVW1aAdRrdMreliwDI3E0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rB0DL6Wy; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rB0DL6Wy"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 4141F60178;
	Mon, 23 Mar 2026 18:55:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774288552;
	bh=qFeLTMkhUSgtf3rxNbf/eR1kSfwi2aWB2JmBP8SNsU8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rB0DL6Wy+u4ApNV38q/Bmh8ZvagFtGk1WuUNQvkyz9oS439OqsYL1X3+ZYWytdg/B
	 5opI/KO7L1ofURrgh0Lh4qhbAqZpYlFas6+VWkc+hASOzGKG+W7SxgaLuC6Ecf8P+o
	 SQkDcipFzvXNm6v9Yt9ORPbfIK08N91xKhhJDlH8Hwp1ermuG2HOP/sI1D6tZHABjy
	 M1jS1A79vUn2t5iphmnhH8oYEEdMRa+JDaDC1GkpskPApOUjxNUnFHLEqbWlVYzBTk
	 Y0EN02jcJBrGd86SB/kGLt7QTOINcek/s6GyvfsNBOLCjQoF8xi2dOWpHP5qe88M88
	 0ErcSPyxt94Gw==
Date: Mon, 23 Mar 2026 18:55:50 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: Re: [PATCH nf-next,v2] netfilter: nft_meta: add double-tagged vlan
 and pppoe support
Message-ID: <acF-pua5PjDy_UhO@chamomile>
References: <20260322225147.469027-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260322225147.469027-1-pablo@netfilter.org>

On Sun, Mar 22, 2026 at 11:51:47PM +0100, Pablo Neira Ayuso wrote:
> Currently:
> 
>   add rule netdev x y ip saddr 1.1.1.1
> 
> does not work with neither double-tagged vlan nor pppoe packets. This is
> because the network and transport header offset are not pointing to the
> IP and transport protocol headers in the stack.
> 
> This patch expands NFT_META_PROTOCOL and NFT_META_L4PROTO to parse
> double-tagged vlan and pppoe packets so matching network and transport
> header fields becomes possible with the existing userspace generated
> bytecode. Note that this parser only supports double-tagged vlan which
> is composed of vlan offload + vlan header in the skb payload area for
> simplicity.
> 
> NFT_META_PROTOCOL is used by bridge and netdev family as an implicit
> dependency in the bytecode to match on network header fields.
> Similarly, there is also NFT_META_L4PROTO, which is also used as an
> implicit dependency when matching on the transport protocol header
> fields.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: - Fix typo comment "packer" -> "packet".
>     - Add comment to clarify this support double-tagged vlan with
>       vlan offload + vlan header in skb data area.
>     - remove nft_meta_protocol_store() helper function.
>     Note: IPv6 still untested here.

PPPoE with IPv4 and IPv6 is working, but there is an issue with VLAN.

I will post a v3, apologies.
