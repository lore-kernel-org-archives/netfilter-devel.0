Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C594D4898
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Sep 2026 18:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790016618; cv=none; b=S4+l9bnsKJupqZomNTI2w0Jk956r5QsynjVpHwaDV3zW6dgyibdg1BVjDbm+FREddKcgQBCkPOHobCyU1S8aqAzPDjm42su6xCiE342uAeXtWmWTWdwDTNLdHqplUyfDyPfuM9OT2Kf9Yi5xT+VY8sRyWGB0UbupyakIy8Jf3TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790016618; c=relaxed/simple;
	bh=IYPVhIIHColpz3Xe6PKSkjVxLZO93KObBuZH7JJjGVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i5UbDS1KlXRejAqNG1nJvlu+DuBUPxmZ16C0iaUoZAxYBfZhcVHsxDikpMpYmPgVddDPFvx2hSmKi1NlRhNHE3AIxsbdfw8za7MWjmojy/LxlsCswXW5lahkGkCNar+GwO8/TG8khP6BMAOSgsZAaC/xOHLV3h1e/kmlniRoI88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B06B860456; Mon, 21 Sep 2026 20:50:13 +0200 (CEST)
Date: Mon, 21 Sep 2026 20:50:13 +0200
From: Florian Westphal <fw@strlen.de>
To: Adrian Moisey <adrian@changeover.za.net>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] payload: restore is_raw flag for th expressions
 parsed from udata
Message-ID: <arF8ZZGEPiT7VgrF@strlen.de>
References: <20260825191048.95426-1-adrian@changeover.za.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825191048.95426-1-adrian@changeover.za.net>

Adrian Moisey <adrian@changeover.za.net> wrote:
> payload_expr_parse_udata() restores the pseudo transport header (th)
> proto desc from set userdata, but not payload.is_raw. The bison and
> json parsers both set is_raw for raw th expressions, which makes
> evaluation skip the transport protocol conflict check. Without it,
> re-evaluating a map declared with 'typeof ... th dport ...' from a
> later transaction fails with a bogus
> 
>   conflicting transport layer protocols specified: tcp vs. th
> 
> Set is_raw when the restored desc is proto_th, just like the parsers
> do.
> 
> Signed-off-by: Adrian Moisey <adrian@changeover.za.net>
> ---
>  src/payload.c                                 |  3 ++
>  .../testcases/maps/typeof_maps_restore_0      | 28 +++++++++++++++++++
>  2 files changed, 31 insertions(+)
>  create mode 100755 tests/shell/testcases/maps/typeof_maps_restore_0

Hint: "run-tests.sh -g" also generates the dump files.

Just mentioning this for future submissions, patch is applied,
thanks.
