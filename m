Received: from cornsilk.maple.relay.mailchannels.net (cornsilk.maple.relay.mailchannels.net [23.83.214.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBDE354ACB
	for <netfilter-devel@vger.kernel.org>; Sun, 19 Oct 2025 02:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.214.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760839691; cv=pass; b=aSaPVEVYg8B4G3MYTIaxdzlnRPOjW9nVGKdHd1J8qjIeNyLSmJSINNewJ441TqtqDHauHtRCVbQ8WD+XLV/7+H2mz4Z4wceKHUl25xC5KvHB2EFdit76onZydutFM2X5ellHDPC6eck+MPUakd+5TSOju+yR+sjp3aaIxsG5C38=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760839691; c=relaxed/simple;
	bh=g76xkTj+R5j5qGsUdFy0N6qJOX7Rfg6KBZUTU3NYjUg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JnSiaY2RtbdL4mUl5LnByybxL3Z3K++X9u9AsRA99oxC89fgel4x/T0Qkat5GBgZIv1vo2imnbhCfFdpalbhjXVo06TsWStqeEPRfZ9JzBmbDRMiRBfCKak6hzPoOG2mtmNJVRDj7NPfkB4Eit+6sLj+J9WoXWYqjLR6lGqhEM0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=christoph.anton.mitterer.name; dkim=fail (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b=sq/1O5VQ reason="key not found in DNS"; arc=pass smtp.client-ip=23.83.214.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b="sq/1O5VQ"
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id A21B5362761;
	Sun, 19 Oct 2025 01:50:52 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-5.trex.outbound.svc.cluster.local [100.117.194.179])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id D98B8360DCE;
	Sun, 19 Oct 2025 01:50:51 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1760838652; a=rsa-sha256;
	cv=none;
	b=5c6dAzcIDJ+uIGes5nZrteNkZtJYFGtlKr56pyYPx8sMq5n46l4GnAAZC0f898+fPwazRq
	Y1aEQha0t5gRa9CAYjOhjMAMKmfczjLQF4BVSOkVpwWS6tVxPbKKYKBKtkzkzDZXGSLz1x
	6oGqZ8cAeE2UEebvI0Puc9ksQLXRNWy3qdeRFSgkWsrwTmlcC2KqdcrfwR2dYeMNdMuIzc
	+bMvM0nDNJvTL1+e/IMInuOKIHV2d4hF5lK/+l7FW/KqG5HTix2Thhi0rS5rKx6iIgojwu
	K0PC7WBHSqe9UALq2mFW9Z484zDTnMnw11yhDhZwb6O16uc2dPMcWwhvUpHrWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1760838652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xhDpF0/yC6PvNGqeTMp1400NKrvGKyLFRulvBIZOfuU=;
	b=7Ga+UzQzvK6QCSfcKrsb2wMPf+EtFMYnhtemudPK8UfscrXVtLbUomOTd9EkPhiglCEYlc
	ycrtNDv8mmKjZm794D8+s/Om2p7TS5efE7VmOITzUDUqulAvzi23H1PQhy/wVuI/1ZjPdg
	xPPKVXwrNeILjiBKXYh6dFoRrH1ANkJsin1GkPP6boSYOw5MoUBsqhrxzMrY+0Xmvy/Ck2
	EdYk41hJrAz8zfZgwgTx0cpbb6UroftxpdPZyJBC+aG1PqASxsSQgxix5/Wv/wbA9DFKji
	iRMprUf8htAbEzWOweHc+rk8xdC5icFmdMvyFcfycTwnFnMfTLuEdI4R1EZfHg==
ARC-Authentication-Results: i=1;
	rspamd-6c854d7645-dmgkf;
	auth=pass smtp.auth=instrampxe0y3a
 smtp.mailfrom=mail@christoph.anton.mitterer.name
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MC-Relay: Neutral
X-MailChannels-SenderId:
 instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MailChannels-Auth-Id: instrampxe0y3a
X-Occur-Gusty: 707e5d1575fac32b_1760838652560_3939762782
X-MC-Loop-Signature: 1760838652560:2120595901
X-MC-Ingress-Time: 1760838652560
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.117.194.179 (trex/7.1.3);
	Sun, 19 Oct 2025 01:50:52 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=christoph.anton.mitterer.name; s=default; h=MIME-Version:
	Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From
	:Subject:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
	List-Archive; bh=xhDpF0/yC6PvNGqeTMp1400NKrvGKyLFRulvBIZOfuU=; b=sq/1O5VQE3tL
	epHad8RRhBubQ1Klq9mbGXSwJHJJ0qXsfnVBfdjsL1GusTJitj3a+UE2R4xGTi/GefbbjH6NgvBS3
	m/k4UFD75JgmEqYyO46sXsc+UaAxjgJV6gqkZ0S+iS90gYRwQl09+S9cnQFMfWjai4fb4D5jiourz
	BtD2fd7+dLs7Ku0FvEzAAkUHR/KbTEDq4E/yiMUjCJwqnbGvPACO9AktHntEoeqyiruTUGy7R/4v9
	WZtpgYzwiw/KtVhEWL1SulIm7XasIFu5R/ILArE+eK6a6yRA0Mnfg7q6UpThTJ1zf75djiTh+V0IL
	L5Pn7W0156PymmqNAnhZVQ==;
Received: from [212.104.214.84] (port=38721 helo=[10.2.0.2])
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <mail@christoph.anton.mitterer.name>)
	id 1vAIZQ-0000000DVJw-2ub5;
	Sun, 19 Oct 2025 01:50:50 +0000
Message-ID: <ce20de5c38e3e60011f66e3e89e2921607dd91c3.camel@christoph.anton.mitterer.name>
Subject: Re: [PATCH v2 7/7] doc: describe how values match sets
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Date: Sun, 19 Oct 2025 03:50:48 +0200
In-Reply-To: <aPObdWdH3N9jBWkB@strlen.de>
References: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
	 <20251011002928.262644-1-mail@christoph.anton.mitterer.name>
	 <20251011002928.262644-8-mail@christoph.anton.mitterer.name>
	 <aPObdWdH3N9jBWkB@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-5 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-AuthUser: mail@christoph.anton.mitterer.name

On Sat, 2025-10-18 at 15:51 +0200, Florian Westphal wrote:
> Yes, or if its contained in the range (for ranged sets).=C2=A0 E.g.
>=20
> 1.2.3.4 will match a set containing 1.2.3.0/24 or 1.2.3.2-1.2.3.5 for
> example.

Damn... knew I forgot something.

I've changed:

diff --git a/doc/nft.txt b/doc/nft.txt
index 09da6f28..e0ed4b11 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -777,7 +777,7 @@ effect.  Adding *1.2.3.5* changes the existing range to=
 cover *1.2.3.1-1.2.3.5*.
 Without this flag, *1.2.3.2* can not be added and *1.2.3.5* is inserted as=
 a new entry.
=20
 Equality of a value with a set is given if the value matches exactly one v=
alue
-in the set.
+in the set (which for intervals means that it=E2=80=99s contained in any o=
f them).
 It shall be noted that for bitmask values this means, that
 *'expression' 'bit'[,'bit']...* (which yields true if *any* of the bits ar=
e set)
 is not the same as *'expression' {'bit'[,'bit']...}* (which yields true if


It would be included in any further iteration of the series - I just
didn't want to spam with a v4 with only that change now.
Or you could just apply manually.


The "in any of them" is a bit fuzzy, as intervals are, IIRC, always
non-overlapping, so it can always be contained in only one of them.
But I don't think this matters here and isn't disputed by the wording
either.


Cheers,
Chris.
