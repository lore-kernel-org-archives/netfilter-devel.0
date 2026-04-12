Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D653E2BE7CD;
	Sun, 12 Apr 2026 17:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776014246; cv=none; b=GgBb4RvgMN708aXM/3j/FjrFzLLj+0AdGryE0FYHGK/3xtVLlrf7J0D/c5SXXmCIvscs0r5/pf9xrPO+n8fylcihNwCFq/u4WOK5muW8Tv5jRox6W7DRtE+KJpcwKhM2XmjS/jVgsCdA76P/7Or+zgLiHw3FBimGyG/DZBXS6HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776014246; c=relaxed/simple;
	bh=CzfTOj4mUNn2bmRFGl/gGFgp2GcpRDFPE4OAXwXXrJs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n0MDq3BKJWN+9nC0uJX5NwEmCKb5BaKnV72AKfKs6H9KnWZuTr026crufOg+6C6KyUgQA7CINbf2hk3X8It6GKTMVkbYLlBSd3RvTdeZxW6MCNfJf76G7vfokPoPkm9aAzIeHh0D9l95Q45qUG3pzDPKki4lTv2evmLnrKIgTG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C6D26602AB; Sun, 12 Apr 2026 19:17:22 +0200 (CEST)
Date: Sun, 12 Apr 2026 19:17:22 +0200
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH net-next 00/11] netfilter: updates for net-next
Message-ID: <advTosG9qZ_ZW355@strlen.de>
References: <20260410112352.23599-1-fw@strlen.de>
 <20260412094049.7b01dd7b@kernel.org>
 <advOUl92VLlqaiCJ@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <advOUl92VLlqaiCJ@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> Jakub Kicinski <kuba@kernel.org> wrote:
> https://sashiko.dev/#/patchset/20260410112352.23599-1-fw%40strlen.de

Forgot to mention this:

---------------
AF_PACKET raw sockets or tun devices, the network_header might be
uninitialized (~0U). In this state, skb_mac_header_len() will evaluate to
a very large number, bypassing the ETH_HLEN check completely.
---------------

Really?  TIL.

---------------------
Furthermore, skb_mac_header_len() only verifies the logical distance between
header offsets, rather than ensuring the bytes are actually present in the
physical linear buffer.

---------------

Really?  Total news to me :-(
