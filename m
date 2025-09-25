Received: from rusty.tulip.relay.mailchannels.net (rusty.tulip.relay.mailchannels.net [23.83.218.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8466A7A13A
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Sep 2025 16:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.252
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758816678; cv=pass; b=A/13X/FH3cdD3XvwgrYCUyqwAxYyqcBZAI/4p6wxKqqv9wgXglBsY9MXpyCviXBNv9BPpV47imNShcdCDR0gq/ye7gT5t1hJD9GTVJ4Mn3QyYOTz86hJVCnDICcjxL36Zc4qPqSmGr9qP8SEwh48W09c9iuetlam2uKouo+i+5c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758816678; c=relaxed/simple;
	bh=rYAYbifg1GcGilllMyVPmj62XV7Nu3MTzY8diok45Pk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Qgozf4sklR7Eyl3axDB2WoFennueZ/60wQzwjl5+UFRZoqdPWUn8nDOR+juioouyKdstZX5Ky3hYp9AnM2sZwAkaYcHsw8pv4u2CwCglF10hjb78cSsITEApW6pTZgYVXKP2NMDiXmvVSpGlfSdx06Y6uThvMx6hj4ElkCGymyc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.218.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id A5A25101C2A;
	Thu, 25 Sep 2025 15:53:16 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-blue-6.trex.outbound.svc.cluster.local [100.109.34.94])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id A2F5F1013D4;
	Thu, 25 Sep 2025 15:53:15 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1758815596; a=rsa-sha256;
	cv=none;
	b=rRblUakKXaIRsh1t0/cmwGndKN7CocNi2TyMyV83/NM6GJO2BgpykH7umyD5bfxuAyL6tr
	1AuO0AmAFGIqzx47nPP/3N6a2uk79paHdlFURfNIZVDadJutQtgvHynhN3dvNybPFBDQH2
	IH6OHyNiyudMBdiHIeAiLnyTZ5mwQE2G1afXH6K3Sw3IodO+JXS9vVkqOiepxpmodUvu3k
	OFNrxOmLqT+yg3RasbFJQaMUpAGX8uOH3RvQ8RWJMPtUNBYIjVloTRW4cfKhZD5fsSpq2h
	a8yLPeskvX8iznPnXb7gVX4xiXNiQTxlPBi6CbGtyD4PDUzyqRvRvB7w4Xeg/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1758815596;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rYAYbifg1GcGilllMyVPmj62XV7Nu3MTzY8diok45Pk=;
	b=Tm5xuaBEwDJG7jz7X+a1gDoJi171o2LTYva3Kzg38TWDk9CDV8YFWxFVaQ1SwgiejaSVkz
	83ljv6p02GputFvcX+5gxsDv940Jycb4x9JP9yHVwtW4g/59s0dgoNaOjhkL+Tk9eqLArZ
	MQqLrxSvVvKN73p3a8+fYV93T1wrklg3dbcwB7kCvZuo0pZRmo8oX/cjMhVqOP9/Ki0IuW
	8bzFY+c1sxKzE17I52lUjicSlZihnfYri+Rb3SdXQUqJjO/W7rlOOMzbrM26DgaCOfBH1d
	YJzQFXSFdPq+ajG74e5jT4+X15px7hxarxsyKtXHw0+JsQfd42C1+g6ObFvubA==
ARC-Authentication-Results: i=1;
	rspamd-b66946488-lt6lz;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MC-Copy: stored-urls
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Reaction-Gusty: 331636626ec00f26_1758815596345_1731292729
X-MC-Loop-Signature: 1758815596345:3382534801
X-MC-Ingress-Time: 1758815596345
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.109.34.94 (trex/7.1.3);
	Thu, 25 Sep 2025 15:53:16 +0000
Received: from [79.127.207.171] (port=25705 helo=[10.2.0.2])
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1v1oHU-00000009TPQ-0MSS;
	Thu, 25 Sep 2025 15:53:13 +0000
Message-ID: <658f160530a48d923a345334fca2729c879762de.camel@scientia.org>
Subject: Re: bug: nft -n still shows "resolved" values for iif and oif
From: Christoph Anton Mitterer <calestyo@scientia.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Date: Thu, 25 Sep 2025 17:53:12 +0200
In-Reply-To: <aNVUxFz1RDsu7wuk@strlen.de>
References: <f2c46dc450b3223834cd837882877f892b234491.camel@scientia.org>
	 <aNVUxFz1RDsu7wuk@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-3 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-AuthUser: calestyo@scientia.org

On Thu, 2025-09-25 at 16:42 +0200, Florian Westphal wrote:
> Christoph Anton Mitterer <calestyo@scientia.org> wrote:
> > IMO especially for iif/oif, which hardcode the iface ID rather than
> > name, it would IMO be rather important to show the real value (that
> > is
> > the ID) and not the resolved one.
>=20
> Seems like a bad idea.=C2=A0 Existing method will make
> sure that if the device is renamed the output will change.

But AFAIU only when it's renamed, not when it's e.g. removed and then
brought back?

I mean sometimes (admittedly rarely) I unload for example my wifi
driver modules and reload them (when the driver or firmware got in a
weird state and doesn't seem to recover).
Then my wifi iface would get a new ID, wouldn't id?


Maybe one could make iif/oif a special case... where the numeric value
is written and in a comment "(current: <name>)"?


