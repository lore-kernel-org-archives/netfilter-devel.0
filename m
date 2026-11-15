Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794704169;
	b=GLS80Mph5I90bnYFmERo3OOLLjio1l6K3K+2/hEN6wD4c7z3S+B2iJnlVYzDIy9SIS3P
	 uS6Vhkd8cGko+08xuGkle77AeleuNvPzYVaXPjMa2RdsXKuvBXW+OJFx/yuCqI+2Zf0aO
	 Zq00G44fJm/v13Q0hY20YOlQLteOqJnxBiOVsvPGJGC4NzjuvQDxBElXOmmtNnjlXaEG3
	 MVbQ9b2ERL9c7Qmb6FMMfi2v3pNy+dJxWSHLuEM537Jl4nUEhGg/kbbMh4uWzG6Jt823X
	 m3aVf8VJy0R769M/3oM623PCgpnebRW3R33e5vQ0X76vYcXt5fFfaQtkoIfHMtC/x5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794704169;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=EXiLXVBflQGlm4cX13sHzQkGhpIOp9cmpNR58hxiL1A=;
	b=D0EoQvxKHTBpShp5nRg2QRq9OzcPpPdLzxLl0ekmOIg6guKldF3Y2H48Cr3a4SUCKOPN
	 WYbhIE1+GuqvtM88dDH+uIdNiTxQpnW4sVZLtS1h4x2tbC5uU7tsvygueVf1kHSNveg7m
	 R7A6o7pcIliYWaj/0Y45XQNwwCs/KDS7aNQFA+7SbHvafcj8Ct5FQhyvBz4x2a8+AgzHE
	 MWitS0ORAE22JaCAOLoMsHkdHpVSmon6irnw9iD/fK5wMPsUIbqJ00d9JaJV1ySnyyCD4
	 gNwrXxQAtAJczJfq1J9+60GtpAfIVqdI0ODqyxdR1QDiWvI80EcEgjyQkYRUYBLsd9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bairaktaris.de;
	spf=pass smtp.mailfrom=bairaktaris.de;
	dkim=pass header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b="nLwi/sa3";
	arc=none smtp.remote-ip=209.85.218.49
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37F8606A323
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Nov 2026 00:56:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D37F8606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=nLwi/sa3
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c4d427836e9so314701966b.1
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Nov 2026 16:56:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1794704167; x=1795308967; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EXiLXVBflQGlm4cX13sHzQkGhpIOp9cmpNR58hxiL1A=;
        b=nLwi/sa3548+Zm1k4zR5gIG8GKanUjn0tMfXpNZPuTKr+P9PKrYmiNthDAKdZ6PFv8
         ldheE2YF0jLlXkFGdCnkklO2PVJj6HXg87kSZsy9ygc9i+LvJ0V81TW3FFROQOJMiUfu
         pMATh6jWwbA76icBXAGerKleOZ3gstRB+hWkCYIPgTsmtJAUojTbWJkjo6MAlgF6H6BR
         i7KmAUpjUSZF5+sXrw/7CUsuF67bJ/0p1gcpx8gaMA2k0s7aHsOonF1CXw0J3MuewHdT
         cfjxpQkykCc6JzIOZZO/ZsvDo0I0Zu1uwxnPgjUF7L92dUGMDsUOFb1tZLu7xtCulFJS
         uh/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794704167; x=1795308967;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EXiLXVBflQGlm4cX13sHzQkGhpIOp9cmpNR58hxiL1A=;
        b=HX3fMKJy8pzUbJ5lC4DYTERIizL0RxbdeF7mWH178WqzoSXAHXzY3ytobhxhi/kTG+
         ncB0AVcuAdDwjdfw4L5U5lDw6z8IeY9d76TDvwjxZA8oTW15qtpgF95QXi8s7WBigqpB
         SG/1/+9yVZyZKwhF9e0azUFHHFVzsMRmbua6kP2nkbGiveJpC5NW4MB0U5FO1pOCdqpZ
         GqewCEL1ByjG9+BRXd2Cbmt0VcpcqGzjClZzW12mL5148cyIGkZmc1YrIahzYa6KJoZT
         UyWfOg9FxwE/wcTmhyAHcjJCYUuAaDDT20rhw1y3cFMNObbGmXW8jvAbcB9DvjIh9+Ge
         bibg==
