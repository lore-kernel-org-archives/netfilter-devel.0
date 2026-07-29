Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D630D416860
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 09:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785318310; cv=none; b=dV1GYorj5b/qnm8fEBQO7eGga/HUDL4TcEqAkRkasi8hi+OTmCyAzMj8iMHshdy5DefhNtTQ5ZSAHoOexIM+Xpj5rCJZVgsOiUw5hPuSHR19k6OxvNL4MEv7uRks+JzV9DONoFyAcoB/bRms6ZJvfcy8iJ6e/McGTEmuD8cF644=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785318310; c=relaxed/simple;
	bh=nNIW3hy6Gltee4jp0L6r65l+XQoBJ5TExwJ0P+HqvfU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RVHTy7p221HfL8NBjegWOT8n3zcuWh5O4XDPoNUxLzLevzJ39njZIhVYJKu6gFSM/76J908WF7eIwoIyAngVOsLdt0pqUF3g/JYq7IuuC6UgSSo50ZTm0CWM//EXoIXXjS224jcZRuNisszs9rr1kvCURqafGVPOSao55ArtK+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=pI1fV0LG; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="pI1fV0LG"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 138A46019F;
	Wed, 29 Jul 2026 11:45:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785318305;
	bh=Rf0+7vjk3mIOOdwGqzG8G9Y2WmkOSB+vCI2KTn6PolY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pI1fV0LGN4GeJNu3oL194pnNJOe2QvZkTgQ/nI8p6F2mwc2VVBfotMLC4uCE53zeQ
	 vIqjPVsbmbOMFSr4q0ISV7EzmHArkUOVHNwXIolddWoj5FXda3LcBjlO+PeX+uYpZ/
	 +Xfkg7vhKvDfAhQqBTO4Cm2Nq5nf5MC5GXLcqe615HgYFWtROCK24Pmq9FiT7R1knY
	 Yw/ByuicHLAmRGQ1GDpDprZWGehokW7Ihu4vu7jqIJPPEOC8+j9XCxIIW0qCLLejWM
	 Xjdyz7nITNXrjdAsIJJmwXmQi6lwGa5gzANVQ7jf85UW4p8eVEkQ3td+KyyMS7bY4Q
	 2/DaNtk6iVOYg==
Date: Wed, 29 Jul 2026 11:45:01 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_tables: call skb_valid_dst()
 before skb_dst()
Message-ID: <amnLnSkq53NgaFs_@chamomile>
References: <20260728084006.101762-1-pablo@netfilter.org>
 <5ee31f48-b783-4e2a-8c35-933ef7fd9a66@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5ee31f48-b783-4e2a-8c35-933ef7fd9a66@suse.de>

Hi Fernando,

On Wed, Jul 29, 2026 at 11:33:24AM +0200, Fernando Fernandez Mancera wrote:
> On 7/28/26 10:40 AM, Pablo Neira Ayuso wrote:
> > When fetching the dst_entry from the skb, check if it valid, ie. this is
> > not a template dst.
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Hi Pablo,
> 
> I used a coccinelle script to see if this pattern is present in other
> places. So far in Netfilter I have found this in
> net/ipv6/netfilter/nf_reject_ipv6.c:nf_send_reset6()
> 
>         if (!skb_dst(oldskb)) {
>                 nf_ip6_route(net, &dst, flowi6_to_flowi(&fl6), false);
>                 if (!dst)
>                         return;
>                 skb_dst_set(oldskb, dst);
>         }
> 
> If I am not wrong the same problem happens here too.

Good point.

It was intentional, I thought this is never called from netdev
ingress/egress.

I can expand the commit message to explicitly mention that the
intention is to check for valid dst in the netdev/ingress,egrees paths
where the template dst can be seen.

But, after second glance, this can be indeed called from
NF_INET_INGRESS.

So this chunk is really needed, I will post v2, thanks!
