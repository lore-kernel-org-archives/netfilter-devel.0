Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A21F2D027F;
	Fri, 22 Aug 2025 07:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755849069; cv=none; b=hpJe/UXzAXbKFFWeNuc2cpCy7/ds3F34TJQX1fP57TOslwjgcBSggASa791ZQyyrTQ3MKtWyOwNSmF7XR7xGhEoYR9Nlhg3KS037JbE+MZONWdDHIAXHEakdW2VD9s/cRuSvKhlC0IRtAIT0wfAfu2Jn57iDlUAkqnQwiM96f38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755849069; c=relaxed/simple;
	bh=wicOY1qcD0m0AG2H1lGWeGGdCJnN7vbO2ZcJmgUjL7o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AJ8NtYaWEXyxVQBYHJbeUj1vp6M2+s0f94F6PDCGgxtQzFvmlUO1QA9SkkJfdcFGwKTf0ryBfQWT8utBr1FiomvMFlj0sOfhaRFqONf16Avy4rJlVo+9/el8t/euP6CYNs4wHdJsqW/3aqGSQXk93meIU81T69QRkFh/e8goxZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 108E860242; Fri, 22 Aug 2025 09:50:59 +0200 (CEST)
Date: Fri, 22 Aug 2025 09:50:58 +0200
From: Florian Westphal <fw@strlen.de>
To: Wang Liang <wangliang74@huawei.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, razor@blackwall.org,
	idosch@nvidia.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	yuehaibing@huawei.com, zhangchangzhong@huawei.com,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	bridge@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] netfilter: br_netfilter: do not check confirmed
 bit in br_nf_local_in() after confirm
Message-ID: <aKghV0FQDXa0qodb@strlen.de>
References: <20250822035219.3047748-1-wangliang74@huawei.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250822035219.3047748-1-wangliang74@huawei.com>

Wang Liang <wangliang74@huawei.com> wrote:
> When send a broadcast packet to a tap device, which was added to a bridge,
> br_nf_local_in() is called to confirm the conntrack. If another conntrack
> with the same hash value is added to the hash table, which can be
> triggered by a normal packet to a non-bridge device, the below warning
> may happen.

I placed this in nf.git:testing.

In case netdev maintainers want to take it directly:

Acked-by: Florian Westphal <fw@strlen.de>
