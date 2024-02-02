Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C1E45C07
	for <netfilter-devel@vger.kernel.org>; Fri,  2 Feb 2024 13:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706881998; cv=none; b=rdbqJT2gSPdcHkrNprwy6bEzydi8LLFTCW/Hd57JB2M6j1B7j5sVlyhR/OprHe2ZxIAElPyityRnOTVQvVZ55ellbSAtDe2PM+zQOauIpjALlBOciRLJmjSltuqHiHDS+tuyYLwOjKpitHgJzlKCc2eRoBZfXYBBGfUVkwD6UHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706881998; c=relaxed/simple;
	bh=gKIEu3jiSXKdFoqZwYiIQ8OnJBDU0+l7WUBwxnaOpok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o7I+kpzynLa4HJ2DAZUh2EFy5KCzepNu4bemZ8jzDIZZhxj2aXII9FlYxuHC5ociPkunNrGKu6xvW5AC5UaFTZJIkrX4O++xB3OYHbK6gQYm7ni6g72aWJumvlk5Yu73e5+mRBEr3oL/yEKrt45vGg4hWa7Q3ALNBl+AkEifIJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Kev2a1Nk; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Kev2a1Nk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=aGvekk9GI63sQodndU6XqoyyerOMJ38nXaSI/t7AUnw=; b=Kev2a1NkxOz8askoTAXjTd1KY/
	vvvzpQVYW+hyTpFib1UTusnBPBdikdpLfEithGSwZtRLOXJ72GssEZqTf8H+RZ6X8O5icpyHr5hHI
	Tai90NqipVFh6pkU5osBd19h5fZIvIzfkx1BwqeRmjqqp9v48c0iWp3fSlUgWLeqAoUn/BFPVRW/Y
	VpSLW30pItTNwfKp70Y4UdwS+hAhviuAdNnoPxMxVfVRRcZAq0klKo2BFf5F5pgwV4pGd072BvtSV
	8Eiy4t6QimI+YfEebYdCo/W80PoPXPJqWqgkPicWvouugFq17OWYRT5TDdcjGqPO1+eqLGJDW6HnY
	R0v7mQAQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rVtyk-000000003C3-0kRl;
	Fri, 02 Feb 2024 14:53:14 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH 11/12] extensions: tcp/udp: Save/xlate inverted full ranges
Date: Fri,  2 Feb 2024 14:53:06 +0100
Message-ID: <20240202135307.25331-12-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240202135307.25331-1-phil@nwl.cc>
References: <20240202135307.25331-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Also translate a bare '-m tcp/udp' to 'meta l4proto' match.

Fixes: 04f569ded54a7 ("extensions: libxt_udp: add translation to nft")
Fixes: fb2593ebbf656 ("extensions: libxt_tcp: add translation to nft")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_tcp.c      | 48 +++++++++++++++++++++++--------------
 extensions/libxt_tcp.t      |  4 ++--
 extensions/libxt_tcp.txlate |  4 ++--
 extensions/libxt_udp.c      | 43 ++++++++++++++++++++-------------
 extensions/libxt_udp.t      |  4 ++--
 extensions/libxt_udp.txlate |  4 ++--
 6 files changed, 64 insertions(+), 43 deletions(-)

diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index f82572828649b..32bbd684fd5d7 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -225,13 +225,18 @@ print_port(uint16_t port, int numeric)
 		printf("%s", service);
 }
 
