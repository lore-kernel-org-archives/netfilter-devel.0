Received: from iguana.tulip.relay.mailchannels.net (iguana.tulip.relay.mailchannels.net [23.83.218.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C944E2D320E
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2025 00:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.253
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761698606; cv=pass; b=NQM3FVn+ll88NkiTqip40vHtTn+gXic64/UWYLWHRirIPHHabwgJzNc8F5x8dkCnQsrIkg56qOnJ0qka+Y/3+LkES9XzAP/NHdHMEWAmOXZNJyMg0UVYecD5Tj39ETs5G0/Mzy6bBN4WV2p1sNtQsCybYYcDYxTFWbuLJ7/Nzwc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761698606; c=relaxed/simple;
	bh=HMDGuIq5Wk3rqQ5IRW7KD4Q7BJ5DnhMHJsLOIuE+QSg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Io17Xm3m6ZMNBPSRUI8EJ6ATFBN8QQz9aFBUTgumxZ9vy7c7PB0JpNf98evuvvc1ZW8HPiIS3hmKts6TBaiXe5RSU5DvrHXxjy0cPOJM6pLyBC779/cTRwNqmxZZLbpJKUCNHmuGgXh4pSY+CP0rCj2NXaVPJknY6lccvaIkN34=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=christoph.anton.mitterer.name; dkim=fail (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b=TMPsJtjU reason="key not found in DNS"; arc=pass smtp.client-ip=23.83.218.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b="TMPsJtjU"
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id D6C851212FB;
	Wed, 29 Oct 2025 00:35:05 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (100-120-42-56.trex-nlb.outbound.svc.cluster.local [100.120.42.56])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id F0C531212A4;
	Wed, 29 Oct 2025 00:35:04 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761698105; a=rsa-sha256;
	cv=none;
	b=m5H49dhbiThVacnIDtdjzM+zjYJGT0RvTDiZyEbPeCUtpgcMQLa6XJHvXR/7143Z2mIm2G
	iyJNV3QSRlFic8PD8UtFIvpqvoFMhS6hpKDR3O6e/wUdZd7C31zNqhg8MNR1M1sBuWnmXc
	pqADjnzENJ2fL3oYv9k+Rq+PCVEcthE6f7QURYhqRFykOiQF6sUcXn/4dsY12v5NAS368s
	A2EmXPRLs9yKBzm/YvZd3g0j1dsczIBC607UbcepEwy8RaStFPB4zdZmbxeXJ6+1h5V3Gc
	5s52T9mDqEZfv1BYINglcxxFmNlpImUZeLsv6bbRH5sr9FVTWOf/DmJVu0xaqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761698105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HMDGuIq5Wk3rqQ5IRW7KD4Q7BJ5DnhMHJsLOIuE+QSg=;
	b=eUISFByQKja6hARqCB21sb4YyK4IGY1XNRiRf53FqB5qPq620MhumAJzTDdN0ynvBIkSPO
	MMsfBVUCfubMWngQ+NgYKMopRgt0pUHBNT5wJQEEwO06fSNZ7MpBXT+qC/KHsYkqEqHzdF
	F4LsCTylK3yfgLhl5KUQFecfZ2Qhxm4P2TVtCGEtpuE7boJLko91nH+6+3KUIA+c6zQ5Z2
	yBkSrwGeBWl1EHZ7JjeFykNT75Ae7ymE01OMwesqSLkncW1SY6ZMWmusmf5Z1aUb99r1HU
	r5m3Xv5TV1Y7VbIDp1fWkCcnba+AZwtic/ZXsKQmGWKGCza6C7onn3q92NRbaQ==
ARC-Authentication-Results: i=1;
	rspamd-768b565cdb-4szxz;
	auth=pass smtp.auth=instrampxe0y3a
 smtp.mailfrom=mail@christoph.anton.mitterer.name
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MC-Relay: Neutral
X-MailChannels-SenderId:
 instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MailChannels-Auth-Id: instrampxe0y3a
X-Chemical-Wiry: 5f54e5b604f204b1_1761698105712_183413558
X-MC-Loop-Signature: 1761698105712:571872035
X-MC-Ingress-Time: 1761698105712
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.120.42.56 (trex/7.1.3);
	Wed, 29 Oct 2025 00:35:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=christoph.anton.mitterer.name; s=default; h=MIME-Version:
	Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From
	:Subject:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
	List-Archive; bh=HMDGuIq5Wk3rqQ5IRW7KD4Q7BJ5DnhMHJsLOIuE+QSg=; b=TMPsJtjU6Hxn
	ujodgIDzB28CsUBLKR7uiRtJ50QIlbTOZjr7acM0GiIlYCR+MdWbS9Svxmtbn1tCK2OKGmGrArCJz
	gv1+nDOd0/IVnPxAKTqJaNGb84nHotNAMgRQdKitWI6hBKObPlMFxiKnW++V+Kh1oG6PdMyir8s9h
	zxHQ+khl3cUxp6lTdVd2d56OIRxZUWQNJkBqErJXjT0wvq45pAxi9UmpdTuTkuvtt1lazjsqQK04F
	t8I9M5usm7FxsjvRSkhdm+ca4kZ6Y7Og484ooZ45RvJqzo75p/DU8Ev6peY4pZ52sIiz8AP/F3wvV
	e4xn5uthvL/Nn/Xgc0FLwg==;
Received: from [212.104.214.84] (port=3736 helo=[10.2.0.2])
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <mail@christoph.anton.mitterer.name>)
	id 1vDu9W-0000000DJdQ-3xSM;
	Wed, 29 Oct 2025 00:35:03 +0000
Message-ID: <b89a2c19fbde68004ae4c59fe00599d1382fc6f0.camel@christoph.anton.mitterer.name>
Subject: Re: [PATCH 5/9] tools: depend on `sysinit.target`
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: Jan Engelhardt <ej@inai.de>
Cc: netfilter-devel@vger.kernel.org
Date: Wed, 29 Oct 2025 01:35:01 +0100
In-Reply-To: <87oq102q-55q8-3137-5377-s74r778qn718@vanv.qr>
References: <20251024023513.1000918-1-mail@christoph.anton.mitterer.name>
	 <20251024023513.1000918-6-mail@christoph.anton.mitterer.name>
	 <87oq102q-55q8-3137-5377-s74r778qn718@vanv.qr>
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

On Tue, 2025-10-28 at 18:19 +0100, Jan Engelhardt wrote:
> The explanation is sound, but long-winded. Feel free to shorten the
> commit message to simply sy that no reason *for* DefDeps=3D is on
> record
> when it should have.

Wenn I read the commit that added the file to netfilter, it didn't
mention why e.g. DefaultDependencies=3D were chosen as it was (and why
the values for it implies were e.g. not set).

I figured, if my patch would have gotten merged, even only a few months
from now, no would remember why I e.g. set
After=3D/Requires=3Dsysinit.target *and* WantedBy=3Dsysinit.target, but e.g=
.
not basic.target.

So IMO it's better to have a good rationale, than not.


Cheer,
Chris.
