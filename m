Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792666929;
	b=ArFkUzeLaqvOf/CO53v109op5BQpuwReG09DP484i9pt2caZFLbYzn9+fEgUBCsZrVxb
	 QTBiZddQb5UPLQd3DRjSALLi+wJUrxZgGD0hYGz2N/Gj8+i1yCtmUGk5WwajTf5wbzsoP
	 vgjckzNPzHWLDR6Q59ZGEF9Pj+i2saVX/6q+miZsbn3zQ4KHCMLDpbXnf6w4DwElYENZg
	 282FViyW/c52dhf2c4aOmDbMzsT6hJKeE7DvPBokI04KXntf0YorHoIlDW36/7+H3NdV+
	 3ECwktlJ/z1jWjkvwu8ikVE0+BMhGXf/5Dmj5aHjmcQNk9WS1m+zMoubaf2i5bj0QUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792666929;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QRHuvewQDkW7Qs/NCBaG8NxQX27dKGA8PbOiyV1o5wA=;
	b=oStuZ3il4x/rCOnarfos1yWV8NpQqedlUGL0WD/KV+9Ljck+Uy4wQLEDTvy3CIB8sCKT
	 ETJ8iamZMGOois5uvc/hpHFTS+YtxZwigTFqREWOa67qskVOtYfMQsKmWuDswqxlepVrH
	 8s0HhXmKiyoaseazyS8jRYQzfgPH5BZ6U/ZPcliJxxL2QMLTqihiNd1eN8G07aTg4Bc0S
	 /LaRlWQyzsXbgkaowYdzyiRLzXepUgdcrMKFLHPUUxNAcd5mDZ52x5ojbWLxawJdJGik6
	 +Jtago5scfSLXc+uTzeFboj18JslFZ9E1wvjVAGOp9W9ThUWBog7QmufUodw6RrvdtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=MqVndisA;
	arc=none smtp.remote-ip=209.85.219.43
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8EC606A31D
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2026 11:02:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C8EC606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=MqVndisA
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-91b8b456dbeso18590366d6.2
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2026 04:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792666928; x=1793271728; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QRHuvewQDkW7Qs/NCBaG8NxQX27dKGA8PbOiyV1o5wA=;
        b=MqVndisAcnNte2/6UioG0DG0DwjYzQiSHzvKaAL8eqlaL1AlFqw1fHMfS7Tp8fTEGo
         S++ORIIyyNfQnBTWLVDPOmjLsmBH30ueivMH6u31kIUsbu4VCWwDFR5Qj0B0uVOpz6Be
         79uvyEP9ZPy/88Y4Z/qfHqbou4BaIAwIGMAGSMRD61lhwU20YP7qHEcjHpK20KUt9R4I
         fQ/WN9HRzK+4fpAC8tWdmZXw1Enzs+xSFiW91veffNDck1Xg88sqUeaQdGOYzyF15FsC
         Ew3qOkBJqT5SLv8vm3xebMSJu82q7SJ9Un9S+TKe/Io/xhdOQROaKfdHT2X2IuEiTa5p
         h0lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792666928; x=1793271728;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QRHuvewQDkW7Qs/NCBaG8NxQX27dKGA8PbOiyV1o5wA=;
        b=2TsaxfZ20bSFZ+cBLdRZxKYWgKYu1l+keEhz+JoH6YwGJeiTVEhGJ/3MDCejtJKo1v
         z65ThWgdkyEgs04zu8XolDcKNH/jM+DyKrh8oNtRb5TC/bhfeJMUEIP97i292vvNQKLB
         fbBkVhySs1ZCvDCxv6uETjPFlx06vr8ytdBQHZgtc422PMbfU+mSspNqhQOadh3BU/dW
         z+U6fvq8+6JUD+/tlZpZLeWS5MyLxbTr1dmfnMvFMqO99GBq3AGPnGSVg+CFiq0PBNJg
         sNsd0lNUIjgqv2uCrwjckbwgkSxxXwPp8nX1s5lOxsTFdHQzgjiRoDditRlkxWoA/xm2
         LfGA==
X-Gm-Message-State: AFq9FYISIEcwyjhPduAto7WbQ0Z0VgYqHxIFq0wO/b43RTIWrYeKwY8s
	YLU7x/A8Y4mQlsp5IsXeeytXFRIqdRFI9CTj0L4e0j8/laTylXT95vfj01yB7mCM
