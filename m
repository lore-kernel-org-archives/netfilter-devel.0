Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C3E1FDE39;
	Thu,  5 Jun 2025 08:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749113872; cv=none; b=pOnyBGF7oVDS6zZtjek+feEWiPVDWF40/yvUf8dMpECV8GjAl1N3gkYOpDd1FTckqHoTkiLllLGC/k3X6gifyVCDDzRXK5Zep9ozKqDeoV4OapbXv06N2QWRabOyWTBOGzrSngnmdkdjp8Le/Cow/cYwBlU8GFfVr00AoLOKNg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749113872; c=relaxed/simple;
	bh=5RqsokUFRQ32z562jIvzkISko8/aFy/KIQTCU+9duOI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bl0unwB6pPhKuKFaf6DhxQp47QsAnRteezfJOu62HvF5n2251n+6YLPOosq/kDgiqAbGSGPAOaoVsSHtNg2sxPHbmtvofLqOQ2MMKOYcrhuycdb45/elzwpQC7uwCWAA6rWjljy1+iSFwyQDeXpe79cvxcTwjGeXNOFL/u1fSkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=GQIQJQ7K; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=tSnoG5np; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="GQIQJQ7K";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="tSnoG5np"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id D73CC60750; Thu,  5 Jun 2025 10:57:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749113868;
	bh=8aWv+KraxHNACl96bHonmy4FC5YLjhGEng20f4OByjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GQIQJQ7KmBsHpcE1Lv4Bjw8tB4fhWd8zXhudYvz1po18OK6nmZMVHMzoMcwraoDzf
	 rPCmlrETMI/jaujcZgaqISjlNHYVlQuaeEjeXofOqqQzYManbYOHkStb2DoOgq98Pu
	 NPcYUZZQZejiGCbskwDDXctrHRwR4EAjNzZg9wAqgDeJX/nOm90QJwf19MxU5Gr32z
	 JnYkGeLoFAK4ete+jLrv0sfytYepQoe7LRoZSrB4fFnOz4pbr/EA9+5594RO4Tu5fQ
	 x4EPNbjlLob+b4/tLNdE49s+5XddBuVaKimLQ0tJgaaGnvdq6THZ4/19in1O5IbbSQ
	 TQP5vvYAQC+ew==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2C9FD60750;
	Thu,  5 Jun 2025 10:57:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1749113862;
	bh=8aWv+KraxHNACl96bHonmy4FC5YLjhGEng20f4OByjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tSnoG5npU15K/0XavvXm4LjVRZ+8cx0E9cMxrOPDPAo0tWfQilBWdWIP620XorHky
	 GLJqPOyQgHg/HmNO5AVEtpMAgFsFPDkqb1oNMr5iMfDZ/2YKyvIrMLpIcuMSOid8dA
	 u7KrJBU8D92G08q+5HeA/UJbG0g2dP2oQR1BfL9r18Oor01Id7rhE/KiRgLpkSNDUa
	 K6KctSZrAzIi+Mm4PBy2pkbF7VpMxXDRpv8RdB6no+nJfdqYgzjC2hwk7b+7ZE1p5R
	 8r9jJcIvqLvGRR8IWYSDNcZsUEyexedfSd43Z53dOUvxz6mOQQAt60mI6ukwuhars9
	 IRuG/r/3UUrUA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 4/5] netfilter: nf_nat: also check reverse tuple to obtain clashing entry
Date: Thu,  5 Jun 2025 10:57:34 +0200
Message-Id: <20250605085735.52205-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250605085735.52205-1-pablo@netfilter.org>
References: <20250605085735.52205-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

The logic added in the blamed commit was supposed to only omit nat source
port allocation if neither the existing nor the new entry are subject to
NAT.

However, its not enough to lookup the conntrack based on the proposed
tuple, we must also check the reverse direction.

Otherwise there are esoteric cases where the collision is in the reverse
direction because that colliding connection has a port rewrite, but the
new entry doesn't.  In this case, we only check the new entry and then
erronously conclude that no clash exists anymore.

 The existing (udp) tuple is:
  a:p -> b:P, with nat translation to s:P, i.e. pure daddr rewrite,
  reverse tuple in conntrack table is s:P -> a:p.

When another UDP packet is sent directly to s, i.e. a:p->s:P, this is
correctly detected as a colliding entry: tuple is taken by existing reply
tuple in reverse direction.

But the colliding conntrack is only searched for with unreversed
direction, and we can't find such entry matching a:p->s:P.

The incorrect conclusion is that the clashing entry has timed out and
that no port address translation is required.

Such conntrack will then be discarded at nf_confirm time because the
proposed reverse direction clashes with an existing mapping in the
conntrack table.

Search for the reverse tuple too, this will then check the NAT bits of
the colliding entry and triggers port reallocation.

Followp patch extends nft_nat.sh selftest to cover this scenario.

The IPS_SEQ_ADJUST change is also a bug fix:
Instead of checking for SEQ_ADJ this tested for SEEN_REPLY and ASSURED
by accident -- _BIT is only for use with the test_bit() API.

This bug has little consequence in practice, because the sequence number
adjustments are only useful for TCP which doesn't support clash resolution.

The existing test case (conntrack_reverse_clash.sh) exercise a race
condition path (parallel conntrack creation on different CPUs), so
the colliding entries have neither SEEN_REPLY nor ASSURED set.

Thanks to Yafang Shao and Shaun Brady for an initial investigation
of this bug.

Fixes: d8f84a9bc7c4 ("netfilter: nf_nat: don't try nat source port reallocation for reverse dir clash")
Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1795
Reported-by: Yafang Shao <laoar.shao@gmail.com>
Reported-by: Shaun Brady <brady.1345@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Tested-by: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_nat_core.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index aad84aabd7f1..f391cd267922 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -248,7 +248,7 @@ static noinline bool
 nf_nat_used_tuple_new(const struct nf_conntrack_tuple *tuple,
 		      const struct nf_conn *ignored_ct)
 {
-	static const unsigned long uses_nat = IPS_NAT_MASK | IPS_SEQ_ADJUST_BIT;
+	static const unsigned long uses_nat = IPS_NAT_MASK | IPS_SEQ_ADJUST;
 	const struct nf_conntrack_tuple_hash *thash;
 	const struct nf_conntrack_zone *zone;
 	struct nf_conn *ct;
@@ -287,8 +287,14 @@ nf_nat_used_tuple_new(const struct nf_conntrack_tuple *tuple,
 	zone = nf_ct_zone(ignored_ct);
 
 	thash = nf_conntrack_find_get(net, zone, tuple);
-	if (unlikely(!thash)) /* clashing entry went away */
-		return false;
+	if (unlikely(!thash)) {
+		struct nf_conntrack_tuple reply;
+
+		nf_ct_invert_tuple(&reply, tuple);
+		thash = nf_conntrack_find_get(net, zone, &reply);
+		if (!thash) /* clashing entry went away */
+			return false;
+	}
 
 	ct = nf_ct_tuplehash_to_ctrack(thash);
 
-- 
2.30.2

