Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795240858;
	b=HmWuboueep+x5xXYpIZfcIaK0mJL3gMwD0j+bY8uig7z9+GVpN4lIJ5uhEEH3BVCUlJi
	 CrMOEvhtJLA1wu7v9Au3oif/rruOjVAAbaG0fOYhxo2LUGf9PugN6bgHF/J9b5dfje3xb
	 Mmlz+3ETjUg4/Xhm5sMg9yZOfHkspw1sFfYg9T6Oqv3ZbB4xCNCHGOkSb44C71kxob9yq
	 dCnyetgQswAsBAATcrm+TkXf+vJurhU2JrC96RzJ1ah5EX+xx3DXX5HEOKaTVCSse4T8/
	 7XniF2xZi888IR+/Y1mcdY3mW6p0rkA+ZLq4EtEziF1ZuuyMGOMm15gsiq6Fc18yHjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795240858;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=IQV70RhBDJz2gr1xgRVKGi+QfrPAsfYMwYTaqhGpHKE=;
	b=qPzDqgSef06ZDzae+ec+0JN8xMAFal6Br6uSdTdAwfMFfATO2x+rTAlfk3+VlP0HRtDz
	 lbwF3MccUI0+quh8mq87aTx803pgzU31XlisVKtRE6sWKH9/EpikKY/ZH4sNKYJhKwfQ+
	 SvkyuM75ngojsyfGFFKb0JHQ8TtkdIXvElZ6S7JeQXpZxj+W6qc//H+vhXcn+SlF1japq
	 4qKOjOywXVmDDCECTi3Gvn790ky4sN1cNgi+RcSU0M/WQmfTIHGJ4UT5oCVV0Msf/5FnU
	 d3valxhK6brcxQ3ui5L8V9L0v7ZKE9Sj7PxmK+N4CuZvbnEYAHDLUk1tf86j1VwNidA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12F5606A692
	for <netfilter-devel@vger.kernel.org>; Sat, 21 Nov 2026 06:00:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D12F5606A692
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6CF86601A0; Sat, 21 Nov 2026 07:00:55 +0100 (CET)
Date: Sat, 21 Nov 2026 07:00:55 +0100
From: Florian Westphal <fw@strlen.de>
To: Ryosuke Iwahashi <ryosuke@ikotaslabs.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 nf] netfilter: ipv6: stop the conntrack fragment
 search at AH
Message-ID: <awEzl_Us0ce32N2w@strlen.de>
References: <20261121055253.1801692-1-ryosuke@ikotaslabs.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261121055253.1801692-1-ryosuke@ikotaslabs.com>

Ryosuke Iwahashi <ryosuke@ikotaslabs.com> wrote:
> find_prev_fhdr() looks beyond an IPv6 Authentication Header (AH) for a
> Fragment header. Reassembly there can change data covered by AH before
> IPv6 input processes AH.
> 
> Stop the search at AH. Conntrack still reassembles fragments when the
> Fragment header precedes AH.

There are real world AH deployments?
I thought its dead and unused.

I suspect its an LLM complaining about this...?
