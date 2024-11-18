Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4151E871
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Nov 2024 14:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731939725; cv=none; b=NLtXp/fkdEAfkr1yky6J8FWSvEXAIFAxiwLkv/CJHkBWzbif8wmc2A9MZFqugHkiO81zoTaw6HtbB6zwtSgDVqqcOus9pj4mEsp9ojst8O2bt1z9eV5qUbQqFb+6wU+jrVcE+q2a5bP5itIHyv6seAfiP+DU5027jOYMRp3oUV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731939725; c=relaxed/simple;
	bh=PTnftLpZoHBUbwwuALIsU80t9YfwnOQOnlTflYGr1S0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RBvdjdPjK1mc6Qf3+Fo1F1ym5VKA5GZNDT9s69WgamRKWHRKFYRKDb8I1AlgFKG4uDsajqWMnrDC7ttIYLVnzKQKszO6SoxhZdbX5+w2r1wMPU13fYevit8hEqLR+h97iSgRAFPncBYUM3bEtQ0XdBkTGtsCpo7dvgN1EpK5x2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=J1HwwnDw; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="J1HwwnDw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=m5UL0becTMD52W8cCiovL88nNdGyGQSe7j1I37hCmSM=; b=J1HwwnDwbYaJfLHOXH40xmDBNk
	lUYMs1S29MADXuu5n32C17H6ob57i3pC8o7qRoPudN4ur4GyZJIL59+UQ+10z4GvBf6hkcGC1HDib
	dCFbvcJwjFDpre8KS4qcBVwwpvccmLeZREq4I5mekI+R6H5aYLVGHH4pmj21bSfMWmR5MflgA4x6Q
	vn6z/njrCLlyQ4zhg4QY4aCuw8MuW8fl0BS+ZTwacMG6e6n+V1DSntsaTWmWVP4hRMeJuuzxki61w
	Eo67OiziTZSVyrgItSQsnCjT23G+Dk+0gtDYkyQ0a4EKWcyiOuUjHZ0YFKMg7rmtmbiZk0ImdndsA
	hAW+MB+w==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1tD2FY-008UwJ-2H;
	Mon, 18 Nov 2024 13:57:08 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Phil Sutter <phil@nwl.cc>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH iptables] nft: fix interface comparisons in `-C` commands
Date: Mon, 18 Nov 2024 13:56:50 +0000
Message-ID: <20241118135650.510715-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false

