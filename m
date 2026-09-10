Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1FA3DB30F
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Sep 2026 09:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789030861; cv=none; b=efkk5NNa3+Jh/oxP0e8NCsz0kHrrcZdFt1xJ6u68hogF7GrC6bBD8+buDNaVEL/5zqeHtP7W9B3aHPeGOnRG7Rlojh0L1H8RvplQjrq5PFLveWah93BDjUIFVTMdVCq9yYXZkV3TrT9GHtNxFt/mO5b5fBI9eK/c38MgN2RodZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789030861; c=relaxed/simple;
	bh=NiDvAbsWduwc9Ie7/lzQ65vAjTWmgNeFXc1Agxk/npM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fjykBITcQ0w43mWhp8T9TSx/+2QaHPgx9mTalM9zmQ6DQ30eBybzgG86escS+Pzd6R7xMx1Fwu41311gvIEjgRdwV8yrs1FoD6z/h81ezMCZogw6clfAerctIodQ8jND3ZYCnFHBJgOtMWQ0JymoMP4npiH8pzqIRrOCV3ItijU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=jUZWPaJW; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="jUZWPaJW"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c25b661d37dso1005215666b.0
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Sep 2026 02:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1789030853; x=1789635653; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sI6uVqqlwqaRtMuzW9jXOvHuhO1f712UR/f6QW76OsE=;
        b=jUZWPaJWmpb53Pj2LcFRmD0WJxzKrXbHxw6DZHD9HA7TEWGYS91BGY1kJPNA1PWSJ4
         QHa3AlrEtCT/60Q/o4pA+Ux3tQNRIMrWyNRp7jkQaN2ff0jjo3PWhKJPkmaDiTxcHtTE
         73SiGTX3DsI7cY3TCSaCHmwrE7n9CW31CcVcAR9V4eqWN7r2wAyvjp44wfQWOguJeQ46
         4Vrq1tr7IujaxG4MYISf2ZhQF4p7SHso911Q4lOXiIf3RV6HoSZy5UhciNj570CWgxZ6
         bQ97CpAEH8rbqYfT04X+lU6yaTABz6RFNMVWuqlX7v10mo9YggjtgO2we4nMb3hkZMCs
         +CLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789030853; x=1789635653;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sI6uVqqlwqaRtMuzW9jXOvHuhO1f712UR/f6QW76OsE=;
        b=KiHgYZs4Tu9JgkgOEzXtJpQMQ4jBRryGuCWdEFWCQ//WlAPU/yo5zy7VKWe5Pzu7E2
         wMYJQ0udRiA5dQ3L1V2S93xhx95zb88QbY/fCf3FkZ/2TQ3fctJEbwba6m6YbmOYBXic
         kq8O69ERbzYgRIwZfnow5sgyDV+XCot+kiI7HJuNdYeavPnvQvrEy3ALxZ3YEOGLiJ/X
         6plMLwxVUdIKApDrZiOOUEizdCr3ypQ0mquiblOTfhhiyvqkfJ6LHndgkfGZbqlvfHzd
         neCMH4LHELgvSkO13XueenhmU216XUEsZKISC0kXkqtITOTXuvI/K6vnkZ8wKwkOoQhV
         kw8w==
X-Forwarded-Encrypted: i=1; AKwUvBzgkOys4RBpZAYAMIRQXGWVRWD8F082qpNm9ufsY0SuThw9r9hMPOvNYvJKgZciH3HravrF1LfWTiqtgTDZKso=@vger.kernel.org
X-Gm-Message-State: AFuF++mJHmOJ0+ZvIbN0ICBQEmQmzKeGp4sSU0PTy9gmiGlCXI6p5mUE
	V1hnjNzsHa/5SjuHpzb5LtxhJGIKd9s18tqkYnE0LkqZKKhguch69au4qvVjEyAkrAqwdp2mHC1
	tmKQ4/lOQcP/hqw==
