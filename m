Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795133820;
	b=Id6FGl9jmphBZl2HAOif7T379dzooOfLGUYGhmu+UyVCjY2B9siCO8T93cAIx4JrLr7T
	 yv0YSjDsIG8KcpNErCpQlBqzk4h2mnbnlIIMNe+vVTHbGSgG0BjoiAvY2cUgthGRodJYA
	 z7qlDohi4ft6/r4ZtmThkHihqMHAvapbUGPDdi5c2jlEM3LFs6+sv3dTcjOtZydRG0Bwq
	 5P4gEmYmFMyMmQd+9Wcf56ctWcPUOxcLx8gBff3qLEILiP5sUkD7YryCbX7+PoQke6n7H
	 g39jRIGcpH1KhkfOP0Zel9HBpBrbMZ5A6NBg8KcoJo6eWvl4TNOk9nqSXAtyqdl7LbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795133820;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=UaidrchdsiA6ina6W5vc78SK6thsHus4W9FFXBWLfs8=;
	b=HnGqs8h1SguEhhixdAgukH9PHcMKg6//PE8JsWJfLL56RHybxuY/cMMIHoCzCyV042oW
	 b/ltdj2XIMV6Y5hAhJg28L1yeinz7rminM5CxRDxDQ748S8a5MPvJIs+GSiA/nYauZJ9s
	 oH9EKN2jOrK82nQVVa0qExxRWDIri3wEfrBAMEv2M4jtn8V3co230i8Kl7rkRD39SyyI1
	 DRzqpxSFI+OJTApooZQCObc9F2vrljJ+sQIxVj7eGQMwJCukAObCdkHk6BjT5FftWCRDg
	 o/fu35Azk0FREB2oXtFi44tHqnuiupcw1r6mKw6cBLBCW7MPURow3O0JvfzRmvYOuyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b="Kw/m1nn5";
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id C32BE606A320;
	Fri, 20 Nov 2026 00:16:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C32BE606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Kw/m1nn5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795133817;
	bh=UaidrchdsiA6ina6W5vc78SK6thsHus4W9FFXBWLfs8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Kw/m1nn5uPO8sIjJtDnbS9vwZHOGeIIyv6jCAiZjfZqcMs9PfYN0Zu84MZXhXI2+l
	 8VY2fpe/BgeMC2D+MZEFbir2yWm+v0rTo4/3r0ecDW8tCKVyarMELnpgMCZOnIt3kW
	 0iYb+WIwvuljtEN2W9tGCMGiVvpGo9Rp1mZqoLP1NmdhuD5B8A0xzwCUrx/R8Z1lYj
	 2pUcV72PNAgpMT77gSurAASzXvF0y1S1qXFEhcejdrmPsoEKBQYqpWtkJtNhK7CRSh
	 T5WLE+NXOlfccAXSaHScs/X0au7VjVj86t/zTFVF+mRbdXcOsDPj421JZ4djs9x8MW
	 t02UNDfBy259Q==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 52D17601C8;
	Fri, 20 Nov 2026 01:16:57 +0100 (CET)
Date: Fri, 20 Nov 2026 01:16:54 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: John <shffr@protonmail.com>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"coreteam@netfilter.org" <coreteam@netfilter.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"regressions@lists.linux.dev" <regressions@lists.linux.dev>
Subject: Re: [REGRESSION] netfilter: flowtable: XMIT_NEIGH flows sent to
 00:00:00:00:00:00 once the next hop's neighbour entry is gone
Message-ID: <av-RdjXsq4IXsnMg@chamomile>
References: <MAEpYNlWKRd7lM0j62YlEZ97Ux1h5AyjSuFRm4Lxk2Q6haeDGTKqX8lpDRZ8slvBu6qA7Bbt18zpr9fyF_jArrEemTgRqzqluxmsGH7UcFk=@protonmail.com>
 <avSIBUcLH4kZyISX@chamomile>
 <avTngTkNKE5ApQW8@chamomile>
 <LCJrB-Fde--T9NiYx2QfFb-X-9W-vsYYmtmrHwIKuKgM8enKRWF2DYypz2_zJKSKQBMUdb9sS6xMEfPihv1YO2FLjX1OUN-Td3Hq1eAdLgw=@protonmail.com>
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
In-Reply-To: <LCJrB-Fde--T9NiYx2QfFb-X-9W-vsYYmtmrHwIKuKgM8enKRWF2DYypz2_zJKSKQBMUdb9sS6xMEfPihv1YO2FLjX1OUN-Td3Hq1eAdLgw=@protonmail.com>

On Thu, Nov 12, 2026 at 09:08:27AM +0000, John wrote:
> Hi Pablo, Thorsten,
> 
> Thorsten: I first saw this on 6.18.60 and have reproduced it on
> 6.18.62 and v7.4-rc2. 6.18.63 has the same nf_flow_table_ip.c.
> b5964aac51e0 came into 6.18.y with 6.18.45, the release named in
> the thread you linked.
> 
> Pablo: on 7.4-rc2 your patch stops the black hole, but as you
> noticed, one packet is still lost each time the next hop's entry
> goes away, which with neighbour GC happens about every 75 s on a
> long-lived flow. 6.18.44, before b5964aac51e0, lost nothing in
> the same tests. On 6.18.y the patch only works together with
> 871df5007eda.

For the record, I posted these series to address this issue:

https://lore.kernel.org/netfilter-devel/20261119090736.3342541-1-pablo@netfilter.org/T/
