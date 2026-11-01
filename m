Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793546852;
	b=tSR5vNFKlYrpwDGd4aIY1Z79AkBpnvW68FPb12cfntydrTghwET3a5JHEYb14iyqAGqW
	 XaFxChauTdun/+VZCrF4d6UJW7+0WBc4gwpxjtQFXXopHm32oeNm8g08gfS0xTAD1bTOl
	 1eOpdBDNu8CuuyNO1+KqXAUP96lAODXPJ8IOllYXA7ZEI/ZoXXXJjNQgIk6zF1hR9L67H
	 4i8jsmCOnSDmVlTviulQ7+pWINkUedKj8FG8p3mNmTTlm1WWfrwXlSC/84Vb/LfRYUu/y
	 P7BfteEUbGigVS6sGsn0pUdOY/jXTmi0JpE0Nz0We6jiG5TN65sbCKKcUSNt2jshMgw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793546852;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:X-B4-Tracking:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=gJLut8ASX/Ab5sbRbsK49enozmp84PZ10WeFKpY/N2I=;
	b=3k64It7XcVgSkkV1nHXZCUyiIJDCzh33AmREaMw9Dcf5W3pmmUhDnXAtfqGwJFMb0BlS
	 otF/+cJoYTw80ISjnSCBuq9GVOSNpzMIvRVBlalH8IvEDsWQBIIPI0P1yWmZuJlC9vFae
	 4+u80BAq8dBRv0YICfMJHh4qz7KGkMP74y0We36+zT2ICqhMcs+BQuF9fMEJoD1DjhObA
	 zJ2Jwc8y87MEzYWqr6HDPWPZS6XQuyONG57Cu/c4BVUj4IGDv8Gk/PKgRebYnurPxRNuv
	 Iyi8me2BHFsQQ2KVwRqg0cH6xQJb0UZL1vA+INK1D7XtKHiIFNt6Pvpdf1WPYDlqWiw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UzE6gDsw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75314606A325;
	Sun,  1 Nov 2026 15:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UzE6gDsw
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793546852;
	b=PuRTFQadaIpC5shTdIpKco+ARrwwLYDtBo1dJFEm4J6wOcf+OSupHH2/2XrejyK/0IcR
	 GhYE6rAKFBju3zl2np+7vrh8uhCTkkjPuu2WKVRVAH5OcUnhOcbC06993I5VptLHUTyXQ
	 lgciVwESPGK1Nd90YqI8oW+O/BLYlyFI4t9MadmPOfoxlac2SnPdJ1mLhHMKs45P1GCcz
	 wKHsKcmo6v4k18um3FI6alikxP81ME/uQv1u7YL5fRe0gnyD3FoPglldgtQlB+fDn9ome
	 6B6izXBNTzjzBs87ZxS0yFFLyVqmVsNxupQeWwDuzp4CKFDVekErNkMbS9dNi/Ya8OQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793546852;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:X-B4-Tracking:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=gJLut8ASX/Ab5sbRbsK49enozmp84PZ10WeFKpY/N2I=;
	b=NzXHOSqv3B/4l0GqFpLH9PrmCEuFbVhCmZLyUwtcduKaxNCmEa44A2thV/zixbLc5Tbk
	 7FFRiNEADeOuRWv9bzZpU1lsyCF//TgW1NM6xuW2aJlPMzZI78SCfGNkktAayZEdPYxx2
	 89HydzElU7Yl3xlwI/3zyg3UARvl0BsKSYTGPXnOdWUKt9FRDHUeQ/xPdBSxnIsPk/EBr
	 wf2KH3df009vP3U1JZ2tWr3hts4MgldKkQwNbzYlJiSkyA+frjYXMwjT/i6jD9fER83Qp
	 Mp33t4AeOt0hty1iEdUixGuH93YePb+PSJzzSBUfa3+fVpxZj3PI4DDQzAM6ofB2VBA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 8C6FB1F000C1;
	Sun,  1 Nov 2026 15:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793546852;
	bh=gJLut8ASX/Ab5sbRbsK49enozmp84PZ10WeFKpY/N2I=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=UzE6gDsw/iSxm42tp3NXN7tQ0tpqUKYhG3rS08KAqtFvDANEja4Cpfgl9vsUF2uVy
	 FrXtrMvD0pBnvFmDMjjxz6PG4UUejNJHmPZtbhxX63N6n1xW9SsefK8o9tNYMuZvPd
	 9/VYVA9qTpM8h5niQD6xrlWXRS36m4V8ZRBcRaWV2BHAc3R6Tl6GwfdUPB27HosRPB
	 al54qSweZJRM2jrKkZQUvJAlZ9Di+eCXYLa0UUDPhQA49uHCNeKRiByeKOGrKNIVMF
	 k8BF+70A/Z78ySUCHxrKQYdGbdweRO6m3p5mWNrbpto27HBMv+SQiSrYQb+3HkrmSU
	 E9+HNJi75YgDw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 1A9DD461C0;
	Sun,  1 Nov 2026 15:27:31 +0000 (UTC)
