Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.227
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794868432;
	b=GVfJEsGurrGnnJGslzdOr974/R8EjD9mvPYImg2FlE+IY2PcHKBX6K00eapamrWMK0fb
	 eKV5r2u2KmiUOIc6MS3r83xtPVUl3USEuG3STsksfq4MTWLerZ97ih4xeqP9oz9Y/Z29i
	 BN0jvlKFNu2sVIBkAklof4XW03sq5X2aMDMvi4Y0x58B9XT9kuV7Lvd3WqEzSitMeIlCr
	 YHpldjuIvqq9CrysRILalya7vkodyIrrh9N4DvUaecqEHKF3R2ptfF55tCwHON1o11UIE
	 u9oNAvsOYbjl0a4HmsIaFAzgebaATwEqCdwG12ggKweL9aVAsWig4ZPRBy8kIuN5MGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794868432;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=42NWJDQZ2EtkvUcsZu/X6ZQPyfzCVmcoYq5gbzwq5uY=;
	b=oUJx+5E2DtczcDVQ44d+0mS4E2WK3sIB1bvOJJKbgQhNLVCFJUoOGgUetC6JR0j50pjM
	 NQYNIB/8S6kFTRsKXaEUWzYXqZhnIrp0bFqD6lef8cD8h6EtV/k1rkTSTxcjSfjha0IhH
	 iTstBDs2bwqfKTluDiBKf1lFMz2fi/+pi4r0gcu2bNRZihiEPrhmyc7h5MRV9h8D6chZp
	 yRxyFTPTY/YwJbWrFShhNgVO+06jcRpNRLiGijIYLHEz1XmzFNNstYBohsenRk2/M5YQ8
	 YcK4tCB5Eddd9hlRfWRGacvlKbnXA+frn5SH9aRIZaWNfS4ZA2npmk03NfGhLOlvBFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b="Ewi/BXI2";
	arc=none smtp.remote-ip=209.85.215.227
Received: from mail-pg1-f227.google.com (mail-pg1-f227.google.com [209.85.215.227])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4DA606A88F
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 22:33:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E4DA606A88F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Ewi/BXI2
Received: by mail-pg1-f227.google.com with SMTP id 41be03b00d2f7-cddee4abc57so478666a12.0
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 14:33:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794868431; x=1795473231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=42NWJDQZ2EtkvUcsZu/X6ZQPyfzCVmcoYq5gbzwq5uY=;
        b=GywbiZ8Qz23hRvbDTQ1D5Q66YG+pvp7XydVJlDF5jrFb/FYtlzt9mCy3RQcKEo/mvI
         txPK1NFo1DImEQVMgWHi4ncOAlPw1+woJ7gzkD1ZjlxGtpTvs5AS73FestBUTNLwUOEQ
         E/rbrHpsp6sj8Aidbh6+Z+U8mhTjLULMHCYmuo0w0i4cPk/mJaPALibKXCJH6P0v0+s4
         Bd8KfEG+TmIpBdHyyPasR0cID89vDQ/FiorkAnz2uwhdqiMYpnmh4hVK/Rp5fTHdDzZU
         Kc+s8IsMhhk12658BJBAS4ScNTlwtyroMtqdDYn9ReA5yDvsc0QqS7sFCkkbmr8k1j4S
         KIyQ==
X-Forwarded-Encrypted: i=1; AL+hErESIeK9ZO2nibdb2x2wXPP4GiX5JCSp3UOjufQ0cdEWu1yfeasgEByrn6WEPsOvei5WgYPZsax0wlfJfB+QMDc=@vger.kernel.org
X-Gm-Message-State: APuU4Z820y5aVa/Ypc8Ho7LkEnAoYdV78+PVCEaaa0OZ7aPAnw1/1Dia
	g/KbtoMaKoGMu2fJdE5X5xpNuwfAcWD6/B3gRUsKwBs5SVz5awI9h8WV6HiqOKUdQu95/k6ddze
	qBBPtySYEqqvKaOSgqCjSTZxXl59mqd3bf18UlG/5bjfFy+reawAMt9fkvbXVqynhnQvgnSDOhR
	FAcCHmEP532s7XEYdUt7IWlaAry571E46/u51Jdzd08SWxeyUXZyyeCl2M49BY9sFKO49NYY1Ji
	IFyZPYdb6l4XyW8Acd1skWopqZR
