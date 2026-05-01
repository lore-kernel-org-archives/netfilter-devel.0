Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B8F2C0323;
	Fri,  1 May 2026 10:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777631697; cv=none; b=iqIkmsmBK4Rws56jK4Z6SGnPYQAHEYiLYUBZNqz9AWj53VXcl7VY2ID9qCZacpH9u4zvwdx69UyFb1fbOGlzk9nARdOQkNqURjWF8iwJKDQmeU4LVQyfZiVWA7AtKCs9H5ni3GuP5+M6C9jyjmnpyGmezcBQj7uELQljusucAJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777631697; c=relaxed/simple;
	bh=4R2d+PO1s4GRghqVVGeZVJvO4QKPS8Dl1O6igHjjIss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i1f48XK4ydoPhKa2ZdWU7/kFviUJoANO8KH39vW1BgN9nWyiCPJti1ntj/KxAjnygjwwOB+2t4yDpQ0aF5Ps15TVX7xg1G8jeWC3ZA3NRDx0JtqVYZTdpgyRVbY/YGIHZE86s8Ob8YTuqYBbRrkf7WNnv14ByL2ltRqAApD9fy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=VyOoazpr; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="VyOoazpr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=aDBEEjkiSXpgJH2USnaJxMirYPdb5GCRweTME9xpuQk=; b=VyOoazprwdamsKeHm3ElEUyUKM
	lgJtzRlrG8FX36Vca7VJsqU7ZUlR4RInB7aXS5gwxds1nQl6ASUA9SbGOcxGwlsVx5wgXHY67zxF+
	OadDY3QKm5nT0q7zCoIvVw2mexSdRXRo9hNmbejhonTg8kOeW/PbOulHThs/0IjdOteQLYX0lMtXi
	gHfYpTdfKSA/k6iC4BA0dFs7C5ySgjpxRrnk1/4rGoLNcAUzI0prbQ+takIzWjOItpdDSCAkKdlNC
	uzxniUeWSytM5u8aAN82/GdpETe5rLUWeKffKzb8thjFggU5trzd8MfKhkK/VwmKRQpmrCi4XfEGV
	EafjqIgg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wIlCu-000000003rE-1z6L;
	Fri, 01 May 2026 12:34:52 +0200
Date: Fri, 1 May 2026 12:34:52 +0200
From: Phil Sutter <phil@nwl.cc>
To: HACKE-RC <rc@rexion.ai>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/3] netfilter: conntrack: add shared port
 parser and use it in IRC and Amanda helpers
Message-ID: <afSBzDE-caw3Dsr1@orbyte.nwl.cc>
References: <20260501063156.2520780-1-rc@rexion.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260501063156.2520780-1-rc@rexion.ai>

On Fri, May 01, 2026 at 12:01:53PM +0530, HACKE-RC wrote:
> Both nf_conntrack_irc and nf_conntrack_amanda parse port numbers
> from application-layer protocol data using simple_strtoul(), which
> relies on nul-terminated strings and returns unsigned long without
> range checking. Port values above 65535 silently truncate when
> stored in u16.
> 
> This v2 adds a shared nf_ct_helper_parse_port() function to the
> conntrack helper core, modeled after the approach in 8cf6809cddcb
> ("netfilter: nf_conntrack_sip: don't use simple_strtoul"), then
> converts both helpers to use it.

Looking at Florian's patch, how about going the extra mile of
implementing a shared nf_ct_helper_parse_uint() which is called by the
new nf_ct_helper_parse_port(), then drop sip_strtouint() for the former
and have sip_parse_port() call the latter (wrapped by the colon and min
port value checks) in a fourth patch?

Cheers, Phil
> 
> Changes since v1:
>   - Added shared nf_ct_helper_parse_port() in the helper core
>     instead of open-coding range checks in each helper (Pablo)
>   - Parser does not rely on nul-terminated strings
>   - Dropped simple_strtoul usage entirely for port parsing
> 
> HACKE-RC (3):
>   netfilter: conntrack: add shared port parser for helpers
>   netfilter: nf_conntrack_irc: use nf_ct_helper_parse_port()
>   netfilter: nf_conntrack_amanda: use nf_ct_helper_parse_port()
> 
>  include/net/netfilter/nf_conntrack_helper.h |  3 +++
>  net/netfilter/nf_conntrack_amanda.c         | 11 ++++----
>  net/netfilter/nf_conntrack_helper.c         | 28 +++++++++++++++++++++
>  net/netfilter/nf_conntrack_irc.c            |  4 ++-
>  4 files changed, 40 insertions(+), 6 deletions(-)
> 
> -- 
> 2.54.0
> 
> 
