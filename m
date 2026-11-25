Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=151.80.46.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795604439;
	b=SaLxA1y/2AgC/638tVQdpRccWASzypsza8Aye3IbzSLPDbY+8Psi52Sz517Z1/p9Kjh0
	 7eaArvjnDJUaIx79xZphKOuVkU2+ZbHpqH3aCnx1EbNVeWSh0FCgIRIvk5SHHdrNcHpS+
	 Z6QSDnmjGKzadfuS/v6iUwp+z+ryK1PX+B26arlVtDs7VfxgLb79umthHagPoKYLn6hyW
	 pX9If7GCoOEqlSISQUkism9iD3uxARmuPTve4WoysMNK+AgdeM8R+nIDuYO/O7qLyqocK
	 ugM7JvBdN+MaH3AkIueNfQrctATH2kB7WiTe75cjcn9sO2lgJKkVJf0df4jce0GOnNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795604439;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=/WmuactaER3V1iVrEVHBQFNPcsZ52x3YBuXhpdVr9JM=;
	b=rkYDa1kqt5cHNCDW7sm7xH2H75jWIQ+8v1ZXvzKdh3Q+QvOZC1QNc7gcV33vg/j4ZISY
	 xL4HnK46TrzlkjaAoPErcyUQj+MNuxzRj35DVbSgk/6/PPHa8+82JaMPzHCwGMsc1Vqus
	 KrtyHtQ3uQe7RaR3yT0AmcFU3E3rICUp9FS1e2PcE98a+msla4ArLDbtmJX0gXz9fymlv
	 oK3lmxBkQW18E9J0MRfAverrytqjXKLvYSU3XmSczsEr1szbAmuCQsSyt2Wm5eQMtSMf5
	 3lw/JwklZQ5qhChJ3WfHkWapP26XJxZdTMjxRv6MJRC8QqD65NcQGVWM4bf/zFs9VHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=nwl.cc;
	spf=pass smtp.mailfrom=nwl.cc;
	dkim=pass header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=WGWbzlsJ;
	arc=none smtp.remote-ip=151.80.46.58
Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B71606A323
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2026 11:00:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46B71606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=WGWbzlsJ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/WmuactaER3V1iVrEVHBQFNPcsZ52x3YBuXhpdVr9JM=; b=WGWbzlsJUd3P4eConLxHM07tHt
	+OA4Za3TT6ugmhIz3S2ky8Iu3Y+q4UGYX1fWZAu5yVi+dRGAXJHNQnp76AskXXhrs8b8DR9BZj6JZ
	CivoNI/hQK9qhgLvRZGIu4EvVZ/P9XZHBHTTTmhZz+ingN6rn4lEH/9uTF4oi5pl7L3CKBi4o4gtP
	AB0Ocki9eFp1rM9MfixPzvVs0abVr9l4QhHRC1OR9+jVH9xdSFXHk/d9HgpZLpya738Ti0b3XW2XC
	IpGQgb/opQ5wSBePicrARigu+N1kPyvjuFvmu5AdbtfizM2juy0QoKSu12oEHuKB7j+AfV8ZDgTeR
	K3dR1iOA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xWAjn-000000004gg-487s;
	Wed, 25 Nov 2026 12:00:32 +0100
Date: Wed, 25 Nov 2026 12:00:31 +0100
From: Phil Sutter <phil@nwl.cc>
To: YuPeng <yupeng@kylinos.cn>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, debianyu@163.com
Subject: Re: [PATCH] ebtablesd: Fix missing arguments for %s in error messages
Message-ID: <awa_z-IRhiv2BS5P@orbyte.nwl.cc>
References: <1795597475442100152.16763@kylinos.cn>
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
In-Reply-To: <1795597475442100152.16763@kylinos.cn>

On Wed, Nov 25, 2026 at 05:04:35PM +0800, YuPeng wrote:
> Five ebt_print_error() calls in ebtablesd.c use a "%s" format
> specifier without passing the corresponding argument.  As
> __ebt_print_error() is variadic, this is undefined behaviour and what
> gets printed depends on leftover register contents.  With current gcc
> output on x86-64 the preceding strcmp() happens to leave argv[2] in
> the variadic argument register, so the message usually still names the
> table; different code generation or a different call site can print
> garbage, print "(null)", or crash instead of reporting the error.
> 
> Pass argv[2], which holds the table name for the free, open, fopen,
> commit and fcommit commands, as the calls just around these already do.

Correct, in other spots argv[2] is passed for that matter as well.

> This fix was originally carried in the Kylin Linux SRPM since 2022;
> the commit message has been rewritten to describe the behaviour
> observed on current master.
> 
> Signed-off-by: YuPeng <yupeng@kylinos.cn>

One could also fix the inconsistency wrt. ticks around table name or not
and also join the format strings broken into pieces. OTOH ebtablesd is
so dead, we may risk reincarnating it by accident. So I applied this
patch as-is (aside from adding a Fixes: tag).

Thanks, Phil