From: Joas Antonio dos Santos via B4 Relay <devnull+joasantonio108.gmail.com@kernel.org>
Date: Sun, 01 Nov 2026 15:27:31 +0000
Subject: [PATCH 6.1.y] netfilter: nf_conntrack_expect: add and use
 nf_ct_expect_related_pair()
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
Message-Id: <20261101-nfexp-pair-6-1-y-v1-1-5aa95ee76098@gmail.com>
X-B4-Tracking: v=1; b=H4sIAGJa52oC/x3MPQqAMAxA4auUzEYakVa8ijj4EzVLLSlIRby7x
 fEb3nsgsQon6M0DypckOUMBVQaWYwo7o6zF0NjGEVnCsHGOGCdRdEh4Yzuzt65j31oPJYvKm+R
 /OYCrqb5hfN8PZ09Ea2kAAAA=
To: stable@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, 
 Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org, 
 Sasha Levin <sashal@kernel.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Jaeyeong Lee <iostreampy@proton.me>, 
 Joas Antonio dos Santos <joasantonio108@gmail.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793546850; l=8782;
 i=joasantonio108@gmail.com; s=20261031; h=from:subject:message-id;
 bh=n2l6hhC0bG+nOk0YkOz4F3IR1FdeB1tT1vc20LyRtVg=;
 b=GX9qOqErelNp7byCPfa0ukiqHrLnlMaVYKIjxtJGjx0StTiqcHA+iDHBBg59HbREoeDD0zdoe
 Y9gliQFLKUeAxXSesve0nQ3jG6L/BqK8b/6RXUNigdZCbnSckxgVnlZ
X-Developer-Key: i=joasantonio108@gmail.com; a=ed25519;
 pk=ZxAznJT/FcPPdzLrDDFJQm4LLjjHVGBBqDSG3TXS23w=
X-Endpoint-Received: by B4 Relay for joasantonio108@gmail.com/20261031 with
 auth_id=1371
X-Original-From: Joas Antonio dos Santos <joasantonio108@gmail.com>
Reply-To: joasantonio108@gmail.com

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 4aa63842fc92de1bce59d4709a0d32e718890bb2 upstream.

Add a new function to insert a pair of expectations, this is required by
the SIP and H323 NAT helpers. The spinlock is held to check if there is
a slot for both expectations, in such case, insert them.

This removes the need for nf_ct_unexpect_related() inside the loop to
find a pair of consecutive ports, otherwise inserting expectations whose
dead flag is already set on can happen.

Bump master_help->expecting for the expectation class after checking if
the expectation fits in the master expectation list, which is needed for
this new _pair() function variant to run the eviction routine including
the preallocated slot for the first expectation in the pair.

[ Joas: nf_ct_expect_insert() and __nf_ct_expect_check() do not take
  a master_help argument in this tree, so keep their existing
  signatures; nf_ct_expect_related_report() gets master_help from
  nfct_help(expect->master) for the moved expecting[] increment. ]

