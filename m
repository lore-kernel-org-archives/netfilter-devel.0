Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4931DE8A3
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Jul 2025 10:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752746752; cv=none; b=WebahqKgmHvIFiH02H2iFF2kt6uMSgua04hCaVDBqEx8GMBgoQahkC5qzGU3MeLZh5HoqpFf3pFzDC9pNt0c6sNr/dadCZrM+BcXZf6CQ4C+4djl+FbCSVtyGcMTPRZ4p1dkmBr0Yr2PG0vRlVlB9zCM94R538KdR6aF7I/P/7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752746752; c=relaxed/simple;
	bh=pXFnICH0asLfGWQsyAaC/fo0tjSOxAgG/yuwOxeqsns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RrZ17aCHM5sIER+g0a69GGJkbSUfndw70cMeWwmPgmyRUq2L/TbgFWAeeS0+iL5sG4rqz8lh3xaxmQijMqCouosOvaUekado/+a2Ou6Pp+3BxMVL4h8Rq81YAIQSsUjLEn6rbC2q/kgRVzknk73D/0EIbCDOPA4AWtTFxFZUK2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=T1ePOvC7; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="T1ePOvC7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=PAzkwWpQnaO+TfZrMrmS9/FsqLz5sZBoH1JU5geFxU8=; b=T1ePOvC7anAsbWAQAnpj1hpxJy
	ii1afk6bBQxyM0nhmPkPtLrYPueYWD3YgT53yqNgpckplQgisgunJXqxLK3sL92L362gjG2mCsJHt
	grx3TtzoMROpoQFnq35mTNwVGyRCYUs9PwgDEmuVa9mB6BhzH8bdp/evxWmldZ4skwmLUyh0eOMnQ
	YJ968/IIWhgW7jx8XFWx6h+sZ1BNqDrktk+ScjYIEPJKP12lueaWMEx9A2zxLMHc6SvYuNPXib8z2
	XyVu1CI6s/SammHSv7R8R7gI0fieWFi45XiPmdHA5RbHjwYiyh/rt5aPzyfLuSkx+9iYOx0r5KPL2
	oGrxP5kA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ucLUo-000000005T5-1l4E;
	Thu, 17 Jul 2025 12:05:46 +0200
Date: Thu, 17 Jul 2025 12:05:46 +0200
From: Phil Sutter <phil@nwl.cc>
To: shankerwangmiao@gmail.com
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables v2] extensions: libebt_redirect: prevent
 translation
Message-ID: <aHjK-qqHoUYRVMHX@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, shankerwangmiao@gmail.com,
	netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
References: <20250717-xlat-ebt-redir-v2-1-74fe39757369@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250717-xlat-ebt-redir-v2-1-74fe39757369@gmail.com>

Hi Wang Miao,

On Thu, Jul 17, 2025 at 04:27:37PM +0800, Miao Wang via B4 Relay wrote:
> From: Miao Wang <shankerwangmiao@gmail.com>
> 
> The redirect target in ebtables do two things: 1. set skb->pkt_type to
> PACKET_HOST, and 2. set the destination mac address to the address of
> the receiving bridge device (when not used in BROUTING chain), or the
> receiving physical device (otherwise). However, the later cannot be
> implemented in nftables not given the translated mac address. So it is
> not appropriate to give a specious translation.
> 
> This patch disables the translation to prevent possible misunderstanding.

ACK, better drop the translation for now if it behaves differently to
the original.

> Fixes: 24ce7465056ae ("ebtables-compat: add redirect match extension")
> Signed-off-by: Miao Wang <shankerwangmiao@gmail.com>

Patch applied, thanks!
