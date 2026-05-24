Received: from out-12.smtp.spacemail.com (out-12.smtp.spacemail.com [198.54.127.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3DA2494FE;
	Sun, 24 May 2026 11:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.54.127.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779621902; cv=none; b=n0pM4ipNTTSYnJ35rB/bq+0uU2t4cf2XRTbzx/N921wi5xqIT+mzeLVoa9wpj6DuzQxsYpwMlfuDiS+mXQNNL+dxMIu+UMmWcE3l5Nj2ZUeI7Mpx/V2xgLpvnHIUtM52YgzfrVHp9lPM4UpkgPoNPm2O69Y9fFVSyNoLoHRcENc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779621902; c=relaxed/simple;
	bh=qenjscNh1f8clKsOgQfQt/PXt7PexEisYMMD+pJ4Pks=;
	h=From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-Id:Date; b=WP0Taa6JNT5w8LCmEBtnBL/e0bHbgYY/yKYs9Rp2twYVZBX9EE6J/ab9Q82GM47THXafts15IqcKTcoU47ad5G9vLEEb68fZtfuQSPtBPee4vKiJZF5VJG+cFIwBSuOQrGt/pXUi2mtzJmvwNn2k8DUSMnVZzpwRFYeLSQcI4yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai; spf=pass smtp.mailfrom=rexion.ai; dkim=fail (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b=m2Xnu9iF reason="key not found in DNS"; arc=none smtp.client-ip=198.54.127.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rexion.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b="m2Xnu9iF"
Received: from [127.0.1.1] (unknown [49.207.213.66])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4gNbyT3lKNz8sX8;
	Sun, 24 May 2026 11:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rexion.ai;
	s=spacemail; t=1779621301;
	bh=w5RpyG4/aQvV3ylagbYpeH1Folp9rSlHgTQMQ/w/Dzw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=m2Xnu9iFTXKWi+s/j6qmwcFOGnR0mEdVal5yRU6++pBz+PkYiLv76kAJ0d4qmcWD+
	 chDcMD3/EA+b1gcWatGrChUYx7T46JRcYvBLukfSw/904kiKnwcU8/7IJeav1vVhbe
	 P701kC8xEDe1bCKb7bQDkLES2SftMQJ8bl0hZ8zBBtj2IRWxaFyzym8c1aMAzAXCaQ
	 yJ1DFZQ8gZygam21sJ7hs7rIyLqTc6OmbI3TY2wXUopdSCa8MZWjx2FUbmV7vh/uES
	 MWzyfGWRynjcZLUAdaWW2B6MlKISRw+UAaFB4qrTSeB2HRow4Tyslw4W9jTbpv5gSX
	 ANnJtiF+xPRJQ==
From: Rahul <rc@rexion.ai>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
 David S. Miller <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/4] netfilter: conntrack: add shared port and
 uint parsers for helpers
In-Reply-To: <afpwLbN-W2Sur5Qu@chamomile>
References: <afSBzDE-caw3Dsr1@orbyte.nwl.cc>
 <20260503083220.630655-1-rc@rexion.ai>
 <20260503083220.630655-2-rc@rexion.ai> <afpwLbN-W2Sur5Qu@chamomile>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <4gNbyT3lKNz8sX8@mail.spacemail.com>
Date: Sun, 24 May 2026 11:14:57 +0000 (UTC)
X-Envelope-From: rc@rexion.ai

On Sun, May 03, 2026, Pablo Neira Ayuso wrote:
> You will need a "real name" here.
> In nf.git, there is a new function sip_strtouint() that can possibly
> be moved to nf_conntrack_helper.c.

Apologies — my name is Rahul. v4 will use "Rahul <rc@rexion.ai>"
throughout.

I looked at 8cf6809cddcb ("netfilter: nf_conntrack_sip: don't use
simple_strtoul"). Florian's patch adds two local helpers:

 - sip_strtouint(): generic bounded uint parser, used for expires,
   cseq, clen, code, and port in process_sdp().
 - sip_parse_port(): port-specific wrapper around sip_strtouint(),
   used in epaddr_len(), ct_sip_parse_request(), and
   ct_sip_parse_header_uri().

My v3 patch 4 already converts ct_sip_parse_request() and
ct_sip_parse_header_uri() to use nf_ct_helper_parse_port(), which
overlaps with what sip_parse_port() does.

Would it make sense to:

 1. Align nf_ct_helper_parse_uint() with sip_strtouint()'s design
    (same endp-on-error semantics, UINT_MAX cap) and export it.

 2. In patch 4, drop sip_strtouint() from nf_conntrack_sip.c and
    replace all its call sites with nf_ct_helper_parse_uint(), and
    replace sip_parse_port() with nf_ct_helper_parse_port()?

That would consolidate both local helpers into the shared core and
avoid the overlap. I am happy to send a v4 along those lines if that
is the direction you prefer.

Thanks,
Rahul
