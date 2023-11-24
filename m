Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="omEIo44Z"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A3F10D7
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Nov 2023 03:19:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=eHtNaSYb4jtHNbF2RYuBao1tzaY7GcWctuKDiQ/TcgI=; b=omEIo44ZNNc20Ht+7nBVhTLcPI
	jAuzYzsRBeNh7dGONZjASRgGgi77VT/skuBFjcgRktWCUILAajlw0/ECj50rO1GjVJnjoUZplzs38
	AFuMkpV6yolOQcCgAf8iGBu5bNV5zIkSwXrGR88TfKfSY1/2ZOcAQBgmYZE3tqM9Y39TZK8zgCjVa
	8QTaM5rgQGpI4+RhAAimnLOioXkl1yJHGNYZSZg7ttjsvW640wq8gdmMBeL1mDSoAwqr5HocS5Our
	VpbmfAYrDM8C5skDc1wlGZaxaztB6xMjcDEsNhRWZbwI9HpnzNuWsPUAOm/lJn2CCvApMo87U9Q+j
	z7uAW2vg==;
Received: from localhost ([::1] helo=minime)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1r6UDV-0002UZ-05
	for netfilter-devel@vger.kernel.org; Fri, 24 Nov 2023 12:19:25 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/3] xshared: Entirely ignore interface masks when saving rules
