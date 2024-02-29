Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDE3692F6
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Feb 2024 17:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709226509; cv=none; b=OH+XZLQkWK4VHWafCRIDsm1/lDd/LLTMu8SUP3LbHMrfQk9OYAwa8gNvFQULjoBzfCF6fZHBQMkf1c0vv/r/4dxW3a7MsOo8ZQwg/MLpX+tRZ+3B0s023bzXpUzgWU7b9o0eIuPmrGAlMbkL9Z1HYXRrx61/BtIXiqE+wSu+L1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709226509; c=relaxed/simple;
	bh=Q/bnBicL/LWk0GsHiO8hToCIB2tvAiqi2phGpnaHKK0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u8lvRGlJMLWTeu5zHPOBPNnU4oh1tKR/z2GocPIsl9VdIM3IU2FBZZ2V9uVh/RC19jHMx4xR15MsMbC1YDi9B+apv3ak1LidzDcuPK3UGiRUJCFaDoSYd69I+CkfT3nKkDohb0FjW4yEm3CdivTXO54T3Y1RwGHxyAZ+z6Pyi2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=LOygE5Bc; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="LOygE5Bc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Fa32ioqsfs/2uYU81Uq22KNuHMtXDrf03rNTSfLg5/I=; b=LOygE5BcYpFP/CMPQx3SQYajh4
	SmISd5EWnCtYRIubghZS/LUkcFYaJCLqmslRAgGfJScjJjV8JYfSHmng+DjTpLCB9tvRy51hIwcdo
	SXB21sh2goK4qAWSnYMhStgaVAeeVCbsvnlhqYXEb8KM5bz4WAuc1IlK6BkfyVhY8RQ01O+XJoXcX
	8EtPS6X1h6AS4YIxOMUTVDKmwcfXeYmcwJ0VaAfdiIu5o8YT7uNeDd2X34pnVAd/+9o1uI8/Qnd7o
	ol9lCxl3YS0fe6aCWPEkQ69PT5q6dxrgZTCyekUEbh2Z3Yigi38LGTzt38kSsys6e5HkLmsLemrhB
	wSmHF7SA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rfjtK-000000005wh-35xQ;
	Thu, 29 Feb 2024 18:08:18 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: matoro_bugzilla_netfilter@matoro.tk
Subject: [iptables PATCH] xtables-translate: Leverage stored protocol names
Date: Thu, 29 Feb 2024 18:08:15 +0100
Message-ID: <20240229170815.28205-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Align output of ip(6)tables-translate for --protocol arguments with that
of ip(6)tables -L/-S by calling proto_to_name() from xshared.c. The
latter will consult xtables_chain_protos list first to make sure (the
right) names are used for "common" protocol values and otherwise falls
back to getprotobynumber() which it replaces here.

Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1738
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/generic.txlate | 30 ++++++++++++++++++++++++++++++
 iptables/nft-ipv4.c       | 24 ++++++++++--------------
 iptables/nft-ipv6.c       | 25 ++++++++++---------------
 iptables/xshared.c        |  2 +-
 iptables/xshared.h        |  2 ++
 5 files changed, 53 insertions(+), 30 deletions(-)

diff --git a/extensions/generic.txlate b/extensions/generic.txlate
index b79239f1a0637..9ad1266dc623c 100644
--- a/extensions/generic.txlate
+++ b/extensions/generic.txlate
@@ -64,6 +64,36 @@ nft 'insert rule ip6 filter INPUT counter'
 ip6tables-translate -I INPUT ! -s ::/0
 nft 'insert rule ip6 filter INPUT ip6 saddr != ::/0 counter'
 