X-Gm-Gg: AZFdTZfTRWe26u3dB97a66GwyYE9Q2IYQ5OkzgAtjSNRmn4SMVFWOylcLM3VZojY5UW
	NuLL3z4eSwoYYGapzVOyKq94FhrlNOKQRsakOhJz+V6jktoLHAoMpq78sYOrLgL6NbCPVZIuns9
	FsXi19ZBpUolgDSrKAVgHjuCLy2E4TmaPtYw28mMQQ2EdCn0S2XXvq77tPRQoEVB7EauRK63IdX
	d2YmFZ3t/g4c4cj0n4C+WLAOGLH+0PtpiXfeqcNUolo3DZe3stF2xXZcuVijztQxp6KrIED7xkC
	BDB3NWtXsPphno7EHJv518WxqPzZaP+U8gqPRBbkV5NG54bh8fbT12Tv2Bhjd7jgpbNUlQg3X6S
	ZAJe6WYsHCCixFYI5vqVusDh5JnMuqVO9VziddISmULq3NzF5nsSRleFq9uK6m/8ZNr6ECFLard
	93v6CFVzGHPxruy3xvJp29Mvia55/hgcdAm/C6b3xX
X-Received: by 2002:a17:90b:3c4e:b0:3b1:8380:a9a0 with SMTP id 98e67ed59e1d1-3b1b0b67c8amr11708286a91.46.1794868430274;
        Mon, 16 Nov 2026 14:33:50 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 41be03b00d2f7-cddc1898b07sm196115a12.15.2026.11.16.14.33.49
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Nov 2026 14:33:50 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ua1-f71.google.com with SMTP id a1e0cc1a2514c-9984a7eb3ddso3028432241.0
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 14:33:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794868429; x=1795473229; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=42NWJDQZ2EtkvUcsZu/X6ZQPyfzCVmcoYq5gbzwq5uY=;
        b=Ewi/BXI2jPKWzC03ejVaZ2h5cdns/yHffRGNC9Sgl6nMQIQoVHWvaiP+whmXZLBdRx
         xBXkjzGIN4cluUovKPT7JI7Zujx2NIIWpsiJXcpLC+Ui1fg9jriaAfEI4f40LzAi/Luf
         aW9PxEl4/ItB+pUDTWI+fUjeWJwsAx3C2vAwU=
X-Forwarded-Encrypted: i=1; AL+hErEFYOJ+Nt9nsuMwr0tGPt1nzlXkirQwpXlZ4Ue9Nj1WhNDMtcwaOIhTcn2s+ROmatXozTM19kCgL23saUdOBK0=@vger.kernel.org
X-Received: by 2002:a05:7301:5401:b0:35c:8b96:94d9 with SMTP id 5a478bee46e88-37966f31fddmr10107873eec.19.1794867997693;
        Mon, 16 Nov 2026 14:26:37 -0800 (PST)
X-Received: by 2002:a05:7301:5401:b0:35c:8b96:94d9 with SMTP id 5a478bee46e88-37966f31fddmr10107844eec.19.1794867996950;
        Mon, 16 Nov 2026 14:26:36 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-379560f5e06sm50176624eec.19.2026.11.16.14.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 14:26:35 -0800 (PST)
From: Florian Fainelli <florian.fainelli@broadcom.com>
To: netdev@vger.kernel.org
Cc: Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS),
	linux-kernel@vger.kernel.org (open list),
	linux-doc@vger.kernel.org (open list:DOCUMENTATION),
	netfilter-devel@vger.kernel.org (open list:NETFILTER),
	coreteam@netfilter.org (open list:NETFILTER)
Subject: [PATCH net-next 6/9] net: flow_offload: allow drivers to validate and invalidate cached paths
Date: Mon, 16 Nov 2026 14:25:16 -0800
Message-ID: <20261116222519.1416501-7-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261116222519.1416501-1-florian.fainelli@broadcom.com>
References: <20261116222519.1416501-1-florian.fainelli@broadcom.com>
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
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

A classifier does not necessarily contain the mark, DSCP and output-
interface inputs used to select its forwarding path. A partial driver
FIB lookup cannot establish that a cached software route is stale.

Provide optional owner validation and invalidation callbacks. Validation
runs under RCU without sleeping and distinguishes a proven stale path
from unavailable context. Retain direct-path dst references for hardware
flowtables and validate the actual cached routes, cookies and direct
Ethernet neighbours in both directions on demand.

