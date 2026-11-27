Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795814143;
	b=myR+VUDUPSyhDeJQa6a+1S5Uk+c6UcSxaMqu+1naoYaKfHIh7kEXTSswmd40FQ0kR/1i
	 /p+Ezr2sifi9wCCoBMG1cPfANa7WkNbbRZhpPN4JjrWjOyLdNdugZXxVE8NP43EntBw4L
	 Yb6HYTe6YGuXD7KjvvHi44cfuPGhefZS/KpjeO0dv8JjKeBI/s9jJhZH4Y16ScKvXwu69
	 DSqiLMX0fNYZyOp2umcAtx6a5LMxEbOzo60WVmsXRNUv8GZR90o4LE/YN02dA0njtqiSZ
	 LiXs8xsN2cJyaqPpfQBegf0hBOeW083OSZfiohqukwZ0X2U1fvt/cdhQwLPnqs+zA4Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795814143;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=UjluyBnoXBDetWmY7LL/gAafORAZ0sgQFtuZ/uqzehw=;
	b=huNP8b6aH2LLQv0tloMnFg2JG0pT9lvc0agAXPI8/EJ5AUCXi+6qBL0vP6PRKeoj+G2j
	 Lk3NG/fE14KRU7y+XbEkDhfr1OA4eF6GI/0yxBydMOLvbczuOxMpYXTo/KvQH8nROEa5J
	 kB9xg559K0jXhF/KtcNFfIz/KLDXFWnF3Vg+64QNapeRsxJPvqwiVQR8e6OKe9Db7zIHv
	 v+s0BdWQldH45ziRSGjN7HDXxY/TJHvkv7Pj9R/f4gTSDZh5XrVmUoYet5YRTgYxAMFBh
	 PYBay6Bmv/TGV1I3Z5DU5qwwLkT729/ReBN7Wla0AJTwsfXeMCGhVsrRMmaEBt19+fA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ovlt0U+F;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2018A606A31F;
	Fri, 27 Nov 2026 21:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ovlt0U+F
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795814142;
	b=JoM/zH/NDvX5Xg0rf1KdsikqevUyD3aIQ9d1YeyDMTlzh/+C+ROPj6LuEpuX0fZubb5W
	 SyvbT4ANv98UPiFCqHyEEaB3MjdkF8Z1t1VPQR/Ig6i84v3iPjoPjnOeE8flAnDA/fPxf
	 BWxohMItpp31mFsu9AldRFBZePhTPOklSpMAlvq4YajnzQw9GWqhTaIDT+3HO7VaXGsAW
	 zpAvAn9f+WdA/Qe9W7sL8E/wVkZiH8GM6bK37p0aTuq2NzElRI2stfQGU3YWM0ODF1Gc0
	 uXQAYzftPA/FqQNPyXB8ppmLlBwKR4oTDtv5/TYiV4fWSAkKVHJZ99+frh0mdM3zb6Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795814142;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=UjluyBnoXBDetWmY7LL/gAafORAZ0sgQFtuZ/uqzehw=;
	b=1sMBi5Itr6swgZhn4KvMu2Yjld3jt28JUUZBnjRPrmWsksuLLZlPY2y/1AOVgeqO8bqZ
	 BFeh8VfC2ADLDOoKmsiN+GfTuHs+CQK8W/F0Xx18cxZvsZbVbPegYP+b4HmneqSZSjcQ9
	 J/aDkrrZZg3rdRMfNBOTPlDlHs70IVVLsySiRDC5Jc1cRB+dM+YuJkC/fjS0zOsjFWbCK
	 v90IhonK2RQG7vZyeNn3J4xMrOOYx05BwxTcxvpGImInqVHEPOGcazUZJp1yfG5h/HRoO
	 TGxHDXm73uK3Z6UBohIUTusHMtPQ+aTmRdUo273Mlws1CQF/u8byGXa/DsU5bg0YH0A==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 691951F00899;
	Fri, 27 Nov 2026 21:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795814142;
	bh=UjluyBnoXBDetWmY7LL/gAafORAZ0sgQFtuZ/uqzehw=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=Ovlt0U+F/lcSviGq28ho+TDv3PGIiW1+8gNQwNi68CgNYGnNdglbjvbLCex5TzJ+8
	 0fNCXUBiy8cuMkG2650C7agqm+7K5W6MhfIAYRWW4FOGsKqJsB93qWYqieS9D4QISy
	 j457qOu9bTstiyUBoghruAvgqPxmKsontHrEqQ+Wy9ii3b6Af1A6LBExaGNvFZkKXQ
	 +3hG0lqAgjvNOps9Y71+Q0O5hME3mSGQtIJf87Rut8Zj3RkaVKmplvJ0/2gS+RB+R1
	 Vg9FHDPDWzoNiwc0oNH/P3a+/p/jXy7a+RId1tytndluJM81omvlxZRqfM4tewnXOJ
	 /NT3c4VtOt2ww==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id EF6294DDCF;
	Fri, 27 Nov 2026 21:15:31 +0000 (UTC)
