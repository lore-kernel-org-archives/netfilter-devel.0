Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719B12F0E5F
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Jul 2025 13:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752671184; cv=none; b=eovWqCILtGLfROXN8jlaD1dIcrYrM35Q2Bc//FAhdtzmXMqwh/EofE6QAdk5Ejsx4vDmTo7xXTuRcupVY08sZLQzdy9TW2kBJoB+JTLc4QUgwBq47jLaQHsptlHF+U/xwxq4h0tGyOsM7HEe5otWOE24AFeqSOlcWCP+2eQ7qlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752671184; c=relaxed/simple;
	bh=LeSOhj4eEBiwCXYLE96duML6WlmHw30xBlNizX58Kio=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rNZXnLi0Nif6D2TRCvvV8hDzQH0fQGL6+loUalFChPXVCUMXyoxGiAE5OuaF/IspA3f1oz0sM2VRtg+OZLgWHMINxQ7rt3ax4zDxhFaPxYI/COF9BNWYNSlc5a+GDp4jFZAHgTfc87d/D3q2fi6dTF+VvqEWIK4T+J6maR6tk3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3A9EC60637; Wed, 16 Jul 2025 15:06:20 +0200 (CEST)
Date: Wed, 16 Jul 2025 15:06:19 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH v3] utils: Add helpers for interface name
 wildcards
Message-ID: <aHejy360JyFlNdbk@strlen.de>
References: <20250716123325.3230-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250716123325.3230-1-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> +void nftnl_attr_put_ifname(struct nlmsghdr *nlh, int attr, const char *ifname)
> +{
> +	int len = strlen(ifname) + 1;

Nit: size_t len.

> +const char *nftnl_attr_get_ifname(struct nlattr *attr)
> +{
> +	size_t slen = mnl_attr_get_payload_len(attr);
> +	const char *dev = mnl_attr_get_str(attr);
> +	static char buf[IFNAMSIZ];

I missed this on my last review, sorry:

Please pass "char buf[IFNAMESIZ]" as argument.

Returning pointer to a static buffer breaks thread safety
of libnftables.

Alternatively you could always return a malloc'd buffer
and force caller to free it.  Up to you.