X-Gm-Gg: AYBFou1XftjyxueEMyBfzaarzsbY7g1MPTJS0KlKYJKmjy0Iwv7XI+/vB46Oa3rR+SX
	JEDkZp6b4ZDWj132oD3Lc/ybkTa4wxVILnqLcLNsKVdxkzGfIbKf3EIdlIVX0p5Ildf9g8E3YkT
	H1xfHxJliVMK/K1wZ24EWjgxibhEljcdeiO6m68TvDoLm794UC8gpF8Uu4lOaWfVpEUofa/ae3B
	zR2q/57kj+FZV7bQW2wJoVbAOEjNzybZhsfsNtU8Cl9Xl9m/px0WURqn55SM1c4OZaClBpyWwdm
	ZGb4hcd1nPNr+COWT4WTEgOiuOieqNsMJajFALwSbNvZGJB1WsCQv6coLHBC2RRvS5pz9J0qLhA
	iuT/xuDpx6nDfxqMS9do20mwfwIpO2N7JSJKYdOW20NReqU6BSLGKB2QYXZG3tHQZPNo20jkt3e
	/Sos7LKhU+HBCRnF8UHStwCINI7IarzLWnAMTx9BCzFaxOjVyE67Ihgmso59ZANM3OCsOuI2P+8
	6i8SPymEzwTIrYr6obfwt1CSaP2PdYRQlN+Te2vK/vPdLa/DyRRqWHGqc9wXGiz0pETUcOlQqZP
	1LiORkT7R4PhC+WgtOiXGV3U0EdLj5Y4JK8YiRYlxQ7HTPaeKx+K2eTzA6BfdDUilQn8pQIVVM3
	BB3hhCV60jAQjcTu8aNPqxm+NEVdbvraV3eNHXteRaqpPH7AFMOrJjWAIupaVIb/1GBY5OZ9kJt
	pBJHUi9g==
X-Received: by 2002:a17:907:7204:b0:c26:19e3:e98b with SMTP id a640c23a62f3a-c2619e3f02cmr1404442066b.43.1789030853259;
        Thu, 10 Sep 2026 02:00:53 -0700 (PDT)
Received: from Desktop.fritz.box ([217.26.235.87])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c293eaf1ae8sm156106766b.40.2026.09.10.02.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 02:00:52 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: pablo@netfilter.org,
	netfilter-devel@vger.kernel.org
Cc: kadlec@netfilter.org,
	fw@strlen.de,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	geldot@protonmail.com
Subject: [PATCH nf-next 1/4] netfilter: conntrack: pick up a TCP flow whose SYN was never answered
Date: Thu, 10 Sep 2026 11:00:49 +0200
Message-ID: <20260910090052.2034970-2-julius@bairaktaris.de>
In-Reply-To: <20260910090052.2034970-1-julius@bairaktaris.de>
References: <20260910090052.2034970-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gary Dotzler <geldot@protonmail.com>

When only one direction of a connection passes the host, the SYN is
seen, the answer to it is not, and the next packet is an ACK continuing
from where the SYN left off. The transition table has no entry for that,
so that ACK and every packet after it are invalid and the entry sits in
SYN_SENT [UNREPLIED] with one packet.

Treat the connection as a mid-stream pickup. Delete the entry and look
the packet up again, so it creates a new entry through the loose path.
That path fills in the unseen direction from the packet and stops
window checking in both directions.

Signed-off-by: Gary Dotzler <geldot@protonmail.com>
Tested-by: Julius Bairaktaris <julius@bairaktaris.de>
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
Assisted-by: Claude:claude-opus-5
---
 net/netfilter/nf_conntrack_proto_tcp.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index ad6f1986d52a..335b11301a78 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1173,6 +1173,25 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 			return NF_ACCEPT;
 		}
 
+		/* The answer to the SYN never passed the host, as happens
+		 * when the reply direction takes another path, and the client
+		 * continues from where its SYN left off.  Take the connection
+		 * over as a mid-stream pickup: delete the entry so the packet
+		 * creates a new one that seeds the unseen direction from the
+		 * packet itself.
+		 */
+		if (tn->tcp_loose && !nfct_synproxy(ct) &&
+		    old_state == TCP_CONNTRACK_SYN_SENT &&
+		    index == TCP_ACK_SET && dir == IP_CT_DIR_ORIGINAL &&
+		    !test_bit(IPS_SEEN_REPLY_BIT, &ct->status) &&
+		    ntohl(th->seq) == ct->proto.tcp.seen[dir].td_end) {
+			spin_unlock_bh(&ct->lock);
+
+			if (nf_ct_kill(ct))
+				return -NF_REPEAT;
+			return NF_DROP;
+		}
+
 		/* Invalid packet */
 		spin_unlock_bh(&ct->lock);
 		nf_ct_l4proto_log_invalid(skb, ct, state,
-- 
2.53.0

