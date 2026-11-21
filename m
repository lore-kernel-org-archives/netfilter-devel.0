Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795294539;
	b=RVb2kL72vh8aTpykkUrSaBcVmhBSAV14tefTkbtSTZodNG7HHWM/0TBDgFtmzMkw7Ju5
	 q2Eb1Ow/l8ibXnTVNJ0xAP4tWa7ZxE98691zIariuSWf1WxfiBTpyU7KynRM/3eXFQ6N6
	 3uX3mZ9au1em3ZvZhwRkCG/IpYm0ssEtQPJHJP3j5n62unsAXW7GVCxMrta/PxrQB7aCT
	 RevPbsGrQRtCffR66ejPQO2a0yboOoKPL+XbUbM5awxh2kPCjJFVd//xp1n2/D2gHWRCg
	 Lnxl/vPsMiw7ojGmI7S4SjffnYuPgFII7gX4md7wWG0c8/HMN/RvOC45Xx3+BjIPwlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795294539;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=GeBK2KWSTEYOjvpbrLoolF+PIHIEDG1AsTpzAFk1TEA=;
	b=lMxIQM2zcJSYkBmIBsaP8HuwHTfMKyBNZ7RM4pUJgecWxCrm7qdbmF+ErSjTPAEUjdU0
	 3zvu7kMMYSBZnlJKOyAL6s9uJu7nCH1LVi3rF2TDoM0d23N0upID/4KTZtYXO4mnpS867
	 VbjZ7FQASVAHdcgJsBB2v+r0rSjQ04NebchciOd6yh28+pgtdYXppr0wqfBBaDGDyPJtU
	 nVSBWFOrAMA75xzkgf7gVjTpwiWDbgmcYohsF3MtYqTBG95jOl12y6heStQOtke7MjDXc
	 00etVjB0P7NUroDza/sT42uf9eT7dmjsPTQNn5yHwkb5Q59aCiv4szbk6zQ4JcYqsXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bairaktaris.de;
	spf=pass smtp.mailfrom=bairaktaris.de;
	dkim=pass header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=gXLaYwSm;
	arc=none smtp.remote-ip=209.85.218.52
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F846606A33D
	for <netfilter-devel@vger.kernel.org>; Sat, 21 Nov 2026 20:55:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3F846606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=gXLaYwSm
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c505b2e1cb9so379923366b.2
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Nov 2026 12:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1795294537; x=1795899337; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GeBK2KWSTEYOjvpbrLoolF+PIHIEDG1AsTpzAFk1TEA=;
        b=gXLaYwSmXWTREaLwLLM+ay5C5XzlrBUYr7O0dsBnYQlVGtg+A8IMRdGMYB4owSa2J9
         UVVAaU57/dF3/dCbAFIIvr3IGJ1M2BAG1xkIpz81tvwl3jLcAVsLMhNk0iiKCMU4G2a3
         /ooENIhc/pje28/aDXUyaWCcGpAg257tZU7I3mQ705yYKKCc7G+KY5KBTaAZgKwMEl+n
         MRy9eRpsciitgZe1pHcrhWd/ZMjkjwahO3BFlPdEvrBacI1rj9xZQPxmJdkUEQdBsS/u
         ck49jXQJf6KeIhs07ptbT0/e2gZ3CF9LjYV/M1PlsYW6q/vPRynqtBmVp1ocdGOyT8jy
         WWTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795294537; x=1795899337;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GeBK2KWSTEYOjvpbrLoolF+PIHIEDG1AsTpzAFk1TEA=;
        b=05wdbUeOebJpd8Ivi/OA8RsDDMvUcbJ72mt5FRBTdtCvpR1UDQd6LGF0EH6wP/w00U
         JGCikQRiM6mcatGWQ3IBKzIf3h8jcAt7AehG5Dh1juiCpOKq23y29GbZx7xcAMmlO7C9
         oKvE2fuJFC22a3wVCeX7fe+gP6AdwtfbeMybLQK5hEJnvSsYriXRwFu0qdhme7SUvs8y
         z2ODOpMcpHBFY0l7o2fX2DZrJw5vc4KrJ7r8XImFr8gLcij6eySgjOAdxMRUBqGVs2SZ
         Z2LavQJe5wR4oWAOLcJfndlDhB9tsk63kUhRFjEVKMaV60yKb81qpEpo/eh+97r4Pgzs
         KDaA==
X-Gm-Message-State: APuU4Z8Cfb5RD6oj3N9GMSrUvoLk96rp4+DzjtihA0zdBCveZa5am5kP
	o1EIYUMWr5gVL2b66u0sjo/diaJwrvLg8nzoOL01D0WjmndmUDqt9A78ey4ucorRfJlQwrxWjdI
	U0Yys+GgP
