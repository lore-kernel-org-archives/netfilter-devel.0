Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B3A1E0DD8
	for <netfilter-devel@vger.kernel.org>; Sun, 12 Jul 2026 07:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783841565; cv=none; b=aZ/dSlGvr8n24TDK14ncwhCRwJyTT6FQ42TPhaEZEYZNOCKXA+pxYwvphMM+9uuGKLSlIi6cYcRimYoS/JsjMDIgMr+y79yx+RyCzO81fAZA0wFZLXdq/5TcqaPzHFxc2OXymhzWmno4AMdvSGBoXc6o6uOQ8l7xVc6NjNBG0w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783841565; c=relaxed/simple;
	bh=kfsMJQNLH3l0a06WfEBmzcIn+k2AO8aTdUd6cbohKpo=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=SAJqXfegT8C8+h78m5BrDqm+4iIJhXn3LhOGLzn6QitzkDnvfpoMUOq/EAFGczKvvdPtQQ2bBjRlZlLEwyNivTF3StzhnDYg506D2JRn8Vbk/r/SH6VXhCoOOVRdSS1btbnxEIlgN8m8XLLbxhzBekrx3+wqfq3YJE/I2Qcp5fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=Ul4hlkgL; arc=none smtp.client-ip=185.70.43.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="Ul4hlkgL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1783841555; x=1784100755;
	bh=t6YKoDCWnfd7Owjag+TIs+QOCqTpIqtiO2bhLjBbFLo=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=Ul4hlkgLJe+pUTIhJVjPE6BHH39yuDgQpAY60Pn7ETinkZqxDp07eoaQARFBCgM8n
	 +gyYPJ9JXm2Qbyq1rBjBPc6JkSyCh2fCi8llzGK2A70GO+0xcYvNZHpcWrGtkpp8PK
	 kQ6WvBvRIcLqQumR74RNpoRzoSqlFvWbH6L5OcQqdD5OjRbKWQOp4EBT3EKP2OM3gL
	 ESGO/EE+4rSmwRvNk93cQnDbKZLN0VGBT4SeCAr05wUUBcDx+J4ZJDUCG4ypfsGWWd
	 sSEKERVEGOB6goTQfEwtK4WqkGCKGz12dQoatK9KKNKgnkEJtcAvZjN1c+kane8giR
	 vLJX0fpFfo7PA==
Date: Sun, 12 Jul 2026 07:32:31 +0000
To: netfilter-devel@vger.kernel.org
From: Jaeyeong Lee <iostreampy@proton.me>
Cc: fw@strlen.de, pablo@netfilter.org, phil@nwl.cc, gregkh@linuxfoundation.org
Subject: [PATCH nf v2 1/2] netfilter: nf_nat: stop reusing DEAD RTP expectations
Message-ID: <20260712163225.bdf9b106-1-iostreampy@proton.me>
Feedback-ID: 96968035:user:proton
X-Pm-Message-ID: 671c529854549afe01f78826974c5246d4a12547
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Commit b8b09dc2bf35 ("netfilter: nf_conntrack_expect: use conntrack
GC to reap expectations") changed nf_ct_unexpect_related() to mark an
expectation NF_CT_EXPECT_DEAD and leave it linked until an expectation
walker unlinks it. The insertion reference is retained until that
unlink.

The SIP and H.323 NAT RTP/RTCP port searches still continue after
marking rtp_exp DEAD when insertion of rtcp_exp fails with -EBUSY. The
next iteration mutates rtp_exp and passes the same object to
nf_ct_expect_related() again.

If the new RTP tuple hashes to a different expectation bucket, the hash
walk in __nf_ct_expect_check() does not encounter the old DEAD link.
While the master is below its policy limit, no master-list eviction walk
runs either. nf_ct_expect_insert() can then add the already-linked hnode
and lnode again and take a second insertion reference, corrupting the
expectation lists. A later unlink or GC walk can revisit stale linkage
and cause a use-after-free.

Treat a DEAD expectation as terminal. On any RTCP insertion error, mark
rtp_exp DEAD and stop the port search instead of mutating and reinserting
it. The callers still drop both allocation references; the linked RTP
insertion reference is released when a walker or master teardown unlinks
it.

For SIP this follows the existing port =3D=3D 0 path and drops the packet.
H.323 follows its existing no-port path without completing a usable
RTP/RTCP expectation pair or rewriting the signalling address.

This gives up retrying the next RTP/RTCP port pair after RTP insertion
succeeds but RTCP insertion fails. That search is best effort and is not
required for correctness.

Fixes: b8b09dc2bf35 ("netfilter: nf_conntrack_expect: use conntrack GC to r=
eap expectations")
Signed-off-by: Jaeyeong Lee <iostreampy@proton.me>
---
Changes in v2:
- Stop the port search on RTCP -EBUSY and merge the now-identical error
  paths.
- Clarify when a DEAD expectation can reach insertion while still linked.
- Add the core DEAD-reinsertion check as a separate patch, as suggested
  by Florian Westphal.

v1: https://lore.kernel.org/netfilter-devel/178377968720.33756.122048173616=
01593230@proton.me/

 net/ipv4/netfilter/nf_nat_h323.c | 5 +----
 net/netfilter/nf_nat_sip.c       | 5 +----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h=
323.c
index 183e8a3ff2ba..f09fa7704b90 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -234,10 +234,7 @@ static int nat_rtp_rtcp(struct sk_buff *skb, struct nf=
_conn *ct,
 =09=09=09ret =3D nf_ct_expect_related(rtcp_exp, 0);
 =09=09=09if (ret =3D=3D 0)
 =09=09=09=09break;
-=09=09=09else if (ret =3D=3D -EBUSY) {
-=09=09=09=09nf_ct_unexpect_related(rtp_exp);
-=09=09=09=09continue;
-=09=09=09} else if (ret < 0) {
+=09=09=09else if (ret < 0) {
 =09=09=09=09nf_ct_unexpect_related(rtp_exp);
 =09=09=09=09nated_port =3D 0;
 =09=09=09=09break;
diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index aea02f6aff09..5878b4a6a438 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -635,10 +635,7 @@ static unsigned int nf_nat_sdp_media(struct sk_buff *s=
kb, unsigned int protoff,
 =09=09=09=09=09   NF_CT_EXP_F_SKIP_MASTER);
 =09=09if (ret =3D=3D 0)
 =09=09=09break;
-=09=09else if (ret =3D=3D -EBUSY) {
-=09=09=09nf_ct_unexpect_related(rtp_exp);
-=09=09=09continue;
-=09=09} else if (ret < 0) {
+=09=09else if (ret < 0) {
 =09=09=09nf_ct_unexpect_related(rtp_exp);
 =09=09=09port =3D 0;
 =09=09=09break;
--=20
2.43.0

