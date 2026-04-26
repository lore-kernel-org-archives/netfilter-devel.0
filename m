Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADCA23507C
	for <netfilter-devel@vger.kernel.org>; Sun, 26 Apr 2026 14:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777214941; cv=none; b=r6LW+HR7yuMxbpR3AKMCEeSKIL5/M+k9hVgDPlriIVyXhES40YJmoJbYajkligNiWIN8qOs5k81ewzgy9bb3BQwZEKGQbOehdYegXKQPoKutqWKzD+ld4aTwkr+r+ph538DMNCKmzlm3PHaVmvziDT//oYL9q9OZCmA3e927v54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777214941; c=relaxed/simple;
	bh=EzaF9ukZm+IAKve3Rcdx43rJkgsEruseuaZXvOJfxUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aSOPoLr/FZYMy4n6J4j//Bblcu7FxNfaD2PBIfmZ5UtQFyG7RBxyVxgKvvi6Q42MsLNaUlfDrOyFeHJNHIUaiZb/u0AexQvZLjBZ9LfANFMExXizppAviciE6F/Tnya0QtyH+210DOq0r5GuKYJVduOix4K1xzxM08/KYaeOaeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=drDRW9oD; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="drDRW9oD"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8a48deebe95so73244616d6.0
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Apr 2026 07:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777214939; x=1777819739; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pagQ43wFSn3iS5OfTh2ag4EpAzA+S21IQdQp4DAN0tc=;
        b=drDRW9oDKstVlaxXvZmK7xt0hNw0a+hWj1qkNKcTFwMMcBlivtzWqtXDFHf0fcpr8U
         Jium+jf3yPX1QcY1TGs9u9XBni6BmJeQJk10fGoZdtJQSg0+hxXuwU4DPS5CL9S7jDWh
         KkflcSraz8MADhna7IscqciRiJUSLDDNsNRKWFMOtSDxfQAelGM0Y/XpFqRnQut2sDtF
         TEBhq4je2/DXQpy8vvelvtroAQ1Fso2P9cmqQL6XZ0I/Wg7mb+GbQ43SF1eN+C057Tx1
         6S9QE18KAIOkfHJup+ksoRGDBPlKrKDSrXCju+YoSRfWZxXCrP6Dm30G6q4sEleLcefs
         bmbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777214939; x=1777819739;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pagQ43wFSn3iS5OfTh2ag4EpAzA+S21IQdQp4DAN0tc=;
        b=iuso+uOrIBpU8u+GUK8GBcb+0xsOL+rbToVZOsVEIXflqiXWv2d0ZDSTvYZq35tea2
         /R6OPufJkdu/gKdce2uAelTJ1CGvaL/MIeX80x6hvaVCndYtx/hP+hKLvnxJwHlFKCm+
         PARW5gWg8PTBQmzPm1KDWfG+luW3B7QbhrOFxLt9icV30RYsiDSIAW0yV268ElRv0Gqg
         ny/Tg28dHAxzDkv7iF4laYnlOVbZ/5vrowe5wc0CJ9H1cABkBikgcJeYx0SK4QBaX0N6
         4Ng7pT1jOrzNqyon22LKixLze5IJaCM6nVPKzWPsRygr+V/GwT24y9gdZIAaTwmvSdwx
         kVSQ==
X-Forwarded-Encrypted: i=1; AFNElJ9M71SZ0mPRLGR9/4PkAj8t8JP8yW9BWULRnfFn6hAV2WOoFXYQkHdJ5LnWUT3GSsmV+LaoLmJj8wIuuX3tF8I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz78Ld54p9WjvCQbRTqUObzPL9UDq9Bi0qiZhbhtLAnsHn4eGat
	uPs1oibHt2/K5beqcVA+6jOIszhOfhOGh5xOZSy235aG2O5uEbXfKf2a