Mark references retained only for driver validation. They must not opt
plain direct flows into packet-path or GC route checks after unrelated
IPv4 generation changes. Keep the existing checks for direct tunnel,
neighbour and XFRM routes. The explicit owner callback bypasses that
policy and validates the retained dst itself. Other hardware users and
tables without a validating driver keep their existing automatic-check
behaviour. Software-only direct flows retain their previous reference
policy. Release retained references with the flow.

Netfilter implements invalidation by marking the owning connection for
teardown. Owners keep cookies valid through an RCU grace period after
DESTROY; drivers stop issuing notifications when their rules are
destroyed.

Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
---
 include/net/flow_offload.h            | 12 ++++++
 include/net/netfilter/nf_flow_table.h |  8 ++--
 net/netfilter/nf_flow_table_core.c    | 12 +++---
 net/netfilter/nf_flow_table_offload.c | 58 +++++++++++++++++++++++++++
 net/netfilter/nft_flow_offload.c      |  6 ++-
 5 files changed, 87 insertions(+), 9 deletions(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 70a02ee14308..09301a924014 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -697,6 +697,18 @@ struct flow_cls_offload {
 	bool use_act_stats;
 	unsigned long cookie;
 	struct flow_rule *rule;
+	/* Optional owner notification when a rule no longer represents the path.
+	 * Call under RCU; the owner retains the cookie and callback until a
+	 * grace period after DESTROY. Drivers must stop new calls at DESTROY.
+	 * The callback must not sleep or call back into the offload driver.
+	 */
+	void (*invalidate)(unsigned long cookie);
+	/* Optional cached-path validation, called under RCU during REPLACE.
+	 * Return 0 for a valid path, -ESTALE for a demonstrably stale path,
+	 * or -EOPNOTSUPP when validation is unavailable. Do not sleep or
+	 * call back into the driver. The callback does not invalidate its owner.
+	 */
+	int (*validate)(unsigned long cookie);
 	struct flow_stats stats;
 	u32 classid;
 };
diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 5b22d31cb140..99cb087ff0b2 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -154,7 +154,8 @@ struct flow_offload_tuple {
 					encap_num:2,
 					needs_gso_segment:1,
 					tun_num:2,
-					in_vlan_ingress:2;
+					in_vlan_ingress:2,
+					dst_validation_only:1;
 	u16				mtu;
 	u32				dst_cookie;
 	struct dst_entry		*dst_cache;
@@ -305,7 +306,7 @@ nf_flow_table_offload_del_cb(struct nf_flowtable *flow_table,
 }
 
 void flow_offload_route_init(struct flow_offload *flow,
-			     struct nf_flow_route *route);
+			     struct nf_flow_route *route, bool keep_dst);
 
 int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow);
 void flow_offload_refresh(struct nf_flowtable *flow_table,
@@ -313,7 +314,8 @@ void flow_offload_refresh(struct nf_flowtable *flow_table,
 
 static inline bool nf_flow_dst_check(struct flow_offload_tuple *tuple)
 {
-	if (!tuple->dst_cache)
+	/* A driver-only reference must not change direct-path/GC semantics. */
+	if (!tuple->dst_cache || tuple->dst_validation_only)
 		return true;
 
 	return dst_check(tuple->dst_cache, tuple->dst_cookie);
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 4c82097cd50b..b16a336101af 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -96,7 +96,7 @@ static struct dst_entry *nft_route_dst_fetch(struct nf_flow_route *route,
 
 static int flow_offload_fill_route(struct flow_offload *flow,
 				   struct nf_flow_route *route,
-				   enum flow_offload_tuple_dir dir)
+				   enum flow_offload_tuple_dir dir, bool keep_dst)
 {
 	struct flow_offload_tuple *flow_tuple = &flow->tuplehash[dir].tuple;
 	struct dst_entry *dst = nft_route_dst_fetch(route, dir);
@@ -127,7 +127,9 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 
 	switch (route->tuple[dir].xmit_type) {
 	case FLOW_OFFLOAD_XMIT_DIRECT:
-		if (route->tuple[!dir].in.num_tuns) {
+		flow_tuple->dst_validation_only = keep_dst &&
+			!route->tuple[!dir].in.num_tuns;
+		if (keep_dst || route->tuple[!dir].in.num_tuns) {
 			flow_tuple->dst_cache = dst;
 			flow_tuple->dst_cookie =
 				flow_offload_dst_cookie(flow_tuple);
@@ -162,10 +164,10 @@ static void nft_flow_dst_release(struct flow_offload *flow,
 }
 
 void flow_offload_route_init(struct flow_offload *flow,
-			     struct nf_flow_route *route)
+			     struct nf_flow_route *route, bool keep_dst)
 {
-	flow_offload_fill_route(flow, route, FLOW_OFFLOAD_DIR_ORIGINAL);
-	flow_offload_fill_route(flow, route, FLOW_OFFLOAD_DIR_REPLY);
+	flow_offload_fill_route(flow, route, FLOW_OFFLOAD_DIR_ORIGINAL, keep_dst);
+	flow_offload_fill_route(flow, route, FLOW_OFFLOAD_DIR_REPLY, keep_dst);
 	flow->type = NF_FLOW_OFFLOAD_ROUTE;
 }
 EXPORT_SYMBOL_GPL(flow_offload_route_init);
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 4365859220e6..1f3adf70f598 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -885,6 +885,62 @@ static int nf_flow_offload_alloc(const struct flow_offload_work *offload,
 	return 0;
 }
 
+static struct flow_offload *nf_flow_offload_cookie_flow(unsigned long cookie)
+{
+	struct flow_offload_tuple *tuple = (struct flow_offload_tuple *)cookie;
+	struct flow_offload_tuple_rhash *tuplehash;
+	struct flow_offload *flow;
+
+	tuplehash = container_of(tuple, struct flow_offload_tuple_rhash, tuple);
+	flow = container_of(tuplehash, struct flow_offload, tuplehash[tuple->dir]);
+	return flow;
+}
+
+static void nf_flow_offload_invalidate(unsigned long cookie)
+{
+	flow_offload_teardown(nf_flow_offload_cookie_flow(cookie));
+}
+
+static int nf_flow_offload_validate(unsigned long cookie)
+{
+	struct flow_offload *flow = nf_flow_offload_cookie_flow(cookie);
+	unsigned int dir;
+
+	for (dir = 0; dir < FLOW_OFFLOAD_DIR_MAX; dir++) {
+		struct flow_offload_tuple *tuple = &flow->tuplehash[dir].tuple;
+		struct flow_offload_tuple *other = &flow->tuplehash[!dir].tuple;
+		struct dst_entry *dst = tuple->dst_cache;
+		struct neighbour *neigh;
+		u8 mac[ETH_ALEN];
+		bool valid;
+
+		if (!dst)
+			return -EOPNOTSUPP;
+		/* This is the actual route selected with the packet's policy
+		 * context, including mark, DSCP and the reverse lookup's oif.
+		 */
+		if (!dst_check(dst, tuple->dst_cookie))
+			return -ESTALE;
+		if (tuple->xmit_type != FLOW_OFFLOAD_XMIT_DIRECT)
+			continue;
+		/* A stacked path may have a different final Ethernet neighbour.
+		 * Do not mistake that unsupported context for a stale owner.
+		 */
+		if (dst->dev->ifindex != tuple->out.ifidx)
+			return -EOPNOTSUPP;
+		neigh = dst_neigh_lookup(dst, &other->src_v4);
+		if (!neigh)
+			return -ESTALE;
+		neigh_ha_snapshot(mac, neigh, dst->dev);
+		valid = (READ_ONCE(neigh->nud_state) & NUD_VALID) &&
+			ether_addr_equal(mac, tuple->out.h_dest);
+		neigh_release(neigh);
+		if (!valid)
+			return -ESTALE;
+	}
+	return 0;
+}
+
 static void nf_flow_offload_init(struct flow_cls_offload *cls_flow,
 				 __be16 proto, int priority,
 				 enum flow_cls_command cmd,
@@ -896,6 +952,8 @@ static void nf_flow_offload_init(struct flow_cls_offload *cls_flow,
 	cls_flow->common.extack = extack;
 	cls_flow->command = cmd;
 	cls_flow->cookie = (unsigned long)tuple;
+	cls_flow->invalidate = nf_flow_offload_invalidate;
+	cls_flow->validate = nf_flow_offload_validate;
 }
 
 static int nf_flow_offload_tuple(struct nf_flowtable *flowtable,
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index d3c5651dd699..05207ca808ee 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -113,7 +113,11 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	if (!flow)
 		goto err_flow_alloc;
 
-	flow_offload_route_init(flow, &route);
+	/* Hardware admission may validate the route used to build a direct path.
+	 * Keep its reference and cookie instead of reconstructing a lookup with
+	 * incomplete policy-routing inputs in the driver.
+	 */
+	flow_offload_route_init(flow, &route, nf_flowtable_hw_offload(flowtable));
 	if (tcph)
 		flow_offload_ct_tcp(ct);
 
-- 
2.53.0

