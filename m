Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D48637B015
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Aug 2026 22:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787697044; cv=none; b=cy87tB8h/AARtooTS3Pm1qj5QkzxeLf3/YTeiDKvP48DDRwfu4Zi36NYUpC+4UaCPABDQoG7vdLWH50cgm2FlGB3m4zp7QaPkesCFpZlIPthvRLMNGu/AXWOUaL2+U0GOMSInf48j4LMg3qherBU2t0zX5IEEBlWq1zdLAk31mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787697044; c=relaxed/simple;
	bh=dNIUKYEBek80O/SrjZ1kKoDMucg4tdJO9tuO1e3AWRs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hp3XYlu5x2lIw1RTFJDC4UzI5o/+r2aP4ji8riSOj/2Sd0eYhSWmBNjgl8m5G4wHrUjJ5JP2fAmpyG/icuV8CP6AI0FlDhi6CE2lwv3aTs5Q88m+AL/7/Tzx5Er/5gitchIi7j0ys9k19+MceTva1Boy8crCYLPhmbU8DiQfubo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Mmc8va56; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Mmc8va56"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787697040;
	bh=yHj/zDqxVu8K32VRWPJJHY+bSoI20TGni1C4ve0jMmk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Mmc8va565MMcy3tEuCCs/ggZm6ceR0hg5dcWJ7RHDLn+CfqLGI6Pr5DIDcNDTb8g7
	 gfA2k6htyackH+am+G2IzKh5teCvLswMh5g0ChSu4UtjROjIfotPNRz19945VZI6sy
	 diotOMwSh1fcdZDPxeSRKUqxONhT1Zf9DTpWYXukXZo7AjsKrR3477lURXQr6iKmFn
	 rsbcANtrbsbsAi99V7/DGrqNxSpRjTLfM88+2H/7BT+TORsTIO1PwRPGrVO2L95ijK
	 PnTwFntbm/VLt53VdAzEaFA83AEVZfBBJ2jCbv8LwJGWem7LkJY2gpp9QxL/autug2
	 Ur0sgTglAiVgg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 532F260081;
	Wed, 26 Aug 2026 00:30:40 +0200 (CEST)
Date: Wed, 26 Aug 2026 00:30:38 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: lwtunnel: expose read-only sysctl
 nf_hooks_lwtunnel for non init-netns
Message-ID: <ao4XjtWuZWyFsHrW@chamomile>
References: <20260824221902.96694-1-pablo@netfilter.org>
 <aozID8YV177fIgql@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aozID8YV177fIgql@strlen.de>

Hi Florian,

On Tue, Aug 25, 2026 at 12:39:11AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Expose nf_hooks_lwtunnel sysctl with 0444 mode from non init-netns
> > instead of 0644, sashiko reports this is exposing a global static branch
> > to modification by unprivileged users.
> 
> No objection but I find this report weird.  Why is that an issue in the
> first place?

Sashiko specifies that this allows for unpriviledged user to turn
on/off the nf_hooks_lwtunnel via static key, which is something that
only init_net should be able to do.

> > Fixes: a2225e0250c5 ("netfilter: move the sysctl nf_hooks_lwtunnel into the netfilter core")
> 
> AFAICS it was exposed before this too, just via conntrack module and not the core.

I can point to the initial patch:

7a3f5b0de364 ("netfilter: add netfilter hooks to SRv6 data plane")
