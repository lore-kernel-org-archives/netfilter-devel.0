Received: from tiger.tulip.relay.mailchannels.net (tiger.tulip.relay.mailchannels.net [23.83.218.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FEC2329E4E
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2025 23:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.248
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761868759; cv=pass; b=i0oX4VCg6iANxxNwP8JUEJpLZrxiBK7ViKvY1LVgujye1WnJhoDbup5K37uzSiG44Bln/dWP6JQ50Wqyd/G1Txh5dntGWtSI+dHBFAs3dA5kcnAfbxl6eEf1uxOYaAjRPpuSFkoiQmT5cks/2SryJecLAgZo3unsGgbCkjei2fw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761868759; c=relaxed/simple;
	bh=7sYXQAFij4SUWYWmx1uVHteRH5v6Xa0NZj4/bZ7tv4Q=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=V3uUCJByqzgucME9cPDw9QYP5EusE44g0cyhh28wWa5xLZcjPb3/4huKY+I3Fr8Ob9QQRZ8y3ANHqiDM9JQVAboS5kAzC41KzXa94uvlqjflyIWptr3rr4XbnqwVwGVPvKJgvfCGxvdsFuxtG6x5TYxLsM1+ZQ808eQ+8IAq6Jo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org; spf=pass smtp.mailfrom=scientia.org; arc=pass smtp.client-ip=23.83.218.248
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id EB1312218AB;
	Thu, 30 Oct 2025 23:59:16 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (100-121-221-249.trex-nlb.outbound.svc.cluster.local [100.121.221.249])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 22476221382;
	Thu, 30 Oct 2025 23:59:15 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761868756; a=rsa-sha256;
	cv=none;
	b=Q3goMujUxjj/rWHTkHERc235YaOYqDpzfExXG/tZBvKhLvb+0nhaRi+w0GAnVSuG8TiB8Y
	kAFN4J4f99NLeV0Al/ln0zkChiMM8Fe4scYkkf0ZKtQRxLUS0embM5Gcoc1peZHBiIcWNw
	+/CryHUHp1lUieUehyPSASWJ/pXnSV60t2mJhVXsk1ySpfzeJOxtUfMzXSj576U9eZqNiR
	uPv5wPw5SQF7gLoobRSZN14dWgvwzA8S7cSDnlQwJtT10LlmhEb/d+eqo0RCXNBGckC1xk
	ae16tpmB398ztp1G96UiMl6QdlBfBJoSXEFVB4aW9+JjbB2DmROYFGWq7T8J2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761868756;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7sYXQAFij4SUWYWmx1uVHteRH5v6Xa0NZj4/bZ7tv4Q=;
	b=FM5rme2mr1EgKns7yZTmb6Qv5ZvaIZAbKco3D+fc4SwkkePb5s8l+C5Bi3nqwZPgATlL2n
	U8yTdDeGrixy6n2TvL8uFCmiD3PySSUKYZ17h9yf2K43nrLXc9F4uw7WGPelc/ptQp9kez
	dUfq29VLit1/da8YsTMF4J7tT7rC9Prh8EIij0+HEL4AznIAMK7xL3psD1qAYrASObfKcO
	gcMkjVhBujOFTw1RIJWdMx6xHUzurTJ50fqVrQPMAw2rNYCT341wwe0l62mFcOt2xBhi+m
	cfNhPZOX9tPel1yDve1+gpZzg9hhc2nlrSOP3g3g5dHAwlnsK855FYvi4eY0VQ==
ARC-Authentication-Results: i=1;
	rspamd-768b565cdb-f949h;
	auth=pass smtp.auth=instrampxe0y3a smtp.mailfrom=calestyo@scientia.org
X-Sender-Id: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MC-Relay: Neutral
X-MailChannels-SenderId: instrampxe0y3a|x-authuser|calestyo@scientia.org
X-MailChannels-Auth-Id: instrampxe0y3a
X-Grain-Abaft: 2c4a907278f84ebc_1761868756830_2097171914
X-MC-Loop-Signature: 1761868756830:3801503176
X-MC-Ingress-Time: 1761868756830
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.121.221.249 (trex/7.1.3);
	Thu, 30 Oct 2025 23:59:16 +0000
Received: from [212.104.214.84] (port=43819 helo=[10.2.0.2])
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <calestyo@scientia.org>)
	id 1vEcXz-00000009Wyo-3uFU;
	Thu, 30 Oct 2025 23:59:14 +0000
Message-ID: <55947376098fca1d7a71c4464dda3fceb4be5fc6.camel@scientia.org>
Subject: Re: nftables.service hardening ideas
From: Christoph Anton Mitterer <calestyo@scientia.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Date: Fri, 31 Oct 2025 00:59:12 +0100
In-Reply-To: <aQP1HRqdYtTFxQD8@calendula>
References: <71e8f96ac2cd1ee0ab8676facb04b40870a095a1.camel@scientia.org>
	 <aQP1HRqdYtTFxQD8@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-5 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-AuthUser: calestyo@scientia.org

On Fri, 2025-10-31 at 00:30 +0100, Pablo Neira Ayuso wrote:
> For more advanced configurations, probably we can provide a list of
> extra configurations for the paranoid users that they can apply to
> refine in some other form (wiki page?).

I personally, don't like wikis for documentation (it's rather difficult
to "download" them).

What I've thought about was that one could make the more esoteric stuff
comments in the .service, so that any users of it (like downstream
distros) could decide whether or not they want to enable it.

However, that would still kinda put he burden on maintaining these
comments (and keeping them working) on nftables, which it seems is not
really desired.

For example, my:
> ExecPaths=3D/usr/sbin/nft -/lib -/usr/lib
(an some more) wasn't well tested enough yet, and would have broken my
own ExecStop=3D (which tries to execute sh and systemctl).

Keeping all that sandboxing options well tested and up2date is of
course some effort, so from that PoV I can fully understand Florian,
when he doesn't want to have any of this in upstream.


Cheers,
Chris.
