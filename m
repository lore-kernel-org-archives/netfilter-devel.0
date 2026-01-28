Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B379F2D780C
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Jan 2026 11:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769601445; cv=none; b=lRjARmUe+NhmfuFTRaEEMNlmMpFS234WI4rERtyItyim43B/ZDXEYPiylJU3q7UzVqp4+VD7i18jMnGZrZMahklyHU2hKDxK9OqRLQaqSmrnFEWLYDTb8NZcOwKIuvd0P02KUL9oK8zgYyqw4xiKS4s9ocrYX3TSuMQ//yEYgK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769601445; c=relaxed/simple;
	bh=lx9tTfbNU+aEpWvp2nM+C6qwW8glfTi5Q6dYpaw2foE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ux4+SAGoqNifKsyrvhIYoRYMpm3eMHKS/sTjayP1UcTHSIBNKIR8vQjkieeH0R17PQ6DiJ3RlYgv6KIJSWHy366d2AQZ5ZnPtFsyczWrdPMjrOWT2Ld0b2UEZtpfy83MvcDNkK6397kuMiXxPP25MIhQaBBtCu+HeeT0//vU3UU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=XPaYQuLS; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="XPaYQuLS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=nVyDYeeQwxB1YBK8usjQL/45vJzK3/aewD+inknddGE=; b=XPaYQuLSjycg1CnF4EpIg7gkBS
	nYxVyzDnvHSaHDiV+n80vr1oubFAnftrsa3x100FhAgDquy3TvLXNs7tPqiKni7BDxDaeu5o0EnD2
	wiTjKidobxYtGzfsFN/XOhHQ63B/mfc+Kva4qoQtAtPj8NSklhurOBCGgMlOk76E4P9k79aDleuh+
	gg8AH1P0VX09oRaYkuXCeTeFCt++jwuQHUftdGOgqGP96cPSS5NycKwzlSzRpv58WemSGkGcwe6z8
	JjAWrcEqa7ReO960E+MV126u72Qlzg288OdXSvuSOhTncnpG3MHC934ZtfJieOjv/MuK5Kabh58LW
	EiU8vHYQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vl4Ai-000000002sv-1kte;
	Wed, 28 Jan 2026 12:57:20 +0100
Date: Wed, 28 Jan 2026 12:57:20 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH 9/9] udata: Store u32 udata values in Big Endian
Message-ID: <aXn5oCx0nASLhd_I@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20251023160547.10928-1-phil@nwl.cc>
 <20251023160547.10928-10-phil@nwl.cc>
 <aXlMqOfp2klbz_bH@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXlMqOfp2klbz_bH@chamomile>

Hi Pablo,


On Wed, Jan 28, 2026 at 12:39:20AM +0100, Pablo Neira Ayuso wrote:
> On Thu, Oct 23, 2025 at 06:05:47PM +0200, Phil Sutter wrote:
> > Avoid deviation of this data in between different byte orders. Assume
> > that direct callers of nftnl_udata_put() know what they do.
> 
> How does this work after an update?
> 
> Load ruleset with nft version previous to this, then upgrade, then
> list ruleset with new nft version.

You're right, on LE systems this would interpret LE data as BE. Do we
support this scenario? I vaguely remember a discussion around this topic
with iptables-nft, but don't recall any details.

Without this patch, udata values are in host byteorder. In order to
correctly print them, libnftnl would need to know how data is
structured, which it doesn't and that is by design, right? So the only
alternative to this breakage that I see is to entirely omit userdata
from debug output.

Cheers, Phil
