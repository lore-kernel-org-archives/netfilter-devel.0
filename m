Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760071B6D18
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Mar 2025 20:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742328258; cv=none; b=E+LKv2MKLNWNXbkbzFKgIQ/MZ8ZwXkvqYGyFazlhJbLtvGcNPMID7Zbd7nWw3AH0ZHdLycl3OV1I/P2+uonIsjj7Cj6+GWRsJuSpi1HEv+PVpaUN86cDa8KupDXffFQUhaf057Gdly0EVsGaEo6V281p8b1fMgIGHWobNTRt5eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742328258; c=relaxed/simple;
	bh=LGguJaxwCxzIfCpxJCL+6Fo693qXWh4fbR/0KEQET+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qSvYQr7YIHcNm6sgmdVriLVFUzsEkKoXowu9A11WCMflzTOL7r/L6oi8ZkCGtX8O2waozxczcC98iZW6D0SGZVya8jFUU3GKP1bO9sKn2YLVl3W/zjMQAqnKQj1yjBOjeIk3OCTW5yAv5ZpEgFUtMR4By8PQn0Lkww4a5CKJ+kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tudAZ-0000Vk-Kb; Tue, 18 Mar 2025 21:04:11 +0100
Date: Tue, 18 Mar 2025 21:04:11 +0100
From: Florian Westphal <fw@strlen.de>
To: Antonio Ojea <aojea@google.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Eric Dumazet <edumazet@google.com>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v4] selftests: netfilter: conntrack respect reject rules
Message-ID: <20250318200411.GA840@breakpoint.cc>
References: <20250318094138.3328627-1-aojea@google.com>
 <20250318163529.3585425-1-aojea@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250318163529.3585425-1-aojea@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Antonio Ojea <aojea@google.com> wrote:
> This test ensures that conntrack correctly applies reject rules to
> established connections after DNAT, even when those connections are
> persistent.
> 
> The test sets up three network namespaces: ns1, ns2, and nsrouter.
> nsrouter acts as a router with DNAT, exposing a service running in ns2
> via a virtual IP.
> 
> The test validates that is possible to filter and reject new and
> established connections to the DNATed IP in the prerouting and forward
> filters.

Reviewed-by: Florian Westphal <fw@strlen.de>
Tested-by: Florian Westphal <fw@strlen.de>
