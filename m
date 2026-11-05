Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.238.174.39
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793878100;
	b=FQOZgOJx5kunOLCIz25RwY3AIPSOTlicMy6ml+J7cyZfgbzPo0eI8Q/dbrtBQLpO18Bx
	 3QmLbgFuY/+bDf7MhJqXL+rMh6rGDt+Zx3LeLT3nq8C/Ice/XkT+0kxCpqi0xznnlpyNT
	 NMUjJi2qz8RLRdPn0aPAp3El2fIxH6feBet5LAy0kV0YbITYSIw2lQfVEkMwuhRU5htvm
	 DGMGN1F9iFK7Hr9CH9AHpqzTy85xfoP8g7arDJzyAFWCUPKCtRJ59ncn5owGFzFZ7aiHO
	 L0+h2K7qq9UkBbOA0Ha214w030Oe6SwNB23epPkb/rowvTvMSCUCLUkUqPN9aS9T/ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793878100;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:Date:
	 From:To:cc:Subject:In-Reply-To:Message-ID:References:MIME-Version:
	 Content-Type;
	bh=/DhdHHSKF5ENLCkIBlI46CZSU4/cobTTYN29i/kBP5k=;
	b=mjQGTcic4H4o5Ufv6mdV0ZcjJIBbJHq6zjSNLWRuVNc3Swb96viVIQe1M25LLjLOAia5
	 5k3LHffvbeaBz+uBl5W788OQnD+OE4i4c/S/wCaFRv/TCmq3jznxELpuzb63gne3BIYIB
	 TDO/yfLHhk9qoHoX2K/I3THCNTf0OY9VEhe2ekYGQUyX39D4AjGcBXsIZb2KG1bqtuRsb
	 R4nh7Kj19W3Bc4Jvf/sQZ2fID7lv9plFnHpLoK1yfQFmg2gSZ7OKfOfP0XBoEkefJXXzl
	 E7OqCzNh8FPOP9jrRVHOCY8+AUzs4TdRYoFOq/EYvT6Lythbsvcxi4Dn0Ko5i+9HQcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ssi.bg;
	spf=pass smtp.mailfrom=ssi.bg;
	dkim=pass header.d=ssi.bg header.i=@ssi.bg header.a=rsa-sha256 header.s=ssi header.b=SuH7ZXLI;
	arc=none smtp.remote-ip=193.238.174.39
Received: from mx.ssi.bg (mx.ssi.bg [193.238.174.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED25606A334;
	Thu,  5 Nov 2026 11:28:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AED25606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ssi.bg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=ssi.bg header.i=@ssi.bg header.a=rsa-sha256 header.s=ssi header.b=SuH7ZXLI
Received: from mx.ssi.bg (localhost [127.0.0.1])
	by mx.ssi.bg (Potsfix) with ESMTP id DE31221DB9;
	Thu, 05 Nov 2026 13:28:15 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ssi.bg; h=cc:cc
	:content-type:content-type:date:from:from:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=ssi;
	 bh=/DhdHHSKF5ENLCkIBlI46CZSU4/cobTTYN29i/kBP5k=; b=SuH7ZXLIc6dZ
	c/gNLJGzoZ4LBl3IUboffzYhXkLmT5QyDBTvg6OyCNZ7tfW5xE4d+BhBKWF4qHIY
	jt3M+Np8nBfVJb+pTyV8iVCRDyTZgeK7a7kC09zLdgyb2e7iWhNZoOkyo3Xcpmk1
	VGIQpme3UXlkCmxxEufiLEwNTcJtec+LBukX8h1YRHJXuHRbyePiZ/oWKW/3G1xi
	5aowgPaotrreOSVdBqK3U2C+8df+uPzg/lJ7nJs5FtuZzZjRHLn+igCqXJEYhBAf
	adfO6qTfMiQHJsV0ka7JFN+HzVX+v9+9QIhxnOgM3eVALYUbF0DYX1f+R8RaDoXu
	jc13xJVqWu9TDVd+G5rct4Nbj/apo8E5+sw+6+2pq98evsVpXpTDRfJ9/Y08Itwe
	2hFMWJ7Y8bfrBu44aMM2J6X/sxH74f/RKHbPODkUbm49vLoQxfF0RFk8R97Lnmt1
	dqcpZlcaMCmwR+wb3vKefbTsh/9FtqcvpDa4/dEt8+fnChUJQykKnNntRqOVWB1S
	uibTuXZEAj7IcpRxWDOoO6+xOaxcN7/KIeZWLML91+llfB3Nz8pGvi78MDwXkrLU
	s4p0k6fX852zdLOma0Z4hyXNB54tKy+PPc+XQZddUbk4LOvIpDQ2Hb7sr31un7Uq
	YnaQgc2Io8zZFd3rx2D04tTpZo4/kzE=
Received: from box.ssi.bg (box.ssi.bg [193.238.174.46])
	by mx.ssi.bg (Potsfix) with ESMTPS;
	Thu, 05 Nov 2026 13:28:15 +0200 (EET)
Received: from ja.ssi.bg (unknown [213.16.62.126])
	by box.ssi.bg (Potsfix) with ESMTPSA id 7628960C22;
	Thu,  5 Nov 2026 13:28:15 +0200 (EET)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by ja.ssi.bg (8.18.2/8.18.2) with ESMTP id 6A5BSDa2035968;
	Thu, 5 Nov 2026 13:28:13 +0200
Date: Thu, 5 Nov 2026 13:28:13 +0200 (EET)
From: Julian Anastasov <ja@ssi.bg>
To: Paolo Abeni <pabeni@redhat.com>
cc: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        edumazet@kernel.org, horms@kernel.org, fw@strlen.de
Subject: Re: [PATCH net,v3 00/13] Netfilter/IPVS fixes for net
In-Reply-To: <51aa2527-0a99-4d67-845a-a8b28f822efb@redhat.com>
Message-ID: <f0d18f47-1ca7-a6a8-2c7b-31f53fbee02c@ssi.bg>
References: <20261104090224.750548-1-pablo@netfilter.org> <51aa2527-0a99-4d67-845a-a8b28f822efb@redhat.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


	Hello,

On Thu, 5 Nov 2026, Paolo Abeni wrote:

> On 11/4/26 10:02, Pablo Neira Ayuso wrote:
> > v3: keep back two patches in the series with sashiko reports that
> >      suggest they need a bit more work.
> 
> I *think* Julian additionally suggested dropping/changing patch
> 
> ipvs: do not create conns from packets with port 0
> 
> but it looks untouched ?!?
> 
> Also AI review did not kick on this revision, likely because
> the bot is confused by the mismatch between cover letter prefix
> "net,v3" and the patches prefix "net".
> 
> I think a new revision may be needed?

	The PR contains v1, even v2 has problem and can be
dropped. I have v3 ready to send later today.

Regards

--
Julian Anastasov <ja@ssi.bg>

