Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711350;
	b=QXpIGdJmsJ5F6RkJrLQEnRJEnhb4If2RJGx26pfDTjSe/mpiIMz2nX0cJkMlZNESemkC
	 EvsM+wxQRiT1eozTBbLayNb2PACWmtmqO+RfX86mRZ/3KpxGK+3HOtfYMvmuc3Xb4tPff
	 wYfWtQ+NAipkC3qk1T4HXHeF01g1ONBOw+0fyJhNb0lVliKWC9wrx7Uv1Toe+8E/2tbBL
	 ZpzKVWCtjjqoJ1kWGYBjNiuojgGC48EN0YN5u5Vs4Ndx9p60//cv5R4D8y/0Bq3lToxCe
	 6kNccXxWwj1P+8oWEwGirilxaVd+EBnMNNiA7mD1ZrkxWtxlUG4mg7Qs8TVOk5gl1IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711350;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=WC+LcDGnW8nEq4R+XP05R3FgHMOOvaZh3naa9whyN8U=;
	b=IqUDzpHA2JsQ4eXNWKytL+b7Z/bmLhJ+Wco5p2yF4Vi5a/J6pi1lU5iZ73z9uV6Q7NK8
	 JNECMIutrOH/MtpRcS+nBswr6pYGXyadtkz9Hdcxwj3nKGEfn2tHD8ST6pP0kaYIO93lv
	 wZiU1i61fvJdBZv6Bf3IFI1GrxCEwLi/u52f1yjrTJ/V2A2sIdgr5xT+jI52qymL6RDPH
	 +eOLUEuV+LE5Is/NCwzgylutNtVm0RBWm9WgI0S+KsCUrJnOsBz8mW6wG3BNg+8hZqXYe
	 fi0TYsO+MFimJuhh+EcbiMTn8ipPKuOgf8RPbhN6eLeWpaQTm6Tz/IBCN0+fSOclCyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5431D606A33C;
	Tue,  3 Nov 2026 13:09:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5431D606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CF9E460678; Tue, 03 Nov 2026 14:09:06 +0100 (CET)
Date: Tue, 3 Nov 2026 14:09:05 +0100
From: Florian Westphal <fw@strlen.de>
To: Matthieu Baerts <matttbe@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, edumazet@kernel.org,
	horms@kernel.org, ja@ssi.bg
Subject: Re: [PATCH net 00/15] Netfilter/IPVS fixes for net
Message-ID: <aunc8YgjvFXsPDeo@strlen.de>
References: <20261102005654.532438-1-pablo@netfilter.org>
 <b452b25b-37fd-48ab-a88c-feec6b82e9ec@redhat.com>
 <5dc1159d-e577-442f-a7b2-8d5dcc8cfb01@kernel.org>
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
In-Reply-To: <5dc1159d-e577-442f-a7b2-8d5dcc8cfb01@kernel.org>

Matthieu Baerts <matttbe@kernel.org> wrote:
> It looks like the patches have not been tested, because of the kdoc
> issue on patch 6/15:
> 
> 
> https://netdev-ctrl.bots.linux.dev/logview.html?f=/logs/build/1198360/14931104/kdoc/stdout
> 
> I guess this will need to be fixed in the v2. If it is a false positive,
> please ping me.

The only effect this test has is that I will stop making kdoc comments.
