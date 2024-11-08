Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CAA1E884B
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Nov 2024 13:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731071717; cv=none; b=CA2oBFr3ToI+lWXpYXctPAPGkKoZlbBEiIGGYMfkfHYTJwSm4Eb8v1M99ffYiTqWeYb+auI3iApRKiiPNUNhZCLRLw7fjXEpFCEO4zVw39TL/Fj18fjJjBJA23ydr+/56DyVwiI8P4H5l3DJNRgpFZkgBa+F1D/jX0CIaVAaLSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731071717; c=relaxed/simple;
	bh=dk0mf1ZRUeyhewdZw2o8wQ32PYpQW24nAapKgqg04v8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8b2aJqel6N1JyNfq9544Qb3WB0r7BdQBwNyPHbtID1XW6VOqwkEQ8uVFUotdEw1OaVazemEuNYP00Onnzym2J9uMztT9epz7l0qfVfj3gbmE297skT3FcpRFFCJqo52lQ76qqwL9eGpikiASUTdrM1d+DdsbaOxXgdHN4jdHMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=WuKx5Se8; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="WuKx5Se8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=YFBn5UyCVOLyPxBOA7Jq6vE19m5Qvoe/naQMx84AHaQ=; b=WuKx5Se8cddeil1/49O1Mk7Bum
	Rf78TRcKllGYNvji0JI/Rm1lZydOTVjsBDXIOB7jbgwTHVOV/gwCIkIHHR2L9LUvnb2ST/c/pPzWp
	S6cI0be2EjqMnBLiO96TJgtD1r29kDdJ0GyH8uHt0sMSEDhNKqoP746PT8s5HnZUEqzuCOeAsRzHX
	TBCXyMwUGWt6mTvDX8TVpYceLUhS9kUeouN/HBE+csWYDkIJHCiWXU9pxerwySWpci68LZapZo7Up
	oPsmBN6DEJqXNHVRtSra+13N+ovBBTats94jrikvEkb/LO69OxxjEnQ8/QRemodBeMbtC7FA1qlxo
	UmOcPIdQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t9OpU-0000000022y-06ZZ;
	Fri, 08 Nov 2024 14:15:12 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: [iptables PATCH] xtables-translate: Use protocol name/value as user specified it
Date: Fri,  8 Nov 2024 14:15:08 +0100
Message-ID: <20241108131508.6706-1-phil@nwl.cc>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <Zy4JtJDEkxePLqe7@calendula>
References: <Zy4JtJDEkxePLqe7@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Avoid playing games with /etc/protocols lookups, especially in the
context of the testsuite. Instead make use of the stored protocol name
(which is merely sanitized to lower-case) and use that for output.
Invalid protocol names will still be rejected by the proto_parse
callback call during option parsing.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/generic.txlate | 14 ++++++++++----
 iptables/nft-ipv4.c       |  2 +-
 iptables/nft-ipv6.c       |  2 +-
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/extensions/generic.txlate b/extensions/generic.txlate
index 9ad1266dc623c..5823a64b328da 100644
--- a/extensions/generic.txlate
+++ b/extensions/generic.txlate
@@ -65,16 +65,22 @@ ip6tables-translate -I INPUT ! -s ::/0
 nft 'insert rule ip6 filter INPUT ip6 saddr != ::/0 counter'
 
 iptables-translate -A FORWARD -p 132
-nft 'add rule ip filter FORWARD ip protocol sctp counter'
+nft 'add rule ip filter FORWARD ip protocol 132 counter'
 
 ip6tables-translate -A FORWARD -p 132
-nft 'add rule ip6 filter FORWARD meta l4proto sctp counter'
+nft 'add rule ip6 filter FORWARD meta l4proto 132 counter'
 
 iptables-translate -A FORWARD ! -p 132
-nft 'add rule ip filter FORWARD ip protocol != sctp counter'
+nft 'add rule ip filter FORWARD ip protocol != 132 counter'
 
 ip6tables-translate -A FORWARD ! -p 132
-nft 'add rule ip6 filter FORWARD meta l4proto != sctp counter'
+nft 'add rule ip6 filter FORWARD meta l4proto != 132 counter'
+
+iptables-translate -A FORWARD -p sctp
+nft 'add rule ip filter FORWARD ip protocol sctp counter'
+
+ip6tables-translate -A FORWARD -p sctp
+nft 'add rule ip6 filter FORWARD meta l4proto sctp counter'
 
 iptables-translate -A FORWARD -p 141
 nft 'add rule ip filter FORWARD ip protocol 141 counter'
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 740928757b7e2..d58efe8d8f1db 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -215,7 +215,7 @@ static int nft_ipv4_xlate(const struct iptables_command_state *cs,
 	}
 
 	if (proto != 0 && !xlate_find_protomatch(cs, proto)) {
-		const char *pname = proto_to_name(proto, 0);
+		const char *pname = cs->protocol;
 
 		xt_xlate_add(xl, "ip protocol");
 		if (cs->fw.ip.invflags & IPT_INV_PROTO)
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index b184f8af3e6ed..b655130b661bc 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -194,7 +194,7 @@ static int nft_ipv6_xlate(const struct iptables_command_state *cs,
 		     cs->fw6.ipv6.invflags & IP6T_INV_VIA_OUT);
 
 	if (proto != 0 && !xlate_find_protomatch(cs, proto)) {
-		const char *pname = proto_to_name(proto, 0);
+		const char *pname = cs->protocol;
 
 		xt_xlate_add(xl, "meta l4proto");
 		if (cs->fw6.ipv6.invflags & IP6T_INV_PROTO)
-- 
2.47.0