Date: Fri, 24 Nov 2023 12:28:32 +0100
Message-ID: <20231124112834.5363-2-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231124112834.5363-1-phil@nwl.cc>
References: <20231124112834.5363-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rule printing code does this for more than 20 years now, assume it's
safe to rely upon the wildcard interface name to contain a '+' suffix.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/ip6tables.c |  3 +--
 iptables/iptables.c  |  3 +--
 iptables/nft-ipv4.c  |  3 +--
 iptables/nft-ipv6.c  |  3 +--
 iptables/xshared.c   | 32 ++++++--------------------------
 iptables/xshared.h   |  6 ++----
 6 files changed, 12 insertions(+), 38 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 08da04b456787..21cd801892641 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -509,8 +509,7 @@ void print_rule6(const struct ip6t_entry *e,
 	save_ipv6_addr('d', &e->ipv6.dst, &e->ipv6.dmsk,
 		       e->ipv6.invflags & IP6T_INV_DSTIP);
 
-	save_rule_details(e->ipv6.iniface, e->ipv6.iniface_mask,
-			  e->ipv6.outiface, e->ipv6.outiface_mask,
+	save_rule_details(e->ipv6.iniface, e->ipv6.outiface,
 			  e->ipv6.proto, 0, e->ipv6.invflags);
 
 #if 0
diff --git a/iptables/iptables.c b/iptables/iptables.c
index a73e8eed9028a..ce65c30ad0b15 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -516,8 +516,7 @@ void print_rule4(const struct ipt_entry *e,
 	save_ipv4_addr('d', &e->ip.dst, &e->ip.dmsk,
 			e->ip.invflags & IPT_INV_DSTIP);
 
-	save_rule_details(e->ip.iniface, e->ip.iniface_mask,
-			  e->ip.outiface, e->ip.outiface_mask,
+	save_rule_details(e->ip.iniface, e->ip.outiface,
 			  e->ip.proto, e->ip.flags & IPT_F_FRAG,
 			  e->ip.invflags);
 
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 7fb71ed4a8056..c140ffde34b62 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -161,8 +161,7 @@ static void nft_ipv4_save_rule(const struct iptables_command_state *cs,
 	save_ipv4_addr('d', &cs->fw.ip.dst, &cs->fw.ip.dmsk,
 		       cs->fw.ip.invflags & IPT_INV_DSTIP);
 
-	save_rule_details(cs->fw.ip.iniface, cs->fw.ip.iniface_mask,
-			  cs->fw.ip.outiface, cs->fw.ip.outiface_mask,
+	save_rule_details(cs->fw.ip.iniface, cs->fw.ip.outiface,
 			  cs->fw.ip.proto, cs->fw.ip.flags & IPT_F_FRAG,
 			  cs->fw.ip.invflags);
 
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index bb417356629a9..4bf4f54f18a00 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -147,8 +147,7 @@ static void nft_ipv6_save_rule(const struct iptables_command_state *cs,
 	save_ipv6_addr('d', &cs->fw6.ipv6.dst, &cs->fw6.ipv6.dmsk,
 		       cs->fw6.ipv6.invflags & IP6T_INV_DSTIP);
 
-	save_rule_details(cs->fw6.ipv6.iniface, cs->fw6.ipv6.iniface_mask,
-			  cs->fw6.ipv6.outiface, cs->fw6.ipv6.outiface_mask,
+	save_rule_details(cs->fw6.ipv6.iniface, cs->fw6.ipv6.outiface,
 			  cs->fw6.ipv6.proto, 0, cs->fw6.ipv6.invflags);
 
 	save_matches_and_target(cs, cs->fw6.ipv6.flags & IP6T_F_GOTO,
diff --git a/iptables/xshared.c b/iptables/xshared.c
index ca17479811df3..839a5bb68776c 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -757,29 +757,12 @@ void print_ifaces(const char *iniface, const char *outiface, uint8_t invflags,
 	printf(FMT("%-6s ", "out %s "), iface);
 }
 
-/* This assumes that mask is contiguous, and byte-bounded. */
-void save_iface(char letter, const char *iface,
-		const unsigned char *mask, int invert)
+void save_iface(char letter, const char *iface, int invert)
 {
-	unsigned int i;
-
-	if (mask[0] == 0)
+	if (!strlen(iface) || !strcmp(iface, "+"))
 		return;
 
-	printf("%s -%c ", invert ? " !" : "", letter);
-
-	for (i = 0; i < IFNAMSIZ; i++) {
-		if (mask[i] != 0) {
-			if (iface[i] != '\0')
-				printf("%c", iface[i]);
-		} else {
-			/* we can access iface[i-1] here, because
-			 * a few lines above we make sure that mask[0] != 0 */
-			if (iface[i-1] != '\0')
-				printf("+");
-			break;
-		}
-	}
+	printf("%s -%c %s", invert ? " !" : "", letter, iface);
 }
 
 static void command_match(struct iptables_command_state *cs, bool invert)
@@ -1066,17 +1049,14 @@ void print_rule_details(unsigned int linenum, const struct xt_counters *ctrs,
 		printf(FMT("%-4s ", "%s "), pname);
 }
 
-void save_rule_details(const char *iniface, unsigned const char *iniface_mask,
-		       const char *outiface, unsigned const char *outiface_mask,
+void save_rule_details(const char *iniface, const char *outiface,
 		       uint16_t proto, int frag, uint8_t invflags)
 {
 	if (iniface != NULL) {
-		save_iface('i', iniface, iniface_mask,
-			    invflags & IPT_INV_VIA_IN);
+		save_iface('i', iniface, invflags & IPT_INV_VIA_IN);
 	}
 	if (outiface != NULL) {
-		save_iface('o', outiface, outiface_mask,
-			    invflags & IPT_INV_VIA_OUT);
+		save_iface('o', outiface, invflags & IPT_INV_VIA_OUT);
 	}
 
 	if (proto > 0) {
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 28efd73cf470a..952fa8ab95fec 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -212,8 +212,7 @@ void save_ipv6_addr(char letter, const struct in6_addr *addr,
 
 void print_ifaces(const char *iniface, const char *outiface, uint8_t invflags,
 		  unsigned int format);
-void save_iface(char letter, const char *iface,
-		const unsigned char *mask, int invert);
+void save_iface(char letter, const char *iface, int invert);
 
 void print_fragment(unsigned int flags, unsigned int invflags,
 		    unsigned int format, bool fake);
@@ -225,8 +224,7 @@ void assert_valid_chain_name(const char *chainname);
 void print_rule_details(unsigned int linenum, const struct xt_counters *ctrs,
 			const char *targname, uint8_t proto, uint8_t flags,
 			uint8_t invflags, unsigned int format);
-void save_rule_details(const char *iniface, unsigned const char *iniface_mask,
-		       const char *outiface, unsigned const char *outiface_mask,
+void save_rule_details(const char *iniface, const char *outiface,
 		       uint16_t proto, int frag, uint8_t invflags);
 
 int print_match_save(const struct xt_entry_match *e, const void *ip);
-- 
2.41.0

