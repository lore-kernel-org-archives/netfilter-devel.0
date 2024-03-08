Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D358C2747F
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Mar 2024 23:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709939086; cv=none; b=SbxB2SO3qciOP090Auus2ds6GDVaT/0UJD31OXE72F94OnGecpKcOEgmPmbfjAnOlMfvIoOPBk4qYMrGSpPJme5A1eQCwewXGRidJAgfFQpujJrIBHNQmZemw9hiUsD0itKoayorojGGsDiLQMIvAIEe8/zocjZTbhqdXpth5DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709939086; c=relaxed/simple;
	bh=SN0UvnrOyHJs1ehJcUqofUzqOy3TKXP1J3u9WbWuqYY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SClmWsuS/WHC4XYQoL4U3X4Iqd2kRK9yOHftaTKueXkI1mkruv5V/QgGtlbe2O5cJN7HU4utn8uZeP/cL+HdG6ligMGR7VPOHlWfrud2ncJyWldxyx2nj5PCOpBgkhJ9+Sc7ykHXFq63No2PBPq9k4+ck51Us34+W2iUdiXcf6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=FdGDZz1b; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="FdGDZz1b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vPnmwPK8itWql2FYbCYcs2xropP6Rfbi8MMVad34hks=; b=FdGDZz1bt/hlMyb4sokGvIFutI
	9OLoJL/E6dW5iXIrYK5iXQmQGhOAS3WAIPJWyc5PFNJ/dwyYhKVXAnyOHsvmkqHp99gEcxaMOdLJz
	DKndrzLzOSwr1vwJH16z9CxO1gUKs6Juw7dlTnYuBNCkCfMMHUYpgT5JTlyzUWYpRUnqkfdaMDYAE
	y0+RQVLq2bvXAHszdZl0NItgcJLkn8CPDfi9UJC/yawyLKW76YsMwIR+tzzza5FIDNoT2Tut5j2JO
	4VscZV/2wsPj8r4AWsOnpv0aASIesEbFZGNI2fUDDveBNI+oeIB79skXkf/dXnw0Rf37JLqpXbLpe
	MCRWj1Fg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rijGa-000000003mS-1azh;
	Sat, 09 Mar 2024 00:04:40 +0100
Date: Sat, 9 Mar 2024 00:04:40 +0100
From: Phil Sutter <phil@nwl.cc>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH arptables] Fix a couple of spelling errors
Message-ID: <ZeuZiCDOI8NoyfOF@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Jeremy Sowden <jeremy@azazel.net>,
	Netfilter Devel <netfilter-devel@vger.kernel.org>
References: <20240308221720.639060-1-jeremy@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240308221720.639060-1-jeremy@azazel.net>

On Fri, Mar 08, 2024 at 10:17:20PM +0000, Jeremy Sowden wrote:
> One mistake in a man-page, one in a warning.
> 
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>

Patch applied, thanks!

Just please be aware that it's entirely unclear if/when a new
arptables-legacy release will be made.

Cheers, Phil
