Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F7440D565
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Aug 2026 09:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787821416; cv=none; b=fHU4u2XoPfCbXCFimSyD/B6dQdd85TXNsPsUoZgw8tXX/4ppR9G9f3hggond6yV7w+hgAL5pbBkJ23cfDUhMewbBJyAQLcG1BC2zoIFm04682+7lkgqMppkCiFd3PMHDNAPK6NZ4Y7PWNyzDPlcTG0KJSZf+HY8kDpRB7T9ddzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787821416; c=relaxed/simple;
	bh=Utzdl97Q3ts3K9+blOTMD79OMjz1lvu3Kl0BL42BKFQ=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aac80mROIQBXZ0qPQc55vZDLsibL/cqWAoBb0o513l9HQ/LPkT30lEqDUbHBFLl8OPx0H5uFy6G87M9HK0Jr0PhvQWx+xssbcaIfhe2QBylZAy46xHHvQaN+XmIIWY176g4DeaDPC7ZYx+eHHSw7Sx8otZgm18+SweMoLAjoKzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OWPQfm6c; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OWPQfm6c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787821407;
	bh=Utzdl97Q3ts3K9+blOTMD79OMjz1lvu3Kl0BL42BKFQ=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=OWPQfm6c1a4T7NrhdBPhHRjGYT9EfzRR2soN6mZDWhjmQPfcISxpylcJjLLX9OT3w
	 T5xTx2VTByzbkl30rgOawJi6X20qoflP0XXO/cgM127RcanbCha/A7+RhjhlOBTvUB
	 baTVNWWcAfkBOm+LQghUhreK5QWJtRS0vCR5YJKryr1mYX+W68aGQDDn+3wsHNQYwe
	 Cm82xDcVqboR/noxaPfPYUjLA7hEn1Znvq1x3qGNrCD/dNdqESSGI2Gb6m4SlyIqx2
	 437stesVS+FvdRl68nE3lSjJNQZsPrx8A9dIyZjnIGnOCHj41kzdPVANYiEnCGiPTc
	 QnC2KVQzj0+vA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 3897C6005F
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Aug 2026 11:03:27 +0200 (CEST)
Date: Thu, 27 Aug 2026 11:03:24 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/3] segtree: assert on value expressions
Message-ID: <ao_9XJOgUUfOXHDg@chamomile>
References: <20260824212909.68597-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260824212909.68597-1-pablo@netfilter.org>

Hi,

On Mon, Aug 24, 2026 at 11:29:07PM +0200, Pablo Neira Ayuso wrote:
> Assert value expression before performing math on them instead of
> crashing with unsupported expressions.

JFR: I have pushed out this series.