From: Dickson Wu via B4 Relay <devnull+dickson.wu.certik.com@kernel.org>
Subject: [PATCH nf 0/2] netfilter: reject mismatched conntrack template
 protocols
Date: Fri, 27 Nov 2026 21:09:11 +0000
Message-Id: <20261127-nf-ctproto2-v1-0-b5383cef8da2@certik.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHfxCWsC/yWMQQrCMBBFr1Jm7UAa0KpXEReZZGIjMimZVITSu
 5vo8j3+fxsol8QK12GDwu+kKUuD8TCAn508GFNoDNbY0zjaCSWir0vJNVs0R3OmcKHINEF7LIV
 j+vxqN5AI97/TlZ7sa8/0FTllpOLEz10pS6g5v7B72PcvpZGukZMAAAA=
X-Change-ID: 20261127-nf-ctproto2-0508bd9bfeb7
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, 
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
 coreteam@netfilter.org, netdev@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795813751; l=1932;
 i=dickson.wu@certik.com; s=dickson-b4; h=from:subject:message-id;
 bh=i71b4CrHv+7F8+HFRek3oHZywpCTEPpzNL6nhGvS7bs=;
 b=0QGhu63aw7WiHz1z/nQvM94YRULFZEao8KtCxvIQ9FTkEq7AA/mWJNe+8wwsv58CdZU/qPobT
 S+DwaR0rcYdBBF0aUyQ9PWDplR7BNi3bbh/m2b+H7bFe3Rrwl2bIzFC
X-Developer-Key: i=dickson.wu@certik.com; a=ed25519;
 pk=fxH7FS4FdojeJSGLJzgKdfO51Rvr4EW30yinj2mc1vg=
X-Endpoint-Received: by B4 Relay for dickson.wu@certik.com/dickson-b4 with
 auth_id=1647
X-Original-From: Dickson Wu <dickson.wu@certik.com>
Reply-To: dickson.wu@certik.com

xt_CT under nft_compat can attach a helper or timeout policy selected from
NFTA_RULE_COMPAT_PROTO to packets of another protocol. The helper mismatch
also affects act_ct through the common template assignment path.

Reject mismatched helpers and timeout policies when a conntrack copies its
template state.

Tested under UML with KASAN, with the trigger running as uid 1000 in new
user and network namespaces (namespace-local CAP_NET_ADMIN only):

- nft_compat xt_CT with the H.323 RAS helper on TCP: stock panics in
  mangle_contents(); patched completes; reverted panics again.
- act_ct with the RAS helper on TCP: stock panics in ras_help() from the
  receive softirq; patched completes; reverted panics again.
- xt_CT with an ICMP timeout policy on TCP: stock gives a KASAN
  slab-out-of-bounds read in nf_conntrack_tcp_packet(); patched keeps the
  default TCP timeout; reverted reads out of bounds again.
- Matching-protocol controls still work: UDP H.323, TCP FTP, and ICMP
  and UDP timeout policies.

W=1 builds are clean. The rule-load checks in xt_CT and nft_ct already
require an exact protocol match, so valid configurations are unaffected.
The gap is nft_compat not enforcing its compat protocol per packet, and
act_ct.

A reproducer is available if it helps.

This was found and the fix prepared with AI coding tools (OpenAI Codex
agents, with review by Claude). I went over the analysis and the patch
before signing off.

---
Dickson Wu (2):
      netfilter: conntrack: reject helper protocol mismatch
      netfilter: conntrack: reject timeout protocol mismatch

 net/netfilter/nf_conntrack_core.c   | 10 +++++++---
 net/netfilter/nf_conntrack_helper.c |  2 ++
 2 files changed, 9 insertions(+), 3 deletions(-)
---
base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
change-id: 20261127-nf-ctproto2-0508bd9bfeb7

Best regards,
--  
Dickson Wu <dickson.wu@certik.com>


