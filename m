Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=31.154.135.10
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793565519;
	b=spoaHwP0mTD2pywLmgISqYNZ41c6fdH8M11qvu4yqIGaGZt4Mp8jxhQfsim1C+IOsgr5
	 wM+7Sc2PDSTEs8Fp1nZ7eYg2Tu0qEfxi/z5uDq6rN++paKwsysI3BokFqgEGr1eJA92Vx
	 8L67C5lZ1uatM6dDyk7MBolrMTc3vIsxm8MEGV3Q33dG7I7CgHNqfBhB4jIY8W6RzfHbI
	 GvzCpZVN5tras569BZ/C/LZMCNwvfPjr+hk/zSKOHyjC3v/udu7Ty+50wdjscDvyHbNHb
	 h4qW8+z8EHV6pGdZFF/1YxnNqgR3G/jysKrnVYctVi/KcB7SPIrEmDIlPQcKQiEIheg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793565519;
	h=DMARC-Filter:Received:Received:Received:Received:Received:
	 DKIM-Filter:DKIM-Signature:X-Virus-Scanned:Received:Received:From:To:
	 Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tYUfK8GwiDIa7aaUBZOe6yXmiCtPdp+KmTL6nk74YPE=;
	b=qSOtg3snl4rqTolr/IkEypgPf/VxPBRCJupsJ/0rsRHE+h3XzDShIkVMEeLZ1iT0xfDs
	 zQKvqQwyi18WIb0Fx3hctSnEJd7eDnaA9I/F2jHhvVm1sU1WYG0hFnvYBhG7qY+Qq8sK8
	 ag8AId1cIy2fofjpNDy4eZxuYFss6xV/S2MLSaxJRrlpOTrozpy7bQgBM6w2+t16+3pvl
	 AGp3AUY2H9IpCe7V0K1iUg7oi8AUpvUD03K/DimHD1VmUO5VwQx07RBsWT5yfs47AH83H
	 r92HbKyXLCMYx5DtF92dWia8kGUwkDHCALRyd9iQuaTDW12wEMYcAm8IXogXO8XHWoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=inango-systems.com;
	spf=pass smtp.mailfrom=inango-systems.com;
	dkim=pass header.d=inango-systems.com header.i=@inango-systems.com header.a=rsa-sha256 header.s=45A440E0-D841-11E8-B985-5FCC721607E0 header.b=ZjiAXR0f;
	arc=none smtp.remote-ip=31.154.135.10
