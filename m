Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6446E26561C
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Jul 2025 12:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752755037; cv=none; b=Jq6GTz8yai6+WJjJ8/F18uDfYx28QP1iK9VcHuHGwajy+3IXRqzVH3ez5VoBNND3CUViWD0QRWv0Y0/LZyuNcUCO3TBgvYMxpkwW0ayQquXMKB3QSC72Opd9VeYyex2e1Js+KL4H9mQZPeZDUoeIorsjHAwoRFRgl4G78qVd8sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752755037; c=relaxed/simple;
	bh=qNDfIj7z3NG4EaTvh5UweX1sjnYFKbJnoDaY9nZDV0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RofoD94QIVaxSs5vaqKYIy8c518Od/fnUo283rTOGlsiqG9SjspspdipUV8Mx1r0CQOsHADnL1CKbAkOvrduxeVK0lxhzbyI/6B+yMBDPIZTYZW1WxyGq5P27abulnDsNYvKw04ungmhoocS1a1foIlzKjdwdNeICqUpgRjGEdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Gjbx82+e; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Gjbx82+e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5pUYrzn+t2DMRKxntcyz8vvyyQTcI0DR1jKcZzrwXik=; b=Gjbx82+eI8S2H9Xr5J2wALdaDw
	7GdY6RCdJmRQce4Gan2dJcWPuhWuXTXTej2NoPIgSxk4w6AbBgcO3AeIX8Q2h09s2G2Ledqy5TpBp
	VlHTAXW52VuBEsWbB1Tro8WWgxr52tz+SpS/DnZyA41Tg4oKT3DZTimI6u4yyrHOq5LrMuiq8QH/p
	PHqBTJ7byQUo96qaxAwqLOgC2mtKHyFjhIgmocseBDTPmi6tqEK+6JncYBwiUF2gtxz4MgtCZ0ZG+
	kFTi9E2b8mFnTacVVM/3IL3otsohtc3LXcb96ax1f4Fe7D/t0jJAhnPgcum5qGdfqONiuTXKdgoo0
	8Or4/1pw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ucNeR-000000002wL-4C09;
	Thu, 17 Jul 2025 14:23:52 +0200
Date: Thu, 17 Jul 2025 14:23:51 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: shankerwangmiao@gmail.com, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables v2] extensions: libebt_redirect: prevent
 translation
Message-ID: <aHjrV-YUot_fKToY@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>, shankerwangmiao@gmail.com,
	netfilter-devel@vger.kernel.org
References: <20250717-xlat-ebt-redir-v2-1-74fe39757369@gmail.com>
 <aHjmETYGg4UtDdSf@lemonverbena>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aHjmETYGg4UtDdSf@lemonverbena>

Hi Pablo,

On Thu, Jul 17, 2025 at 02:01:47PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Jul 17, 2025 at 04:27:37PM +0800, Miao Wang via B4 Relay wrote:
> > From: Miao Wang <shankerwangmiao@gmail.com>
> > 
> > The redirect target in ebtables do two things: 1. set skb->pkt_type to
> > PACKET_HOST, and 2. set the destination mac address to the address of
> > the receiving bridge device (when not used in BROUTING chain), or the
> > receiving physical device (otherwise). However, the later cannot be
> > implemented in nftables not given the translated mac address. So it is
> > not appropriate to give a specious translation.
> 
> It should be possible to expose the bridge port device address through
> this extension, see (untested) patch.

Yes, that looks good!

> Then, it should be possible to provide this translation:
> 
> ebtables-translate -t nat -A PREROUTING -d de:ad:00:00:be:ef -j redirect
> nft 'add rule bridge nat PREROUTING ether daddr de:ad:00:00:be:ef \
>         counter meta pkttype set host ether daddr set meta ibrhwdr accept'

Now in broute table, ebt_redirect.ko sets the ether daddr of the packet
to that of the incoming interface, i.e. the bridge port not the bridge
itself. We'll need an extension for that, too right? I guess just
calling 'redirect' verdict will manipulate the IP header as well which
we don't want.

Cheers, Phil
