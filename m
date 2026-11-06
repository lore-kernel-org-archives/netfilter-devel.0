Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793925519;
	b=rpgO3x89p5eQtmLb6Inh5AH5rEDY2fUVhLl+SU4Xkr+K/cN6Fo6yYUYCmYxv2V67HFlp
	 XpqDgdu3vuAVYy6IgKZ4AHm/zxuuWEMCg5EM46jA45Is/SnkKeb5t2k1l36wLjb6wf/Ah
	 tL98sOJmceA+G0uNr4E6pmVkuiUhu0Spisej0CNv9j6o1S8jIp805gze0AtK4mbJQVsVH
	 TEPA1FQEsXE2hJg/1CtFB4rsAZ0ik5TeNs8OsrEmT6eLyxSZv1nGk9qp0xDaDqexKra0W
	 Eg7eSAO3ZvknDGL8KH17iwf9kY9Z++youHSd5yciPtwQ6sGO8I3yGmMUDvAX4fOQMEQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793925519;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=EoiKEimL8LAzUeiD8K7+zrkXPOCx9rbue0jNd1YRDoI=;
	b=NahNSzNy/VVqXPFlLgdWO1wz3svNoFtYoDqhgaZTEMOytvipUXaFX9QK2AIUCNiAz2JX
	 3oXOAqFX7opFi3N3zmjjzFDLzMUvH71XLbQmAyo/JaZlVCCzp2eibvXAbbEmdxjEFemzn
	 1SD51DdCSViVWueQXBnCNMiXahSHwV1u5SQ+y5WRhn4MqqRsdT0MU6+yvPwfGXzEUKnNM
	 OGwJB/s69kUN6C8Ilx2mbR4NOl4D29VfcDttKmEZYJ/MxtV96dGc8M3106OZiXXtpB2LA
	 QKbGnEUki8+NytDqivb2PTnJJziQxvCQHcCB826W5ZCyH/qRxT1r6AHNyXXoEMM4f1g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kQPCa1KH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024C1606A32E;
	Fri,  6 Nov 2026 00:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kQPCa1KH
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793925518;
	b=pWUv8jjHUEG6Z0/Kjbties+dVVJsJQuqgwDl2oRHJC7chWKsKe/Om0oGSDwfr2E42EZz
	 Tr8eLuKlPT+AVP00GyFiKWak5ZHwiATi5T42usy86Q9ibd/mmhhOLJdIiH9QrTG3u2EUz
	 g3wQ5AEnfNt4e/lQZJSVW4NX+celKLPaKd9+EEQ6pN+48Z1sXbWNa8AwNF5MZtjVMb7tR
	 y+eyiFSeMWCm6wBFf2kqMrQEbV8sPZC5Kx5E/ghsJLzUdGcwc2s/FCZq428krjIsC/mov
	 p/gEaiW8p6mXCg+6b8THN7cbukobEZ/MFM0D5OJ2gwE/ttFwa22G5AJcaAo4oGX3Gxg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793925518;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=EoiKEimL8LAzUeiD8K7+zrkXPOCx9rbue0jNd1YRDoI=;
	b=PKoevf3Qc9WXGHlBPFb06tQxvjCBnHxgRkveAI6DfTb8ugAKGQxds9OQ4eCevS+mTlsp
	 WZZVIJKIMZy7/K0q71TrgkxsFIfVrZ8vfUs5IjiXeDwa/RiHWoOfFH+HjoJpWJb0dpHkL
	 GqlZKsfQEsqcmtbsWNM7f19ahstZP9hOlvIX4tZldiqP/MuLs9hSijcPWDMktPYXkeCHB
	 PUEDP4FrjQZjsDX2YAN/p0QBG2E7gjI8MpSA/fvHkY5czMzeI3onStnnTclpTLDNj7lL1
	 T3Fy1ETmayeC1Rm82PRv7ahSlKW43L0gPXJhM/PYsw5E2epovayFb5zMvO3TMAO934Q==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 156101F008A1;
	Fri,  6 Nov 2026 00:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793925518;
	bh=EoiKEimL8LAzUeiD8K7+zrkXPOCx9rbue0jNd1YRDoI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=kQPCa1KH5DpGHt6NmSAZsp0wsf1UYQUaEqujZNC6OTRYt4A5h966iLeuWsOTRw9xR
	 S2eI/OP8kL/12XWPVxRQ2+bX6Hqtc+MqxMmriwEvbrewCuDvdam2ejkBYBkXtCRzUM
	 ynLOijvzjf1VCv3XmRtt+TgryCYmtiotGKADvfj2sSWfrmbS/IHOGGUlki7GsaablH
	 p/KELVjmCutpFt+AeWnS//YGp2rj96WEhSmnWFzp753m2fxSXZ7R1uxYq3vU60JEsy
	 1dN/GCQuga8HDqUN/EYQsGIdT5Hfu2/16hib0+oZdlTjKFxongvuIShzUva3S3CgIu
	 iPbszgCx0ecYQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 771A945AF2;
	Fri,  6 Nov 2026 00:38:37 +0000 (UTC)
