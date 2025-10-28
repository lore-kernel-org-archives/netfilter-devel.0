Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0DCD348882
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 17:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761671494; cv=none; b=BXEJCzEueYdiL/mDbh8b0Q2MqHgW8TsbUsFIgBX9nLA/YKwqFWv9YKo/RTcQd/zAEQNeZj+chKv70XoRj0h4YqBuOnoORjvC4pXDhPgbD+Sv8pNtBl/Z9XNffwlNRIFSZa1ibUMOH8jNDjZ5ZiwBEwCq70exSh/VRkODppJdX8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761671494; c=relaxed/simple;
	bh=n21Aw+TnlrJm4+ohlxL6kA0tA+uSiKz9S5fD7+j37Cs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XBoBX7emHpsJhJLw3rXy8irsU2LHRoL2Rf6cLA+tq5JoYNSCfUtyTosn/62AAVSI3ViioxWEph8Hb/XVvUNqiA87jm6O0pLz+gxhFfsLkP4kgd34jLV1hzSMD+c4nRlLLlRZW5XPENKDQuGwM0ET1/dfgOtQiSZLyCslqQFAZGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=kH7I4UtX; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="kH7I4UtX"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 52EB160278;
	Tue, 28 Oct 2025 18:11:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1761671488;
	bh=DOZlPPoZM8ux5hTde6V0Nh0GIs7OMKoVDedSp+JikNE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kH7I4UtXKcYvsdEbd6gdniuqsk191RtQB4tnwO7z54VN2kg6Var32GNlAgfsgjFM/
	 j78AHjTfyYdsjjU/h9LqZ6rAnUg3CueWUdbPd0bC/170Fd4vxSPzEvbpxyHE1AyWlY
	 ONgI2F0zisYFjk4yfPVSGPm7qp82nDZx2Q0H8KeYwfEgOHkEvNfHpxN4/hcf5b7fbO
	 /8dQQbQPtYoDQ64jpqgJKsNsdNfihUsjtyKTqNh5e4qEFXgGos32+CpSMykkQlZLfX
	 Xaom3/t2iKVh92v4cbzZMWxaAfBKY5dPdKhryrl5B42Oj9I8LAQ8RtZ44LPdT35Ax6
	 TzrWFQikm5Vmg==
Date: Tue, 28 Oct 2025 18:11:25 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	louis.t42@caramail.com
Subject: Re: [PATCH nf] netfilter: nft_connlimit: fix duplicated tracking of
 a connection
Message-ID: <aQD5PUkG7M_sqUAv@calendula>
References: <20251027125730.3864-1-fmancera@suse.de>
 <aQD2R1fQSJtMmTJc@calendula>
 <aQD4J7pI-Fz1V3eC@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aQD4J7pI-Fz1V3eC@strlen.de>

On Tue, Oct 28, 2025 at 06:06:47PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > -	if (nf_conncount_add(nft_net(pkt), priv->list, tuple_ptr, zone)) {
> > > -		regs->verdict.code = NF_DROP;
> > > -		return;
> > > +	if (ctinfo == IP_CT_NEW) {
> > 
> > Quick question: Is this good enough to deal with retransmitted packets
> > while in NEW state?
> 
> Good point, I did not consider retransmit case.
> What about if (!nf_ct_is_confirmed(ct)) { ..?
> 
> Would need a small comment that this is there instead of NEW
> check due to rexmit.
> 
> > > +		if (nf_conncount_add(nft_net(pkt), priv->list, tuple_ptr, zone)) {
> > > +			regs->verdict.code = NF_DROP;
> > > +			return;
> > > +		}
> > > +	} else {
> > > +		local_bh_disable();
> > > +		nf_conncount_gc_list(nft_net(pkt), priv->list);
> > > +		local_bh_enable();
> > >  	}
> 
> As this needs a respin anyway, what about removing the else
> clause altogether?  Resp. what was the rationale for doing a gc call
> here?

You mean, call gc for both cases, correct?

> And, do we want same check in xt_connlimit?

Are you referring to the !nf_ct_is_confirmed() check?