+iptables-translate -A FORWARD -p 132
+nft 'add rule ip filter FORWARD ip protocol sctp counter'
+
+ip6tables-translate -A FORWARD -p 132
+nft 'add rule ip6 filter FORWARD meta l4proto sctp counter'
+
+iptables-translate -A FORWARD ! -p 132
+nft 'add rule ip filter FORWARD ip protocol != sctp counter'
+
+ip6tables-translate -A FORWARD ! -p 132
+nft 'add rule ip6 filter FORWARD meta l4proto != sctp counter'
+
+iptables-translate -A FORWARD -p 141
+nft 'add rule ip filter FORWARD ip protocol 141 counter'
+
+ip6tables-translate -A FORWARD -p 141
+nft 'add rule ip6 filter FORWARD meta l4proto 141 counter'
+
+iptables-translate -A FORWARD ! -p 141
+nft 'add rule ip filter FORWARD ip protocol != 141 counter'
+
+ip6tables-translate -A FORWARD ! -p 141
+nft 'add rule ip6 filter FORWARD meta l4proto != 141 counter'
+
+iptables-translate -A FORWARD -m tcp --dport 22 -p tcp
+nft 'add rule ip filter FORWARD tcp dport 22 counter'
+
+ip6tables-translate -A FORWARD -m tcp --dport 22 -p tcp
+nft 'add rule ip6 filter FORWARD tcp dport 22 counter'
+
 ebtables-translate -I INPUT -i iname --logical-in ilogname -s 0:0:0:0:0:0
 nft 'insert rule bridge filter INPUT iifname "iname" meta ibrname "ilogname" ether saddr 00:00:00:00:00:00 counter'
 
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 979880a3e7702..0ce8477f76c2a 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -214,20 +214,16 @@ static int nft_ipv4_xlate(const struct iptables_command_state *cs,
 	}
 
 	if (cs->fw.ip.proto != 0) {
-		const struct protoent *pent =
-			getprotobynumber(cs->fw.ip.proto);
-		char protonum[sizeof("65535")];
-		const char *name = protonum;
-
-		snprintf(protonum, sizeof(protonum), "%u",
-			 cs->fw.ip.proto);
-
-		if (!pent || !xlate_find_match(cs, pent->p_name)) {
-			if (pent)
-				name = pent->p_name;
-			xt_xlate_add(xl, "ip protocol %s%s ",
-				   cs->fw.ip.invflags & IPT_INV_PROTO ?
-					"!= " : "", name);
+		const char *pname = proto_to_name(cs->fw.ip.proto, 0);
+
+		if (!pname || !xlate_find_match(cs, pname)) {
+			xt_xlate_add(xl, "ip protocol");
+			if (cs->fw.ip.invflags & IPT_INV_PROTO)
+				xt_xlate_add(xl, " !=");
+			if (pname)
+				xt_xlate_add(xl, "%s", pname);
+			else
+				xt_xlate_add(xl, "%hu", cs->fw.ip.proto);
 		}
 	}
 
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index e4b1714d00c2f..c371ba8c938c7 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -193,22 +193,17 @@ static int nft_ipv6_xlate(const struct iptables_command_state *cs,
 		     cs->fw6.ipv6.invflags & IP6T_INV_VIA_OUT);
 
 	if (cs->fw6.ipv6.proto != 0) {
-		const struct protoent *pent =
-			getprotobynumber(cs->fw6.ipv6.proto);
-		char protonum[sizeof("65535")];
-		const char *name = protonum;
-
-		snprintf(protonum, sizeof(protonum), "%u",
-			 cs->fw6.ipv6.proto);
-
-		if (!pent || !xlate_find_match(cs, pent->p_name)) {
-			if (pent)
-				name = pent->p_name;
-			xt_xlate_add(xl, "meta l4proto %s%s ",
-				   cs->fw6.ipv6.invflags & IP6T_INV_PROTO ?
-					"!= " : "", name);
+		const char *pname = proto_to_name(cs->fw6.ipv6.proto, 0);
+
+		if (!pname || !xlate_find_match(cs, pname)) {
+			xt_xlate_add(xl, "meta l4proto");
+			if (cs->fw6.ipv6.invflags & IP6T_INV_PROTO)
+				xt_xlate_add(xl, " !=");
+			if (pname)
+				xt_xlate_add(xl, "%s", pname);
+			else
+				xt_xlate_add(xl, "%hu", cs->fw6.ipv6.proto);
 		}
-
 	}
 
 	xlate_ipv6_addr("ip6 saddr", &cs->fw6.ipv6.src, &cs->fw6.ipv6.smsk,
diff --git a/iptables/xshared.c b/iptables/xshared.c
index bff7d60ce1390..b998dd75aaf05 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -62,7 +62,7 @@ static void print_extension_helps(const struct xtables_target *t,
 	}
 }
 
-static const char *
+const char *
 proto_to_name(uint16_t proto, int nolookup)
 {
 	unsigned int i;
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 7d4035ec03e52..26c492ebee9ec 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -335,4 +335,6 @@ void iface_to_mask(const char *ifname, unsigned char *mask);
 
 void xtables_clear_args(struct xtables_args *args);
 
+const char *proto_to_name(uint16_t proto, int nolookup);
+
 #endif /* IPTABLES_XSHARED_H */
-- 
2.43.0

