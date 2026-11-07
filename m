Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794067447;
	b=KFtgLWL6Pnt+6eTs84DRkWRfcqENWrmkoPdp2sb6NOCpMrc2F+Y761OME3ZLUWdZ3UAe
	 5+DrzsUUt6VgEyGvUx2EWCro+QZ6Qs3zw6qmQcHtiV5okUQlFna3v3ZasU4BZWcClfNLl
	 cQ8VQip/4rH3zgDCLVazQUNnkt8OO9ILKxAt76e4N+xZvElZ9KKg7no77m34rxrqpwFrc
	 e4OSDhZseBAKr0pgBAHQhZIv7+bkeIu74uod1QKfQDValeYyTDn1tACHfKyPRQGvJizJx
	 BGxcVGDnJpYJPnbc3JoFYrFZHTkTQPM/fQb5tvy2NCIyyxqVDTHiTcJSD1fhGsqHx8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794067447;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=NtVqZMd664OMZ9IpVYAbFo+i4+3IRzNzsuls05T01jQ=;
	b=tN14x13c0GlLhHQIY9UwvzaU5bEFdaACIV8kb4mYPPlcGlLPTtA/iLadjUXHBoxKXJZY
	 /NXDkGlQlxywVie4q4p7XXU1L0mqm5UuPdlwsdvsNs4VrxN/TdPfPsPk/aPh4QhLAU4uA
	 UoyQ8EiTUsvHO6tZs9ccLIp/kHbgHNHuA+ntUAOhUVXN0cTQflcexVoC6YIA3fI+JHmbD
	 46zZZl1DjGcTIjLiyyg9t9n/M9jp0/Sa/WkmKV51Hcbc893Xpj5TWvHaTXEKkPC68lHno
	 ElpDMso1G0tfbGXKfogRXr9f4QnlGUmKfM58eIuNvTN5v0kmg8ck0PfrirFWq3D6s1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=000ty.net;
	spf=pass smtp.mailfrom=000ty.net;
	dkim=pass header.d=000ty.net header.i=@000ty.net header.a=rsa-sha256 header.s=protonmail2 header.b=ZP9T3KqD;
	arc=none smtp.remote-ip=185.70.43.99
Received: from mail-4399.protonmail.ch (mail-4399.protonmail.ch [185.70.43.99])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDC3606A326;
	Sat,  7 Nov 2026 16:04:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BFDC3606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=000ty.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=000ty.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=000ty.net header.i=@000ty.net header.a=rsa-sha256 header.s=protonmail2 header.b=ZP9T3KqD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=000ty.net;
	s=protonmail2; t=1794067443; x=1794326643;
	bh=NtVqZMd664OMZ9IpVYAbFo+i4+3IRzNzsuls05T01jQ=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=ZP9T3KqDSNlIyWaAPpLgd8uCbvuc1a3DczxAGHebq8NHNf++ZR3QxxoUXiN0WTMPq
	 et9Yj56IdGMZ/w+dMUF7HBtETS6FkJHeqt3XfOZ9Y6pGtgDrjgNbUkhto4gX/1dg56
	 dom3HhFTk7lYwL2z2lrV2RcZnRjedtKCB6DyHwgtVibX+b3IB1EajSCOaT40a1oSbE
	 BvfDoNfj66oM/HUPRCSvg3s828waOyMutKfZ8RpU9OC2oVrxL8e4AYQQZnepbHMgOe
	 +eu3H7f0UfbDs6SbfEK2MHtWp/3NwMKRDrYujE5T0FzN5JPPdsL7kxPiYHUAgCO8TB
	 ZIIDjizif9c1w==
Date: Sat, 07 Nov 2026 16:03:57 +0000
To: netfilter-devel@vger.kernel.org
From: Tamaki Yanagawa <ty@000ty.net>
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, coreteam@netfilter.org, linux-kernel@vger.kernel.org, ty@000ty.net
Subject: [PATCH nf] netfilter: nft_inner: always save the parsed tunnel context
Message-ID: <20261107160350.1359-1-ty@000ty.net>
Feedback-ID: 168296199:user:proton
X-Pm-Message-ID: 86f354ef732ef347dcaa492700a6a6cd4a4d70f4
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

nft_inner_save_tun_ctx() only updates the per-cpu tunnel context when
its cookie differs from the skb being evaluated. The cookie is the skb
address, so once an skb is freed and its address is reused by the next
packet on that cpu, the context parsed for the new packet is never
stored, and every following inner expression in the chain restores the
offsets and protocols of the previous packet instead. A tunnelled
packet can then be matched against another packet's headers, e.g. a
"vxlan tcp dport 22 drop" rule misses a packet whose inner IP header
length differs from the one before it. Store the context
unconditionally.

Fixes: 7b1d83da254b ("netfilter: nft_inner: incorrect percpu area handling =
under softirq")
Signed-off-by: Tamaki Yanagawa <ty@000ty.net>
Assisted-by: Claude:claude-opus-5-5
---
 net/netfilter/nft_inner.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/nft_inner.c b/net/netfilter/nft_inner.c
index 97fb4eea2d..3af5ddd5ff 100644
--- a/net/netfilter/nft_inner.c
+++ b/net/netfilter/nft_inner.c
@@ -265,8 +265,7 @@ static void nft_inner_save_tun_ctx(const struct nft_pkt=
info *pkt,
 =09local_bh_disable();
 =09local_lock_nested_bh(&nft_pcpu_tun_ctx.bh_lock);
 =09this_cpu_tun_ctx =3D this_cpu_ptr(&nft_pcpu_tun_ctx.ctx);
-=09if (this_cpu_tun_ctx->cookie !=3D tun_ctx->cookie)
-=09=09*this_cpu_tun_ctx =3D *tun_ctx;
+=09*this_cpu_tun_ctx =3D *tun_ctx;
 =09local_unlock_nested_bh(&nft_pcpu_tun_ctx.bh_lock);
 =09local_bh_enable();
 }

base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
--=20
2.52.0


