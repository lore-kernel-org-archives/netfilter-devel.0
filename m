Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17331429F
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Mar 2024 17:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709658668; cv=none; b=JSgTxFYFzEKwqW34yRPAj6r6qrtzvX3QCi/NbSu9IwwjiV0uQTlzvsUqO6sGNPiiHaFvqKZIk+2pm1In/4VkmOBTD24KkyrG8+s8WvIZfMVTjsxtrRSdoWPlznPmLjKzrgR0JUjogMnC+33FFhTcJcosBtSoL58mR3aiGVPM8mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709658668; c=relaxed/simple;
	bh=PtuKSkKiuudsrbU2x8UQstmoJM8fUT0HA3Ztri4sF3g=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=onzg57P2sKXZgrdQVLNkou6gCsGvAEZ89Qr36H1F7D50g4vAb7IjSCnwUSTfRE2L82XV2yNOii0OOhCOLx8kQMFfVNRBX8mrFfy6UYg+tvUrfUBLFAxJnnc1wg+j9MK48DCU6GFDvFIAGplngcIvG9rTQy+3NJp83zu6G/Qrg7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Xt8cUJ6H; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Xt8cUJ6H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=gdoW6TwV8QMLxIKeONSWF30lI+BHhUkw3Z1Wo21TAYs=; b=Xt8cUJ6HMtmHpwr4tjfsGepKcS
	XLxWcb/q+vOap8mmSKtUdl6t9u4buWqkfevbNGSjwGFJvK92qIfjfkQvz+gs7UgoFOQA3+NkQxZX9
	6J58Ti5u/qht1uzmpwa58B7wMF/e78hIRvXeVyY4qTTsRwmnq3e2zDsHBA/4MHZiLsUGmC0fgW09i
	jZqnNS1FLt7Rm1Oh8BD/u0revAoejoc4yXG0excT9Hw441w2OYtUM//ZoWBbhOrPN/AH6jgjBtFTi
	hSRnNJBz1Zq8RKuBCAo+xx5+i92T92JxL9207Q9tjtQ3Z5ZTbL2h12PY3pszSwt3+K63IhnWslBYs
	J02psJTQ==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rhYJj-000000008Q2-2gAX
	for netfilter-devel@vger.kernel.org;
	Tue, 05 Mar 2024 18:11:03 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/2] xlate: Improve redundant l4proto match avoidance
Date: Tue,  5 Mar 2024 18:10:58 +0100
Message-ID: <20240305171059.12795-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xtables-translate tries to avoid 'ip protocol'/'meta l4proto' matches if
following expressions add this as dependency anyway. E.g.:

| # iptables-translate -A FOO -p tcp -m tcp --dport 22 -j ACCEPT
| nft 'add rule ip filter FOO tcp dport 22 counter accept'

This worked by searching protocol name in loaded matches, but that
approach is flawed as the protocol name and corresponding extension may
differ ("mobility-header" vs. "mh"). Improve this by searching for all
names (cached or resolved) for a given protocol number.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libip6t_mh.txlate |  6 +++---
 iptables/nft-ipv4.c          | 23 +++++++++++------------
 iptables/nft-ipv6.c          | 23 +++++++++++------------
 iptables/nft.h               |  1 +
 iptables/xtables-translate.c | 17 ++++++++++++++++-
 5 files changed, 42 insertions(+), 28 deletions(-)

diff --git a/extensions/libip6t_mh.txlate b/extensions/libip6t_mh.txlate
index 3364ce574468f..cc194254951e9 100644
--- a/extensions/libip6t_mh.txlate
+++ b/extensions/libip6t_mh.txlate
@@ -1,8 +1,8 @@
 ip6tables-translate -A INPUT -p mh --mh-type 1 -j ACCEPT
-nft 'add rule ip6 filter INPUT meta l4proto mobility-header mh type 1 counter accept'
+nft 'add rule ip6 filter INPUT mh type 1 counter accept'
 
 ip6tables-translate -A INPUT -p mh --mh-type 1:3 -j ACCEPT
-nft 'add rule ip6 filter INPUT meta l4proto mobility-header mh type 1-3 counter accept'
+nft 'add rule ip6 filter INPUT mh type 1-3 counter accept'
 
 ip6tables-translate -A INPUT -p mh --mh-type 0:255 -j ACCEPT
 nft 'add rule ip6 filter INPUT meta l4proto mobility-header counter accept'
@@ -11,4 +11,4 @@ ip6tables-translate -A INPUT -m mh --mh-type 0:255 -j ACCEPT
 nft 'add rule ip6 filter INPUT exthdr mh exists counter accept'
 
 ip6tables-translate -A INPUT -p mh ! --mh-type 0:255 -j ACCEPT