X-Gm-Gg: AeBDies3emhuUxZS2KIdEcNIjxUgL024RKUrHWNLzQyoMlHJouI6im+8KShpSOmxFEU
	8/h4loI0ll90FVYgeSvaipp/qGkivy9jnzfu1UCqnRg1IynGIMfMXQXrCsxlU9DTNAKXfFkbMO1
	xanhTreMLbr6Ql1F2U/3XBq2Kb4v//eANG+5UZKEP4IiujR/dct/FJ1xT6yuBdItML/xCVcVGIO
	JnAOHo23hhu9OJpxhxe8h0lC4LWCyTSONsi7Y7pYBIfKWAysnMbIM8yV5nQcYTWeAbUjEwbZ0QU
	eMHSTsBauvF2WJ3XdXaLVVM9bS577wmCUo5MLjWogm0HdSwbhTppSFrPoyi1l0wNEesiXTFzdeM
	XcIUxOJGX5qlZ5Li8YRPYqjoxdaJvAGd6xwFcMCg7654TaPrj7D5EGzjGyX7FZH+wa0jHQAchd2
	ncFOHKmd75jIw/m77ckCMhmH90fTo5MWcOzwipEvbtjTqKPEM6A8DNN1ZlubGvNvanASiXfXa0I
	1vczON9UBtMHFfFp1r4PBGGV3m/n8yWgdturv2EspNJAyzrKKQH05ue1th/YZvQxV1ORvvga1s=
X-Received: by 2002:a05:6214:43c8:b0:8ac:b1ad:3a1f with SMTP id 6a1803df08f44-8b0281108f1mr602566766d6.35.1777214938809;
        Sun, 26 Apr 2026 07:48:58 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b02aebc655sm232579146d6.48.2026.04.26.07.48.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 07:48:57 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>,
	netfilter-devel@vger.kernel.org,
	linux-sctp@vger.kernel.org
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Yi Chen <yiche.cy@gmail.com>
Subject: [PATCH net v2 1/2] netfilter: skip recording stale or retransmitted INIT
Date: Sun, 26 Apr 2026 10:46:40 -0400
Message-ID: <ee56c3e416452b2a40589a2a85245ac2ad5e9f4b.1777214801.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1777214801.git.lucien.xin@gmail.com>
References: <cover.1777214801.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An INIT whose init_tag matches the peer's vtag does not provide new state
information. It indicates either:

- a stale INIT (after INIT-ACK has already been seen on the same side), or
- a retransmitted INIT (after INIT has already been recorded on the same
  side).

In both cases, the INIT must not update ct->proto.sctp.init[] state, since
it does not advance the handshake tracking and may otherwise corrupt
INIT/INIT-ACK validation logic.

Allow INIT processing only when the conntrack entry is newly created
(SCTP_CONNTRACK_NONE), or when the init_tag differs from the stored peer
vtag.

Note it skips the check for the ct with old_state SCTP_CONNTRACK_NONE in
nf_conntrack_sctp_packet(), as it is just created in sctp_new() where it
set ct->proto.sctp.vtag[IP_CT_DIR_REPLY] = ih->init_tag.

Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Acked-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_proto_sctp.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 645d2c43ebf7..7e10fa65cbdd 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -466,9 +466,13 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
 			if (!ih)
 				goto out_unlock;
 
-			if (ct->proto.sctp.init[dir] && ct->proto.sctp.init[!dir])
-				ct->proto.sctp.init[!dir] = 0;
-			ct->proto.sctp.init[dir] = 1;
+			/* Do not record INIT matching peer vtag (stale or retransmitted INIT). */
+			if (old_state == SCTP_CONNTRACK_NONE ||
+			    ct->proto.sctp.vtag[!dir] != ih->init_tag) {
+				if (ct->proto.sctp.init[dir] && ct->proto.sctp.init[!dir])
+					ct->proto.sctp.init[!dir] = 0;
+				ct->proto.sctp.init[dir] = 1;
+			}
 
 			pr_debug("Setting vtag %x for dir %d\n", ih->init_tag, !dir);
 			ct->proto.sctp.vtag[!dir] = ih->init_tag;
-- 
2.47.1