X-Gm-Gg: AYBFou2e0osZH+Fo5jescX+wJJIIMTNpuvfMpS+Odz24jMcTfrSbX1lhDzUnmWK15Iu
	3iMzc6chbTFNE1cf1ijgzFMfiaK0p2yTuer2nKwTo9fZ/EV2oPHVudnH+mVNzHvxSBrgo7rkoyu
	ZAmgdDdPcWcpT9I26i4QhVGvYqSZI4tmImh5zJsWS3BC4G21udbbVlttGzN21ZfsSJuLyPz9uPg
	KiKrTXoULqtR7qXN+0lw2BZJ6krtWH5MD06U9AZmHrbdZwcbRthmVj9RhpidHocKjRdChbO86AY
	kAfqW+swmnZF5EIKdQmmik62m1W+tHb+hCfpxorsVZyhcurgzeXEe51q7G4YGpdMxGkmYPXs2II
	3MVAMehpDxx9BPCmFLVRq2ViM2IB8Bo1YYFmmYX2P/I1Lx2Oym5JfuIkg/7gCaDClE2n5qsNoFi
	znhuyBN/zC8IRNFppWOARLSxcq9UMSPF/7S+QW8F22v1/AfV2twvxVYdpnlDrKr88rADmGaLwty
	XNgAYioPgWfR2/gG/UZWWUFc7b/B2//ADPbwXkvlJg+QVuD3ITvdqWktILY/ZPkn4KVU7mw5EAV
	812lAVprT0eWBjSqdv59Dvg3BjxCWq24wHGQDOd4xXp7sJ2zDEuT
X-Received: by 2002:ad4:5ca7:0:b0:914:4464:41a9 with SMTP id 6a1803df08f44-91c12eff859mr82758566d6.29.1792666928067;
        Thu, 22 Oct 2026 04:02:08 -0700 (PDT)
Received: from b2r3-prox-24-ubuntu18.. ([66.198.16.131])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c10b76143sm48333796d6.14.2026.10.22.04.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 04:02:07 -0700 (PDT)
From: Vimal Agrawal <avimalin@gmail.com>
X-Google-Original-From: Vimal Agrawal <vimal.agrawal@sophos.com>
To: netfilter-devel@vger.kernel.org,
	pablo@netfilter.org,
	Florian Westphal <fw@strlen.de>
Cc: phil@nwl.cc,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	Anirudh Gupta <anirudh.gupta@sophos.com>,
	avimalin@gmail.com,
	Vimal Agrawal <vimal.agrawal@sophos.com>
Subject: [PATCH nf] netfilter: nf_nat: do not link a conntrack twice into nat_bysource
Date: Thu, 22 Oct 2026 10:59:43 +0000
Message-ID: <20261022105943.4003353-1-vimal.agrawal@sophos.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Vimal Agrawal <vimal.agrawal@sophos.com>

nf_nat_setup_info() assumes it owns an unconfirmed conntrack, but the
clones made by br_flood() share one (skb_clone() only takes a
reference). That is safe while they are handled one after another on
the same CPU. If one clone is sent to NFQUEUE and another is not, the
queued one is reinjected later from process context by nf_reinject()
(BH enabled, any CPU) and can run NAT concurrently with the other.

Both callers can then reach hlist_add_head_rcu(&ct->nat_bysource, ...).
Linking a node twice makes it point to itself, so a walk of that bucket
never ends. Also, "ct->status |= IPS_SRC_NAT" is a plain
read-modify-write outside nf_nat_locks[]; it can erase a concurrently
set IPS_SRC_NAT_DONE, and nf_nat_cleanup_conntrack() then leaves the
node of a freed conntrack in the bucket.

