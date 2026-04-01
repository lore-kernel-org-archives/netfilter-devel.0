Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9EEB2F90E0
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Apr 2026 19:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775073475; cv=none; b=dvlC7ACtqUwgzSU1bchfExUYXIhF3dL67D/y5g8K0vHpIA807U+tbqRO9ZosZdj4Esg38hcKbagIy1XaQT/6lYfI2LT8ERqi0omuzt/h4jZ4KrF5PD+VWB6VEQl1Jn2k3Q1XDju4D/C8n6H+ZTlV9fjJwJqZznf8hGRMwwOBr4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775073475; c=relaxed/simple;
	bh=unEbOdgeG11Dld7ycx+4oWww6aKqjFlb3XITUjj8xJg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uwmyB2a3SXIMYP6o82tTY6iYRaKUeMbWlrJAkGZyAC+MsSWCEV558Oe96xcE8iT3VNqjzYLvw7yO4wV9lFWszoTdkvDBL2I4tsSE0UsOUDpBO+4vrQZ5lrbswDUui7R9QsRsowmmgCbYuSEUIiZHH25jNYysb3AP7dviLvH63EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=STdnQ0+l; arc=none smtp.client-ip=74.125.82.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="STdnQ0+l"
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-1271195d2a7so695509c88.0
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Apr 2026 12:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1775073473; x=1775678273; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aeITYxK34c/QDzcWz7FhrmR9ZS2GxFl1Q0wwk/XvrR0=;
        b=STdnQ0+lWiocYIJyVmuvCHrqzSz+dRo/lEVN1klQ30ZmXgXbjqOdItypPfyMrslnse
         n5wfRZXHt4fcHY8lAfy3UfBaB83h3vftY4vj4fE1OgXwpSycNgZAkmMJSFzRr3LLszxa
         xVKBM2uh+Vz3N7l9gQJve27K0xMU71vasEXpE9EvjWHR0gnAJrfVr+YhiuaICMOELYRm
         aVVNKHNdc9tR1wM10UA5YKQomrudAgDL+DDtycDIyNyCUWxFD65U9H6UfZP5OT9GfUgC
         vDv0P49q/3Z/ot5q66fnTPM1xnKlli+VsDiia+ONNzoLPaqxnsmojLqnSmzZXp5D41U8
         2biw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775073473; x=1775678273;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aeITYxK34c/QDzcWz7FhrmR9ZS2GxFl1Q0wwk/XvrR0=;
        b=JlvnvbFTT5QeIAap79xVcngz27BaQIhN0bGuUrzreLKnQBcexKALk3uAve3AU1yON/
         uiqQBZjdcwDXFyeRehAslSgBovZTx/babVTatoZ+O9hu8AmUjRfmlGfI641kYUEsknNJ
         Jqw3TKZjmxh8WKRJH9539iVuCZYy+CWijKOIUud6Nbp1USQH8inhuxZIyzb7oB8DiKPo
         iszmrKYryDmMJJjtFUxC+J1rgsgTGAwn91rvWTEyl8wchT5RBVUKfrhmojwI2t/DiiQv
         PBhVxJ5kpUxtXGQBVOLBRo4fx7wYPL1SyNYoctarr16atcaGk3nkRzL5VMcDXLd9HfXn
         0zvg==
X-Gm-Message-State: AOJu0Yz9FDIVmmuFFE9H+RRSsouuVKZNzhBXa77DA5mGpL376vztaot5
	+8v2ODwvLsesbYtymQs+C+OE8teqbpB0M52o5eKQBbujB7lcMZl11AHOu0xlBq3Cz6XswSCDBB6
	74xFaPTYY
X-Gm-Gg: ATEYQzz3pjzkaIXpQsrfRKSgwiMdgaqmwLROrFOMsLvxqK1gREqYRp002At/J+UWImC
	YjIG3Adu9YUVbIyzjpPzsIQwWGt0ncRd1C7V24J0TBgol2Fr1DTUz6DrL6gmIEtdE4WNBDPVhZj
	YaRN19LXgTIKVyA1MHyx+Y8ZsUjoywr+ifXIvkVP26hR/CCXGiMh6t/sulBMd3FhKYP4QW1h2ji
	TAcTLZjg//tTVUCIr0fmZBit+MAcX7Rijxk9uuuvOX0iow+FF4mSLEo0wA/t5FghhyjzLBtCsMV
	60k4fC2iMvnOHLHhtKzZfzBxG/NUbtymf7Ws5ZPG598LiXpwjCU/YkMJNCX+NnlcXg0Il6AdaEX
	Q7eVpsYffJbFInc6CadTS6M/AxkSHYLFB7xhYrj4wEe6FvRGpLVKr8uJZkXSpX/+uNPcNT1MTsy
	fB7ahqLsMrDVqbATYm5stQ7+1FI8qE5bNjIpcMy9E1Rlsl6r7oarEkrw==
X-Received: by 2002:a05:7022:fd07:b0:12b:ed30:5b85 with SMTP id a92af1059eb24-12bed305f94mr912158c88.2.1775073472682;
        Wed, 01 Apr 2026 12:57:52 -0700 (PDT)
Received: from p1.scai.dhcp.asu.edu (209-147-138-15.nat.asu.edu. [209.147.138.15])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12bed93f861sm1540852c88.0.2026.04.01.12.57.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 12:57:52 -0700 (PDT)
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
Subject: [PATCH net] netfilter: nfnetlink_log: initialize nfgenmsg in NLMSG_DONE terminator
Date: Wed,  1 Apr 2026 12:57:35 -0700
Message-ID: <20260401195735.564488-1-xmei5@asu.edu>
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

Initialize the nfgenmsg struct after nlmsg_put(), consistent with how
__build_packet_message() populates nfgenmsg for regular NFULNL_MSG_PACKET
messages, to prevent leaking kernel heap data to userspace.

Fixes: 29c5d4afba51 ("[NETFILTER]: nfnetlink_log: fix sending of multipart messages")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
---
 net/netfilter/nfnetlink_log.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index fcbe54940b2e..ad4eaf27590e 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -361,6 +361,7 @@ static void
 __nfulnl_send(struct nfulnl_instance *inst)
 {
 	if (inst->qlen > 1) {
+		struct nfgenmsg *nfmsg;
 		struct nlmsghdr *nlh = nlmsg_put(inst->skb, 0, 0,
 						 NLMSG_DONE,
 						 sizeof(struct nfgenmsg),
@@ -370,6 +371,10 @@ __nfulnl_send(struct nfulnl_instance *inst)
 			kfree_skb(inst->skb);
 			goto out;
 		}
+		nfmsg = nlmsg_data(nlh);
+		nfmsg->nfgen_family = AF_UNSPEC;
+		nfmsg->version = NFNETLINK_V0;
+		nfmsg->res_id = htons(inst->group_num);
 	}
 	nfnetlink_unicast(inst->skb, inst->net, inst->peer_portid);
 out:
-- 
2.43.0

