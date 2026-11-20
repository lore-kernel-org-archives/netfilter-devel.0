Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795177842;
	b=TiwbS6XSbyCMYzypOLl2KY2Q9S9kKeVmjRMf1BFz44EIkMvce4pRAUsRG7CJMUbfMyDy
	 UJ6B0XEWUfn34k7jIHYlNEk+p4wtBNNhnaLpurF6GPHr46lEXN4QqEW/YcCdpN6LhOcGZ
	 77fZTrn1geDrgF3bswysX0Ag+HpJoMD5skM5YpCvk9Ly+I1bJddnC28sG/BR6xXuFiEN8
	 CK1+CjKTnbtJu65hWXhsqbK4nm3OYCZFKq/M3gJ5nn2uPYKbu9fJDa05S1bhM2iY1bbrw
	 S/BoEA4P6tAZQF7vEMs5n2kXxGxsmPKnv/hOFnddLpXc6oTtnfc4rA+na/4KUx9QF0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795177842;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=3x2uiAzQDyjRyuSsB/NleI/o1rLWVIuk9GwKt/3SqVY=;
	b=htUvuMT3UNcm1JpBECr9P7rvMRpgihl4Kh75eQehH4xLAFV9nZ447YRHRNARYXqaMZ+u
	 QhGPCq5QusfFGnJ9m2BGWCKU2WeAQ/d4abyr1Q3HmZqDRxzpbTKb9bsxyGcLK3YIsnnzA
	 czOUFJxHCOI8lfPc1rAfBg5PNAEE9lYPi6phgW5Ek04teyy/nGdjODFsDdGHcX3j1329q
	 TlOtEEmhQBB89BeroNnP6RoDz1G4o5Ey2zR3S1OXB58eN5TojIkW/WGPBnjYOKCXa0gxC
	 fNLbyQjW3PMX9+4FvYKiaywB8vT2335BYBKezFb8UUaQHqxF8+SWYbLMq2H5C0ngAdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=protonmail.com;
	spf=pass smtp.mailfrom=protonmail.com;
	dkim=pass header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=iL2IYH33;
	arc=none smtp.remote-ip=79.135.106.98
Received: from mail-10698.protonmail.ch (mail-10698.protonmail.ch [79.135.106.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C06C606A320;
	Fri, 20 Nov 2026 12:30:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C06C606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=iL2IYH33
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1795177839; x=1795437039;
	bh=3x2uiAzQDyjRyuSsB/NleI/o1rLWVIuk9GwKt/3SqVY=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=iL2IYH33shWhvLf/J0TVsbZNoH/IWweuJfYJCpwaxxyKFzjUWKHjVuXZoEPmYLLHT
	 g7L/1A0EEWg6hqIMcv99DPwA6iGPQQFrZSxeke+f7hhicr5XOfiqu2nuswo95/yT4k
	 D46J696zRvkLABfDSg4CHYG3Nqf1vmDOuGpFaTBOKdukrxTttpjF9P3GvB8sl4rGY7
	 uVslTnlx1t7ZzFeVBUnzjGSXmLorIKw1r6GDfmfto7w2SRKV0sX4/FOxXHC9ro6r28
	 GEyyRMeXPpX2H7AgGLf8/mlUa6OB856doI9Hh8K80UaSI5LtXFusfy6Aq6dPNz4sWh
	 CPsgt+yCDWjBQ==
Date: Fri, 20 Nov 2026 12:30:34 +0000
To: Pablo Neira Ayuso <pablo@netfilter.org>
From: John <shffr@protonmail.com>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, "coreteam@netfilter.org" <coreteam@netfilter.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Subject: Re: [REGRESSION] netfilter: flowtable: XMIT_NEIGH flows sent to 00:00:00:00:00:00 once the next hop's neighbour entry is gone
Message-ID: <mnTRsDnjFGwkaEs2TyBhSVGORGNjDv2jpYzwr8fY9E3xMMohO6nE5PDALNhJYrjPVDAfxziY2rjCLBNeJ5zs7vRg-6LyTC56Ypk4TKStDKg=@protonmail.com>
In-Reply-To: <av-RdjXsq4IXsnMg@chamomile>
References: <MAEpYNlWKRd7lM0j62YlEZ97Ux1h5AyjSuFRm4Lxk2Q6haeDGTKqX8lpDRZ8slvBu6qA7Bbt18zpr9fyF_jArrEemTgRqzqluxmsGH7UcFk=@protonmail.com> <avSIBUcLH4kZyISX@chamomile> <avTngTkNKE5ApQW8@chamomile> <LCJrB-Fde--T9NiYx2QfFb-X-9W-vsYYmtmrHwIKuKgM8enKRWF2DYypz2_zJKSKQBMUdb9sS6xMEfPihv1YO2FLjX1OUN-Td3Hq1eAdLgw=@protonmail.com> <av-RdjXsq4IXsnMg@chamomile>
Feedback-ID: 9232920:user:proton
X-Pm-Message-ID: d0bec2f19f1968670e03cb0da2155cefd3870d42
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
Content-Transfer-Encoding: quoted-printable

Thanks for the series. I tested v4 on 7.4-rc3 with the same two
tests as in my earlier mail, IPv4 and IPv6, and no packets were
lost. In the GC test the entries went from STALE through PROBE
back to REACHABLE for the whole run and were never deleted.

v4 adds a new problem for flows that leave the router through a
tunnel device, which plain rc3 handles correctly. I put a GRE or
WireGuard tunnel between the router and the server, with the
tunnel device and the client's veth in the flowtable, and sent
one UDP datagram per second for 60 s. On plain rc3 the flow is
offloaded once and stays offloaded. With v4 the flowtable GC
tears it down within 0.2 s of every offload and the next packet
offloads it again, 53 to 55 times in 60 s. Each datagram from the
server arrived after a teardown, so 59 of the 60 took the classic
path, against 5 on plain rc3. Nothing was lost, so the cost is
the classic path and the churn.

As far as I can tell nf_flow_dst_check_gc() returns false for the
direction out through the tunnel, because the neighbour on that
device fails the addr_len !=3D ETH_ALEN check (GRE has 4, WireGuard
0). nft_dev_fill_forward_path() already treats such devices as
non-Ethernet and offloads them with a zero h_dest, so perhaps the
GC check should skip them the same way.

A 6.18.y backport probably also needs 871df5007eda, since 6.18.y
still offloads a flow when the next hop is unresolved.

John


-------- Original Message --------
On Friday, 11/20/26 at 01:17 Pablo Neira Ayuso <pablo@netfilter.org> wrote:
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

https://lore.kernel.org/netfilter-devel/20261119090736.3342541-1-pablo@netf=
ilter.org/T/

