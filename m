Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9042080C8
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Aug 2025 22:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756333464; cv=none; b=mJ/NJHw2bqa/enzzTxUmdsTtuN4KMyZOp0zHEnqzfgCQSF+SOxNMPl2ppyUDhdLnH5I32E68z1BXybjfZnNL34e6K9lumxuQbRD7/LIcDQSnF2scyvOFxOP+uUDdiFqeLLSiFuXvGOdAksF8UkwtDVOi7osh/ql8T/hxTFBOPDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756333464; c=relaxed/simple;
	bh=qa8oaTVjjdfryUuTTBI9NbSm5nDarBfatRqA+PohuiY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sgHHyWB9YgFixioxiBK3f4na63F6CwEGp2IrxBcDZZoj17HlsYbFTuubyRMvs0Re9jSrefugd2KddL5D0WhF0//PMND7cdd0jgQQ06m6R26/TBD5PPpe1i/EOLtDSdDrIOFEhzMiGc8XOEsUSOujpf6pU6B2WFLitE78vOvpLl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=v2H3Zkm+; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CJ8WV6G9; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="v2H3Zkm+";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CJ8WV6G9"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 127F360797; Thu, 28 Aug 2025 00:24:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756333459;
	bh=fCtbLrDm7d8E1dJnHkm/j0n/Zh++3uZ0Yd3XQ+oSoWY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=v2H3Zkm++wzItT0brzTqp5322OuYjz2kF3lmSugEkx4LwbK7Y7bPr1V3pxCXK8g4p
	 oMdukZPTxHDBRMi2vZ6YFmPla3KrBO/4Ci2f0FKsSt8XxMUfDbwGVKJmKC0DkOVRiB
	 6yAo/CRvfER+YAlxXL7c4htGd2iDauCa8Hmk2Ugu7CUyi23v5z8/Fsb9gXcrWwXp7y
	 sW9n3IjQ5whhjmRpZbzMnJBKShPD7D56XqUWK3IZ65PBqflkTcQ1WsZ6yDxYAGorBB
	 Wa2OqE6WTbQpO3BIQt4xfczGY5NuWhUVgQ+tUFAjLjuRMix/ns2Z/VGtzZivooX2hC
	 xuhNxbV23XPrg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 21D7960777;
	Thu, 28 Aug 2025 00:24:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756333457;
	bh=fCtbLrDm7d8E1dJnHkm/j0n/Zh++3uZ0Yd3XQ+oSoWY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CJ8WV6G9HtkXc0aLeZNa7o/PDzMgc4HlQnrivnYyIBR4NQ4xU9vljfxdQ6Io2ATWh
	 N0nxLhMFqEN4W+o/lKlQDBjfeX2hof3JMaZp12VfqAejqpiyAEXmgesJtN4iV7kmkF
	 pWJWyr7NrfwyoBJx9AT0q944+VuswuRVDHlqFoWeHPSDRSlnifBz4CIY1+CgBo9dgh
	 jiVQwSK/rha5uKoX0oXPgmrf1Zn4PFszwjz+QenCiqoUNSd0zIMMqws1XPQSPBvmZ8
	 ptYpe0pgleoyT7Ohz+sjIUB5k5EAeFdlQsXSgdhtsBM7y+XOEbWdC0+JVlig1FcQN5
	 j0dUySHR6czqg==
Date: Thu, 28 Aug 2025 00:24:15 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, fw@strlen.de,
	phil@nwl.cc
Subject: Re: [PATCH 1/7 nft v3] src: add tunnel template support
Message-ID: <aK-Fj4mdPZYGlyUG@calendula>
References: <20250821091302.9032-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250821091302.9032-1-fmancera@suse.de>

Hi,

On Thu, Aug 21, 2025 at 11:12:56AM +0200, Fernando Fernandez Mancera wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> This patch adds tunnel template support, this allows to attach a
> metadata template that provides the configuration for the tunnel driver.

I have applied this series.

Thanks.
