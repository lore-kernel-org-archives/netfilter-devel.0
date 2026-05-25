Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622078462
	for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2026 17:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779731626; cv=none; b=nHC5jtfyHNsFsjcT6NOKP4v/UNse6WQ18vDVIq1M5oFkUr0GTuXfiSVQfltOdgpCtvm5mf3i16gsjTTYAGiFlB7gxcO382q8CUqBWZ/2oTw7WpOqrfjUDPbhWi4TxRGWA7cf1XG87E1RDQ8wWYlB+m5EhBl3W5SjBKP5y2CsVeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779731626; c=relaxed/simple;
	bh=eGZGnF1/vH/i8T6SXiT16xpmMF9oB/vu5Ss2uA3zkIk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=HoF+Dt4HbPHy489eAEg34B10r91w2+5qjBuS5vsoFtvVyT0kMjbgLoCEcg/E+WOmvfchwPjlkXNJeUsYzadFSmGtjDXUJ1uiuYFQQky9g8+XSh4Ukk8YDyCBidBYe50jlA3anPyQrxSzoJwucGEBGUMjBl9qBJOolU9M41dC4dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9677260595; Mon, 25 May 2026 19:53:35 +0200 (CEST)
Date: Mon, 25 May 2026 19:53:35 +0200
From: Florian Westphal <fw@strlen.de>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: netfilter-devel@vger.kernel.org
Subject: Followup needed for netfilter: nft_fib_ipv6: walk fib6_siblings
 under RCU?
Message-ID: <ahSMn9GB65ztRN2e@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

Sashiko claims we need this change:

diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -191,6 +191,9 @@ static bool nft_fib6_info_nh_uses_dev(struct fib6_info *rt,
 
                if (nft_fib6_info_nh_dev_match(nh_dev, dev))
                        return true;
+
+               if (!READ_ONCE(rt->fib6_nsiblings))
+                       return false;
        }
 
        return false;


Could ypu please check and send a followup if its correct?
AFAICS the nodes can be relinked to a *different* list and
then this turns into busyloop without the extra test.

https://sashiko.dev/#/patchset/20260520023411.391233-1-jiayuan.chen%40linux.dev

Thank you.
