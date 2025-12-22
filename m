Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C01028690;
	Mon, 22 Dec 2025 10:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766399559; cv=none; b=VKfnDC6mrYaXoBOtGjSw2fVi2t/LJNqW6gRYLgfoWyN5Jwptk6cppZ6q7KAeWaU7RyEQmeKYEOdKqAhhlJ+Rib2dyOYUKQLpPXO14g8ejNs0j5WG4t9Fk/7iuzGth4EDK38HRgx7DbOd24BR7uNYvOHrsJ6JXC6tCJArB4P2M6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766399559; c=relaxed/simple;
	bh=e4P0S9A6aO8pqwS6YCDXG2SotNG//YAqls4OZZ9aAIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DjZBwvIUxufCuRlNsIl7yP70RlXxDuxm43JzlD2vPVDgFteU5c0NRbAl7rhnk565zWwUEp4e+NWDebMEEPPZcFy89XG78+A0b3rjBUSX6rw5hXhksmW6Td8sLurFfmhDD3PKko3ywDNWkBRwtEzmSmaED5c8XNDqeSeH9SHFU4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Pcj9Tp2Z; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Pcj9Tp2Z"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id B487F60251;
	Mon, 22 Dec 2025 11:32:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1766399553;
	bh=1NpEQC9EpFnWR41IbAT2CeM/RNdQL0REZywPWMJ/Yfs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pcj9Tp2ZlyYepsawvcOHHJXUL9womOzTH0Q6VCTQmiMU7S0k7D8OeC5ZKNb2dBH9X
	 FZp/RaRg8AZDlcvJWXGENnWUSSs1qmNXV5eNX+81YDSHZ1kxNgWOg6o6ThOEhq4rlg
	 7cfD6Ofhr6hx/6pKE7BpVWgUWLGKy+t9krZbejll0Nw18o4BZIbO0X/5+2rr1SZzL8
	 Af3HnP+nkRBvvz/Dg4ckwhXblYIx/lZBR5kOaQHhHcHW/1nk2B/s22aCOztqcoWVr/
	 h5CAqk2eXlIxebTA52aPzBdbuU+2SFQFzxVfXo/1zy978GBMbqMYsq4rJeS6YX/K8N
	 7MMe9aRyz8TSQ==
Date: Mon, 22 Dec 2025 11:32:31 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Yuto Hamaguchi <Hamaguchi.Yuto@da.mitsubishielectric.co.jp>,
	kadlec@netfilter.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_conntrack: Add allow_clash to generic
 protocol handler
Message-ID: <aUkeP0xzUcPjWwX-@chamomile>
References: <20251219115351.5662-1-Hamaguchi.Yuto@da.MitsubishiElectric.co.jp>
 <aUcBp4VuHTPqCdEt@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aUcBp4VuHTPqCdEt@strlen.de>

On Sat, Dec 20, 2025 at 09:05:59PM +0100, Florian Westphal wrote:
> Yuto Hamaguchi <Hamaguchi.Yuto@da.MitsubishiElectric.co.jp> wrote:
> > The upstream commit, 71d8c47fc653711c41bc3282e5b0e605b3727956
> >  ("netfilter: conntrack: introduce clash resolution on insertion race"),
> > sets allow_clash=true in the UDP/UDPLITE protocol handler
> > but does not set it in the generic protocol handler.
> > 
> > As a result, packets composed of connectionless protocols at each layer,
> > such as UDP over IP-in-IP, still drop packets due to conflicts during conntrack insertion.
> > 
> > To resolve this, this patch sets allow_clash in the nf_conntrack_l4proto_generic.
> 
> Makes sense to me, thanks.

Would it be possible to follow a more conservative approach?
ie. restrict this to protocols where we know clashes are possible
such as IPIP.
