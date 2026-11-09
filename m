Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794239119;
	b=Khc0AMHM/FVKTmmkou7hd5+SgrJVKFMw42l/kxFQ/zUgBHLTQKW7ut3hscy2sfgV6RCr
	 qkabH/WqwYeeX3AvbkSykJKT104TosCA9p3BAJg0MnoYuG1EgIZpCKNn45+SuqK2fh/sD
	 bScyR4Zou1Q12Y9hNMpv3nbZsAlvaRatPpJGuo4zt/XABdlb36ud+BGFU8Gy/jZuCxcyE
	 fGpkfIagTFn8ZuEFHfv7sMuclXS86Q2ZjIMECzXLZaVXEKX6yohutETvGA7OJsCzTxyid
	 52dR7/Up5u7ikHxxYbb5JmkFgOOAOiGQAAiMdkifUt7QNhhsXb3HHdpizHmNSOubNeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794239119;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=os959wYCQaL3IcBabCJ0yD5KsNKP7F5a6r8I2PBz1ss=;
	b=zXQOTy0WZwyayWWKVDGQ1oO8inPoKbh5FmIsba0aGf9xhvm+5PEvfYcTTZDGmVMPoGkD
	 6fwrpmAyfwmNEM4J1Vso0ZeQLU39OaJoWi1I3Wdi6obQHDrUwnibZ4DeyCccflJazUgrF
	 qkD4SOeDoZa56g0ARJBM5qbdvUTqn2bsWF87LmSfdose4dSasALjLsneKlSDMZqWMwWNh
	 TPMQ39Ff2qPSdzfktUMicBhY//gEsuAIehWOzsg88izr8LnVu1iE0eAE1m1qDmdGF0A2R
	 7lCKjr2uiQep86YF3V55dSH24ZAenosrgaUcK4M+IKJV594IDKost2+BohNphfBXpUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D6C606EE8C
	for <netfilter-devel@vger.kernel.org>; Mon,  9 Nov 2026 15:45:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66D6C606EE8C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 084F160342; Mon, 09 Nov 2026 16:45:16 +0100 (CET)
Date: Mon, 9 Nov 2026 16:45:13 +0100
From: Florian Westphal <fw@strlen.de>
To: jpeska <jpeska@redhat.com>
Cc: netfilter-devel@vger.kernel.org, fwestpha@redhat.com
Subject: Re: [PATCH nf-next] selftests: netfilter: add UDP flowtable offload
 test
Message-ID: <avHqieUCRJQg9FLQ@strlen.de>
References: <20261109135137.1770507-1-jpeska@redhat.com>
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
In-Reply-To: <20261109135137.1770507-1-jpeska@redhat.com>

jpeska <jpeska@redhat.com> wrote:
> From: Jiri Peska <jpeska@redhat.com>
> 
> nft_flowtable.sh offloads only TCP, so the UDP flowtable paths never
> run: the UDP tuple lookup, the UDP checksum update, IPv6 source NAT,
> and nf_ct_acct_update behind the flowtable counter flag.
> 
> Add an echo test for IPv4 and IPv6, with and without masquerade. The
> payload must come back intact, the forward chain must see only the
> handshake, and conntrack must mark the flow OFFLOAD and account every
> datagram.

Any reason why this doesn't extend nft_flowtable.sh?