-nft 'add rule ip6 filter INPUT meta l4proto mobility-header mh type != 0-255 counter accept'
+nft 'add rule ip6 filter INPUT mh type != 0-255 counter accept'
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 0ce8477f76c2a..740928757b7e2 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -200,6 +200,7 @@ static void xlate_ipv4_addr(const char *selector, const struct in_addr *addr,
 static int nft_ipv4_xlate(const struct iptables_command_state *cs,
 			  struct xt_xlate *xl)
 {
+	uint16_t proto = cs->fw.ip.proto;
 	const char *comment;
 	int ret;
 
@@ -213,18 +214,16 @@ static int nft_ipv4_xlate(const struct iptables_command_state *cs,
 			   cs->fw.ip.invflags & IPT_INV_FRAG? "" : "!= ", 0);
 	}
 
-	if (cs->fw.ip.proto != 0) {
-		const char *pname = proto_to_name(cs->fw.ip.proto, 0);
-
-		if (!pname || !xlate_find_match(cs, pname)) {
-			xt_xlate_add(xl, "ip protocol");
-			if (cs->fw.ip.invflags & IPT_INV_PROTO)
-				xt_xlate_add(xl, " !=");
-			if (pname)
-				xt_xlate_add(xl, "%s", pname);
-			else
-				xt_xlate_add(xl, "%hu", cs->fw.ip.proto);
-		}
+	if (proto != 0 && !xlate_find_protomatch(cs, proto)) {
+		const char *pname = proto_to_name(proto, 0);
+
+		xt_xlate_add(xl, "ip protocol");
+		if (cs->fw.ip.invflags & IPT_INV_PROTO)
+			xt_xlate_add(xl, " !=");
+		if (pname)
+			xt_xlate_add(xl, "%s", pname);
+		else
+			xt_xlate_add(xl, "%hu", proto);
 	}
 
 	xlate_ipv4_addr("ip saddr", &cs->fw.ip.src, &cs->fw.ip.smsk,
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index c371ba8c938c7..b184f8af3e6ed 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -184,6 +184,7 @@ static void xlate_ipv6_addr(const char *selector, const struct in6_addr *addr,
 static int nft_ipv6_xlate(const struct iptables_command_state *cs,
 			  struct xt_xlate *xl)
 {
+	uint16_t proto = cs->fw6.ipv6.proto;
 	const char *comment;
 	int ret;
 
@@ -192,18 +193,16 @@ static int nft_ipv6_xlate(const struct iptables_command_state *cs,
 	xlate_ifname(xl, "oifname", cs->fw6.ipv6.outiface,
 		     cs->fw6.ipv6.invflags & IP6T_INV_VIA_OUT);
 
-	if (cs->fw6.ipv6.proto != 0) {
-		const char *pname = proto_to_name(cs->fw6.ipv6.proto, 0);
-
-		if (!pname || !xlate_find_match(cs, pname)) {
-			xt_xlate_add(xl, "meta l4proto");
-			if (cs->fw6.ipv6.invflags & IP6T_INV_PROTO)
-				xt_xlate_add(xl, " !=");
-			if (pname)
-				xt_xlate_add(xl, "%s", pname);
-			else
-				xt_xlate_add(xl, "%hu", cs->fw6.ipv6.proto);
-		}
+	if (proto != 0 && !xlate_find_protomatch(cs, proto)) {
+		const char *pname = proto_to_name(proto, 0);
+
+		xt_xlate_add(xl, "meta l4proto");
+		if (cs->fw6.ipv6.invflags & IP6T_INV_PROTO)
+			xt_xlate_add(xl, " !=");
+		if (pname)
+			xt_xlate_add(xl, "%s", pname);
+		else
+			xt_xlate_add(xl, "%hu", proto);
 	}
 
 	xlate_ipv6_addr("ip6 saddr", &cs->fw6.ipv6.src, &cs->fw6.ipv6.smsk,
diff --git a/iptables/nft.h b/iptables/nft.h
index 57533b6529f5b..b2a8484f09f0a 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -242,6 +242,7 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table, boo
 struct xt_buf;
 
 bool xlate_find_match(const struct iptables_command_state *cs, const char *p_name);
+bool xlate_find_protomatch(const struct iptables_command_state *cs, uint16_t proto);
 int xlate_matches(const struct iptables_command_state *cs, struct xt_xlate *xl);
 int xlate_action(const struct iptables_command_state *cs, bool goto_set,
 		 struct xt_xlate *xl);
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 8ebe523c447f2..3d8617f05b120 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -131,7 +131,6 @@ bool xlate_find_match(const struct iptables_command_state *cs, const char *p_nam
 {
 	struct xtables_rule_match *matchp;
 
-	/* Skip redundant protocol, eg. ip protocol tcp tcp dport */
 	for (matchp = cs->matches; matchp; matchp = matchp->next) {
 		if (strcmp(matchp->match->name, p_name) == 0)
 			return true;
@@ -139,6 +138,22 @@ bool xlate_find_match(const struct iptables_command_state *cs, const char *p_nam
 	return false;
 }
 
+bool xlate_find_protomatch(const struct iptables_command_state *cs,
+			   uint16_t proto)
+{
+	struct protoent *pent;
+	int i;
+
+	/* Skip redundant protocol, eg. ip protocol tcp tcp dport */
+	for (i = 0; xtables_chain_protos[i].name != NULL; i++) {
+		if (xtables_chain_protos[i].num == proto &&
+		    xlate_find_match(cs, xtables_chain_protos[i].name))
+			return true;
+	}
+	pent = getprotobynumber(proto);
+	return pent && xlate_find_match(cs, pent->p_name);
+}
+
 const char *family2str[] = {
 	[NFPROTO_ARP]	= "arp",
 	[NFPROTO_IPV4]	= "ip",
-- 
2.43.0

