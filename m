Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=151.80.46.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793351214;
	b=X0yETZXGUvfsPLNwEwkXmdvBmkL/1EGaJfrcDjh7apYMGYpArIrZe2tHvo44yGWQM9WG
	 RcZEo4ZAkPYzKObAFsgzbFqLAkqyRku1XtTG3z4DIs0JbsrOq6U6kYEPKCwdrV01yXw8+
	 Q2i2+aHcQr/C65cx3J8bGS7bu6JyKFX5AOxhmz4Xm2SW4Go39L5xE3YBe7oK/jQwWXXFS
	 Cj6b1oJLHACy4TSKnji7PUrFB3rYdoEPhxZDYV/OyetdHgJHaP1MEUl2i+yggj4KUL4oq
	 n3CIav6WX8EEoZAX180GvIevcfutiQ/Jjt3LXTawomFdx/dlgbFzBrWtnGD6wxnWL/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793351214;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=rsj2Qkistx2ort8JFjwkW8VnNbsJKet/jrB/45pByng=;
	b=35q78sqYsxNlQKtGgMJa04ZRUxgR/M+9ltbXQZW8VWPdhczHp5fxj7rZGXwo42hFDbll
	 YlXLsKFlKoablHPE6mtlpswNVfxCNlehJmFmSOfShMiKVrgO/Z4Cz+acLWkUcvLs4aX87
	 wQuMVBbeCSc8X4nPdWqjqJAPNRlGnKmK1L1Wq6cXN8AEq+5xlBltiL6nkxKDXA/YEkJAh
	 y+Mp+BrqEYU4TP5a1/UTLTSbTEnRGyK/H0JIg2lCBDdvhTUHVYonTXQVDzC6PMOvjwcu5
	 0RH2I9f8wKdAj8u282EPv6RTK1bj29N1++p0n+SlpzKnNOfPEBChRW49dZx8bTl2MyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=nwl.cc;
	spf=pass smtp.mailfrom=nwl.cc;
	dkim=pass header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=bX4Nbm3b;
	arc=none smtp.remote-ip=151.80.46.58
Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9A6606A31C
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2026 09:06:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF9A6606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=bX4Nbm3b
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rsj2Qkistx2ort8JFjwkW8VnNbsJKet/jrB/45pByng=; b=bX4Nbm3b0BX7DeNRrepxrtKPxC
	B3Dd0mP6dTq6LbKkxGHRsMYFWJOI+hIGBWSlukwtmINhR4mquHE7UX1cq2idt1OpNsohw8PB1QB1Y
	GBCNDpX8mVkxbPk3HvzMDmndrCdu4DKI3ZDHWND/U1Z9XcHteBCsr0LaOhFECVNq+UD/JM/GnynsI
	v56SlsmWkuDB5IRx2gIHegsgLweTx69DjpyiDyehlUzBmLdzDSZaoa2mPmxWlTf7TrtqyDCatS/ev
	fePDrQnQ/L9511zlbb/rWGpcqHVvDI9UIWbWqCc1Alt6NAEGW8Ho/apzH3BB8a8vpvycU0JWoIBVF
	2xHiWZUQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xMiZX-000000000uO-1ltT
	for netfilter-devel@vger.kernel.org;
	Fri, 30 Oct 2026 10:06:51 +0100
Date: Fri, 30 Oct 2026 10:06:51 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 1/2] tests: shell: Fix packetpath/meta_time on slow
 systems
Message-ID: <auReK3kxK9o4kru9@orbyte.nwl.cc>
References: <20261029163706.3243948-1-phil@nwl.cc>
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
In-Reply-To: <20261029163706.3243948-1-phil@nwl.cc>

On Thu, Oct 29, 2026 at 05:37:05PM +0100, Phil Sutter wrote:
> A system so slow that the whole shell test suite run takes 20min fails
> this test, probably because the last non-matching rule's range starting
> 10s ahead is not sufficient. Move that time range into the past, so the
> test may take up to 2min to complete and still pass.
> 
> Fixes: b5145809b1bb8 ("tests: shell: add packetpath test for meta time expression.")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Series applied.