From: Alireza Asgari via B4 Relay <devnull+alireza.asgari.net@kernel.org>
Date: Fri, 06 Nov 2026 00:37:04 +0000
Subject: [PATCH RFC net 1/3] netfilter: nfnetlink_queue: reject duplicate
 pending packet IDs
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
Message-Id: <20261106-nfqueue-review-v1-1-b6c933f44943@asgari.net>
References: <20261106-nfqueue-review-v1-0-b6c933f44943@asgari.net>
In-Reply-To: <20261106-nfqueue-review-v1-0-b6c933f44943@asgari.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>, 
 Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org, 
 netdev@vger.kernel.org, kunit-dev@googlegroups.com, 
 Alireza Asgari <alireza@asgari.net>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793925516; l=1761;
 i=alireza@asgari.net; s=nfqueue-20261106-d5b860a0;
 h=from:subject:message-id;
 bh=H8ooWtA1mr2Wq7BiH1vRavQSsCcbnCRuf8kq87M4yUU=;
 b=84zUIRG+XE722zKxiEYoCLVl6WGYPK4vnkbl5+ISktq8p6Dji8ar1sNsaWAEdMESLei6jWSKk
 G0u+QkVt0z3CrggCgC8bJsnmpfMn31HqytmWM91Lae2aDyyoHlMleSb
X-Developer-Key: i=alireza@asgari.net; a=ed25519;
 pk=zQFqyM4zwBHzads8dtEOnNQiQQ1pktgndpKPB3TI+AE=
X-Endpoint-Received: by B4 Relay for
 alireza@asgari.net/nfqueue-20261106-d5b860a0 with auth_id=1424
X-Original-From: Alireza Asgari <alireza@asgari.net>
Reply-To: alireza@asgari.net
Content-Transfer-Encoding: 7bit

From: Alireza Asgari <alireza@asgari.net>

A queued packet can outlive a complete 32-bit ID cycle while newer
packets receive verdicts. rhashtable_insert_fast() permits equal keys,
so the reused ID can identify two pending packets and verdict lookup
can select the wrong entry.

Use rhashtable_lookup_insert_fast() under the queue lock to reject an
incoming collision before list insertion or userspace notification.
Preserve the pending packet and use the existing enqueue-failure path:
drop the incoming packet by default, or accept it with FAIL_OPEN.
The attempted ID is consumed and the next enqueue advances normally.

This enforces uniqueness among pending entries. The unchanged 32-bit
interface cannot distinguish stale verdicts after an ID is released
and reused.

Codex assisted with development, review and validation of this change.

Fixes: 7af4cc3fa158 ("[NETFILTER]: Add "nfnetlink_queue" netfilter queue handler over nfnetlink")
Signed-off-by: Alireza Asgari <alireza@asgari.net>
---
 net/netfilter/nfnetlink_queue.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 90d887546f7db..c71f4fe890eee 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -227,8 +227,10 @@ __enqueue_entry(struct nfqnl_instance *queue, struct nf_queue_entry *entry)
 {
 	int err;
 
-	err = rhashtable_insert_fast(&queue->nfqnl_packet_map, &entry->hash_node,
-				     nfqnl_rhashtable_params);
+	/* A wrapped ID must not alias a packet that is still queued. */
+	err = rhashtable_lookup_insert_fast(&queue->nfqnl_packet_map,
+					    &entry->hash_node,
+					    nfqnl_rhashtable_params);
 	if (unlikely(err))
 		return err;
 

-- 
2.43.0


