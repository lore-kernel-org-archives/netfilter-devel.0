Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B156617556F;
	Tue, 11 Jun 2024 08:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718095289; cv=none; b=mvnLt07Z/tErJ5WbK3DdZt0l7BV8ZSsPzHYuLYJ+OhJSKRLrWsMGMRPKcfcBpN6WBgzrrRtyTZg305NAW1rdAIJedGavxsoWvUYRKa5l32DUXC3TbrDIFxvr33idLiuL8DmpbbsQeuCA7NHFe7cWwXRmwEVNlS1NbXs000Y0TQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718095289; c=relaxed/simple;
	bh=ocsjki62tMXIwEMfkAUu6z5CKETwhLUNFOD++UH5k8E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bO1kncCcy5LtjktMyK7pJI3CUB/m0sqFMBSH6A9MgOHFWQ8KQm8zk3doEaddlOLJjMWEcSIDralGL+IVnmzBr4aX7E+/onfjGWGdIlbVqaGNXtGrwJRAqVDW70EhzOR3DVIvb+9V7qaj6qqmVrtlsyE85KjZWSdJwr7V0MD/Og8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=40150 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sGx4B-001zqS-U7; Tue, 11 Jun 2024 10:41:22 +0200
Date: Tue, 11 Jun 2024 10:41:19 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: netfilter-devel@vger.kernel.org,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: Testing stable backports for netfilter
Message-ID: <ZmgNr0y2gCR4YW_K@calendula>
References: <652cad2e-2857-4374-a597-a3337f9330f0@oracle.com>
 <Zmd3XaiC_GiCakyf@calendula>
 <c3789a4c-f262-444b-8234-8431cded548b@oracle.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c3789a4c-f262-444b-8234-8431cded548b@oracle.com>
X-Spam-Score: -1.8 (-)

On Tue, Jun 11, 2024 at 11:28:29AM +0530, Harshit Mogalapalli wrote:
> On 11/06/24 03:29, Pablo Neira Ayuso wrote:
> > On Mon, Jun 10, 2024 at 11:51:53PM +0530, Harshit Mogalapalli wrote:
> > > Hello netfilter developers,
> > > 
> > > Do we have any tests that we could run before sending a stable backport in
> > > netfilter/ subsystem to stable@vger ?
> > > 
> > > Let us say we have a CVE fix which is only backported till 5.10.y but it is
> > > needed is 5.4.y and 4.19.y, the backport might need to easy to make, just
> > > fixing some conflicts due to contextual changes or missing commits.
> > 
> > Which one in particular is missing?
> 
> I was planning to backport the fix for CVE-2023-52628 onto 5.4.y and 4.19.y
> trees.
> 
> lts-5.10       : v5.10.198             - a7d86a77c33b netfilter: nftables:
> exthdr: fix 4-byte stack OOB write
>   lts-5.15       : v5.15.132             - 1ad7b189cc14 netfilter: nftables:
> exthdr: fix 4-byte stack OOB write
>   lts-6.1        : v6.1.54               - d9ebfc0f2137 netfilter: nftables:
>
> exthdr: fix 4-byte stack OOB write
>   mainline       : v6.6-rc1              - fd94d9dadee5 netfilter: nftables:
> exthdr: fix 4-byte stack OOB write

This is information is incorrect.

This fix is already in 6.1 -stable.

commit d9ebfc0f21377690837ebbd119e679243e0099cc
Author: Florian Westphal <fw@strlen.de>
Date:   Tue Sep 5 23:13:56 2023 +0200

    netfilter: nftables: exthdr: fix 4-byte stack OOB write

    [ Upstream commit fd94d9dadee58e09b49075240fe83423eb1dcd36 ]
