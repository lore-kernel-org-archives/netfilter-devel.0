Received: from mail-244122.protonmail.ch (mail-244122.protonmail.ch [109.224.244.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F2836E488
	for <netfilter-devel@vger.kernel.org>; Sun, 12 Jul 2026 07:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783841572; cv=none; b=YSgcBSmcKxLGYnpkekvJfHEvOYgUzZ1OAL6VbO2a2xOQvgr/ufifGQLXQrmSeZi4X5sb3DHT6tDTwWz84EArZ/guYOEM2kzYNUGBjInM0NSb+ymqfhF/69r10Iwtf97MfgcRw0wohGz05II/qfdsALlW0ztNOoyXBjH6wtfUxYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783841572; c=relaxed/simple;
	bh=Jdl6JNkPdde7vLMLgohfEgOKbXdYHE+KOhLgor8/M9M=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rv6BBUGQYp1sepCADPPnxyfM5xUh/wv+HNMGAIU4pWv/rRF/yqExi5YLt0Ho/8IIKbVrDN4BI40iEww3EQklq9UTc16rwB/F7lqbHCvHrnIittmXTpqgHUmia64RScmsN6v6Yjqyr2PRIECm0eImT3L9r1V8oK0pcfPGIa9zk0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=exlRMjS0; arc=none smtp.client-ip=109.224.244.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="exlRMjS0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1783841560; x=1784100760;
	bh=d4mU7BaRL93tH/izyrV8uyAWcRguOaVTAwHOqbE3p68=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=exlRMjS0uVaLlZLHS0+0PBfR4ppdnQrJoKkAqJfnk+ZOiDojBPEVK+nX9rsLYudXM
	 HVu68iIcMrUE1UAQwQ+iWHNQdDkgJUW1R2EoXPafsp0pownq8b7Ch7+5uHy3CE1+6B
	 QhYt2Y4VYoy+2z0Cr6OuJ2vQuBwlQBR2AcLdm37eLXK+QKnWado50eCv+FaPhfjvVH
	 Gw4VJU3Ziav8cfZU66c8Wzq4MEKn+pzB75f5eJHp1oMIwtGguCEKyrkAsDQL4MBGij
	 0QM7K/MTwTHGdk8tYNnL38PiJ+IZH+h8lP2xXJ5taXDEO5kjpXakfFZ/XDbe+NORHD
	 9i/LCnuQUXaFQ==
Date: Sun, 12 Jul 2026 07:32:38 +0000
To: netfilter-devel@vger.kernel.org
From: Jaeyeong Lee <iostreampy@proton.me>
Cc: fw@strlen.de, pablo@netfilter.org, phil@nwl.cc, gregkh@linuxfoundation.org
Subject: [PATCH nf v2 2/2] netfilter: nf_conntrack_expect: reject reinsertion of DEAD expectations
Message-ID: <20260712163225.bdf9b106-2-iostreampy@proton.me>
In-Reply-To: <20260712163225.bdf9b106-1-iostreampy@proton.me>
References: <20260712163225.bdf9b106-1-iostreampy@proton.me>
Feedback-ID: 96968035:user:proton
X-Pm-Message-ID: fc688c1f8d83d07fc5274cf855895d33ab56be44
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Since commit b8b09dc2bf35 ("netfilter: nf_conntrack_expect: use
conntrack GC to reap expectations"), nf_ct_unexpect_related() marks an
expectation as NF_CT_EXPECT_DEAD but leaves it linked until a GC or list
walker unlinks it.

Passing the same object to nf_ct_expect_related() again violates this
terminal-state invariant. If its tuple was changed and hashes to a
different bucket, __nf_ct_expect_check() does not encounter and unlink
the old DEAD entry. The still-linked object can then reach
nf_ct_expect_insert(), which links its hnode and lnode again and takes
another insertion reference, corrupting the expectation hash and the
per-master expectation list.

Reject DEAD expectations immediately after taking the expectation lock,
before the insertion checks can alter any expectation lists. Return
-EINVAL without warning or modifying the object or the lists, so an
invalid reinsertion cannot panic a kernel with panic_on_warn enabled.

Fixes: b8b09dc2bf35 ("netfilter: nf_conntrack_expect: use conntrack GC to r=
eap expectations")
Link: https://lore.kernel.org/netfilter-devel/2026071235-geometric-snowdrif=
t-bb4c@gregkh/
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Jaeyeong Lee <iostreampy@proton.me>
---
Changes in v2:
- New patch, based on a suggestion from Florian Westphal.
- Return -EINVAL without WARN_ON_ONCE to avoid panic_on_warn, as pointed
  out by Greg Kroah-Hartman.

 net/netfilter/nf_conntrack_expect.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntra=
ck_expect.c
index 7ae68d60586a..f02f9ecdb08f 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -524,6 +524,11 @@ int nf_ct_expect_related_report(struct nf_conntrack_ex=
pect *expect,
 =09int ret;
=20
 =09spin_lock_bh(&nf_conntrack_expect_lock);
+=09if (expect->flags & NF_CT_EXPECT_DEAD) {
+=09=09ret =3D -EINVAL;
+=09=09goto out;
+=09}
+
 =09master_help =3D nfct_help(expect->master);
 =09if (!master_help) {
 =09=09ret =3D -ESHUTDOWN;
--=20
2.43.0