X-Gm-Gg: AZFdTZdN9iFHRmeAIbKz5nQ7BNv53Ryrh4cBcO0Onntqoevk7N8KKYW+EARcJJksiRe
	50nmzR/3herSHpWGG2+WC5EZu7TIxLrKvRlD/jTBFClcj9baghNmEVLMakwp551go1gGQvFms+6
	d/dWXEtMIbNK1eKzuWlzewk7QY4kwl6cjE0smSsjdnheaR29S3ciwfd51yJquI6hkfP8Hc9t25M
	eGc/8jrTmDJekNiJJyZudcyMRCKhMzAL7pQlRBpvsGi8WuyJtCxoOfg+9INnbaDryg3WIAZGemU
	NGtZCQOhslJacINCD0/iWW2KKFLe6MXkGJ8jyHfxyyP/MFQlsB+qY5n6fCDvjPVuyBWNKy8Qu8j
	w/PepJFNsWgLlkQIxWE3n3HiGpzf5Qd4qZRo8OZRvBFW5pAm9XcKJujXd4GPyhWBFuHomflMqfo
	2Q0deJ537E1MjmUJ4XKmwHfBiSwCVm+2k74xRf4mcKHhC2AHzUD+yWgzxyp3Pb5EEAuBET76miC
	ZlZj0mu4AMqn2O8tTER1mDoGQGCruB07ImrlJ9WOt1diPan9/vyMNaVRMMok+B7w/UeCtPsDpfP
	HE9VdJedXKVp0mkjhV1g7w5DblqTFKGNXTQRwNQOsRMoAJFbc6MOop/f2cfZTD7rUDs604oWkpF
	hVXfAbMBctHNJPDaUQByulK3Lb9stoAX00XJTbeGkdzbzoIQI4TMzKRpQ0YcukIX3D0CX5mJPU9
	fZHtF6I4rRGLoXoYE073G0VXWXOnMQP32vr29OB9g8LEiENEGdjh+U7Y72FGycMJ8hnoIJLO/Zp
	WBmStT+9gzK8EqnINcFqxxN8P/H5FHoORFK+Bqv2KaTTdXnUQz9qCn0/cbXvgVMopvOViJ76upD
	0+IP6B7n9HQ/aaieDiSVloWtDyybVPPyymPtT04IR7fxkDiEUQiVquo=
X-Received: by 2002:a17:906:f8cf:b0:c50:bf14:8ec1 with SMTP id a640c23a62f3a-c513ab4d93emr437004166b.33.1795294536714;
        Sat, 21 Nov 2026 12:55:36 -0800 (PST)
Received: from Desktop.tail070c67.ts.net (p200300f2470dfa000000000000000a27.dip0.t-ipconnect.de. [2003:f2:470d:fa00::a27])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c513aea28f4sm237136666b.33.2026.11.21.12.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 12:55:35 -0800 (PST)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Eric Woudstra <ericwouds@gmail.com>,
	netdev@vger.kernel.org,
	bridge@lists.linux.dev,
	coreteam@netfilter.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH nf-next v11 1/3] net: bridge: fill a forward path only to a port that forwards
Date: Sat, 21 Nov 2026 21:55:33 +0100
Message-ID: <20261121205535.1888592-2-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261121205535.1888592-1-julius@bairaktaris.de>
References: <20261121205535.1888592-1-julius@bairaktaris.de>
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

br_fill_forward_path() resolves the destination port from the fdb and
checks only that the vlan exists on it. A port in STP blocking, learning
or disabled state, or an MST vlan that is not forwarding on it, still
gets a path, so the flowtable transmits straight to a port the bridge
itself does not deliver to (should_deliver()).

Add br_port_forwards(), the port and vlan part of should_deliver(), and
fill a path only to a port it accepts.

Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
v11: no changes
v10: https://lore.kernel.org/netfilter-devel/20261115005555.645727-2-julius@bairaktaris.de/

 net/bridge/br_device.c  |  2 +-
 net/bridge/br_forward.c | 19 +++++++++++++++++++
 net/bridge/br_private.h |  1 +
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 0a1ce9e59a4d..f5860e88dbe9 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -402,7 +402,7 @@ static int br_fill_forward_path(struct net_device_path_ctx *ctx,
 		return -1;
 
 	dst = br_fdb_dst_port(f);
-	if (!dst)
+	if (!dst || !br_port_forwards(dst, path->bridge.vlan_id))
 		return -1;
 
 	if (br_vlan_fill_forward_path_mode(br, dst, path))
diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index 54365c6104b5..9dbe9c949558 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -31,6 +31,25 @@ static bool should_deliver_vlan(const struct br_fwd_dst *fwd,
 	return br_allowed_egress(nbp_vlan_group_rcu(fwd->port), skb);
 }
 
+/* Called under RCU. Whether @p forwards a frame in @vid, 0 without vlan
+ * filtering, as should_deliver() decides for a frame filtered at input.
+ */
+bool br_port_forwards(const struct net_bridge_port *p, u16 vid)
+{
+	struct net_bridge_vlan *v;
+
+	if (!br_mst_is_enabled(p) && p->state != BR_STATE_FORWARDING)
+		return false;
+
+	if (!br_opt_get(p->br, BROPT_VLAN_ENABLED))
+		return !vid;
+
+	v = br_vlan_find(nbp_vlan_group_rcu(p), vid);
+
+	return v && br_vlan_should_use(v) &&
+	       br_vlan_state_allowed(br_vlan_get_state(v), false);
+}
+
 /* Don't forward packets to originating port or forwarding disabled */
 static __always_inline bool should_deliver(const struct br_fwd_dst *fwd,
 					   const struct sk_buff *skb)
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 014d0b8db8c7..2c73d2549eae 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1048,6 +1048,7 @@ int br_dev_queue_push_xmit(struct net *net, struct sock *sk, struct sk_buff *skb
 void br_forward(struct net_bridge_dst dst, struct sk_buff *skb,
 		bool local_rcv, bool local_orig);
 int br_forward_finish(struct net *net, struct sock *sk, struct sk_buff *skb);
+bool br_port_forwards(const struct net_bridge_port *p, u16 vid);
 void br_flood(struct net_bridge *br, struct net_bridge_vlan *v,
 	      struct sk_buff *skb, enum br_pkt_type pkt_type,
 	      bool local_rcv, bool local_orig);
-- 
2.53.0

