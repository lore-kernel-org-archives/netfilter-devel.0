Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5612C15BA
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Jan 2026 15:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769700253; cv=none; b=L55j5zGZiDVPSJI/LzzdkKWv0RYx3S9uhQZ/1Fma10zl7TrUyMWsr/l6RrRCBvTXscALhRZhsmefkMabe8dMHtA/6wk4AuVuFO5SpJ6aKw2td4MFQwBHrqexjXvpG0OLxg/7ugoF0821ToZXj9egakEwF/bfpP/cJutvdyxyuIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769700253; c=relaxed/simple;
	bh=6cSOZlpt5h1drnz7zmkp7vbU3IY1ouMgx+1Zokqm2aE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F0YZ5p+6beRW+8us4JwTOx8ghaZcDXyniywvHNqinYKJq870WALCAJ8kopj31/C2k+4kSi/aeeSwoNxoIvWIJrmP6sIPIKtabtW/xo3gdk6JNeXETM/LV0v6QhlTRR0Zo27TA3YNiI5+7FskIY2qfoUfCokAWMNSGOeqJl1GaG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=NSRCK49q; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="NSRCK49q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/0HVf8tKHaWv//yh5xYMb0h1DT2uA2a7vqtWuRS0vtw=; b=NSRCK49qwv1QSkc9xaKDxgp1ic
	kG3pA5/RZGgr4UuJe3DSoRE5kv2byY+T1m74RALtVw/Ix2MWUcgdCWdkCHtdi4pGJ7mohKTKKHxPr
	wFcJUUwjSKP5JD6a5uJDBkExgNf6Cr27uzbktNeTEwHGx/eCjMBHVw+NFREmgubOYY4Awjj9+lVqt
	ne9gIA7n78GvyME4IdHt2tIeLWi8MweeDHEqrymisRqsWE/VS2cWeHPMufz6o94ipXbCbw4L0wiMN
	ZvCXtlFedKwI/wPWI0JyCs25kNqU0xskTC0/ZrDEE5e7RmteUHINVYET3yX12J0g2Ujvecd2Nn/yi
	MB62mcpg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vlTsO-000000002vR-2ikC;
	Thu, 29 Jan 2026 16:24:08 +0100
Date: Thu, 29 Jan 2026 16:24:08 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] ruleparse: arp: Fix for all-zero mask on Big
 Endian
Message-ID: <aXt7mLPPbsRN_H8R@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20260128214443.27971-1-phil@nwl.cc>
 <aXt1mToz6_7g9P88@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXt1mToz6_7g9P88@strlen.de>

On Thu, Jan 29, 2026 at 03:58:33PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > With 16bit mask values, the first two bytes of bitwise.mask in struct
> > nft_xt_ctx_reg are significant. Reading the first 32bit-sized field
> > works only on Little Endian, on Big Endian the mask appears in the upper
> > two bytes which are discarded when assigning to a 16bit variable.
> 
> nft-ruleparse-arp.c: In function 'nft_arp_parse_payload':
> nft-ruleparse-arp.c:93:77: warning: dereferencing type-punned pointer will break strict-aliasing rules [-Wstrict-aliasing]
>    93 |                         fw->arp.arhrd_mask = ((uint16_t *)reg->bitwise.mask)[0];
>       |                                                                             ^
> nft-ruleparse-arp.c:102:77: warning: dereferencing type-punned pointer will break strict-aliasing rules [-Wstrict-aliasing]
>   102 |                         fw->arp.arpro_mask = ((uint16_t *)reg->bitwise.mask)[0];
>       |                                                                             ^
> nft-ruleparse-arp.c:111:77: warning: dereferencing type-punned pointer will break strict-aliasing rules [-Wstrict-aliasing]
>   111 |                         fw->arp.arpop_mask = ((uint16_t *)reg->bitwise.mask)[0];
>       |                                                                             ^

Oops! I didn't notice this because my build script passed -O0 in CFLAGS,
probably from code coverage analysis. So back to the previous approach
involving a union which I had deemed too much for just those four cases:

diff --git a/iptables/nft-ruleparse.h b/iptables/nft-ruleparse.h
index 0377e4ae17a6e..dc755b361ec72 100644
--- a/iptables/nft-ruleparse.h
+++ b/iptables/nft-ruleparse.h
@@ -36,7 +36,11 @@ struct nft_xt_ctx_reg {
        };
 
        struct {
-               uint32_t mask[4];
+               union {
+                       uint32_t mask[4];
+                       uint16_t mask16[];
+                       uint8_t  mask8[];
+               };
                uint32_t xor[4];
                bool set;
        } bitwise;

Or simply use mempcy() instead of the assignment?

Cheers, Phil
