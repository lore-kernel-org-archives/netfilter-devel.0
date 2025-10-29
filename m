Received: from crane.ash.relay.mailchannels.net (crane.ash.relay.mailchannels.net [23.83.222.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B9524677C
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2025 00:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.222.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761697790; cv=pass; b=IxvmsNuNgAGGsXNdPKiSQNszxR4bFn54qUZzH7o+MHLh/8uJDJgzv4etS3rqyV6qaq5q7/QJJg1gnBXVba/kRCEooO3eOvaBmkrjk+o+3+g+3mM+3kPGasiz7gms62zzo9GYF4lEvovS+MKBJB1cJ0nRAuQ4sayuhGw15lqjbRI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761697790; c=relaxed/simple;
	bh=cudDbRhuR1jGZIroMJlki74PKYHEwgrFwzFFt08ou7o=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qRb/lcFIAdfMvzJAuUgQ2mkPLXsSJb4LS0i192segg466hfcGR8bgJUPimID236e+X0OsOpxNqOX1ELtbn8pOW4KFoJfl1gtgaqaA35OPJmYFRaU5tXrajPkMhwjpCO/g4kZXSFycv5EvQSG3LSa9/9NAzanf1Sdz3PuYJ5BgWU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=christoph.anton.mitterer.name; dkim=fail (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b=h0IsexjG reason="key not found in DNS"; arc=pass smtp.client-ip=23.83.222.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b="h0IsexjG"
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 4BDEF581481;
	Wed, 29 Oct 2025 00:29:41 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (100-123-213-201.trex-nlb.outbound.svc.cluster.local [100.123.213.201])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id E7D0458158C;
	Wed, 29 Oct 2025 00:29:38 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761697781; a=rsa-sha256;
	cv=none;
	b=7wWqKCt8/YR6lB8dADn3s3CDvqOs2lwedZj2LFQXNEcc61cJgGjhTuxHt58zdWsJ9aQ9xX
	+j8cEv5gyl/z9g/+I/fv0sVRnb6j6nZpgHHi9IBAwItiebGYnbBhbZGaZ0Tc8wviGwVKDi
	6y73Nhmu14B5zFfsg2FyYcz18XJ1TzC4jNrPJjGz3wgmKaAt1+D82vJda6DFX9NiR3/zor
	SBMrBMaMZ9Pje+OPnwfZe5iTWHB0/su4lzmC5sQKz6I6ybh1Sl6cs0aI9xDbS1sJDXACM6
	1H8E2oTivfFB0GBo3uxj35ZvHlrWFoTKJQf3ZRUxkOTEtWZKOIeY3PSv6TsA1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761697781;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cudDbRhuR1jGZIroMJlki74PKYHEwgrFwzFFt08ou7o=;
	b=jQb6ip5Ik89aB+C37ooDSY9ubkfTLGu7VlZ7KC6zsqo3k9JzM/hqJzeKBLAOc6NwjAHpga
	Qaum3u137IwZIjY0izjRhJ47sHWH0kNT/5i2DcpoQVGvDbWF8oeGGo+0vc10yyIGXB+tt0
	FZScU3mJHlfERVr9RKIREFjAyxSIcwklPr0+RSKPQrnD/xESO6IcsHZ6AnR6d/oQ2ylYkC
	qu2RSxI2EDs9NZRy/Az5NzQvWOKq25Kbe3HfJpM2N5mq60Vr6v7Logdk78F0BvAZVNHEpw
	kLc20b8m6MpYGU0c3MlSKkNTT7zB+VHAMJ5rb/pTVtZNdKCi6AH4X7kF3Ee28A==
ARC-Authentication-Results: i=1;
	rspamd-77bb85d8d5-5lc5z;
	auth=pass smtp.auth=instrampxe0y3a
 smtp.mailfrom=mail@christoph.anton.mitterer.name
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MC-Relay: Neutral
X-MailChannels-SenderId:
 instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MailChannels-Auth-Id: instrampxe0y3a
X-Eyes-Tasty: 4344378858bf10f9_1761697781186_250473648
X-MC-Loop-Signature: 1761697781186:1862609701
X-MC-Ingress-Time: 1761697781185
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.123.213.201 (trex/7.1.3);
	Wed, 29 Oct 2025 00:29:41 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=christoph.anton.mitterer.name; s=default; h=MIME-Version:
	Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From
	:Subject:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
	List-Archive; bh=cudDbRhuR1jGZIroMJlki74PKYHEwgrFwzFFt08ou7o=; b=h0IsexjGQWWq
	9YBuSzLixnFlEMvGW9nJ8tUHz1YC9fPKTwbKx+Dtaaseewe33GXnx5W+7XjfDTBFMQBYbkAiF/auU
	dQS1GwWnBD11G/uqZw01cNBJKrlj25onMNy7f5h99p4LTlIqbA6EksppKNOYGInEhQMTOIVCxXvIQ
	jeBWbeCSHLw71N4wP0RclfKVclc1HE3WJIQhpa1FGZ6NTa+/pVBUDEgC0elko5x4yvrC0nfDWeta6
	ltuJ2CzGAQfrB6HcVoAw7p8zoLX3kW2UkkL7yrXhxcNaRwzWVcFjJ6KXMIE3scsF9y/jcEtdJDRIN
	zVqLDpb+BzkIcS/yWYCTFA==;
Received: from [212.104.214.84] (port=36279 helo=[10.2.0.2])
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <mail@christoph.anton.mitterer.name>)
	id 1vDu4H-0000000DIg0-0Nlx;
	Wed, 29 Oct 2025 00:29:37 +0000
Message-ID: <b3f03819eb68c1e73fb35064a60a676189ff8a36.camel@christoph.anton.mitterer.name>
Subject: Re: [PATCH 4/9] tools: reorder options
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: Jan Engelhardt <ej@inai.de>
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>, 
	fw@strlen.de
Date: Wed, 29 Oct 2025 01:29:35 +0100
In-Reply-To: <n15q6p6p-1qsq-2pr3-r2pn-339n568nr9r2@vanv.qr>
References: <20251024023513.1000918-1-mail@christoph.anton.mitterer.name>
	 <20251024023513.1000918-5-mail@christoph.anton.mitterer.name>
	 <n15q6p6p-1qsq-2pr3-r2pn-339n568nr9r2@vanv.qr>
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

On Tue, 2025-10-28 at 18:15 +0100, Jan Engelhardt wrote:
> This one feels unnecessary, and I do not think there is an officially
> supported order of directives.
> In addition, the file should try to stay simple enough that order
> does not matter.

No there's no official order, I merely felt that keeping related
settings together (like the dependencies) makes things more readable.
