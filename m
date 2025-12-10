Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6F92FD667
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Dec 2025 16:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765382608; cv=none; b=JkfHVCMQGO0rLLP0zwN1D2xhO7SAk6zbT+xCBPq+ggT+q9utpcML0jEmVPHS88rWN5wTOUFaVOHWBjJHFRFZNFyb04IebnKV5n8Oi72pTbzln5Uc7MUBjgYMzBkGSsXgAY6UASq/RfwdsxHyF+qn9CuHB/AxufX3P6bqz4Vi6ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765382608; c=relaxed/simple;
	bh=hChElB2J6TeY4YYt4OB8SL5/EzHk4ksnpfe0aMuBstw=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=izPxZQR7NLPAXr6YR8ljQGxxQhIaKxhM+7F5lFBKzozz4m42Fsmnd3ev+I1k0uo9YGkc8tB3j3jDjudZatg50I8Mj/Vig/KAjtShdXCFasP8dP1UntXW1//lJlzta0AhxvLlzB3cyWwanGnlnnWURTZpvq5b9/OJmrEwmAVEMb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3F8FB60351; Wed, 10 Dec 2025 17:03:23 +0100 (CET)
Date: Wed, 10 Dec 2025 17:03:23 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
	Eric Garver <e@erig.me>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2] src: Convert ip {s,d}addr to IPv4-mapped as needed
Message-ID: <aTmZyw4weixoI3Ot@strlen.de>
References: <20251210150333.14654-1-phil@nwl.cc>
 <aTmOaUEmL0P_h0sy@strlen.de>
 <aTmRr2GGL8nUZ-wy@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTmRr2GGL8nUZ-wy@orbyte.nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> Maybe ip6addr_type_parse() could explicitly try to parse as numeric IPv4
> address first? Or a least impact approach checking sym->identifier
> consists of dots and digits only?

Sounds good, just try inet_pton(AF_INET, ..) to see if you need
to turn on MAPPED flag.
