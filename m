Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01132392C2A;
	Mon, 16 Mar 2026 11:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773662197; cv=none; b=EF2Qzcxn1otuGnhEdGQYKkFxILTobl4CIeC05Rfh5v67MKFaR4m8VIw6AsyWAghra++NQDXaPg4IjGOtxnaQpTOPcwf0UIrm7dg6Yl/mcuYCVwhT51vhFc5F3WqfZGa31inHXSKSULcmTSd6bkdskMUSLMKoCcRlIgRrdinYJco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773662197; c=relaxed/simple;
	bh=63aKDPY0UhR+iiZuz1/NYkXwcTRaGwLdSTyCR8mdO6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z1VKEwpePBt2UBNJxuPNcj2imqekoUxdcvoAkKhWgf6gOfZJmAlHpMOBVfN/ttq4qofWnqj/5PUg3fCjdsT1sq3SR0SVQKjANUO4p6mpkCexf4QKaaUEsc954+WneY4w3dNNpuQm4bmcvQ8bB3rVk49LLaiO4fbU5J/R8PshtU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=aHmGI8ju; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="aHmGI8ju"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 25CD960255;
	Mon, 16 Mar 2026 12:56:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773662194;
	bh=+FmB7ltSsu8PsMWtonK0/5SC51CrYwO1p6jjAuPGzkc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aHmGI8juasAHal3roorv3tSqr0VeskkXf5DG/uBBAGKHp1m4WBaoNsBLDxvaQl9Ny
	 8ZM62wqoyiW6r3cDCIi3DfwJm84YZb2EVThi4EAP1iqRj1uAXYRmU4hnsHgBnBYf67
	 mfsc3tSPwaBWuAYSFcnzTXXZcESKQza4azaZ09J1jMnvejIzUz6BZ09BbxPSl1dsOn
	 o5//FwBLoDIFNuNneGekzlIxiTRqVCCZj0niwzRJ0m6y5ZPDsZo+MxVZTDdXKmesGl
	 z0f0LT/wGL3+NNKnLYkfcl4hNwp9FXl6KGj2GPRTlZm3iaCJsjKri2zmPBq20GS3KY
	 b9vvyRSqT5uGQ==
Date: Mon, 16 Mar 2026 12:56:31 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Hyunwoo Kim <imv4bel@gmail.com>, phil@nwl.cc, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nf_flow_table_offload: fix heap overflow
 in flow_action_entry_next()
Message-ID: <abfv7yGuTZF7x82I@chamomile>
References: <aaxe-uH2Qr6qM4E9@v4bel>
 <aax2yZtJce0d19gd@strlen.de>
 <abfhRFfZ1LOgWEsf@strlen.de>
 <abfoTBGLhav-iPQb@v4bel>
 <abfuEe_PpDCyA64B@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <abfuEe_PpDCyA64B@strlen.de>

On Mon, Mar 16, 2026 at 12:48:33PM +0100, Florian Westphal wrote:
> Hyunwoo Kim <imv4bel@gmail.com> wrote:
> > > Ping.  I'm not even sure if there is a bug to begin with, see Pablos
> > 
> > Sorry for the late reply.
> > 
> > To clarify, I triggered the overflow using a dummy device that accepts
> > TC_SETUP_FT, as I don't have real offload-capable hardware. The 17 entry
> > scenario requires double VLAN (QinQ) + IPv6 + SNAT + DNAT simultaneously,
> > which is unlikely in real-world deployments, so it is hypothetical.
> 
> If you triggered it, its not hyptothetical and needs to be fixed.

He triggered it with... a device which is not in the tree? How is
tunnel really supported with TC_SETUP_FT? What driver did gain support
for this? And SNAT and DNAT !?!?

> > > Normally there should be a check that prevents such a configuration.
> > > If thats missing, please add one instead of increasing this define.
> > 
> > So, should I send a v2 with a bounds check, or drop this patch?
> 
> Yes, please send a v2 that prevents the overflow at configuration time.

Just rising the maximum amount is a workaround, I did not check yet
the implications of this.

Yes, better checks would be good to have here, I agree, because this
is fragile, for future proofing.
