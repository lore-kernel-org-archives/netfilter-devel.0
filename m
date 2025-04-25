Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A207C1607AC
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Apr 2025 14:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745592546; cv=none; b=WY4hG309Tag1hSHsx/+mK1f5R+DyvsJ0gi9yzz21eAeMQg+6oWaoRlm1nesouVR9LRXSPV2Z1cxICUU3y1KKTh2S0JRbc7cAPJvMWYE65ComK9+dCh6yFsbLXBqt+FouoY0Fh0FsjVPed2Hhw5p0dAHZkeEO4AraZrZoPUCDj3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745592546; c=relaxed/simple;
	bh=NRXkvITygKR/z9y5VIg8S8I6x7pzTe5sOajbSOHKpHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JZBN6Ch9zOHL99eK9J0OMpwtdTC0g7NKsQpV0XFES/BYoQl5pSJyDtUJbiycYbDSNaFNhNtHSx41h0lgzz+w8KaP2AhTdjGwk6ZpEnt9y97sFL1EIu2gJSOMX0XbQhQwqi9BbiG60E5YNIOcRpagu8dB2XX/vMfzbZdLIUrNLVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=EsPJM0pI; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="EsPJM0pI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=b3PS4Jxcj1r7YIi5EkHSG/r2E8ZbmdYLk4cP+cySzrA=; b=EsPJM0pIiuPeybi1Js0GpMncQs
	AO1eljcUUNI9XFgkTTm41mVAtNIisukG0HTUJl5OfnfxE9TEcSBU2wAQFMSPhdfaLmGayXWlwkRlY
	rxkCjcQT1AqDcgjo8UrgUrkHKsJtU0oOdowadg5vabyc/ySKYbhDjeAvLxBwFgtI/cyAmLnrihshZ
	JBp2IgTipoSymFCWfJPHK4rGvewHd1kdyjBZ5YpHI3EBD9605Q0lk+k4xDnwLC3iqS3Q3LZDZ27Cj
	Z3Jupof27pJmZWF4q58Af6/fVE7M/AuoxZWj0W11Lw4DFJ4ko7PoK+mKicrX+b89hP0S8lz9cw2VX
	RivSkY2A==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1u8KMI-000000001yE-3hwV;
	Fri, 25 Apr 2025 16:48:54 +0200
Date: Fri, 25 Apr 2025 16:48:54 +0200
From: Phil Sutter <phil@nwl.cc>
To: Miao Wang <shankerwangmiao@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables] extensions: libebt_redirect: prevent translation
Message-ID: <aAug1glDE3CekwQo@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Miao Wang <shankerwangmiao@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250425-xlat-ebt-redir-v1-1-3e11a5925569@gmail.com>
 <aAtPd3QF-2v8TNCe@calendula>
 <37E09A07-36FE-4F90-AB3E-9DB5701B86CD@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <37E09A07-36FE-4F90-AB3E-9DB5701B86CD@gmail.com>

On Fri, Apr 25, 2025 at 05:07:04PM +0800, Miao Wang wrote:
> 
> > 2025年4月25日 17:01，Pablo Neira Ayuso <pablo@netfilter.org> 写道：
> > 
> > On Fri, Apr 25, 2025 at 04:44:24PM +0800, Miao Wang via B4 Relay wrote:
> >> From: Miao Wang <shankerwangmiao@gmail.com>
> >> 
> >> The redirect target in ebtables do two things: 1. set skb->pkt_type to
> >> PACKET_HOST, and 2. set the destination mac address to the address of
> >> the receiving bridge device (when not used in BROUTING chain), or the
> >> receiving physical device (otherwise). However, the later cannot be
> >> implemented in nftables not given the translated mac address. So it is
> >> not appropriate to give a specious translation.
> >> 
> >> This patch adds xt target redirect to the translated nft rule, to ensure
> >> it cannot be later loaded by nft, to prevent possible misunderstanding.
> >> 
> >> Fixes: 24ce7465056ae ("ebtables-compat: add redirect match extension")
> >> Signed-off-by: Miao Wang <shankerwangmiao@gmail.com>
> >> ---
> >> extensions/libebt_redirect.c      | 2 +-
> >> extensions/libebt_redirect.txlate | 6 +++---
> >> 2 files changed, 4 insertions(+), 4 deletions(-)
> >> 
> >> diff --git a/extensions/libebt_redirect.c b/extensions/libebt_redirect.c
> >> index a44dbaec6cc8b12f20acd31dcb1360ac7245e349..83d2b576cea5ae625f3bdf667ad56fc57c1665d9 100644
> >> --- a/extensions/libebt_redirect.c
> >> +++ b/extensions/libebt_redirect.c
> >> @@ -77,7 +77,7 @@ static int brredir_xlate(struct xt_xlate *xl,
> >> {
> >> const struct ebt_redirect_info *red = (const void*)params->target->data;
> >> 
> >> - xt_xlate_add(xl, "meta pkttype set host");
> >> + xt_xlate_add(xl, "meta pkttype set host xt target redirect");
> >> if (red->target != EBT_CONTINUE)
> >> xt_xlate_add(xl, " %s ", brredir_verdict(red->target));
> >> return 1;
> >> diff --git a/extensions/libebt_redirect.txlate b/extensions/libebt_redirect.txlate
> >> index d073ec774c4fa817e48422fb99aaf095dd9eab65..abafd8d15aef8349d29ad812a03f0ebeeaea118c 100644
> >> --- a/extensions/libebt_redirect.txlate
> >> +++ b/extensions/libebt_redirect.txlate
> >> @@ -1,8 +1,8 @@
> >> ebtables-translate -t nat -A PREROUTING -d de:ad:00:00:be:ef -j redirect
> >> -nft 'add rule bridge nat PREROUTING ether daddr de:ad:00:00:be:ef counter meta pkttype set host accept'
> >> +nft 'add rule bridge nat PREROUTING ether daddr de:ad:00:00:be:ef counter meta pkttype set host xt target redirect accept'
> > 
> > this is not a working translation, I don't think this is leaving this
> > in a better situation than before.
> 
> Or can we fully remove the translation? The translation result is
> really misleading, because the result is a valid nft rule statement
> but cannot work as intended.

Returning 0 from the xlate callback aborts the translation. This will
cause nft to print 'xt target redirect'. :)

Cheers, Phil
