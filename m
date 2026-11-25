Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=151.80.46.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795602717;
	b=J1CtKOIDERFKHBS02SabvVz3E5yDQa7AWEG04G32jmYkyZEOiAF5WTI6mFdgPrxoLPAq
	 G2O2SPyb0fqsN1X/czuUpOC/3opGsIQD+H3BapP+G0hKESHgStU6rOmf83BxTH+YlLE9J
	 6uoc6lJ1DNLOOnZN3Kv4xU1kC3NHPxwhQ6plM8OmvukCpgApaz+urPaFwvS2AKPufkvXT
	 LCgc7D4eVTwHHzf+mZHH41avy2nqy/b0HMe8Nyi1hIZWkf7CO6pYPc6BroE2zbo8AvYpK
	 fsxAzxL14Yg/OmBnvcul0cy1nrW47uFZaDYjPvfQr/0wjPp2QX3/MrfKLaCjarGn3Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602717;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=7sbOkZewso/3bjBRRvOOmoNHFckVZRLv5PjcLSe2WeI=;
	b=0exXjthq2fctYyZApub5eUTj8v+WPH+SC2oqm30D4tggzqxR6tTow+MDJ0nGDXHDbs7/
	 h/akIOGtuLZj8N/nWc+YemqCQ8MZrgwbMp3T3RVU83n4K8/kzvGktgBkDrH8iG6yGu7Bh
	 fjBV6fxp02V0jOIxCDSN1jQX0BMl9D8AgJCSkNNzIKgV7IbUFiP163vy6g4n3xIE243SX
	 U0XVvxfGapwohzh2RbvgDlf036YKu0DJhGuOIxeQ/l4LcYuv2Ep2BaA3hLUQBButLeU63
	 oIKlha7jBDL15A3sAnD0MrgqMRtkexOtFT1MYVmiIRRUlPKla+fFEiEm+jdDjVymTdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=nwl.cc;
	spf=pass smtp.mailfrom=nwl.cc;
	dkim=pass header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=GTlTQvOl;
	arc=none smtp.remote-ip=151.80.46.58
Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4278606A31E
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2026 10:31:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E4278606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=GTlTQvOl
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7sbOkZewso/3bjBRRvOOmoNHFckVZRLv5PjcLSe2WeI=; b=GTlTQvOlfn1jl/gGysqJ5Db3JJ
	A5/9cWMkdOh6M6KOaJhOaBKb+60+IfyC6QIr0Kx/W8VTU1A9ILbcrNpoyBhyDpTh1vsbWJaRFbegN
	AJFM/PKu1iF5LcS40A0HbCZTcGbykjozKeWoD8Sh4vFfrIWXQ7BlnZzuhy1/LvnJhyXjIru26BEd2
	uTeS5OOqlqjVYdz72ZToYOWlscErAMfsURXaQ9hIRtVrx3jkoMTGWKxFX3Np5GPnY2i+yc2apMRqh
	KPYBwQgX5eTSWRXHGVNXGcoG7Of2iie5w043uzhqzZeRcDCU64QgIzSJ1Ez2KqjmWZybma/FbFqDd
	PEBBl30g==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xWAI6-000000004Lv-2pqT;
	Wed, 25 Nov 2026 11:31:54 +0100
Date: Wed, 25 Nov 2026 11:31:54 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: set key byteorder when evaluating mapping
Message-ID: <awa5GsKTiQvNkUVA@orbyte.nwl.cc>
References: <20261124235306.1777-1-pablo@netfilter.org>
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
In-Reply-To: <20261124235306.1777-1-pablo@netfilter.org>

On Wed, Nov 25, 2026 at 12:53:06AM +0100, Pablo Neira Ayuso wrote:
> set->key->dtype is TYPE_INTEGER (see integer_type definition) which uses
> BYTEORDER_INVALID by default, this is used to set up the context for
> parsing the symbols in the mapping. Set explicit byteorder context to
> address this bug.
> 
> Fixes: 144d97e151adb ("src: normalize set element with EXPR_MAPPING")
> Reported-by: Phil Sutter <phil@nwl.cc>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Tested-by: Phil Sutter <phil@nwl.cc>

Thanks for the quick fix, Pablo!
