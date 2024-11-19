Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7755A14A60C
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2024 22:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732053806; cv=none; b=Vyo2pecV1S/CWHZVrdrv3C3tBj8EAFJ2IC/0KXIIgbDJjOMvdWFDex/Vf//61tAETnLUCvf0UVNOOOzCKrGYdcrF1JfVmdYClMlBU8suw1DjDxqKB2xmqfIeNgIMrKP/fS397EaoLWpDdy7/HPkcg6TQD+67/joPhM4h6dGi0kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732053806; c=relaxed/simple;
	bh=2ct92UFg/wVPexg02V1ifijI3KIosnhAvOKg0tDfdiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iSv09hO6bIj16pAT/GEO8wZtcdfMqNiyxyhkblC+Vq0i984zzReO7U6owEvFZ/F/5/LTN6WbSZ56Nm0YBO037hZb9fWqmluGV1701Dmflku8WWzNCGLBFW3Lkum3sLY9hmV+0/rzKxBvR9Njp7ycVm18uzE/HuL5H/xXmsUFBeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=jfm0LgXP; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="jfm0LgXP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=QUeFP6P/Piu9Oe7m6+GGzMe2cp1Vd+SBm2mOcRfjhYU=; b=jfm0LgXPBjVh1UECdJBDFlJ7ku
	pu4AEZw/3RY4OjozpdoVi+zTSN6tOvehYV3F4PXpGmQ1RjaBxoIXqtm9bnrMrJ2YKtrF4hqiUX9CV
	Ge/aNBT8H+vEU/MKri0tikkTYQKj8k24zqqcfTEmWjDTeBi55bY3BHPQuiX721RdsVJUPB1Fuoswu
	+0A9sOPe2NW5ORgyqyFYFuvJk4pz65wCMuP5Nd72bOFm0Q7L5roJ1PDoxYdFOz5vtWT6rEqehcbCb
	aSrMyg7c8KFbuYoLL55yC07kBlGkgywQmltEj1Rdc5J/ZurDA+roTOXsh/Z7wt6B0eULZD3pFxkbA
	TzA89exA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tDWJd-000000001Ds-3XuV;
	Tue, 19 Nov 2024 23:03:21 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Jeremy Sowden <jeremy@azazel.net>
Subject: [iptables PATCH v2 1/2] nft: fix interface comparisons in `-C` commands
Date: Tue, 19 Nov 2024 23:03:24 +0100
Message-ID: <20241119220325.30700-1-phil@nwl.cc>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jeremy Sowden <jeremy@azazel.net>

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
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Replace the loop by strncmp() calls.
---
 iptables/nft-arp.c                            | 10 ++----
 iptables/nft-ipv4.c                           |  4 +--
 iptables/nft-ipv6.c                           |  6 +---
 iptables/nft-shared.c                         | 36 +++++--------------
 iptables/nft-shared.h                         |  6 +---
 .../nft-only/0020-compare-interfaces_0        |  9 +++++
 6 files changed, 22 insertions(+), 49 deletions(-)
 create mode 100755 iptables/tests/shell/testcases/nft-only/0020-compare-interfaces_0

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 264864c3fb2b2..c11d64c368638 100644
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
index 740928757b7e2..0c8bd2911d105 100644
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
index b184f8af3e6ed..4dbb2af206054 100644
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
index 6775578b1e36b..2c29e68f551df 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -220,36 +220,16 @@ void add_l4proto(struct nft_handle *h, struct nftnl_rule *r,
 }
 
 bool is_same_interfaces(const char *a_iniface, const char *a_outiface,
-			unsigned const char *a_iniface_mask,
-			unsigned const char *a_outiface_mask,
-			const char *b_iniface, const char *b_outiface,
-			unsigned const char *b_iniface_mask,
-			unsigned const char *b_outiface_mask)
+			const char *b_iniface, const char *b_outiface)
 {
-	int i;
-
-	for (i = 0; i < IFNAMSIZ; i++) {
-		if (a_iniface_mask[i] != b_iniface_mask[i]) {
-			DEBUGP("different iniface mask %x, %x (%d)\n",
-			a_iniface_mask[i] & 0xff, b_iniface_mask[i] & 0xff, i);
-			return false;
-		}
-		if ((a_iniface[i] & a_iniface_mask[i])
-		    != (b_iniface[i] & b_iniface_mask[i])) {
-			DEBUGP("different iniface\n");
-			return false;
-		}
-		if (a_outiface_mask[i] != b_outiface_mask[i]) {
-			DEBUGP("different outiface mask\n");
-			return false;
-		}
-		if ((a_outiface[i] & a_outiface_mask[i])
-		    != (b_outiface[i] & b_outiface_mask[i])) {
-			DEBUGP("different outiface\n");
-			return false;
-		}
+	if (strncmp(a_iniface, b_iniface, IFNAMSIZ)) {
+		DEBUGP("different iniface\n");
+		return false;
+	}
+	if (strncmp(a_outiface, b_outiface, IFNAMSIZ)) {
+		DEBUGP("different outiface\n");
+		return false;
 	}
-
 	return true;
 }
 
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 51d1e4609a3b6..b57aee1f84a87 100644
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
index 0000000000000..278cd648ebb78
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
2.47.0