Fixes: b8b09dc2bf35 ("netfilter: nf_conntrack_expect: use conntrack GC to reap expectations")
Reported-by: Jaeyeong Lee <iostreampy@proton.me>
Link: https://patch.msgid.link/178377968720.33756.12204817361601593230@proton.me/
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
---
b8b09dc2bf35 ("netfilter: nf_conntrack_expect: use conntrack GC to reap
expectations") is in 6.6.160+, 6.12.114+ and 6.1.191, but its follow-up
4aa63842fc92 is not, and it is not in the stable queue either.  Sasha
noted the missing dependency on 2026-09-20.

Without it, nf_ct_unexpect_related() only sets NF_CT_EXPECT_DEAD and
leaves the expectation linked, while the SIP and H.323 NAT port loops
still call nf_ct_unexpect_related(rtp_exp) on -EBUSY and re-insert the
same, still-linked rtp_exp.  That corrupts the master expectation list
and the expect hash.  It is reachable from an unprivileged user and
network namespace (sip helper + NAT, plus one ctnetlink expectation
occupying the RTCP port).

The affected code is the same in v6.1.191.  Runtime-tested on v6.6.161
arm64 with KASAN and DEBUG_LIST, as uid 1000 in a new user+net
namespace; on v6.1.191 the patch is build-tested.  On v6.6.161 without it:

  KASAN: maybe wild-memory-access in range [0xdead000000000120-0xdead000000000127]
  pc : nf_ct_unlink_expect_report+0xfc/0x418
   nf_ct_unlink_expect_report
   flush_expectations
   process_invite_request
   process_sip_msg
   sip_help_udp
   nf_confirm
  Kernel panic - not syncing: Oops: Fatal exception in interrupt

With it, the same reproducer runs clean.  The same backport applies to
6.6.y and 6.12.y (sent separately); I can share the reproducer
privately if useful.

Tool-use note: the analysis, backport and testing were done with help
from an LLM-based assistant; I reviewed the change and ran the tests
myself.
---
 include/net/netfilter/nf_conntrack_expect.h |  3 +++
 net/ipv4/netfilter/nf_nat_h323.c            | 22 ++++++------------
 net/netfilter/nf_conntrack_expect.c         | 35 ++++++++++++++++++++++++++++-
 net/netfilter/nf_nat_sip.c                  | 20 +++++------------
 4 files changed, 50 insertions(+), 30 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index be4a120d549e..8efc1ed0925a 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -160,6 +160,9 @@ static inline int nf_ct_expect_related(struct nf_conntrack_expect *expect,
 	return nf_ct_expect_related_report(expect, 0, 0, flags);
 }
 
+int nf_ct_expect_related_pair(struct nf_conntrack_expect *expect[],
+			      unsigned int flag);
+
 struct nf_conn_help;
 void nf_ct_expectation_gc(struct nf_conn_help *master_help);
 
diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index 10e1b0837731..d55994fccf5d 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -179,6 +179,7 @@ static int nat_rtp_rtcp(struct sk_buff *skb, struct nf_conn *ct,
 			struct nf_conntrack_expect *rtp_exp,
 			struct nf_conntrack_expect *rtcp_exp)
 {
+	struct nf_conntrack_expect *rtp_pair[2] = { rtp_exp, rtcp_exp };
 	struct nf_ct_h323_master *info = nfct_help_data(ct);
 	int dir = CTINFO2DIR(ctinfo);
 	int i;
@@ -221,22 +222,13 @@ static int nat_rtp_rtcp(struct sk_buff *skb, struct nf_conn *ct,
 		int ret;
 
 		rtp_exp->tuple.dst.u.udp.port = htons(nated_port);
-		ret = nf_ct_expect_related(rtp_exp, 0);
+		rtcp_exp->tuple.dst.u.udp.port = htons(nated_port + 1);
+		ret = nf_ct_expect_related_pair(rtp_pair, 0);
 		if (ret == 0) {
-			rtcp_exp->tuple.dst.u.udp.port =
-			    htons(nated_port + 1);
-			ret = nf_ct_expect_related(rtcp_exp, 0);
-			if (ret == 0)
-				break;
-			else if (ret == -EBUSY) {
-				nf_ct_unexpect_related(rtp_exp);
-				continue;
-			} else if (ret < 0) {
-				nf_ct_unexpect_related(rtp_exp);
-				nated_port = 0;
-				break;
-			}
-		} else if (ret != -EBUSY) {
+			break;
+		} else if (ret == -EBUSY) {
+			continue;
+		} else if (ret < 0) {
 			nated_port = 0;
 			break;
 		}
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index a0b9cb8b00a9..c48ba311ebab 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -425,7 +425,6 @@ static void nf_ct_expect_insert(struct nf_conntrack_expect *exp)
 		exp->timeout += helper->expect_policy[exp->class].timeout * HZ;
 
 	hlist_add_head_rcu(&exp->lnode, &master_help->expectations);
-	master_help->expecting[exp->class]++;
 
 	hlist_add_head_rcu(&exp->hnode, &nf_ct_expect_hash[h]);
 	cnet = nf_ct_pernet(net);
@@ -524,6 +523,7 @@ int nf_ct_expect_related_report(struct nf_conntrack_expect *expect,
 	if (ret < 0)
 		goto out;
 
+	nfct_help(expect->master)->expecting[expect->class]++;
 	nf_ct_expect_insert(expect);
 
 	nf_ct_expect_event_report(IPEXP_NEW, expect, portid, report);
@@ -536,6 +536,39 @@ int nf_ct_expect_related_report(struct nf_conntrack_expect *expect,
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_related_report);
 
+int nf_ct_expect_related_pair(struct nf_conntrack_expect *expect[],
+			      unsigned int flags)
+{
+	struct nf_conn_help *master_help;
+	int i, ret;
+
+	spin_lock_bh(&nf_conntrack_expect_lock);
+	master_help = nfct_help(expect[0]->master);
+	if (!master_help || master_help != nfct_help(expect[1]->master)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	for (i = 0; i < 2; i++) {
+		ret = __nf_ct_expect_check(expect[i], flags);
+		if (ret < 0) {
+			if (i == 1)
+				master_help->expecting[expect[0]->class]--;
+			goto out;
+		}
+		master_help->expecting[expect[i]->class]++;
+	}
+
+	for (i = 0; i < 2; i++) {
+		nf_ct_expect_insert(expect[i]);
+		nf_ct_expect_event_report(IPEXP_NEW, expect[i], 0, 0);
+	}
+out:
+	spin_unlock_bh(&nf_conntrack_expect_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nf_ct_expect_related_pair);
+
 void nf_ct_expect_iterate_destroy(bool (*iter)(struct nf_conntrack_expect *e, void *data),
 				  void *data)
 {
diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index 6b00c81084fe..115d955bfaef 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -585,6 +585,7 @@ static unsigned int nf_nat_sdp_media(struct sk_buff *skb, unsigned int protoff,
 				     unsigned int medialen,
 				     union nf_inet_addr *rtp_addr)
 {
+	struct nf_conntrack_expect *rtp_pair[2] = { rtp_exp, rtcp_exp };
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
@@ -615,24 +616,15 @@ static unsigned int nf_nat_sdp_media(struct sk_buff *skb, unsigned int protoff,
 		int ret;
 
 		rtp_exp->tuple.dst.u.udp.port = htons(port);
-		ret = nf_ct_expect_related(rtp_exp,
-					   NF_CT_EXP_F_SKIP_MASTER);
-		if (ret == -EBUSY)
-			continue;
-		else if (ret < 0) {
-			port = 0;
-			break;
-		}
 		rtcp_exp->tuple.dst.u.udp.port = htons(port + 1);
-		ret = nf_ct_expect_related(rtcp_exp,
-					   NF_CT_EXP_F_SKIP_MASTER);
+
+		ret = nf_ct_expect_related_pair(rtp_pair,
+						NF_CT_EXP_F_SKIP_MASTER);
 		if (ret == 0)
 			break;
-		else if (ret == -EBUSY) {
-			nf_ct_unexpect_related(rtp_exp);
+		else if (ret == -EBUSY)
 			continue;
-		} else if (ret < 0) {
-			nf_ct_unexpect_related(rtp_exp);
+		else if (ret < 0) {
 			port = 0;
 			break;
 		}

---
base-commit: 08889840163ebcdb7e24bf7ec311bc2e6fc3aaea
change-id: 20261101-nfexp-pair-6-1-y-4be7068e7407

Best regards,
-- 
Joas Antonio dos Santos <joasantonio108@gmail.com>


