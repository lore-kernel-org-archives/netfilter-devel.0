Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793374140;
	b=s5Rfbec0S5TIx+MIdFbeUQa486lVYtBIFGY1UsFJ5RPkdBq9FzEKwdgJmUYE0wURVmZN
	 G9eqz/yycN4rRCwEChRpMqcwXbReJwkGO/JFDnkKjIcgw5PooYWW3ZO6fShfwawg7KWf4
	 Q2Ybh8T6hYahlG44+fbj1wfClzioQ90Ee3Mozc6Kh6ACte4r39uqqR9je6AX+KlzI3Xjd
	 OzctSw9RcRzOfsrcX3KsFCP/lebtwJF69id2F4y+n4MDdxhOGUIsSNu9NWHEgTbBOEI0E
	 xQ4IpB/RFLYQ/DI76supTjiEC+d1AOEOH2xd6O405Qq6DgqWLZbn6ahkoxk2gBhJY0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793374140;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=D8sJ8l6rKhEN6efZzAAnrAv6n1bk0O3yOaVZuzGl+R8=;
	b=2ZOlqTp+mZj5GzELhL1TZP1WDk/HbePAjVMyBDdxbXc7+kbeV3nIJyoWhhpWHdVgeDHr
	 pAVH/BRUVmlJBiWXed+i2a0i/g0n5ehoi2kn5ywIK7K5+YAfTtdeeI+0WsSUYrZFNOj06
	 tEgqpfaIEZ1pweMhtuxtUD0SoNUqYqX3lJOqAXHu8Vb5ARUzd4SVJjWGnUNFTysrC7M/5
	 u4LtkWF6la6AflLsWBFdN+b+vR48Rvlimd2ZSNiCy+hkk6xQRMb4prQOS8yo6SRcrvTFU
	 NQJPGM5nHteYHcJR6zkQhuHRZuk9vgUJAdXMLI7bEA8ZSk02cTUqmrMneSisNRM09bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B45E606A31A
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2026 15:28:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1B45E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 26F66609D0; Fri, 30 Oct 2026 16:28:57 +0100 (CET)
Date: Fri, 30 Oct 2026 16:28:56 +0100
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	pablo@netfilter.org, phil@nwl.cc, VEGA <vega@nebusec.ai>
Subject: Re: [PATCH nf] netfilter: nfnetlink_queue: keep socket ownership
 when expanding skb
Message-ID: <auS3uO9LHZ0lpqXf@strlen.de>
References: <20261030135750.4452-1-fmancera@suse.de>
 <auSrTEnc8tibSGs2@strlen.de>
 <17f1cf11-ae17-46f6-a8a0-a23644411ab0@suse.de>
 <auSvco0w7wKkuyE9@strlen.de>
 <964c22e6-9be8-4896-8c7c-45d927789c97@suse.de>
 <auSysrRmBdIesdue@strlen.de>
 <01a502da-e5fa-4046-9d24-2dd84e8d5098@suse.de>
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
In-Reply-To: <01a502da-e5fa-4046-9d24-2dd84e8d5098@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> Ah that is right. I missed it. Thanks Florian, let me take a look if 
> this does not take too much effort I might fix it.

Thanks Fernando!

> Otherwise let's drop
> it. Although we might hear about this in the future due to LLMs.

Undoubtedly so...
