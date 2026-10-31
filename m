Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793460121;
	b=F4TCPYFa+Mldod/ksu9wEkceA+iQan2bghy+hrSIg3OasaiTl0No8Pp9IHeUXiSbMJrG
	 4rQXj34Q4EFk+h3ZVAbdlNn9uyHO47oJwD8HMp6/IN5Bz2DcpsXwrU7R6js5HbPQ9GGwY
	 o5YGMbCuOZpsbHd3ZJgNBXyMkMbMTyd4idIFpExAhbwQDVvWJiUFKES77pvIw4iob2PKX
	 TOgaXxoeYvwYPmjvgLJXTK//bETktcf5m9HVbFCT8Tnvc1xFcRvsbzWv4S4gGsAyDXBv2
	 yv3jc18R19kjlgTDFQufMq0dI/oC/q/Mby6x1Qb0MGwS/D45XcECNyvJmnepCr9ydgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793460121;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=SCxhG63YHAFXkOVH8UZ3UYS+hqElctg+27qUKpREdVQ=;
	b=vZYFyykZYcBIOygn7JNelA/hqnraHS2ciQSLzOKlTY8irMGjQc2foAOS5Gdlvvv02Rwk
	 hiq26HSc8dR4MKbE2WeCNtqbdYvy3Pc/vSruP5+kqVDgqGyV9iDyJMqYm33hUEuIu40F2
	 yEAlD2f+n1VQQudY8gh3qqo/HzYkEH4sPT4EfIL6LWaz1lEfHBt+oIHlN/UrcuQoVq3sH
	 BvjfoY58Yq8s0cfFnedFGc3WY5hRwyLjkc4g2AFv32cCAECOdMbra6Zmiwsw0BcgRNLN0
	 /n86B4KtobIkBaO/s51mzcXN4CXZaZXI4Ulk3+QILUDFLTMciswIOTCMCJ/h46w3tAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=protonmail.com;
	spf=pass smtp.mailfrom=protonmail.com;
	dkim=pass header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=Nawok0QF;
	arc=none smtp.remote-ip=79.135.106.101
Received: from mail-106101.protonmail.ch (mail-106101.protonmail.ch [79.135.106.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91203606A31C
	for <netfilter-devel@vger.kernel.org>; Sat, 31 Oct 2026 15:22:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91203606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=Nawok0QF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1793460118; x=1793719318;
	bh=SCxhG63YHAFXkOVH8UZ3UYS+hqElctg+27qUKpREdVQ=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=Nawok0QFnqeha/QtzBbE1sT1OVbWEPohFw7/zxzlvXIXqFf6BThHI9dL1PfPfaVJ5
	 G3ep3YVVnQmewbcNU2ZGrpiUdxEC4Yz624Zkh4q2Rvo0VQCl3R+c3Zzs1IQE8NF2n8
	 Tog2jAW3pEBI0gL747SF/gersOlUD7NxVDppn5XwUynjs1ztn3I4rZZiOi6lwYxTnZ
	 emwCdf6cJgH36wrt+XELb4gFn69AdxQHI4RZ7AX/vpLRihUT9XvFD1DkR5syB/fgJ1
	 z26RPP5Ab6GdIUxolR4GDD/VJj6ACl8VSbOZB9v664zNgy0iQJdcPhfBBcG+1qbwhn
	 R2QZleZGd4FuQ==
Date: Sat, 31 Oct 2026 15:21:55 +0000
To: "netfilter@vger.kernel.org" <netfilter@vger.kernel.org>, "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
From: Turritopsis Dohrnii Teo En Ming <teo.en.ming@protonmail.com>
Cc: "ceo@teo-en-ming-corp.com" <ceo@teo-en-ming-corp.com>
Subject: Changing iptables backend on ipfire 2.29 Core 204 firewall
Message-ID: <tFPvjiny7aomwwtbNLJpjkgm6IgE6hF9RwKQuO5ZQG6PeyBvL5F4BOOm_7cQTXn-fNYkHZOAQ1rRiGA5QyTPdvTyl8CRMNetEBnnOzr4Glk=@protonmail.com>
Feedback-ID: 39510961:user:proton
X-Pm-Message-ID: f8eede5d874ad70b6bead8aaafb3fc12c62dbd61
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

Subject: Changing iptables backend on ipfire 2.29 Core 204 firewall

Good day from Singapore,

My ipfire 2.29 Core 204 firewall uses the iptables-legacy backend.

[root@ipfire ~]# iptables --version
iptables v1.8.13 (legacy)

Can I change it to the nftables backend?

Thank you for your advice.

Regards,

Mr. Turritopsis Dohrnii Teo En Ming
Targeted Individuals Singapore
31 Oct 2026 Saturday 11.21 pm Singapore Time






