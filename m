Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E581C352036
	for <netfilter-devel@vger.kernel.org>; Sat, 13 Jun 2026 21:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781386764; cv=none; b=FYEpfr9uyTcCLT7/+1TGPJUaG1a62v1R23BZZIMYvlbQ0EotCuiB1jwvQ2Im28YnwWaxANaOkeiJdbw6SAEIru0C5aP5t2CEFPwu4iVP2Yew4K7R/pWJuSn1r/115+FA6JdtcrkN4csjTl09Hyd+SZ8tr7ZUbwIdL+MeKldFmek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781386764; c=relaxed/simple;
	bh=gPkBGRN1ErYrvCjLd+b8cf85bckOEl1ldP1cISJH2BU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oHwMgZD4O+ZiIrf3XoVfjuWNUZq8XIR/LWFPlYDm8zFbc94lISjpaQfj8VYiZ6oX79APmN5S0dKElERJyq7pu5sNwxkBHDJ39g1fh9kXTxKwkTckGfOnPjVXM6byXZzkA7jof2PHMstJLFyOARRfspmbHcXQKqyH9JTj9jZrY5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 70036605EE; Sat, 13 Jun 2026 23:31:24 +0200 (CEST)
Date: Sat, 13 Jun 2026 23:31:19 +0200
From: Florian Westphal <fw@strlen.de>
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, phil@nwl.cc,
	yuantan098@gmail.com, yifanwucs@gmail.com, tomapufckgml@gmail.com,
	zcliangcn@gmail.com, bird@lzu.edu.cn, bronzed_45_vested@icloud.com
Subject: Re: [PATCH nf 1/1] netfilter: xt_nat: reject unsupported target
 families
Message-ID: <ai3MJ2P2MnXLxcmb@strlen.de>
References: <cover.1781144570.git.bronzed_45_vested@icloud.com>
 <5722ce33544cc22da3f811de77ab57847eb58366.1781144570.git.bronzed_45_vested@icloud.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5722ce33544cc22da3f811de77ab57847eb58366.1781144570.git.bronzed_45_vested@icloud.com>

Ren Wei <n05ec@lzu.edu.cn> wrote:
> xt_nat SNAT and DNAT target handlers assume IP-family conntrack state
> is present and can dereference a NULL pointer when instantiated from an
> unsupported family through nft_compat. A bridge-family compat rule can
> therefore trigger a NULL-dereference in nf_nat_setup_info().

Are you sure this is related to nft_compat?  What prevents attaching
-j D|SNAT to classic ebtables?

> Reject non-IP families in xt_nat_checkentry() so unsupported targets
> cannot be installed. Keep NFPROTO_INET allowed for valid inet NAT
> compat users and leave the runtime fast path unchanged.

Not so sure, I don't think there is harm in allowing NFPROTO_INET but
such users should not exist.

Patch is fine. There are already many different targets here,
I don't think we should do a NFPROTO_IPV4 / IPV6 split in this case.

(redirect & masquarade are ok, they register via IPV4/IP6 only).
