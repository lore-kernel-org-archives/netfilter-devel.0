Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1052F4BFE9C
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 06:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790057934; cv=none; b=jZUbNyZCSqh0EiQkNSOgB44+sAvtmW95JdtVqdI6WchgmMRqmmqkvbS+TT5IpXrs86cF07VnJjjYL+zLtYuTXQWGl+oUIbCXynezRjmZjaS/h4prX6r4YGDt2ti+A9XQhHcXqku1qF1Hi/Z/KVMaJeF/fmuxK6n2HOpl4rOBU8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790057934; c=relaxed/simple;
	bh=0L2g6U8MI9MaZwqOJH8bof5vfEAxRP0R4KiWd2VQiMM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dtYHViAGkeTd07Ihr2ex7QxaV6bqNGxRX9BjQytNyr84tjsI7SrvGzsDqG4cIveYkWtsNeVPCsEOHPnBnqWHo98GI2BFaRlpdueHWD/nL5neZzyHPMhaA6YewRP5s3F6dbZ1SEg48Tt8621fWzrbuycac2N2yszQeglq+NdtZI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6B23B6035B; Tue, 22 Sep 2026 08:18:49 +0200 (CEST)
Date: Tue, 22 Sep 2026 08:18:49 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	pablo@netfilter.org, phil@nwl.cc, eric@regit.org,
	Yu Junzhe <junzheyu1@gmail.com>
Subject: Re: [PATCH nf] netfilter: nft_reject: prevent unbounded recursion in
 output hooks
Message-ID: <arIdrbUtZyaH7QbQ@strlen.de>
References: <20260921222925.3874-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260921222925.3874-1-fmancera@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> nftables payload-mangling rules can rewrite packet contents (such as TCP
> flags) before they are evaluated by reject targets. This defeats the
> content-based loop guards, allowing unbounded hook recursion that leads
> to kernel stack exhaustion and panics.
>=20
> Fix this by extracting the per-CPU xmit recursion limit previously used
> by the netdev duplication/forwarding paths into a shared header, and
> apply it to the inet and inet6 reject transmit functions. It disables BH
> while transmitting the skb to address a possible migration to different
> CPU leading to imbalanced decrementation of the recursion counters.
>=20
> Note that the dev_queue_xmit() path used when CONFIG_BRIDGE_NETFILTER is
> enabled does not require this recursion guard. In that scenario, the
> generated reset packet is transmitted directly at Layer 2. Because the
> packet egresses from a different hook, it cannot synchronously loop.

Won't nf_send_unreach() / unrach6 need the same guard?

If not, please explain why those are safe, its not clear to me.

Patch looks good otherwise, thanks Fernando.
