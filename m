Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713902;
	b=4p4FqsZ+qut+YFS/MqVpkqC5bVYgWd9n3Z7q3TAlEeTsLS0jGCDfGGnB+Sw4JqXxRWB+
	 3g5hfRAVBis+z/aG55Vsov5bo3+k4si2p8ZMwMMxpO341rn3OlLPuRHs0IXx60yD+Igja
	 SGDQnKf5fIuPsHICaiNdMFBwLN1ZfukplfR1PgTKScDaoXAt4aaq/fHLteFTTU47zMz19
	 CwCZZQ+ZxmhuGn+z+CyGa38/9jArFLO98IWNZcmGpNzEqx6wpWsjAdRR/uabvmNcbR6kF
	 /eqogrjnQAoOloGbb4zSu4j0vjDGWAZUOR3uA3rntga3iga2HUlhzoCa0WIKhq/VwLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713902;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=1QZH9QrkSaB0v/jUckKIgxbNLn9qigD/oJi6yCmD9/4=;
	b=qPJC7rtkUrHFqtDmUr7eDbg6Hv+W47sGJW1w0XQImh8XdEJ4RPIYtGn62hYneIOXgjh6
	 WQWmdJ5+bXGYy2nF2/6AXwGT3UlBCY04oASbnEV6O2mVAZoazxfeMJ3LCSXRjfoTRVPnM
	 YP9a07/mjg/PEcptD6YLi8ISM66dpzO+RSC9MG/U1Uf2W5PyNz7Ex8w4qqgTQLb5fjFxd
	 8nsWjEyZaWi/qDXB1fF/EhwKly1G2wtlyDq8oWKUNt2dNillqdBKK1RkWB73NJ436jxVa
	 33hOVOgtdGEJnF1WworGjudtBhBglyL6qNZGGsHrxszQ1yuAUjfN8hU2jHfU2V6sjcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=fgsG7PLK;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id E2838606A335;
	Tue,  3 Nov 2026 13:51:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E2838606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=fgsG7PLK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793713899;
	bh=1QZH9QrkSaB0v/jUckKIgxbNLn9qigD/oJi6yCmD9/4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fgsG7PLKXSsuMdrAnymUUDfBeSjhkzCrPf6qnu1DppxUDTtz4ldjZmSVGKcHNPaMb
	 tgTxAj0VGQcXp0LecEAweOMyrZfaKrrTCsk9i26m6ZNjbe/WHhVkkFNuZiRo5FR73K
	 8QXl454O5ZMZT2UO8pSixMS+b4Nu2UxkGCwvW5kTzHhPPtzz97tWzLBU4DSyyDueK9
	 aJBOVdbVnnY0I8YuENbSyoUPbs6mgXS0NSC1N/O11ce+e1PGjPhCQbGGEQHMcQYjrh
	 3bLbQvgYLsC9fEwtxQpoF4Uak9YojEf2oa4Y2oGQUkEEH11DoKx3OX69B92M67mMWC
	 /GAZ/9RKMGKIQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 66FCB60058;
	Tue,  3 Nov 2026 14:51:39 +0100 (CET)
Date: Tue, 3 Nov 2026 14:51:36 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Matthieu Baerts <matttbe@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, edumazet@kernel.org,
	horms@kernel.org, ja@ssi.bg
Subject: Re: [PATCH net 00/15] Netfilter/IPVS fixes for net
Message-ID: <aunm6Cr1PeBNJlrk@chamomile>
References: <20261102005654.532438-1-pablo@netfilter.org>
 <b452b25b-37fd-48ab-a88c-feec6b82e9ec@redhat.com>
 <5dc1159d-e577-442f-a7b2-8d5dcc8cfb01@kernel.org>
 <aunc8YgjvFXsPDeo@strlen.de>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aunc8YgjvFXsPDeo@strlen.de>

On Tue, Nov 03, 2026 at 02:09:05PM +0100, Florian Westphal wrote:
> Matthieu Baerts <matttbe@kernel.org> wrote:
> > It looks like the patches have not been tested, because of the kdoc
> > issue on patch 6/15:
> > 
> > https://netdev-ctrl.bots.linux.dev/logview.html?f=/logs/build/1198360/14931104/kdoc/stdout
> > 
> > I guess this will need to be fixed in the v2. If it is a false positive,
> > please ping me.
> 
> The only effect this test has is that I will stop making kdoc comments.

For the record, I have restored the original comment here to please the robot.
