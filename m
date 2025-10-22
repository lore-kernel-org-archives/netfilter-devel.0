Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D5C219EB;
	Wed, 22 Oct 2025 00:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761091916; cv=none; b=SE1kRbtbwhh26xl5p/YzAtCKLrupG4aQYPdNyipifYFI1AeRneQ5TgFPxaBFJcd6slxKwvHzcOawTcgOvzrykQgYUU3R4Lua1j2T0Dhk1L4qVY2yTtyANHn1QH44MgtM089Ho63+7KFJUJtV+gkFWxA5xd0evf1Ws6tiqthAQzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761091916; c=relaxed/simple;
	bh=H2BiOOdDmFkaJj6cEX+TAhbKeUmKCwY0zJbaooI3Bj0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RFVMmb+KuAQjMU8RUX1V+E5x56XM9+QKm4KUqI5j62/18+pgpAqw+FWFexZzQD4+toeLAUK3/E+gIW4P8Xtsrxb7IF5EehBq4tlTa35lhPnWMpekDFetr8iCJ6K5g+zQN3s89IW+l7getoTcxoZA8d0bVOMwwWUcqvu/AR36RFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=f0rbFhnB; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="f0rbFhnB"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CC4BA6029E;
	Wed, 22 Oct 2025 02:11:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1761091911;
	bh=GIo4OUKTs32Xr2u1m5Ejie/Gh94AY9rDWZGoguZ01/s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f0rbFhnB3fb/45Evo5200edshHp+oScnd5Jx9lyVnd5eT7mru9W0eGeP2mcOs1kxK
	 W7jO4VPmgcpHgHfjgRY0hGAQPbXXIw+RCBkLFbPl2LVNMB39xUiIQT9ryrMhW/NjLh
	 jrovz+oDj/ec98t3w2oJlC5qbgtzoPrMZXR9sk4wflW1Bx4zYi2Bxb+6uVsvZfxG7z
	 jpbDiAUmCs31mCFRvYSjLJwcSxgfD2N1vVCVq5/H1/cQ57OLk46aJAo5jXLIPzJbOJ
	 EHfG3voaD8jbfxGcCj0DhLvsistvHA76otmXe/tlCPQ5x0KjStakbGCbJH66FDQ7u1
	 S7TDl9ZQnHTBQ==
Date: Wed, 22 Oct 2025 02:11:47 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Andrii Melnychenko <a.melnychenko@vyos.io>, kadlec@netfilter.org,
	phil@nwl.cc, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] nft_ct: Added nfct_seqadj_ext_add() for NAT'ed
 conntrack.
Message-ID: <aPghQ2-QVkeNgib1@calendula>
References: <20251021133918.500380-1-a.melnychenko@vyos.io>
 <20251021133918.500380-2-a.melnychenko@vyos.io>
 <aPeZ_4bano8JJigk@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aPeZ_4bano8JJigk@strlen.de>

On Tue, Oct 21, 2025 at 04:34:46PM +0200, Florian Westphal wrote:
> Andrii Melnychenko <a.melnychenko@vyos.io> wrote:
> >  
> >  struct nft_ct_helper_obj  {
> >  	struct nf_conntrack_helper *helper4;
> > @@ -1173,6 +1174,9 @@ static void nft_ct_helper_obj_eval(struct nft_object *obj,
> >  	if (help) {
> >  		rcu_assign_pointer(help->helper, to_assign);
> >  		set_bit(IPS_HELPER_BIT, &ct->status);
> > +
> > +		if ((ct->status & IPS_NAT_MASK) && !nfct_seqadj(ct))
> > +			nfct_seqadj_ext_add(ct);
> 
> Any reason why you removed the drop logic of earlier versions?
> 
> I think this needs something like this:
> 
> 	if (!nfct_seqadj_ext_add(ct))
>            regs->verdict.code = NF_DROP;
> 
> so client will eventually retransmit the connection request.
> 
> I can also mangle this locally, let me know.

BTW, this fixes DNAT case, but SNAT case is still broken because flag
is set at a later stage, right?
