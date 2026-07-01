Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D943A3830;
	Wed,  1 Jul 2026 06:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782887478; cv=none; b=X02owfaIpNtBo1Vt6sx1CFk8+e64P1gHRDEkqQ0Nr7b5X4gd3q0sGjPhpahEFZ/3r9wUz2bVldvozvVeTjgn/LIEXkztCCAH+ZYwNzJfDNnM0EMCeBvDe2NJ9qW4tmXeq9HqLbzeiTOAzQ/lsDrVpTgGgAMee2MOxZnW3GjKYsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782887478; c=relaxed/simple;
	bh=6DXe25HNgUIkVcacAqjomd34UoaNnsPR6LZ9KLJs25w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Niv0s/K/NVfvs9Pt1RevvSRMdlMrg+nr0b4S0AFQ9K/E5IT8R2IqiKTgSijKHUj67XGadtA4C2l3sKyyTM3ccXNl5igg+0ISA3nydDykINUEeGJcThUEDJemmRUtiU1iBOPWPwCGfoWXYCwGfrNXML2zqq2dklB64OaRSxqmc8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D868F602F8; Wed, 01 Jul 2026 08:31:14 +0200 (CEST)
Date: Wed, 1 Jul 2026 08:31:14 +0200
From: Florian Westphal <fw@strlen.de>
To: Ian Bridges <icb@fastmail.org>
Cc: David Laight <david.laight.linux@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] netfilter: x_tables: replace strlcat() with snprintf()
Message-ID: <akS0MrGUcI_3oAan@strlen.de>
References: <aj78X4Cjqcpbb8Co@dev>
 <20260627221643.1e837496@pumpkin>
 <akSy4AzKgPffteU7@dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akSy4AzKgPffteU7@dev>

Ian Bridges <icb@fastmail.org> wrote:
> I learned something new today, thanks. I'll use the first form in v2.
> 
> > FORMAT_TABLES should also be FORMAT_NAMES.

No. The name is fine.

> The macro is already named FORMAT_TABLES today, so that rename would
> be a cleanup of pre-existing code rather than part of the strlcat
> conversion. I'm happy to fold it into v2 if a maintainer is fine
> including the tidy-up in this patch.

No need for a v2, I mangled this patch locally already to use
"%s_FOO" in FORMAT_FOO.