X-Gm-Message-State: APuU4Z8uQLD2rYzLXSwsbPH4aSU4QYm64WhO6VSTrkyXRfKq8iwRD/cA
	Gen12h80y9d21h9fxhTH96xZHolONdsh97239rJiKfyirnZHQZB+cmR6WzmMfG25/Rv+8Xcjhhm
	Sd0IW+7Ci
X-Gm-Gg: AYBFou17GM5evyJGgRpjjXuxT0pQUNn+4QgkSDtl9wUgirqjpddpdIVNUozJ0grP1Vl
	HkL3eoUAVezEQJrqXSkQJrY79N7AhueeRu1O6qWNl3h/r9N4xvfY8zDQ3wgg7eG2VSb9cPu7BhO
	kyKIjhAwB64iyZdmZrnHdaXWreCyWz+Ao72M84Cf4P4tv0Q2ISa1/uZ1qRGeOBb728EsYIHgfh9
	hDuLYN9lqDtYEog8v49YlfS0MMd+igLy4Nv+ykxiYlL+zd2t5MY08FiK4hosGYnQorumW5Rz1OG
	gPIolH47Co08C+etWJIxWrkQlkDR9x/LUQy/rn4HCXAnYAsknQadY5hhr72lI1K7RZYW0yA8Asl
	YzhVlc3Z4eAp4Mw9XyCuHTj9U1dP4MkzoyN99nth6bcaplpAZzvSR+eps4Ym7wMupfjnrOGlfrZ
	9vzvVkNVyzGJgvRHxywUKGmG9SSRQucJBSjxrSnwyqX4zMqorL1TVSPdMO5p/QiY8cSbgxDzXdO
	Q1J9ei7AnPIKo2MDfTrQkgfTpwgm18DiFKJgChBgxKxLcNzj1i5a0aaOC9rZk2WQy6+5Zx5NM0P
	0samy0YYX/638PF3wLQINFA9RKsb+kv2wS0cNDM/8FL1AwbO5oju3Om45yIZIY4RbVWIANle79n
	inVDcuRTixbMIJzMKgA3MW4dYl0rYDcJIqAEYCqi/XP+QIkdcbuSDsWyqbLIRJUNw8k/IvGaP2P
	f7Z0YMvB6pNM9KzMfe21WJugNW/UaI4pRGmhKIZj8lygMlLM6FRSZy7adR6E9uU9jJBrIxguBUi
	PuvTB4KRW6MXe06u1qncmoEFdTc5Wm9tx9Rf2Wds+ISLqU591IQOyOIewyiNygHrfLtoirxFnOM
	R7XEZSPvFy+g+3yGjyqHsdgJrYIjHiNp+4UEJyn7UV6zmAoYc6g=
X-Received: by 2002:a17:907:6d02:b0:c46:9ca9:f524 with SMTP id a640c23a62f3a-c50963b6917mr545268566b.32.1794704167251;
        Sat, 14 Nov 2026 16:56:07 -0800 (PST)
Received: from Desktop (p200300f2470a670069e45948b1a17361.dip0.t-ipconnect.de. [2003:f2:470a:6700:69e4:5948:b1a1:7361])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b921d4sm266313166b.83.2026.11.14.16.56.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 16:56:06 -0800 (PST)
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
Subject: [PATCH nf-next v10 1/3] net: bridge: fill a forward path only to a port that forwards
Date: Sun, 15 Nov 2026 01:55:53 +0100
Message-ID: <20261115005555.645727-2-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261115005555.645727-1-julius@bairaktaris.de>
References: <20261115005555.645727-1-julius@bairaktaris.de>
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
v10: new; v9 transmitted to a disabled port and in a vlan removed from
the port, which the gc then left in place

 net/bridge/br_device.c  |  2 +-
 net/bridge/br_forward.c | 19 +++++++++++++++++++
 net/bridge/br_private.h |  1 +
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 0a1ce9e59a4d4..f5860e88dbe95 100644
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
index 54365c6104b5c..9dbe9c9495582 100644
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
index 014d0b8db8c73..2c73d2549eaec 100644
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