+static bool skip_ports_match(uint16_t min, uint16_t max, bool inv)
+{
+	return min == 0 && max == UINT16_MAX && !inv;
+}
+
 static void
 print_ports(const char *name, uint16_t min, uint16_t max,
 	    int invert, int numeric)
 {
 	const char *inv = invert ? "!" : "";
 
-	if (min != 0 || max != 0xFFFF || invert) {
+	if (!skip_ports_match(min, max, invert)) {
 		printf(" %s", name);
 		if (min == max) {
 			printf(":%s", inv);
@@ -315,10 +320,11 @@ tcp_print(const void *ip, const struct xt_entry_match *match, int numeric)
 static void tcp_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct xt_tcp *tcpinfo = (struct xt_tcp *)match->data;
+	bool inv_srcpt = tcpinfo->invflags & XT_TCP_INV_SRCPT;
+	bool inv_dstpt = tcpinfo->invflags & XT_TCP_INV_DSTPT;
 
-	if (tcpinfo->spts[0] != 0
-	    || tcpinfo->spts[1] != 0xFFFF) {
-		if (tcpinfo->invflags & XT_TCP_INV_SRCPT)
+	if (!skip_ports_match(tcpinfo->spts[0], tcpinfo->spts[1], inv_srcpt)) {
+		if (inv_srcpt)
 			printf(" !");
 		if (tcpinfo->spts[0]
 		    != tcpinfo->spts[1])
@@ -330,9 +336,8 @@ static void tcp_save(const void *ip, const struct xt_entry_match *match)
 			       tcpinfo->spts[0]);
 	}
 
-	if (tcpinfo->dpts[0] != 0
-	    || tcpinfo->dpts[1] != 0xFFFF) {
-		if (tcpinfo->invflags & XT_TCP_INV_DSTPT)
+	if (!skip_ports_match(tcpinfo->dpts[0], tcpinfo->dpts[1], inv_dstpt)) {
+		if (inv_dstpt)
 			printf(" !");
 		if (tcpinfo->dpts[0]
 		    != tcpinfo->dpts[1])
@@ -397,39 +402,42 @@ static int tcp_xlate(struct xt_xlate *xl,
 {
 	const struct xt_tcp *tcpinfo =
 		(const struct xt_tcp *)params->match->data;
+	bool inv_srcpt = tcpinfo->invflags & XT_TCP_INV_SRCPT;
+	bool inv_dstpt = tcpinfo->invflags & XT_TCP_INV_DSTPT;
+	bool xlated = false;
 
-	if (tcpinfo->spts[0] != 0 || tcpinfo->spts[1] != 0xffff) {
+	if (!skip_ports_match(tcpinfo->spts[0], tcpinfo->spts[1], inv_srcpt)) {
 		if (tcpinfo->spts[0] != tcpinfo->spts[1]) {
 			xt_xlate_add(xl, "tcp sport %s%u-%u",
-				   tcpinfo->invflags & XT_TCP_INV_SRCPT ?
-					"!= " : "",
+				   inv_srcpt ? "!= " : "",
 				   tcpinfo->spts[0], tcpinfo->spts[1]);
 		} else {
 			xt_xlate_add(xl, "tcp sport %s%u",
-				   tcpinfo->invflags & XT_TCP_INV_SRCPT ?
-					"!= " : "",
+				   inv_srcpt ? "!= " : "",
 				   tcpinfo->spts[0]);
 		}
+		xlated = true;
 	}
 
-	if (tcpinfo->dpts[0] != 0 || tcpinfo->dpts[1] != 0xffff) {
+	if (!skip_ports_match(tcpinfo->dpts[0], tcpinfo->dpts[1], inv_dstpt)) {
 		if (tcpinfo->dpts[0] != tcpinfo->dpts[1]) {
 			xt_xlate_add(xl, "tcp dport %s%u-%u",
-				   tcpinfo->invflags & XT_TCP_INV_DSTPT ?
-					"!= " : "",
+				   inv_dstpt ? "!= " : "",
 				   tcpinfo->dpts[0], tcpinfo->dpts[1]);
 		} else {
 			xt_xlate_add(xl, "tcp dport %s%u",
-				   tcpinfo->invflags & XT_TCP_INV_DSTPT ?
-					"!= " : "",
+				   inv_dstpt ? "!= " : "",
 				   tcpinfo->dpts[0]);
 		}
+		xlated = true;
 	}
 
-	if (tcpinfo->option)
+	if (tcpinfo->option) {
 		xt_xlate_add(xl, "tcp option %u %s", tcpinfo->option,
 			     tcpinfo->invflags & XT_TCP_INV_OPTION ?
 			     "missing" : "exists");
+		xlated = true;
+	}
 
 	if (tcpinfo->flg_mask || (tcpinfo->invflags & XT_TCP_INV_FLAGS)) {
 		xt_xlate_add(xl, "tcp flags %s",
@@ -437,8 +445,12 @@ static int tcp_xlate(struct xt_xlate *xl,
 		print_tcp_xlate(xl, tcpinfo->flg_cmp);
 		xt_xlate_add(xl, " / ");
 		print_tcp_xlate(xl, tcpinfo->flg_mask);
+		xlated = true;
 	}
 
+	if (!xlated)
+		xt_xlate_add(xl, "meta l4proto tcp");
+
 	return 1;
 }
 
diff --git a/extensions/libxt_tcp.t b/extensions/libxt_tcp.t
index 911c51113cf2a..75d5b1ed90996 100644
--- a/extensions/libxt_tcp.t
+++ b/extensions/libxt_tcp.t
@@ -7,13 +7,13 @@
 -p tcp -m tcp --sport 1024:65535;=;OK
 -p tcp -m tcp --sport 1024:;-p tcp -m tcp --sport 1024:65535;OK
 -p tcp -m tcp --sport :;-p tcp -m tcp;OK
--p tcp -m tcp ! --sport :;-p tcp -m tcp;OK
+-p tcp -m tcp ! --sport :;-p tcp -m tcp ! --sport 0:65535;OK
 -p tcp -m tcp --sport :4;-p tcp -m tcp --sport 0:4;OK
 -p tcp -m tcp --sport 4:;-p tcp -m tcp --sport 4:65535;OK
 -p tcp -m tcp --sport 4:4;-p tcp -m tcp --sport 4;OK
 -p tcp -m tcp --sport 4:3;;FAIL
 -p tcp -m tcp --dport :;-p tcp -m tcp;OK
--p tcp -m tcp ! --dport :;-p tcp -m tcp;OK
+-p tcp -m tcp ! --dport :;-p tcp -m tcp ! --dport 0:65535;OK
 -p tcp -m tcp --dport :4;-p tcp -m tcp --dport 0:4;OK
 -p tcp -m tcp --dport 4:;-p tcp -m tcp --dport 4:65535;OK
 -p tcp -m tcp --dport 4:4;-p tcp -m tcp --dport 4;OK
diff --git a/extensions/libxt_tcp.txlate b/extensions/libxt_tcp.txlate
index a7e921bff2ca0..b3ddcc15833cf 100644
--- a/extensions/libxt_tcp.txlate
+++ b/extensions/libxt_tcp.txlate
@@ -32,7 +32,7 @@ iptables-translate -A INPUT -p tcp ! --tcp-option 23
 nft 'add rule ip filter INPUT tcp option 23 missing counter'
 
 iptables-translate -I OUTPUT -p tcp --sport 0:65535 -j ACCEPT
-nft 'insert rule ip filter OUTPUT counter accept'
+nft 'insert rule ip filter OUTPUT meta l4proto tcp counter accept'
 
 iptables-translate -I OUTPUT -p tcp ! --sport 0:65535 -j ACCEPT
-nft 'insert rule ip filter OUTPUT counter accept'
+nft 'insert rule ip filter OUTPUT tcp sport != 0-65535 counter accept'
diff --git a/extensions/libxt_udp.c b/extensions/libxt_udp.c
index ba1c3eb768592..748d418039c3a 100644
--- a/extensions/libxt_udp.c
+++ b/extensions/libxt_udp.c
@@ -82,13 +82,18 @@ print_port(uint16_t port, int numeric)
 		printf("%s", service);
 }
 
+static bool skip_ports_match(uint16_t min, uint16_t max, bool inv)
+{
+	return min == 0 && max == UINT16_MAX && !inv;
+}
+
 static void
 print_ports(const char *name, uint16_t min, uint16_t max,
 	    int invert, int numeric)
 {
 	const char *inv = invert ? "!" : "";
 
-	if (min != 0 || max != 0xFFFF || invert) {
+	if (!skip_ports_match(min, max, invert)) {
 		printf(" %s", name);
 		if (min == max) {
 			printf(":%s", inv);
@@ -122,10 +127,11 @@ udp_print(const void *ip, const struct xt_entry_match *match, int numeric)
 static void udp_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct xt_udp *udpinfo = (struct xt_udp *)match->data;
+	bool inv_srcpt = udpinfo->invflags & XT_UDP_INV_SRCPT;
+	bool inv_dstpt = udpinfo->invflags & XT_UDP_INV_DSTPT;
 
-	if (udpinfo->spts[0] != 0
-	    || udpinfo->spts[1] != 0xFFFF) {
-		if (udpinfo->invflags & XT_UDP_INV_SRCPT)
+	if (!skip_ports_match(udpinfo->spts[0], udpinfo->spts[1], inv_srcpt)) {
+		if (inv_srcpt)
 			printf(" !");
 		if (udpinfo->spts[0]
 		    != udpinfo->spts[1])
@@ -137,9 +143,8 @@ static void udp_save(const void *ip, const struct xt_entry_match *match)
 			       udpinfo->spts[0]);
 	}
 
-	if (udpinfo->dpts[0] != 0
-	    || udpinfo->dpts[1] != 0xFFFF) {
-		if (udpinfo->invflags & XT_UDP_INV_DSTPT)
+	if (!skip_ports_match(udpinfo->dpts[0], udpinfo->dpts[1], inv_dstpt)) {
+		if (inv_dstpt)
 			printf(" !");
 		if (udpinfo->dpts[0]
 		    != udpinfo->dpts[1])
@@ -156,35 +161,39 @@ static int udp_xlate(struct xt_xlate *xl,
 		     const struct xt_xlate_mt_params *params)
 {
 	const struct xt_udp *udpinfo = (struct xt_udp *)params->match->data;
+	bool inv_srcpt = udpinfo->invflags & XT_UDP_INV_SRCPT;
+	bool inv_dstpt = udpinfo->invflags & XT_UDP_INV_DSTPT;
+	bool xlated = false;
 
-	if (udpinfo->spts[0] != 0 || udpinfo->spts[1] != 0xFFFF) {
+	if (!skip_ports_match(udpinfo->spts[0], udpinfo->spts[1], inv_srcpt)) {
 		if (udpinfo->spts[0] != udpinfo->spts[1]) {
 			xt_xlate_add(xl,"udp sport %s%u-%u",
-				   udpinfo->invflags & XT_UDP_INV_SRCPT ?
-					 "!= ": "",
+				   inv_srcpt ? "!= ": "",
 				   udpinfo->spts[0], udpinfo->spts[1]);
 		} else {
 			xt_xlate_add(xl, "udp sport %s%u",
-				   udpinfo->invflags & XT_UDP_INV_SRCPT ?
-					 "!= ": "",
+				   inv_srcpt ? "!= ": "",
 				   udpinfo->spts[0]);
 		}
+		xlated = true;
 	}
 
-	if (udpinfo->dpts[0] != 0 || udpinfo->dpts[1] != 0xFFFF) {
+	if (!skip_ports_match(udpinfo->dpts[0], udpinfo->dpts[1], inv_dstpt)) {
 		if (udpinfo->dpts[0]  != udpinfo->dpts[1]) {
 			xt_xlate_add(xl,"udp dport %s%u-%u",
-				   udpinfo->invflags & XT_UDP_INV_SRCPT ?
-					 "!= ": "",
+				   inv_dstpt ? "!= ": "",
 				   udpinfo->dpts[0], udpinfo->dpts[1]);
 		} else {
 			xt_xlate_add(xl,"udp dport %s%u",
-				   udpinfo->invflags & XT_UDP_INV_SRCPT ?
-					 "!= ": "",
+				   inv_dstpt ? "!= ": "",
 				   udpinfo->dpts[0]);
 		}
+		xlated = true;
 	}
 
+	if (!xlated)
+		xt_xlate_add(xl, "meta l4proto udp");
+
 	return 1;
 }
 
diff --git a/extensions/libxt_udp.t b/extensions/libxt_udp.t
index 3c85b09f871da..6a2c9d07e3576 100644
--- a/extensions/libxt_udp.t
+++ b/extensions/libxt_udp.t
@@ -7,13 +7,13 @@
 -p udp -m udp --sport 1024:65535;=;OK
 -p udp -m udp --sport 1024:;-p udp -m udp --sport 1024:65535;OK
 -p udp -m udp --sport :;-p udp -m udp;OK
--p udp -m udp ! --sport :;-p udp -m udp;OK
+-p udp -m udp ! --sport :;-p udp -m udp ! --sport 0:65535;OK
 -p udp -m udp --sport :4;-p udp -m udp --sport 0:4;OK
 -p udp -m udp --sport 4:;-p udp -m udp --sport 4:65535;OK
 -p udp -m udp --sport 4:4;-p udp -m udp --sport 4;OK
 -p udp -m udp --sport 4:3;;FAIL
 -p udp -m udp --dport :;-p udp -m udp;OK
--p udp -m udp ! --dport :;-p udp -m udp;OK
+-p udp -m udp ! --dport :;-p udp -m udp ! --dport 0:65535;OK
 -p udp -m udp --dport :4;-p udp -m udp --dport 0:4;OK
 -p udp -m udp --dport 4:;-p udp -m udp --dport 4:65535;OK
 -p udp -m udp --dport 4:4;-p udp -m udp --dport 4;OK
diff --git a/extensions/libxt_udp.txlate b/extensions/libxt_udp.txlate
index 3aed7cd15dbd7..d6bbb96f5d744 100644
--- a/extensions/libxt_udp.txlate
+++ b/extensions/libxt_udp.txlate
@@ -11,7 +11,7 @@ iptables-translate -I OUTPUT -p udp --dport 1020:1023 --sport 53 -j ACCEPT
 nft 'insert rule ip filter OUTPUT udp sport 53 udp dport 1020-1023 counter accept'
 
 iptables-translate -I OUTPUT -p udp --sport 0:65535 -j ACCEPT
-nft 'insert rule ip filter OUTPUT counter accept'
+nft 'insert rule ip filter OUTPUT meta l4proto udp counter accept'
 
 iptables-translate -I OUTPUT -p udp ! --sport 0:65535 -j ACCEPT
-nft 'insert rule ip filter OUTPUT counter accept'
+nft 'insert rule ip filter OUTPUT udp sport != 0-65535 counter accept'
-- 
2.43.0

