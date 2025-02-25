Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2B1212D83
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Feb 2025 23:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740525758; cv=none; b=UZD8+SEjc+8MvIl35GQNn1UboNn896pGTYMox4peTfaQD9l3ZWudT1kop0XeW05lXcVb0svavArjD8M99NWhUlSlwZ/9j45IzvjmpzRo+QrF5f51We2Q9eiI7YVIaoyzbFrvPas544DIY39J9IhqQSKRMPHETOuKNWbGAtZNTGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740525758; c=relaxed/simple;
	bh=/0aoy5IWCISVUsakS5cKP+Ov1kB7fSrJVDf1TBRlZMA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tWZaegJR9IvGWBePP2ctA8TZk1PfFcOHmDM1t4YH/Ej5jRLTywzSDkk11ZDXcB8yOqOHF/+x7plUOn4FCsFxYAeE6HSjZBRLEyBJZm5cjkpIIhDslf2X8NiTfKP4KwJMSHu7u1cP76UjYRUMYYyk07mpSH1n8mgEJBd3wkeyphY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=I5Xp4cPX; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=I5Xp4cPX; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="I5Xp4cPX";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="I5Xp4cPX"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C59D460292; Wed, 26 Feb 2025 00:22:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1740525753;
	bh=oLBnhTmBIFGVezxCiDiYMWZ/jASldpdhLpUnp5C2wyw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I5Xp4cPX71MFmoyQ13QH3djKTZCyiik9PCvY19xUzJxT0wBaahpedJg/g7URmwXTP
	 OKIq/YoqPUAmQwpDOBvj5HhASzibvonSIj7vQ64pcqEXGqsX2Chj1A5fakYOgclxhQ
	 cWcek0KNWrRZAz2jA7Pntga1CHUbQWNM4GKDxBdByxTPqbUYoKhcbvc5wMfYziTlqD
	 kvfGlkSSxtNXs/8yAjri4TqaGwbitn/X2X2EUqQTkIqY3nphDUmp0N6c0rHcRP4DHO
	 Gc7EEzNGNT8oAFwTtBwdgwt9XZQ28kgW2kamc9sNxOxiq5EzKDXvBTvYaLy9BEzJq0
	 owJmmyjMxDAwA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3326960292;
	Wed, 26 Feb 2025 00:22:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1740525753;
	bh=oLBnhTmBIFGVezxCiDiYMWZ/jASldpdhLpUnp5C2wyw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I5Xp4cPX71MFmoyQ13QH3djKTZCyiik9PCvY19xUzJxT0wBaahpedJg/g7URmwXTP
	 OKIq/YoqPUAmQwpDOBvj5HhASzibvonSIj7vQ64pcqEXGqsX2Chj1A5fakYOgclxhQ
	 cWcek0KNWrRZAz2jA7Pntga1CHUbQWNM4GKDxBdByxTPqbUYoKhcbvc5wMfYziTlqD
	 kvfGlkSSxtNXs/8yAjri4TqaGwbitn/X2X2EUqQTkIqY3nphDUmp0N6c0rHcRP4DHO
	 Gc7EEzNGNT8oAFwTtBwdgwt9XZQ28kgW2kamc9sNxOxiq5EzKDXvBTvYaLy9BEzJq0
	 owJmmyjMxDAwA==
Date: Wed, 26 Feb 2025 00:22:30 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] payload: return early if dependency is not a payload
 expression
Message-ID: <Z75Qtutd68GHi2PX@calendula>
References: <20250225203400.28709-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250225203400.28709-1-fw@strlen.de>

On Tue, Feb 25, 2025 at 09:33:57PM +0100, Florian Westphal wrote:
>  if (dep->left->payload.base != PROTO_BASE_TRANSPORT_HDR)
> 
> is legal only after checking that ->left points to an
> EXPR_PAYLOAD expression. The dependency store can also contain
> EXPR_META, in this case we access a bogus part of the union.
> 
> The payload_may_dependency_kill_icmp helper can't handle a META
> dep either, so return early.

Fixes: 533565244d88 ("payload: check icmp dependency before removing previous icmp expression")

> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks.
