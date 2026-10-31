Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793471694;
	b=5Rw2Qmy4GQ3J1RqNSVpKXi45IJiRuc6Z3fDALJIWkIG4xSKXXPBbLd4qrpS8G0KUu8sj
	 Wq5ePxlvCrQ71zv80HBlggiq5sxeLUW2ODcINqDGViFzxhSsstjQ3LQvhXrpm8BEnqtao
	 QZ7cPrcZSJLf1fAdXa7KGGSybROpqkE+P1ii2hncPRR+LSHk2HSYDy/pHKWlMo9U2j6rq
	 PwxGBMdwl43lvrXWOjRl+zxRvPwgJ9E5gs15+lyVas4XBI4/r64IPUiga71K/AJfWUwhQ
	 Ria0gNuTzVTEikvQqYhbmz3+8wMFUbaPv7WrD/LBzA3hsOmdBMHfOYK59OVLw+rACjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793471694;
	h=DMARC-Filter:Received:Date:From:To:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=PsE+YmlAQ7SV6RoeByIN6HeKWCRdQ8xGuXMhcYA7YyM=;
	b=cAeIYhRGg7CCXR2+fvgdK4qe3Zu8Onxyl4W0aKWv0OdelnvPK3RQXmt5SOuFsBRKCPsr
	 H4iHe9CBfYr4DnUZmbB/hYewpdXe7QxsBOZFApbqt1taHG+OovGE/YY1LgzjMPrmrAy9B
	 pH/SoCkiYFh7W9quo5c8W716Ng7Jo1nxPEpd5QEcp+BDMNEpaf0rRqANggdlGpaD11q8x
	 rO5cUJfndzoMqoCaU1p2/BgEoz+DaiuRcUoNidEhF2yOWw+OS4JOu73/welc8JeWB+h9y
	 jhxtJVaxeQKL8MwiZrAgfKaId3wJq5TTQDWZTsgtjoI9S9sH11YlYGkLX/JfQlL85Lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C35606A31A
	for <netfilter-devel@vger.kernel.org>; Sat, 31 Oct 2026 18:34:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A6C35606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 00EA160796; Sat, 31 Oct 2026 19:34:41 +0100 (CET)
Date: Sat, 31 Oct 2026 19:34:41 +0100
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 0/4] netfilter: logging cleanups
Message-ID: <auY0wSMHLn3ZDKLg@strlen.de>
References: <20261030154433.13601-1-fw@strlen.de>
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
In-Reply-To: <20261030154433.13601-1-fw@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> 3) Extract dev_parse_header usage into a shared helper for nfnetlink_log and
> nfnetlink_queue, clamping hw addresses to 8 bytes and validating the skb
> mac header. Add BUILD_BUG_ON checks to assert identical container struct
> layouts.

LLM comments convince me that this needs to be re-targeted to nf-next.

I will submit a v2 next week.