Commit 9ccae6397475 ("nft: Leave interface masks alone when parsing from
kernel") removed code which explicitly set interface masks to all ones.  The
result of this is that they are zero.  However, they are used to mask interfaces
in `is_same_interfaces`.  Consequently, the masked values are alway zero, the
comparisons are always true, and check commands which ought to fail succeed:

  # iptables -N test
  # iptables -A test -i lo \! -o lo -j REJECT
  # iptables -v -L test
  Chain test (0 references)
   pkts bytes target     prot opt in     out     source               destination
      0     0 REJECT     all  --  lo     !lo     anywhere             anywhere             reject-with icmp-port-unreachable
  # iptables -v -C test -i abcdefgh \! -o abcdefgh -j REJECT
  REJECT  all opt -- in lo out !lo  0.0.0.0/0  -> 0.0.0.0/0   reject-with icmp-port-unreachable

Remove the mask parameters from `is_same_interfaces`.  Add a test-case.

Fixes: 9ccae6397475 ("nft: Leave interface masks alone when parsing from kernel")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 iptables/nft-arp.c                            | 10 ++-------
 iptables/nft-ipv4.c                           |  4 +---
 iptables/nft-ipv6.c                           |  6 +-----
 iptables/nft-shared.c                         | 21 +++----------------
 iptables/nft-shared.h                         |  6 +-----
 .../nft-only/0020-compare-interfaces_0        |  9 ++++++++
 6 files changed, 17 insertions(+), 39 deletions(-)
 create mode 100755 iptables/tests/shell/testcases/nft-only/0020-compare-interfaces_0

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 264864c3fb2b..c11d64c36863 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -385,14 +385,8 @@ static bool nft_arp_is_same(const struct iptables_command_state *cs_a,
 		return false;
 	}
 
-	return is_same_interfaces(a->arp.iniface,
-				  a->arp.outiface,
-				  (unsigned char *)a->arp.iniface_mask,
-				  (unsigned char *)a->arp.outiface_mask,
-				  b->arp.iniface,
-				  b->arp.outiface,
-				  (unsigned char *)b->arp.iniface_mask,
-				  (unsigned char *)b->arp.outiface_mask);
+	return is_same_interfaces(a->arp.iniface, a->arp.outiface,
+				  b->arp.iniface, b->arp.outiface);
 }
 
 static void nft_arp_save_chain(const struct nftnl_chain *c, const char *policy)
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 740928757b7e..0c8bd2911d10 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -113,9 +113,7 @@ static bool nft_ipv4_is_same(const struct iptables_command_state *a,
 	}
 
 	return is_same_interfaces(a->fw.ip.iniface, a->fw.ip.outiface,
-				  a->fw.ip.iniface_mask, a->fw.ip.outiface_mask,
-				  b->fw.ip.iniface, b->fw.ip.outiface,
-				  b->fw.ip.iniface_mask, b->fw.ip.outiface_mask);
+				  b->fw.ip.iniface, b->fw.ip.outiface);
 }
 
 static void nft_ipv4_set_goto_flag(struct iptables_command_state *cs)
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index b184f8af3e6e..4dbb2af20605 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -99,11 +99,7 @@ static bool nft_ipv6_is_same(const struct iptables_command_state *a,
 	}
 
 	return is_same_interfaces(a->fw6.ipv6.iniface, a->fw6.ipv6.outiface,
-				  a->fw6.ipv6.iniface_mask,
-				  a->fw6.ipv6.outiface_mask,
-				  b->fw6.ipv6.iniface, b->fw6.ipv6.outiface,
-				  b->fw6.ipv6.iniface_mask,
-				  b->fw6.ipv6.outiface_mask);
+				  b->fw6.ipv6.iniface, b->fw6.ipv6.outiface);
 }
 
 static void nft_ipv6_set_goto_flag(struct iptables_command_state *cs)
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 6775578b1e36..fab77b011963 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -220,31 +220,16 @@ void add_l4proto(struct nft_handle *h, struct nftnl_rule *r,
 }
 
 bool is_same_interfaces(const char *a_iniface, const char *a_outiface,
-			unsigned const char *a_iniface_mask,
-			unsigned const char *a_outiface_mask,
-			const char *b_iniface, const char *b_outiface,
-			unsigned const char *b_iniface_mask,
-			unsigned const char *b_outiface_mask)
+			const char *b_iniface, const char *b_outiface)
 {
 	int i;
 
 	for (i = 0; i < IFNAMSIZ; i++) {
-		if (a_iniface_mask[i] != b_iniface_mask[i]) {
-			DEBUGP("different iniface mask %x, %x (%d)\n",
-			a_iniface_mask[i] & 0xff, b_iniface_mask[i] & 0xff, i);
-			return false;
-		}
-		if ((a_iniface[i] & a_iniface_mask[i])
-		    != (b_iniface[i] & b_iniface_mask[i])) {
+		if (a_iniface[i] != b_iniface[i]) {
 			DEBUGP("different iniface\n");
 			return false;
 		}
-		if (a_outiface_mask[i] != b_outiface_mask[i]) {
-			DEBUGP("different outiface mask\n");
-			return false;
-		}
-		if ((a_outiface[i] & a_outiface_mask[i])
-		    != (b_outiface[i] & b_outiface_mask[i])) {
+		if (a_outiface[i] != b_outiface[i]) {
 			DEBUGP("different outiface\n");
 			return false;
 		}
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 51d1e4609a3b..b57aee1f84a8 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -105,11 +105,7 @@ void add_l4proto(struct nft_handle *h, struct nftnl_rule *r, uint8_t proto, uint
 void add_compat(struct nftnl_rule *r, uint32_t proto, bool inv);
 
 bool is_same_interfaces(const char *a_iniface, const char *a_outiface,
-			unsigned const char *a_iniface_mask,
-			unsigned const char *a_outiface_mask,
-			const char *b_iniface, const char *b_outiface,
-			unsigned const char *b_iniface_mask,
-			unsigned const char *b_outiface_mask);
+			const char *b_iniface, const char *b_outiface);
 
 void __get_cmp_data(struct nftnl_expr *e, void *data, size_t dlen, uint8_t *op);
 void get_cmp_data(struct nftnl_expr *e, void *data, size_t dlen, bool *inv);
diff --git a/iptables/tests/shell/testcases/nft-only/0020-compare-interfaces_0 b/iptables/tests/shell/testcases/nft-only/0020-compare-interfaces_0
new file mode 100755
index 000000000000..278cd648ebb7
--- /dev/null
+++ b/iptables/tests/shell/testcases/nft-only/0020-compare-interfaces_0
@@ -0,0 +1,9 @@
+#!/bin/bash
+
+[[ $XT_MULTI == *xtables-nft-multi ]] || { echo "skip $XT_MULTI"; exit 0; }
+
+$XT_MULTI iptables -N test
+$XT_MULTI iptables -A test -i lo \! -o lo -j REJECT
+$XT_MULTI iptables -C test -i abcdefgh \! -o abcdefgh -j REJECT 2>/dev/null && exit 1
+
+exit 0
-- 
2.45.2