We hit this on 6.6.49 (tainted, out-of-tree modules) as a general
protection fault in the bucket walk, from a packet reinjected from
NFQUEUE:

  general protection fault, probably for non-canonical address
  0xabeb549edb10a8d4: 0000 [#1] SMP NOPTI
  RIP: 0010:nf_nat_setup_info+0x8b6/0xba0 [nf_nat]
   nf_nat_masquerade_ipv4+0x11d/0x200 [nf_nat]
   ipt_do_table+0x2b9/0x410 [ip_tables]
   nf_nat_inet_fn+0x14f/0x260 [nf_nat]
   nf_nat_ipv4_out+0x4d/0xe0 [nf_nat]
   nf_reinject+0x177/0x1d0
   ...

Use set_bit() for IPS_SRC_NAT/IPS_DST_NAT. Test IPS_SRC_NAT_DONE under
nf_nat_locks[] before linking and set it only after the node is
linked. A losing caller returns NF_ACCEPT, as before, without linking
again. The early nf_nat_initialized() check is unchanged, and two
callers that both create a real mapping are not covered.

Link: https://lore.kernel.org/netfilter-devel/CALkUMdQ_6aU8Sy8vTORReQ2=vr4TskbkhZQt3WRazwUMTNEOtg@mail.gmail.com/
Signed-off-by: Vimal Agrawal <vimal.agrawal@sophos.com>
Reviewed-by: Anirudh Gupta <anirudh.gupta@sophos.com>
---
 net/netfilter/nf_nat_core.c | 41 +++++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index cc8e1e81006d..3a89c894a520 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -791,11 +791,14 @@ nf_nat_setup_info(struct nf_conn *ct,
 		nf_ct_invert_tuple(&reply, &new_tuple);
 		nf_conntrack_alter_reply(ct, &reply);
 
-		/* Non-atomic: we own this at the moment. */
+		/* Atomic: a concurrent caller on the same unconfirmed ct may
+		 * set IPS_SRC_NAT_DONE (set_bit() below) at the same
+		 * time, and a plain read-modify-write here could erase it.
+		 */
 		if (maniptype == NF_NAT_MANIP_SRC)
-			ct->status |= IPS_SRC_NAT;
+			set_bit(IPS_SRC_NAT_BIT, &ct->status);
 		else
-			ct->status |= IPS_DST_NAT;
+			set_bit(IPS_DST_NAT_BIT, &ct->status);
 
 		if (nfct_help(ct) && !nfct_seqadj(ct))
 			if (!nfct_seqadj_ext_add(ct))
@@ -806,21 +809,41 @@ nf_nat_setup_info(struct nf_conn *ct,
 		unsigned int srchash;
 		spinlock_t *lock;
 
+		/* Concurrent callers can reach here for the same,
+		 * still-unconfirmed ct (skb_clone()/GSO segmentation/
+		 * nf_ct_attach() can share one ct across skbs processed on
+		 * different CPUs before it is confirmed). The DONE bit is
+		 * tested and set under this lock, and only after the node is
+		 * linked, so a set bit always means the node is in the hash
+		 * (nf_nat_cleanup_conntrack() relies on that). Only the first
+		 * caller links the node; a losing caller does not link it
+		 * again, which would corrupt the list.
+		 *
+		 * The winner sets the mapping (ct->status/reply tuple) before
+		 * taking this lock, so it is final once the DONE bit is seen.
+		 * The loser's packet is therefore accepted: nf_nat_packet()
+		 * applies the winner's mapping to it. This is the common case
+		 * for bridge-flooded broadcasts (e.g. DHCP) racing with a
+		 * packet reinjected from NFQUEUE (nf_reinject() runs the
+		 * remaining hooks with BH enabled), where the mapping is an
+		 * identity null binding on both sides.
+		 */
 		srchash = hash_by_src(net, nf_ct_zone(ct),
 				      &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 		lock = &nf_nat_locks[srchash % CONNTRACK_LOCKS];
 		spin_lock_bh(lock);
+		if (test_bit(IPS_SRC_NAT_DONE_BIT, &ct->status)) {
+			spin_unlock_bh(lock);
+			return NF_ACCEPT;
+		}
 		hlist_add_head_rcu(&ct->nat_bysource,
 				   &nf_nat_bysource[srchash]);
+		set_bit(IPS_SRC_NAT_DONE_BIT, &ct->status);
 		spin_unlock_bh(lock);
+	} else {
+		set_bit(IPS_DST_NAT_DONE_BIT, &ct->status);
 	}
 
-	/* It's done. */
-	if (maniptype == NF_NAT_MANIP_DST)
-		ct->status |= IPS_DST_NAT_DONE;
-	else
-		ct->status |= IPS_SRC_NAT_DONE;
-
 	return NF_ACCEPT;
 }
 EXPORT_SYMBOL(nf_nat_setup_info);
-- 
2.43.0