Received: from ksserv.inango.com (ksserv.inango.com [31.154.135.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D540606A324;
	Sun,  1 Nov 2026 20:38:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D540606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=inango-systems.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inango-systems.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=inango-systems.com header.i=@inango-systems.com header.a=rsa-sha256 header.s=45A440E0-D841-11E8-B985-5FCC721607E0 header.b=ZjiAXR0f
Received: from ksserv.inango.com (localhost [127.0.0.1])
	by ksserv.inango.com (Proxmox) with ESMTP id 87539229ED;
	Sun,  1 Nov 2026 22:38:35 +0200 (IST)
Received: from mail.inango-systems.com (unknown [192.168.70.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ksserv.inango.com (Proxmox) with ESMTPS id 5441322962;
	Sun,  1 Nov 2026 22:38:35 +0200 (IST)
Received: from localhost (localhost [127.0.0.1])
	by mail.inango-systems.com (Postfix) with ESMTP id 24D1CD645B1;
	Sun,  1 Nov 2026 22:38:34 +0200 (IST)
Received: from mail.inango-systems.com ([127.0.0.1])
 by localhost (mail.inango-systems.com [127.0.0.1]) (amavis, port 10032)
 with ESMTP id Vx1mrIXQO0Br; Sun,  1 Nov 2026 22:38:34 +0200 (IST)
Received: from localhost (localhost [127.0.0.1])
	by mail.inango-systems.com (Postfix) with ESMTP id ED615D645B2;
	Sun,  1 Nov 2026 22:38:33 +0200 (IST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.inango-systems.com ED615D645B2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=inango-systems.com;
	s=45A440E0-D841-11E8-B985-5FCC721607E0; t=1793565514;
	bh=tYUfK8GwiDIa7aaUBZOe6yXmiCtPdp+KmTL6nk74YPE=;
	h=From:To:Date:Message-ID:MIME-Version;
	b=ZjiAXR0fPtCuzrcxGXlg35EnfHoT1skrLIHHGKBKWSBI3QdpnWh+XxxsOrmeFmVZR
	 ODFr/9iWzfukppKxyemggsWgYQrvatPO0LxOQtPKQ1So9izSCEf+DFPCnybSqBjjaI
	 nJ1eGA8YH62ymaqcRtOkeJEgVwTuLb8nniraKPOp74rrtEmufGn/EE/idfYtsEIAfB
	 ERwOcLIyRFp73jDl8yc9/o0xfG7u5qX8lr5pFh4xMdltaDuIrMu3DlMFw/2Niw+IX5
	 uuhmGEPHLB2u0V1Uqh63sceu9Fb3d9QK6qR1Cx87NbQJplNGWBBIAt/oXC9w6JDSOj
	 ULzOGsojtifSg==
X-Virus-Scanned: amavis at inango-systems.com
Received: from mail.inango-systems.com ([127.0.0.1])
 by localhost (mail.inango-systems.com [127.0.0.1]) (amavis, port 10026)
 with ESMTP id DW5m3QY9DWn3; Sun,  1 Nov 2026 22:38:33 +0200 (IST)
Received: from steamdeck.inango.loc (unknown [193.37.156.111])
	by mail.inango-systems.com (Postfix) with ESMTPSA id 7B600D645B1;
	Sun,  1 Nov 2026 22:38:24 +0200 (IST)
From: Nikolai Merinov <n.merinov@inango-systems.com>
To: netfilter-devel@vger.kernel.org
Cc: netdev@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Nikolai Merinov <n.merinov@inango-systems.com>
Subject: [PATCH 1/3] netfilter: ip6t_NPT: Align not mapped packets processing with RFC 6296 requirements
Date: Mon,  2 Nov 2026 00:37:14 +0400
Message-ID: <20261101203716.269343-2-n.merinov@inango-systems.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261101203716.269343-1-n.merinov@inango-systems.com>
References: <20261101203716.269343-1-n.merinov@inango-systems.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

From: Andrey Kuznetsov <a.kuznetsov@inango-systems.com>

The RFC 6296 section 3.2 have the following requirement:

> If the internal subnet number has no mapping, such as being 0xFFFF or
> simply not mapped, discard the datagram.

This requirement should be applied in two cases:

1. Both source and destination prefixes less than 48, and
   addr->s6_addr16[3] equal to 0xFFFF.

2. When source prefix shorter than destination prefix, which means,
   according to RFC 6296 section 3.7, that the shorter prefix should be
   zero-extended to the length of the longer, all addresses from source
   prefix that does not match zero-extended prefix is untranslatable.

Change code in manner to return false from ip6t_npt_map_pfx() function. T=
he
callers interpret the false value as a flag to drop the packet.

Signed-off-by: Andrey Kuznetsov <a.kuznetsov@inango-systems.com>
Co-developed-by: Nikolai Merinov <n.merinov@inango-systems.com>
Signed-off-by: Nikolai Merinov <n.merinov@inango-systems.com>
---
 net/ipv6/netfilter/ip6t_NPT.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_NPT.c b/net/ipv6/netfilter/ip6t_NPT.=
c
index 787c74aa85e3..6a939e1a9fbc 100644
--- a/net/ipv6/netfilter/ip6t_NPT.c
+++ b/net/ipv6/netfilter/ip6t_NPT.c
@@ -52,13 +52,18 @@ static bool ip6t_npt_map_pfx(const struct ip6t_npt_tg=
info *npt,
 			mask =3D htonl((1 << (i - pfx_len + 32)) - 1);
=20
 		idx =3D i / 32;
+		if ((addr->s6_addr32[idx] & ~mask) !=3D npt->src_pfx.in6.s6_addr32[idx=
])
+			return false;
+
 		addr->s6_addr32[idx] &=3D mask;
 		addr->s6_addr32[idx] |=3D ~mask & npt->dst_pfx.in6.s6_addr32[idx];
 	}
=20
-	if (pfx_len <=3D 48)
+	if (pfx_len <=3D 48) {
 		idx =3D 3;
-	else {
+		if ((__force __sum16)addr->s6_addr16[idx] =3D=3D CSUM_MANGLED_0)
+			return false;
+	} else {
 		for (idx =3D 4; idx < ARRAY_SIZE(addr->s6_addr16); idx++) {
 			if ((__force __sum16)addr->s6_addr16[idx] !=3D
 			    CSUM_MANGLED_0)
--=20
2.55.0


