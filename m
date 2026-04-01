Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F002C08D0
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Apr 2026 21:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775078479; cv=none; b=uQQfr9FbcxAw7eoRaNiXNFFQYvemYerjoAyP8LgW3CGLHwcwRS467KcFxnqMS9heN2+NbGPaFqH4qYBMpKFFj+efZzJXm3aixzgRlULhY8RjobtakUMzXGO0wmnKxsTw+3nbfL5M3PNUqPc0xNzyURego7SkHNeL3xX4g1qw8qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775078479; c=relaxed/simple;
	bh=ceiUWFuE6/YmjPbAR+dTCdL3AyF7U/F+ps+er5MNyl8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IprWVw7hHLuOVvXOzKy3R10F1YvZgPJrccIiD7repqU03pb+qZvkS0guGwKtShY7x5qLlTCA5P1GCK4g/SXrJiAeQYSdJAwffVs6y3YzqcaiyuGjJ2O05d3H/n0MSHMaapb1VSLYlfTkowhNgdP4qX32yKVf9AfJ4U50lbrutWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=Mg6TteOv; arc=none smtp.client-ip=74.125.82.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="Mg6TteOv"
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-2c1632faeb9so493924eec.0
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Apr 2026 14:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1775078477; x=1775683277; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Mj7P4G0mBP6nG/9FnTYA1QuSPTWr/jns+CKVmZY9R/U=;
        b=Mg6TteOvkj/yTagOYA70ENvVsvilvyE7knDqiG1cIrghyWKkqo5OlZiQdyuWHYAMMr
         un+Hob1rh4BU7UikzHeZJLLOlvvi08Djf2GXm2RfWPTm1Gz+3242ylGJGaqKxfKAqSma
         4gxSL4oDipPv/X1guF/LTqdzjrwN9FUCrMhMhDErXjcTQqGXxfQ1lIj6NHfpfXIN2ivc
         QLMqvK6zdQn6s7sjw46wEfPP4CTVHDSDNxUPonEF/doMlCJJZMkqvRJdy28W0gfjPEp0
         PGMTwyNAvBaWY2W+2uRXu17t5e7KXcjWPn7zJmMAnnJ02Xe8eNgLBH7pstHX4OChcM86
         A1sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775078477; x=1775683277;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mj7P4G0mBP6nG/9FnTYA1QuSPTWr/jns+CKVmZY9R/U=;
        b=sTpuv3tbQTivOu9vUw5sZFUVZUVAbMxKlNInuCCOfIbX///qv4Wtj9yIt8AgBRycvJ
         YdFggPcmsP7nbTZBYp0059l4IpsxMW3xygnBpKaROLB69yATIv6Go68y8iZEvamtgpNt
         z6nKRVuA9GEfTmnhuX0Rww8gk7xOQGntFG0/iEAYeMSoTrr2m6nhqbQhTEbUbs/C2Rw1
         ginNGiEXcAv0dmv+0vsXHtTvC37q1XhEBd34nwGbixjp7/w6+SJPZv78mqpsPew5MStT
         3+xF3saDJHTN89jJThloZH/LbZJHDcVxWpqPZbkrvMWXDxj2MwkS2epF+qhEkj6TXzAR
         Fqvw==
X-Gm-Message-State: AOJu0YzkOcnH9u8Ki+/75iGjnLb5C0b5koM2Vdcn0nuFKk8fTu/7679z
	z0S/qV6qLTf9dzU7h5xJVWP9o43uLJDO3eLvq5VtiaWSzVN62LRiKldej5H25vQirfpyrnfa11L
	JzNo6nrEf
X-Gm-Gg: ATEYQzwEt1J8Ma/YSC9sRh0mqVSBxZA1GprESCW5eX1t0rhA7d30wtgMo2kfrLQ23A6
	Ild0vkLQ9dm+5aaWiqNrYmClWp+uh722p5OHEmPBS8W04LGMVbK7scjan12DCO6IFP9zPC4Tnvn
	WSKs48ljk2ec9CsLfP7N27aINKXae/2sRxI+CY754/z9iamDNiWHurW4UhnJfzFXN+iV4mxBGx7
	Em3KIHMhAOq+MBtNni3LQJE77r44C7pHd57b2RqqGETv3+ldTu2N1LluaOSVE03ahJCRuZJA7Em
	UJTUQgGSbb3e4vGj2+D7oIIf2KHXMdkw34gGBSCggUIzPwoyY5OSD1BL/970UpDf1afACszfjaT
	OTKnteFTEAD9JBiNWN1wnhDIccvYCqIMqiiHtk9FtTMiBzswq9LyBdWX75J8u94vyoDp4ttirji
	F+b+LIePCYchKIlUEB7+h6bpMy/607dWAa5C4x+ocmdyzzsnnEqrupOg==
X-Received: by 2002:a05:7301:4188:b0:2c5:347:e642 with SMTP id 5a478bee46e88-2c932eae777mr3121226eec.33.1775078476962;
        Wed, 01 Apr 2026 14:21:16 -0700 (PDT)
Received: from p1.scai.dhcp.asu.edu (209-147-138-15.nat.asu.edu. [209.147.138.15])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ca7c7f268esm690144eec.20.2026.04.01.14.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 14:21:16 -0700 (PDT)
From: Xiang Mei <xmei5@asu.edu>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	eric@inl.fr,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	bestswngs@gmail.com,
	Xiang Mei <xmei5@asu.edu>
Subject: [PATCH net v2] netfilter: nfnetlink_log: initialize nfgenmsg in NLMSG_DONE terminator
Date: Wed,  1 Apr 2026 14:20:57 -0700
Message-ID: <20260401212057.773357-1-xmei5@asu.edu>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When batching multiple NFLOG messages (inst->qlen > 1), __nfulnl_send()
appends an NLMSG_DONE terminator with sizeof(struct nfgenmsg) payload via
nlmsg_put(), but never initializes the nfgenmsg bytes. The nlmsg_put()
helper only zeroes alignment padding after the payload, not the payload
itself, so four bytes of stale kernel heap data are leaked to userspace
in the NLMSG_DONE message body.

Use nfnl_msg_put() to build the NLMSG_DONE terminator, which initializes
the nfgenmsg payload via nfnl_fill_hdr(), consistent with how
__build_packet_message() already constructs NFULNL_MSG_PACKET headers.

Fixes: 29c5d4afba51 ("[NETFILTER]: nfnetlink_log: fix sending of multipart messages")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
---
v2: use nfnl_msg_put to init

 net/netfilter/nfnetlink_log.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index fcbe54940b2e..66ff23c444a6 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -361,10 +361,10 @@ static void
 __nfulnl_send(struct nfulnl_instance *inst)
 {
 	if (inst->qlen > 1) {
-		struct nlmsghdr *nlh = nlmsg_put(inst->skb, 0, 0,
-						 NLMSG_DONE,
-						 sizeof(struct nfgenmsg),
-						 0);
+		struct nlmsghdr *nlh = nfnl_msg_put(inst->skb, 0, 0,
+						    NLMSG_DONE, 0,
+						    AF_UNSPEC, NFNETLINK_V0,
+						    htons(inst->group_num));
 		if (WARN_ONCE(!nlh, "bad nlskb size: %u, tailroom %d\n",
 			      inst->skb->len, skb_tailroom(inst->skb))) {
 			kfree_skb(inst->skb);
-- 
2.43.0

