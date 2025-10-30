Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC753595B
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2025 11:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761822051; cv=none; b=DHJNFvJ+dm/JIIvuT5pP22GigqLpaQgvoz3ec63Ge/WlONziqseHLx6b4LuElWXQ7bj2BoWaLRAChMD9AtFmLlgVdTKw419vzpdrui0TiWQkXQRe8qcfGeTnjMGShl2HSE+iUZuoFBpnL7WIgPWEoGO99Dn6isbZBgjXQX94tr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761822051; c=relaxed/simple;
	bh=a8j5vqmyv4Bf3kjFWqAUDLAXA9aJ1UBcmoUh5GEBBIc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TFs6R3M31FWvjiTvgQOceouxX1yYyJQwRaxnFEYFgbLlqMYeTYhhJkuGBlD9iqoM33w01TB/RkzgK3evidoRT1O6sSXjXxGONRNrbKv2QlXvuLgTqIKacnSaJagWPAVGJ+Jo5rQuwteEfhbmOjhoNRGzdx8LD2ErTBY8Dn+twgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=GQyQplMV; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="GQyQplMV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lhETcglvtacMj3czeVtCC+OxE8hrvT8DWmSFn3jqWBM=; b=GQyQplMVs0EcxSPC7Ub81onxWh
	sL0evvJVRrfCzDgBqzRSVdJkQm9rGHp3By8kcPIMEexdiGK8W7/Gj9UoG7vHVSL/3UwKKQaaLelEN
	6mXPDOlIAdmwO3DKqRYbNtb42gO53mlCekQfNf905Q0JYqxUA/MgMqLxI6j4cS5j9GkW4NdKOOsY/
	NDlOC1o6H5MLITKWjHToDOIvyEKUsGxUBq1WGQx3vqWz7Ysxi+vxxiL4Oi1m3CPm9BMWedksY2ja0
	n4vB0C00ECWUXAkgAzMeouh9Lh9cUD7zzBap8qvSUH43BlBVk6lAV+ySpkWjOJRS8TCgLS3RtEcyS
	toV67mpg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vEQOe-000000003pS-0IM7;
	Thu, 30 Oct 2025 12:00:48 +0100
Date: Thu, 30 Oct 2025 12:00:48 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 10/28] datatype: Increase symbolic constant printer
 robustness
Message-ID: <aQNFYAfsuDn-LkPJ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20251023161417.13228-1-phil@nwl.cc>
 <20251023161417.13228-11-phil@nwl.cc>
 <aQJesgR0qPoO4SfP@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQJesgR0qPoO4SfP@calendula>

On Wed, Oct 29, 2025 at 07:36:34PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Oct 23, 2025 at 06:13:59PM +0200, Phil Sutter wrote:
> > Do not segfault if passed symbol table is NULL.
> 
> Is this a fix, or a cleanup?

It is a fix but for a case which normally doesn't happen. It is
triggered by the macro in patch 26 due to the ad-hoc struct output_ctx
definition not populating the symbol tables.

Cheers, Phil
