Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C73273182
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Dec 2023 13:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="bJ1347e5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=y/iPvyUf8rrKw9Sp4lqDmLkda/2NjCznxlVP/5HlSO8=; b=bJ1347e5DkL+VUIByxU/qPPrag
	qkOn/qNvZet84vfuq1Z0ev2G73eBCwt5vIRl9lROYaO0kTVdILmbB9lg9MI8Nz23puPSPYVlOYdA/
	19IAq46rGBNC+FQ7S6xufy1JNTv9X2wnZ3SKwouaIBJgz4pTjZ/3Sa2ZSJwNTFv3tw9Y0cSYv430m
	4q/iqzHYTfkgaUiOGX/PxlFTgedus1dgXRF+XuwsgcZyOrvdzasU97nbKF47f7zt7OGNxeDUiRbBa
	dZc8/sUGSAuHnqrmr4y7B3JUn4l4a904/GKIekeCpgdQlrd2EQO58nt2G/rCBa9s8sDbLjWHRuzeg
	EcNQXt6Q==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rGIs4-0004D3-Ho; Thu, 21 Dec 2023 14:13:52 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH] ebtables: Default to extrapositioned negations
Date: Thu, 21 Dec 2023 14:13:48 +0100
Message-ID: <20231221131348.25760-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ebtables-nft has always supported both intra- and extrapositioned
negations but defaulted to intrapositioned when printing/saving rules.

With commit 58d364c7120b5 ("ebtables: Use do_parse() from xshared")
though, it started to warn about intrapositioned negations. So change
the default to avoid mandatory warnings when e.g. loading previously
dumped rulesets.

Also adjust test cases, help texts and ebtables-nft.8 accordingly.

Cc: Jan Engelhardt <jengelh@inai.de>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_802_3.c                     |  10 +-
 extensions/libebt_802_3.t                     |   6 +-
 extensions/libebt_among.c                     |  21 ++--
 extensions/libebt_among.t                     |  12 +-
 extensions/libebt_arp.c                       |  39 ++++---
 extensions/libebt_arp.t                       |  22 ++--
 extensions/libebt_ip.c                        |  37 +++---
 extensions/libebt_ip.t                        |  12 +-
 extensions/libebt_ip.txlate                   |   4 +-
 extensions/libebt_ip6.c                       |  29 +++--
 extensions/libebt_ip6.t                       |  16 +--
 extensions/libebt_ip6.txlate                  |   2 +-
 extensions/libebt_mark_m.c                    |   4 +-
 extensions/libebt_mark_m.t                    |   4 +-
 extensions/libebt_mark_m.txlate               |   2 +-
 extensions/libebt_pkttype.c                   |   4 +-
 extensions/libebt_pkttype.t                   |  14 +--
 extensions/libebt_standard.t                  |   3 +-
 extensions/libebt_stp.c                       |  29 ++---
 extensions/libebt_stp.t                       |  28 ++---
 extensions/libebt_vlan.c                      |  19 ++--
 extensions/libebt_vlan.t                      |  10 +-
 extensions/libebt_vlan.txlate                 |   2 +-
 iptables/ebtables-nft.8                       | 106 +++++++++---------
 iptables/nft-bridge.c                         |  10 +-
 .../testcases/ebtables/0008-ebtables-among_0  |  18 ++-
 26 files changed, 234 insertions(+), 229 deletions(-)

diff --git a/extensions/libebt_802_3.c b/extensions/libebt_802_3.c
index 26a7725cd0074..489185e93f1a0 100644
--- a/extensions/libebt_802_3.c
+++ b/extensions/libebt_802_3.c
@@ -33,9 +33,9 @@ static void br802_3_print_help(void)
 {
 	printf(
 "802_3 options:\n"
-"--802_3-sap [!] protocol       : 802.3 DSAP/SSAP- 1 byte value (hex)\n"
+"[!] --802_3-sap protocol       : 802.3 DSAP/SSAP- 1 byte value (hex)\n"
 "  DSAP and SSAP are always the same.  One SAP applies to both fields\n"
-"--802_3-type [!] protocol      : 802.3 SNAP Type- 2 byte value (hex)\n"
+"[!] --802_3-type protocol      : 802.3 SNAP Type- 2 byte value (hex)\n"
 "  Type implies SAP value 0xaa\n");
 }
 
@@ -55,16 +55,14 @@ static void br802_3_print(const void *ip, const struct xt_entry_match *match,
 	struct ebt_802_3_info *info = (struct ebt_802_3_info *)match->data;
 
 	if (info->bitmask & EBT_802_3_SAP) {
-		printf("--802_3-sap ");
 		if (info->invflags & EBT_802_3_SAP)
 			printf("! ");
-		printf("0x%.2x ", info->sap);
+		printf("--802_3-sap 0x%.2x ", info->sap);
 	}
 	if (info->bitmask & EBT_802_3_TYPE) {
-		printf("--802_3-type ");
 		if (info->invflags & EBT_802_3_TYPE)
 			printf("! ");
-		printf("0x%.4x ", ntohs(info->type));
+		printf("--802_3-type 0x%.4x ", ntohs(info->type));
 	}
 }
 
diff --git a/extensions/libebt_802_3.t b/extensions/libebt_802_3.t
index 2e4945b388830..d1e1979559edd 100644
--- a/extensions/libebt_802_3.t
+++ b/extensions/libebt_802_3.t
@@ -1,7 +1,7 @@
 :INPUT,FORWARD,OUTPUT
---802_3-sap ! 0x0a -j CONTINUE;=;FAIL
+! --802_3-sap 0x0a -j CONTINUE;=;FAIL
 --802_3-type 0x000a -j RETURN;=;FAIL
 -p Length --802_3-sap 0x0a -j CONTINUE;=;OK
--p Length --802_3-sap ! 0x0a -j CONTINUE;=;OK
+-p Length ! --802_3-sap 0x0a -j CONTINUE;=;OK
 -p Length --802_3-type 0x000a -j RETURN;=;OK
--p Length --802_3-type ! 0x000a -j RETURN;=;OK
+-p Length ! --802_3-type 0x000a -j RETURN;=;OK
diff --git a/extensions/libebt_among.c b/extensions/libebt_among.c
index a80fb80404ee1..85f9bee423249 100644
--- a/extensions/libebt_among.c
+++ b/extensions/libebt_among.c
@@ -43,10 +43,10 @@ static void bramong_print_help(void)
 {
 	printf(
 "`among' options:\n"
-"--among-dst      [!] list      : matches if ether dst is in list\n"
-"--among-src      [!] list      : matches if ether src is in list\n"
-"--among-dst-file [!] file      : obtain dst list from file\n"
-"--among-src-file [!] file      : obtain src list from file\n"
+"[!] --among-dst      list      : matches if ether dst is in list\n"
+"[!] --among-src      list      : matches if ether src is in list\n"
+"[!] --among-dst-file file      : obtain dst list from file\n"
+"[!] --among-src-file file      : obtain src list from file\n"
 "list has form:\n"
 " xx:xx:xx:xx:xx:xx[=ip.ip.ip.ip],yy:yy:yy:yy:yy:yy[=ip.ip.ip.ip]"
 ",...,zz:zz:zz:zz:zz:zz[=ip.ip.ip.ip][,]\n"
@@ -188,10 +188,10 @@ static int bramong_parse(int c, char **argv, int invert,
 }
 
 static void __bramong_print(struct nft_among_pair *pairs,
-			    int cnt, bool inv, bool have_ip)
+			    int cnt, bool have_ip)
 {
-	const char *isep = inv ? "! " : "";
 	char abuf[INET_ADDRSTRLEN];
+	const char *isep = "";
 	int i;
 
 	for (i = 0; i < cnt; i++) {
@@ -212,14 +212,13 @@ static void bramong_print(const void *ip, const struct xt_entry_match *match,
 	struct nft_among_data *data = (struct nft_among_data *)match->data;
 
 	if (data->src.cnt) {
-		printf("--among-src ");
-		__bramong_print(data->pairs,
-				data->src.cnt, data->src.inv, data->src.ip);
+		printf("%s--among-src ", data->src.inv ? "! " : "");
+		__bramong_print(data->pairs, data->src.cnt, data->src.ip);
 	}
 	if (data->dst.cnt) {
-		printf("--among-dst ");
+		printf("%s--among-dst ", data->dst.inv ? "! " : "");
 		__bramong_print(data->pairs + data->src.cnt,
-				data->dst.cnt, data->dst.inv, data->dst.ip);
+				data->dst.cnt, data->dst.ip);
 	}
 }
 
diff --git a/extensions/libebt_among.t b/extensions/libebt_among.t
index a02206f391cde..aef07acf5a14f 100644
--- a/extensions/libebt_among.t
+++ b/extensions/libebt_among.t
@@ -1,15 +1,15 @@
 :INPUT,FORWARD,OUTPUT
 --among-dst de:ad:0:be:ee:ff,c0:ff:ee:0:ba:be;--among-dst c0:ff:ee:0:ba:be,de:ad:0:be:ee:ff;OK
---among-dst ! c0:ff:ee:0:ba:be,de:ad:0:be:ee:ff;=;OK
+! --among-dst c0:ff:ee:0:ba:be,de:ad:0:be:ee:ff;=;OK
 --among-src be:ef:0:c0:ff:ee,c0:ff:ee:0:ba:be,de:ad:0:be:ee:ff;=;OK
 --among-src de:ad:0:be:ee:ff=10.0.0.1,c0:ff:ee:0:ba:be=192.168.1.1;--among-src c0:ff:ee:0:ba:be=192.168.1.1,de:ad:0:be:ee:ff=10.0.0.1;OK
---among-src ! c0:ff:ee:0:ba:be=192.168.1.1,de:ad:0:be:ee:ff=10.0.0.1;=;OK
+! --among-src c0:ff:ee:0:ba:be=192.168.1.1,de:ad:0:be:ee:ff=10.0.0.1;=;OK
 --among-src de:ad:0:be:ee:ff --among-dst c0:ff:ee:0:ba:be;=;OK
 --among-src de:ad:0:be:ee:ff=10.0.0.1 --among-dst c0:ff:ee:0:ba:be=192.168.1.1;=;OK
---among-src ! de:ad:0:be:ee:ff --among-dst c0:ff:ee:0:ba:be;=;OK
---among-src de:ad:0:be:ee:ff=10.0.0.1 --among-dst ! c0:ff:ee:0:ba:be=192.168.1.1;=;OK
---among-src ! de:ad:0:be:ee:ff --among-dst c0:ff:ee:0:ba:be=192.168.1.1;=;OK
---among-src de:ad:0:be:ee:ff=10.0.0.1 --among-dst ! c0:ff:ee:0:ba:be=192.168.1.1;=;OK
+! --among-src de:ad:0:be:ee:ff --among-dst c0:ff:ee:0:ba:be;=;OK
+--among-src de:ad:0:be:ee:ff=10.0.0.1 ! --among-dst c0:ff:ee:0:ba:be=192.168.1.1;=;OK
+! --among-src de:ad:0:be:ee:ff --among-dst c0:ff:ee:0:ba:be=192.168.1.1;=;OK
+--among-src de:ad:0:be:ee:ff=10.0.0.1 ! --among-dst c0:ff:ee:0:ba:be=192.168.1.1;=;OK
 --among-src;=;FAIL
 --among-src 00:11=10.0.0.1;=;FAIL
 --among-src de:ad:0:be:ee:ff=10.256.0.1;=;FAIL
diff --git a/extensions/libebt_arp.c b/extensions/libebt_arp.c
index b6d691d8c0b10..50ce32be51014 100644
--- a/extensions/libebt_arp.c
+++ b/extensions/libebt_arp.c
@@ -66,13 +66,13 @@ static void brarp_print_help(void)
 
 	printf(
 "arp options:\n"
-"--arp-opcode  [!] opcode        : ARP opcode (integer or string)\n"
-"--arp-htype   [!] type          : ARP hardware type (integer or string)\n"
-"--arp-ptype   [!] type          : ARP protocol type (hexadecimal or string)\n"
-"--arp-ip-src  [!] address[/mask]: ARP IP source specification\n"
-"--arp-ip-dst  [!] address[/mask]: ARP IP target specification\n"
-"--arp-mac-src [!] address[/mask]: ARP MAC source specification\n"
-"--arp-mac-dst [!] address[/mask]: ARP MAC target specification\n"
+"[!] --arp-opcode  opcode        : ARP opcode (integer or string)\n"
+"[!] --arp-htype   type          : ARP hardware type (integer or string)\n"
+"[!] --arp-ptype   type          : ARP protocol type (hexadecimal or string)\n"
+"[!] --arp-ip-src  address[/mask]: ARP IP source specification\n"
+"[!] --arp-ip-dst  address[/mask]: ARP IP target specification\n"
+"[!] --arp-mac-src address[/mask]: ARP MAC source specification\n"
+"[!] --arp-mac-dst address[/mask]: ARP MAC target specification\n"
 "[!] --arp-gratuitous            : ARP gratuitous packet\n"
 " opcode strings: \n");
 	for (i = 0; i < ARRAY_SIZE(opcodes); i++)
@@ -158,51 +158,50 @@ static void brarp_print(const void *ip, const struct xt_entry_match *match, int
 
 	if (arpinfo->bitmask & EBT_ARP_OPCODE) {
 		int opcode = ntohs(arpinfo->opcode);
-		printf("--arp-op ");
+
 		if (arpinfo->invflags & EBT_ARP_OPCODE)
 			printf("! ");
+		printf("--arp-op ");
 		if (opcode > 0 && opcode <= ARRAY_SIZE(opcodes))
 			printf("%s ", opcodes[opcode - 1]);
 		else
 			printf("%d ", opcode);
 	}
 	if (arpinfo->bitmask & EBT_ARP_HTYPE) {
-		printf("--arp-htype ");
 		if (arpinfo->invflags & EBT_ARP_HTYPE)
 			printf("! ");
-		printf("%d ", ntohs(arpinfo->htype));
+		printf("--arp-htype %d ", ntohs(arpinfo->htype));
 	}
 	if (arpinfo->bitmask & EBT_ARP_PTYPE) {
-		printf("--arp-ptype ");
 		if (arpinfo->invflags & EBT_ARP_PTYPE)
 			printf("! ");
-		printf("0x%x ", ntohs(arpinfo->ptype));
+		printf("--arp-ptype 0x%x ", ntohs(arpinfo->ptype));
 	}
 	if (arpinfo->bitmask & EBT_ARP_SRC_IP) {
-		printf("--arp-ip-src ");
 		if (arpinfo->invflags & EBT_ARP_SRC_IP)
 			printf("! ");
-		printf("%s%s ", xtables_ipaddr_to_numeric((const struct in_addr*) &arpinfo->saddr),
-		       xtables_ipmask_to_numeric((const struct in_addr*)&arpinfo->smsk));
+		printf("--arp-ip-src %s%s ",
+		       xtables_ipaddr_to_numeric((void *)&arpinfo->saddr),
+		       xtables_ipmask_to_numeric((void *)&arpinfo->smsk));
 	}
 	if (arpinfo->bitmask & EBT_ARP_DST_IP) {
-		printf("--arp-ip-dst ");
 		if (arpinfo->invflags & EBT_ARP_DST_IP)
 			printf("! ");
-		printf("%s%s ", xtables_ipaddr_to_numeric((const struct in_addr*) &arpinfo->daddr),
-		       xtables_ipmask_to_numeric((const struct in_addr*)&arpinfo->dmsk));
+		printf("--arp-ip-dst %s%s ",
+		       xtables_ipaddr_to_numeric((void *)&arpinfo->daddr),
+		       xtables_ipmask_to_numeric((void *)&arpinfo->dmsk));
 	}
 	if (arpinfo->bitmask & EBT_ARP_SRC_MAC) {
-		printf("--arp-mac-src ");
 		if (arpinfo->invflags & EBT_ARP_SRC_MAC)
 			printf("! ");
+		printf("--arp-mac-src ");
 		xtables_print_mac_and_mask(arpinfo->smaddr, arpinfo->smmsk);
 		printf(" ");
 	}
 	if (arpinfo->bitmask & EBT_ARP_DST_MAC) {
-		printf("--arp-mac-dst ");
 		if (arpinfo->invflags & EBT_ARP_DST_MAC)
 			printf("! ");
+		printf("--arp-mac-dst ");
 		xtables_print_mac_and_mask(arpinfo->dmaddr, arpinfo->dmmsk);
 		printf(" ");
 	}
diff --git a/extensions/libebt_arp.t b/extensions/libebt_arp.t
index c8e874e83c513..ea006f250b5fc 100644
--- a/extensions/libebt_arp.t
+++ b/extensions/libebt_arp.t
@@ -1,22 +1,22 @@
 :INPUT,FORWARD,OUTPUT
 -p ARP --arp-op Request;=;OK
--p ARP --arp-op ! Request;=;OK
+-p ARP ! --arp-op Request;=;OK
 -p ARP --arp-htype Ethernet;-p ARP --arp-htype 1;OK
 -p ARP --arp-htype 1;=;OK
--p ARP --arp-htype ! 1;=;OK
+-p ARP ! --arp-htype 1;=;OK
 -p ARP --arp-ptype 0x2;=;OK
--p ARP --arp-ptype ! 0x2;=;OK
+-p ARP ! --arp-ptype 0x2;=;OK
 -p ARP --arp-ip-src 1.2.3.4;=;OK
--p ARP ! --arp-ip-dst 1.2.3.4;-p ARP --arp-ip-dst ! 1.2.3.4 -j CONTINUE;OK
--p ARP --arp-ip-src ! 0.0.0.0;=;OK
--p ARP --arp-ip-dst ! 0.0.0.0/8;=;OK
--p ARP --arp-ip-src ! 1.2.3.4/32;-p ARP --arp-ip-src ! 1.2.3.4;OK
--p ARP --arp-ip-src ! 1.2.3.4/255.255.255.0;-p ARP --arp-ip-src ! 1.2.3.0/24;OK
--p ARP --arp-ip-src ! 1.2.3.4/255.0.255.255;-p ARP --arp-ip-src ! 1.0.3.4/255.0.255.255;OK
+-p ARP --arp-ip-dst ! 1.2.3.4;-p ARP ! --arp-ip-dst 1.2.3.4 -j CONTINUE;OK
+-p ARP ! --arp-ip-src 0.0.0.0;=;OK
+-p ARP ! --arp-ip-dst 0.0.0.0/8;=;OK
+-p ARP ! --arp-ip-src 1.2.3.4/32;-p ARP ! --arp-ip-src 1.2.3.4;OK
+-p ARP ! --arp-ip-src 1.2.3.4/255.255.255.0;-p ARP ! --arp-ip-src 1.2.3.0/24;OK
+-p ARP ! --arp-ip-src 1.2.3.4/255.0.255.255;-p ARP ! --arp-ip-src 1.0.3.4/255.0.255.255;OK
 -p ARP --arp-mac-src 00:de:ad:be:ef:00;=;OK
--p ARP --arp-mac-src ! 00:de:ad:be:ef:00;=;OK
+-p ARP ! --arp-mac-src 00:de:ad:be:ef:00;=;OK
 -p ARP --arp-mac-dst de:ad:be:ef:00:00/ff:ff:ff:ff:00:00;=;OK
--p ARP --arp-mac-dst ! de:ad:be:ef:00:00/ff:ff:ff:ff:00:00;=;OK
+-p ARP ! --arp-mac-dst de:ad:be:ef:00:00/ff:ff:ff:ff:00:00;=;OK
 -p ARP --arp-gratuitous;=;OK
 -p ARP ! --arp-gratuitous;=;OK
 --arp-htype 1;=;FAIL
diff --git a/extensions/libebt_ip.c b/extensions/libebt_ip.c
index 350dbcb6abb09..3ed852add767a 100644
--- a/extensions/libebt_ip.c
+++ b/extensions/libebt_ip.c
@@ -79,14 +79,14 @@ static void brip_print_help(void)
 {
 	printf(
 "ip options:\n"
-"--ip-src    [!] address[/mask]: ip source specification\n"
-"--ip-dst    [!] address[/mask]: ip destination specification\n"
-"--ip-tos    [!] tos           : ip tos specification\n"
-"--ip-proto  [!] protocol      : ip protocol specification\n"
-"--ip-sport  [!] port[:port]   : tcp/udp source port or port range\n"
-"--ip-dport  [!] port[:port]   : tcp/udp destination port or port range\n"
-"--ip-icmp-type [!] type[[:type]/code[:code]] : icmp type/code or type/code range\n"
-"--ip-igmp-type [!] type[:type]               : igmp type or type range\n");
+"[!] --ip-src    address[/mask]: ip source specification\n"
+"[!] --ip-dst    address[/mask]: ip destination specification\n"
+"[!] --ip-tos    tos           : ip tos specification\n"
+"[!] --ip-proto  protocol      : ip protocol specification\n"
+"[!] --ip-sport  port[:port]   : tcp/udp source port or port range\n"
+"[!] --ip-dport  port[:port]   : tcp/udp destination port or port range\n"
+"[!] --ip-icmp-type type[[:type]/code[:code]] : icmp type/code or type/code range\n"
+"[!] --ip-igmp-type type[:type]               : igmp type or type range\n");
 
 	printf("\nValid ICMP Types:\n");
 	xt_print_icmp_types(icmp_codes, ARRAY_SIZE(icmp_codes));
@@ -182,35 +182,34 @@ static void brip_print(const void *ip, const struct xt_entry_match *match,
 	struct in_addr *addrp, *maskp;
 
 	if (info->bitmask & EBT_IP_SOURCE) {
-		printf("--ip-src ");
 		if (info->invflags & EBT_IP_SOURCE)
 			printf("! ");
 		addrp = (struct in_addr *)&info->saddr;
 		maskp = (struct in_addr *)&info->smsk;
-		printf("%s%s ", xtables_ipaddr_to_numeric(addrp),
+		printf("--ip-src %s%s ",
+		       xtables_ipaddr_to_numeric(addrp),
 		       xtables_ipmask_to_numeric(maskp));
 	}
 	if (info->bitmask & EBT_IP_DEST) {
-		printf("--ip-dst ");
 		if (info->invflags & EBT_IP_DEST)
 			printf("! ");
 		addrp = (struct in_addr *)&info->daddr;
 		maskp = (struct in_addr *)&info->dmsk;
-		printf("%s%s ", xtables_ipaddr_to_numeric(addrp),
+		printf("--ip-dst %s%s ",
+		       xtables_ipaddr_to_numeric(addrp),
 		       xtables_ipmask_to_numeric(maskp));
 	}
 	if (info->bitmask & EBT_IP_TOS) {
-		printf("--ip-tos ");
 		if (info->invflags & EBT_IP_TOS)
 			printf("! ");
-		printf("0x%02X ", info->tos);
+		printf("--ip-tos 0x%02X ", info->tos);
 	}
 	if (info->bitmask & EBT_IP_PROTO) {
 		struct protoent *pe;
 
-		printf("--ip-proto ");
 		if (info->invflags & EBT_IP_PROTO)
 			printf("! ");
+		printf("--ip-proto ");
 		pe = getprotobynumber(info->protocol);
 		if (pe == NULL) {
 			printf("%d ", info->protocol);
@@ -219,28 +218,28 @@ static void brip_print(const void *ip, const struct xt_entry_match *match,
 		}
 	}
 	if (info->bitmask & EBT_IP_SPORT) {
-		printf("--ip-sport ");
 		if (info->invflags & EBT_IP_SPORT)
 			printf("! ");
+		printf("--ip-sport ");
 		print_port_range(info->sport);
 	}
 	if (info->bitmask & EBT_IP_DPORT) {
-		printf("--ip-dport ");
 		if (info->invflags & EBT_IP_DPORT)
 			printf("! ");
+		printf("--ip-dport ");
 		print_port_range(info->dport);
 	}
 	if (info->bitmask & EBT_IP_ICMP) {
-		printf("--ip-icmp-type ");
 		if (info->invflags & EBT_IP_ICMP)
 			printf("! ");
+		printf("--ip-icmp-type ");
 		ebt_print_icmp_type(icmp_codes, ARRAY_SIZE(icmp_codes),
 				    info->icmp_type, info->icmp_code);
 	}
 	if (info->bitmask & EBT_IP_IGMP) {
-		printf("--ip-igmp-type ");
 		if (info->invflags & EBT_IP_IGMP)
 			printf("! ");
+		printf("--ip-igmp-type ");
 		ebt_print_icmp_type(igmp_types, ARRAY_SIZE(igmp_types),
 				    info->igmp_type, NULL);
 	}
diff --git a/extensions/libebt_ip.t b/extensions/libebt_ip.t
index f6012df4c264e..cfe4f54db5f66 100644
--- a/extensions/libebt_ip.t
+++ b/extensions/libebt_ip.t
@@ -1,16 +1,16 @@
 :INPUT,FORWARD,OUTPUT
--p ip --ip-src ! 192.168.0.0/24 -j ACCEPT;-p IPv4 --ip-src ! 192.168.0.0/24 -j ACCEPT;OK
+-p ip ! --ip-src 192.168.0.0/24 -j ACCEPT;-p IPv4 ! --ip-src 192.168.0.0/24 -j ACCEPT;OK
 -p IPv4 --ip-dst 10.0.0.1;=;OK
--p IPv4 --ip-dst ! 10.0.0.1;=;OK
+-p IPv4 ! --ip-dst 10.0.0.1;=;OK
 -p IPv4 --ip-tos 0xFF;=;OK
--p IPv4 --ip-tos ! 0xFF;=;OK
+-p IPv4 ! --ip-tos 0xFF;=;OK
 -p IPv4 --ip-proto tcp --ip-dport 22;=;OK
 -p IPv4 --ip-proto udp --ip-sport 1024:65535;=;OK
 -p IPv4 --ip-proto 253;=;OK
--p IPv4 --ip-proto ! 253;=;OK
+-p IPv4 ! --ip-proto 253;=;OK
 -p IPv4 --ip-proto icmp --ip-icmp-type echo-request;=;OK
 -p IPv4 --ip-proto icmp --ip-icmp-type 1/1;=;OK
--p ip --ip-protocol icmp --ip-icmp-type ! 1:10;-p IPv4 --ip-proto icmp --ip-icmp-type ! 1:10/0:255 -j CONTINUE;OK
+-p ip --ip-protocol icmp ! --ip-icmp-type 1:10;-p IPv4 --ip-proto icmp ! --ip-icmp-type 1:10/0:255 -j CONTINUE;OK
 --ip-proto icmp --ip-icmp-type 1/1;=;FAIL
 ! -p ip --ip-proto icmp --ip-icmp-type 1/1;=;FAIL
 ! -p ip --ip-proto tcp --ip-sport 22 --ip-icmp-type echo-reply;;FAIL
@@ -18,4 +18,4 @@
 ! -p ip --ip-proto tcp --ip-dport 22 --ip-icmp-type echo-reply;;FAIL
 ! -p ip --ip-proto tcp --ip-dport 22 --ip-igmp-type membership-query;;FAIL
 ! -p ip --ip-proto icmp --ip-icmp-type echo-reply --ip-igmp-type membership-query;;FAIL
--p IPv4 --ip-proto icmp --ip-icmp-type ! echo-reply;=;OK
+-p IPv4 --ip-proto icmp ! --ip-icmp-type echo-reply;=;OK
diff --git a/extensions/libebt_ip.txlate b/extensions/libebt_ip.txlate
index 44ce927614b57..712ba3d12c374 100644
--- a/extensions/libebt_ip.txlate
+++ b/extensions/libebt_ip.txlate
@@ -1,4 +1,4 @@
-ebtables-translate -A FORWARD -p ip --ip-src ! 192.168.0.0/24 -j ACCEPT
+ebtables-translate -A FORWARD -p ip ! --ip-src 192.168.0.0/24 -j ACCEPT
 nft 'add rule bridge filter FORWARD ip saddr != 192.168.0.0/24 counter accept'
 
 ebtables-translate -I FORWARD -p ip --ip-dst 10.0.0.1
@@ -22,5 +22,5 @@ nft 'add rule bridge filter FORWARD icmp type 8 counter'
 ebtables-translate -A FORWARD -p ip --ip-proto icmp --ip-icmp-type 1/1
 nft 'add rule bridge filter FORWARD icmp type 1 icmp code 1 counter'
 
-ebtables-translate -A FORWARD -p ip --ip-protocol icmp --ip-icmp-type ! 1:10
+ebtables-translate -A FORWARD -p ip --ip-protocol icmp ! --ip-icmp-type 1:10
 nft 'add rule bridge filter FORWARD icmp type != 1-10 counter'
diff --git a/extensions/libebt_ip6.c b/extensions/libebt_ip6.c
index 0d7403e72589a..247a99eb2672c 100644
--- a/extensions/libebt_ip6.c
+++ b/extensions/libebt_ip6.c
@@ -116,13 +116,13 @@ static void brip6_print_help(void)
 {
 	printf(
 "ip6 options:\n"
-"--ip6-src    [!] address[/mask]: ipv6 source specification\n"
-"--ip6-dst    [!] address[/mask]: ipv6 destination specification\n"
-"--ip6-tclass [!] tclass        : ipv6 traffic class specification\n"
-"--ip6-proto  [!] protocol      : ipv6 protocol specification\n"
-"--ip6-sport  [!] port[:port]   : tcp/udp source port or port range\n"
-"--ip6-dport  [!] port[:port]   : tcp/udp destination port or port range\n"
-"--ip6-icmp-type [!] type[[:type]/code[:code]] : ipv6-icmp type/code or type/code range\n");
+"[!] --ip6-src    address[/mask]: ipv6 source specification\n"
+"[!] --ip6-dst    address[/mask]: ipv6 destination specification\n"
+"[!] --ip6-tclass tclass        : ipv6 traffic class specification\n"
+"[!] --ip6-proto  protocol      : ipv6 protocol specification\n"
+"[!] --ip6-sport  port[:port]   : tcp/udp source port or port range\n"
+"[!] --ip6-dport  port[:port]   : tcp/udp destination port or port range\n"
+"[!] --ip6-icmp-type type[[:type]/code[:code]] : ipv6-icmp type/code or type/code range\n");
 	printf("Valid ICMPv6 Types:");
 	xt_print_icmp_types(icmpv6_codes, ARRAY_SIZE(icmpv6_codes));
 }
@@ -173,31 +173,30 @@ static void brip6_print(const void *ip, const struct xt_entry_match *match,
 	struct ebt_ip6_info *ipinfo = (struct ebt_ip6_info *)match->data;
 
 	if (ipinfo->bitmask & EBT_IP6_SOURCE) {
-		printf("--ip6-src ");
 		if (ipinfo->invflags & EBT_IP6_SOURCE)
 			printf("! ");
+		printf("--ip6-src ");
 		printf("%s", xtables_ip6addr_to_numeric(&ipinfo->saddr));
 		printf("%s ", xtables_ip6mask_to_numeric(&ipinfo->smsk));
 	}
 	if (ipinfo->bitmask & EBT_IP6_DEST) {
-		printf("--ip6-dst ");
 		if (ipinfo->invflags & EBT_IP6_DEST)
 			printf("! ");
+		printf("--ip6-dst ");
 		printf("%s", xtables_ip6addr_to_numeric(&ipinfo->daddr));
 		printf("%s ", xtables_ip6mask_to_numeric(&ipinfo->dmsk));
 	}
 	if (ipinfo->bitmask & EBT_IP6_TCLASS) {
-		printf("--ip6-tclass ");
 		if (ipinfo->invflags & EBT_IP6_TCLASS)
 			printf("! ");
-		printf("0x%02X ", ipinfo->tclass);
+		printf("--ip6-tclass 0x%02X ", ipinfo->tclass);
 	}
 	if (ipinfo->bitmask & EBT_IP6_PROTO) {
 		struct protoent *pe;
 
-		printf("--ip6-proto ");
 		if (ipinfo->invflags & EBT_IP6_PROTO)
 			printf("! ");
+		printf("--ip6-proto ");
 		pe = getprotobynumber(ipinfo->protocol);
 		if (pe == NULL) {
 			printf("%d ", ipinfo->protocol);
@@ -206,21 +205,21 @@ static void brip6_print(const void *ip, const struct xt_entry_match *match,
 		}
 	}
 	if (ipinfo->bitmask & EBT_IP6_SPORT) {
-		printf("--ip6-sport ");
 		if (ipinfo->invflags & EBT_IP6_SPORT)
 			printf("! ");
+		printf("--ip6-sport ");
 		print_port_range(ipinfo->sport);
 	}
 	if (ipinfo->bitmask & EBT_IP6_DPORT) {
-		printf("--ip6-dport ");
 		if (ipinfo->invflags & EBT_IP6_DPORT)
 			printf("! ");
+		printf("--ip6-dport ");
 		print_port_range(ipinfo->dport);
 	}
 	if (ipinfo->bitmask & EBT_IP6_ICMP6) {
-		printf("--ip6-icmp-type ");
 		if (ipinfo->invflags & EBT_IP6_ICMP6)
 			printf("! ");
+		printf("--ip6-icmp-type ");
 		print_icmp_type(ipinfo->icmpv6_type, ipinfo->icmpv6_code);
 	}
 }
diff --git a/extensions/libebt_ip6.t b/extensions/libebt_ip6.t
index 19358431d7ca0..58e3c73c99409 100644
--- a/extensions/libebt_ip6.t
+++ b/extensions/libebt_ip6.t
@@ -1,22 +1,22 @@
 :INPUT,FORWARD,OUTPUT
--p ip6 --ip6-src ! dead::beef/64 -j ACCEPT;-p IPv6 --ip6-src ! dead::/64 -j ACCEPT;OK
+-p ip6 ! --ip6-src dead::beef/64 -j ACCEPT;-p IPv6 ! --ip6-src dead::/64 -j ACCEPT;OK
 -p IPv6 --ip6-dst dead:beef::/64 -j ACCEPT;=;OK
 -p IPv6 --ip6-dst f00:ba::;=;OK
--p IPv6 --ip6-dst ! f00:ba::;=;OK
+-p IPv6 ! --ip6-dst f00:ba::;=;OK
 -p IPv6 --ip6-src 10.0.0.1;;FAIL
 -p IPv6 --ip6-tclass 0xFF;=;OK
--p IPv6 --ip6-tclass ! 0xFF;=;OK
+-p IPv6 ! --ip6-tclass 0xFF;=;OK
 -p IPv6 --ip6-proto tcp --ip6-dport 22;=;OK
--p IPv6 --ip6-proto tcp --ip6-dport ! 22;=;OK
--p IPv6 --ip6-proto tcp --ip6-sport ! 22 --ip6-dport 22;=;OK
+-p IPv6 --ip6-proto tcp ! --ip6-dport 22;=;OK
+-p IPv6 --ip6-proto tcp ! --ip6-sport 22 --ip6-dport 22;=;OK
 -p IPv6 --ip6-proto udp --ip6-sport 1024:65535;=;OK
 -p IPv6 --ip6-proto 253;=;OK
--p IPv6 --ip6-proto ! 253;=;OK
+-p IPv6 ! --ip6-proto 253;=;OK
 -p IPv6 --ip6-proto ipv6-icmp --ip6-icmp-type echo-request -j CONTINUE;=;OK
 -p IPv6 --ip6-proto ipv6-icmp --ip6-icmp-type echo-request;=;OK
--p IPv6 --ip6-proto ipv6-icmp --ip6-icmp-type ! echo-request;=;OK
+-p IPv6 --ip6-proto ipv6-icmp ! --ip6-icmp-type echo-request;=;OK
 -p ip6 --ip6-protocol icmpv6 --ip6-icmp-type 1/1;-p IPv6 --ip6-proto ipv6-icmp --ip6-icmp-type communication-prohibited -j CONTINUE;OK
--p IPv6 --ip6-proto ipv6-icmp --ip6-icmp-type ! 1:10/0:255;=;OK
+-p IPv6 --ip6-proto ipv6-icmp ! --ip6-icmp-type 1:10/0:255;=;OK
 --ip6-proto ipv6-icmp ! --ip6-icmp-type 1:10/0:255;=;FAIL
 ! -p IPv6 --ip6-proto ipv6-icmp ! --ip6-icmp-type 1:10/0:255;=;FAIL
 -p IPv6 --ip6-proto tcp --ip6-sport 22 --ip6-icmp-type echo-request;;FAIL
diff --git a/extensions/libebt_ip6.txlate b/extensions/libebt_ip6.txlate
index 0debbe1255099..13d57e3a67d05 100644
--- a/extensions/libebt_ip6.txlate
+++ b/extensions/libebt_ip6.txlate
@@ -25,5 +25,5 @@ nft 'add rule bridge filter FORWARD icmpv6 type 128 counter'
 ebtables-translate -A FORWARD -p ip6 --ip6-protocol icmpv6  --ip6-icmp-type 1/1
 nft 'add rule bridge filter FORWARD icmpv6 type 1 icmpv6 code 1 counter'
 
-ebtables-translate -A FORWARD -p ip6 --ip6-protocol icmpv6 --ip6-icmp-type ! 1:10
+ebtables-translate -A FORWARD -p ip6 --ip6-protocol icmpv6 ! --ip6-icmp-type 1:10
 nft 'add rule bridge filter FORWARD icmpv6 type != 1-10 counter'
diff --git a/extensions/libebt_mark_m.c b/extensions/libebt_mark_m.c
index f17fe99ab18ef..8ee172072823c 100644
--- a/extensions/libebt_mark_m.c
+++ b/extensions/libebt_mark_m.c
@@ -29,7 +29,7 @@ static void brmark_m_print_help(void)
 {
 	printf(
 "mark option:\n"
-"--mark    [!] [value][/mask]: Match nfmask value (see man page)\n");
+"[!] --mark    [value][/mask]: Match nfmask value (see man page)\n");
 }
 
 static void brmark_m_parse(struct xt_option_call *cb)
@@ -63,9 +63,9 @@ static void brmark_m_print(const void *ip, const struct xt_entry_match *match,
 {
 	struct ebt_mark_m_info *info = (struct ebt_mark_m_info *)match->data;
 
-	printf("--mark ");
 	if (info->invert)
 		printf("! ");
+	printf("--mark ");
 	if (info->bitmask == EBT_MARK_OR)
 		printf("/0x%lx ", info->mask);
 	else if (info->mask != 0xffffffff)
diff --git a/extensions/libebt_mark_m.t b/extensions/libebt_mark_m.t
index 00035427f8b6e..4de72bde32342 100644
--- a/extensions/libebt_mark_m.t
+++ b/extensions/libebt_mark_m.t
@@ -1,6 +1,6 @@
 :INPUT,FORWARD,OUTPUT
 --mark 42;--mark 0x2a;OK
---mark ! 42;--mark ! 0x2a;OK
+! --mark 42;! --mark 0x2a;OK
 --mark 42/0xff;--mark 0x2a/0xff;OK
---mark ! 0x1/0xff;=;OK
+! --mark 0x1/0xff;=;OK
 --mark /0x2;=;OK
diff --git a/extensions/libebt_mark_m.txlate b/extensions/libebt_mark_m.txlate
index 2981a5647bd8e..9061adbf81edd 100644
--- a/extensions/libebt_mark_m.txlate
+++ b/extensions/libebt_mark_m.txlate
@@ -7,7 +7,7 @@ nft 'add rule bridge filter INPUT meta mark != 0x2a counter'
 ebtables-translate -A INPUT --mark ! 42
 nft 'add rule bridge filter INPUT meta mark != 0x2a counter'
 
-ebtables-translate -A INPUT --mark ! 0x1/0xff
+ebtables-translate -A INPUT ! --mark 0x1/0xff
 nft 'add rule bridge filter INPUT meta mark and 0xff != 0x1 counter'
 
 ebtables-translate -A INPUT --mark /0x02
diff --git a/extensions/libebt_pkttype.c b/extensions/libebt_pkttype.c
index b01b83a1f1f45..579e8fdb69daf 100644
--- a/extensions/libebt_pkttype.c
+++ b/extensions/libebt_pkttype.c
@@ -38,7 +38,7 @@ static void brpkttype_print_help(void)
 {
 	printf(
 "pkttype options:\n"
-"--pkttype-type    [!] type: class the packet belongs to\n"
+"[!] --pkttype-type    type: class the packet belongs to\n"
 "Possible values: broadcast, multicast, host, otherhost, or any other byte value (which would be pretty useless).\n");
 }
 
@@ -76,7 +76,7 @@ static void brpkttype_print(const void *ip, const struct xt_entry_match *match,
 {
 	struct ebt_pkttype_info *pt = (struct ebt_pkttype_info *)match->data;
 
-	printf("--pkttype-type %s", pt->invert ? "! " : "");
+	printf("%s--pkttype-type ", pt->invert ? "! " : "");
 
 	if (pt->pkt_type < ARRAY_SIZE(classes))
 		printf("%s ", classes[pt->pkt_type]);
diff --git a/extensions/libebt_pkttype.t b/extensions/libebt_pkttype.t
index e3b95ded4903e..f3cdc19d6f08f 100644
--- a/extensions/libebt_pkttype.t
+++ b/extensions/libebt_pkttype.t
@@ -1,14 +1,14 @@
 :INPUT,FORWARD,OUTPUT
-! --pkttype-type host;--pkttype-type ! host -j CONTINUE;OK
+--pkttype-type ! host;! --pkttype-type host -j CONTINUE;OK
 --pkttype-type host;=;OK
---pkttype-type ! host;=;OK
+! --pkttype-type host;=;OK
 --pkttype-type broadcast;=;OK
---pkttype-type ! broadcast;=;OK
+! --pkttype-type broadcast;=;OK
 --pkttype-type multicast;=;OK
---pkttype-type ! multicast;=;OK
+! --pkttype-type multicast;=;OK
 --pkttype-type otherhost;=;OK
---pkttype-type ! otherhost;=;OK
+! --pkttype-type otherhost;=;OK
 --pkttype-type outgoing;=;OK
---pkttype-type ! outgoing;=;OK
+! --pkttype-type outgoing;=;OK
 --pkttype-type loopback;=;OK
---pkttype-type ! loopback;=;OK
+! --pkttype-type loopback;=;OK
diff --git a/extensions/libebt_standard.t b/extensions/libebt_standard.t
index 370a12f4a2cec..3f1a459cb9814 100644
--- a/extensions/libebt_standard.t
+++ b/extensions/libebt_standard.t
@@ -6,7 +6,8 @@
 -d de:ad:be:ef:00:00 -j CONTINUE;=;OK
 -d de:ad:be:ef:0:00/ff:ff:ff:ff:0:0 -j DROP;-d de:ad:be:ef:00:00/ff:ff:ff:ff:00:00 -j DROP;OK
 -p ARP -j ACCEPT;=;OK
--p ! ARP -j ACCEPT;=;OK
+! -p ARP -j ACCEPT;=;OK
+-p ! ARP -j ACCEPT;! -p ARP -j ACCEPT;OK
 -p 0 -j ACCEPT;=;FAIL
 -p ! 0 -j ACCEPT;=;FAIL
 :INPUT
diff --git a/extensions/libebt_stp.c b/extensions/libebt_stp.c
index 9b372d1d4351a..81054b26c1f0f 100644
--- a/extensions/libebt_stp.c
+++ b/extensions/libebt_stp.c
@@ -63,18 +63,18 @@ static void brstp_print_help(void)
 {
 	printf(
 "stp options:\n"
-"--stp-type type                  : BPDU type\n"
-"--stp-flags flag                 : control flag\n"
-"--stp-root-prio prio[:prio]      : root priority (16-bit) range\n"
-"--stp-root-addr address[/mask]   : MAC address of root\n"
-"--stp-root-cost cost[:cost]      : root cost (32-bit) range\n"
-"--stp-sender-prio prio[:prio]    : sender priority (16-bit) range\n"
-"--stp-sender-addr address[/mask] : MAC address of sender\n"
-"--stp-port port[:port]           : port id (16-bit) range\n"
-"--stp-msg-age age[:age]          : message age timer (16-bit) range\n"
-"--stp-max-age age[:age]          : maximum age timer (16-bit) range\n"
-"--stp-hello-time time[:time]     : hello time timer (16-bit) range\n"
-"--stp-forward-delay delay[:delay]: forward delay timer (16-bit) range\n"
+"[!] --stp-type type                  : BPDU type\n"
+"[!] --stp-flags flag                 : control flag\n"
+"[!] --stp-root-prio prio[:prio]      : root priority (16-bit) range\n"
+"[!] --stp-root-addr address[/mask]   : MAC address of root\n"
+"[!] --stp-root-cost cost[:cost]      : root cost (32-bit) range\n"
+"[!] --stp-sender-prio prio[:prio]    : sender priority (16-bit) range\n"
+"[!] --stp-sender-addr address[/mask] : MAC address of sender\n"
+"[!] --stp-port port[:port]           : port id (16-bit) range\n"
+"[!] --stp-msg-age age[:age]          : message age timer (16-bit) range\n"
+"[!] --stp-max-age age[:age]          : maximum age timer (16-bit) range\n"
+"[!] --stp-hello-time time[:time]     : hello time timer (16-bit) range\n"
+"[!] --stp-forward-delay delay[:delay]: forward delay timer (16-bit) range\n"
 " Recognized BPDU type strings:\n"
 "   \"config\": configuration BPDU (=0)\n"
 "   \"tcn\"   : topology change notification BPDU (=0x80)\n"
@@ -184,8 +184,9 @@ static void brstp_print(const void *ip, const struct xt_entry_match *match,
 	for (i = 0; (1 << i) < EBT_STP_MASK; i++) {
 		if (!(stpinfo->bitmask & (1 << i)))
 			continue;
-		printf("--%s %s", brstp_opts[i].name,
-		       (stpinfo->invflags & (1 << i)) ? "! " : "");
+		printf("%s--%s ",
+		       (stpinfo->invflags & (1 << i)) ? "! " : "",
+		       brstp_opts[i].name);
 		if (EBT_STP_TYPE == (1 << i)) {
 			if (stpinfo->type == BPDU_TYPE_CONFIG)
 				printf("%s", BPDU_TYPE_CONFIG_STRING);
diff --git a/extensions/libebt_stp.t b/extensions/libebt_stp.t
index b3c7e5f3aa8f3..06df607379f2a 100644
--- a/extensions/libebt_stp.t
+++ b/extensions/libebt_stp.t
@@ -1,29 +1,29 @@
 :INPUT,FORWARD,OUTPUT
 --stp-type 1;=;OK
---stp-type ! 1;=;OK
+! --stp-type 1;=;OK
 --stp-flags 0x1;--stp-flags topology-change -j CONTINUE;OK
---stp-flags ! topology-change;=;OK
+! --stp-flags topology-change;=;OK
 --stp-root-prio 1 -j ACCEPT;=;OK
---stp-root-prio ! 1 -j ACCEPT;=;OK
+! --stp-root-prio 1 -j ACCEPT;=;OK
 --stp-root-addr 0d:ea:d0:0b:ee:f0;=;OK
---stp-root-addr ! 0d:ea:d0:0b:ee:f0;=;OK
+! --stp-root-addr 0d:ea:d0:0b:ee:f0;=;OK
 --stp-root-addr 0d:ea:d0:00:00:00/ff:ff:ff:00:00:00;=;OK
---stp-root-addr ! 0d:ea:d0:00:00:00/ff:ff:ff:00:00:00;=;OK
+! --stp-root-addr 0d:ea:d0:00:00:00/ff:ff:ff:00:00:00;=;OK
 --stp-root-cost 1;=;OK
---stp-root-cost ! 1;=;OK
+! --stp-root-cost 1;=;OK
 --stp-sender-prio 1;=;OK
---stp-sender-prio ! 1;=;OK
+! --stp-sender-prio 1;=;OK
 --stp-sender-addr de:ad:be:ef:00:00;=;OK
---stp-sender-addr ! de:ad:be:ef:00:00;=;OK
+! --stp-sender-addr de:ad:be:ef:00:00;=;OK
 --stp-sender-addr de:ad:be:ef:00:00/ff:ff:ff:ff:00:00;=;OK
---stp-sender-addr ! de:ad:be:ef:00:00/ff:ff:ff:ff:00:00;=;OK
+! --stp-sender-addr de:ad:be:ef:00:00/ff:ff:ff:ff:00:00;=;OK
 --stp-port 1;=;OK
---stp-port ! 1;=;OK
+! --stp-port 1;=;OK
 --stp-msg-age 1;=;OK
---stp-msg-age ! 1;=;OK
+! --stp-msg-age 1;=;OK
 --stp-max-age 1;=;OK
---stp-max-age ! 1;=;OK
+! --stp-max-age 1;=;OK
 --stp-hello-time 1;=;OK
---stp-hello-time ! 1;=;OK
+! --stp-hello-time 1;=;OK
 --stp-forward-delay 1;=;OK
---stp-forward-delay ! 1;=;OK
+! --stp-forward-delay 1;=;OK
diff --git a/extensions/libebt_vlan.c b/extensions/libebt_vlan.c
index 7f5aa8cd474d6..b9f6c519e3cff 100644
--- a/extensions/libebt_vlan.c
+++ b/extensions/libebt_vlan.c
@@ -34,9 +34,9 @@ static void brvlan_print_help(void)
 {
 	printf(
 "vlan options:\n"
-"--vlan-id [!] id       : vlan-tagged frame identifier, 0,1-4096 (integer)\n"
-"--vlan-prio [!] prio   : Priority-tagged frame's user priority, 0-7 (integer)\n"
-"--vlan-encap [!] encap : Encapsulated frame protocol (hexadecimal or name)\n");
+"[!] --vlan-id id       : vlan-tagged frame identifier, 0,1-4096 (integer)\n"
+"[!] --vlan-prio prio   : Priority-tagged frame's user priority, 0-7 (integer)\n"
+"[!] --vlan-encap encap : Encapsulated frame protocol (hexadecimal or name)\n");
 }
 
 static void brvlan_parse(struct xt_option_call *cb)
@@ -75,14 +75,19 @@ static void brvlan_print(const void *ip, const struct xt_entry_match *match,
 	struct ebt_vlan_info *vlaninfo = (struct ebt_vlan_info *) match->data;
 
 	if (vlaninfo->bitmask & EBT_VLAN_ID) {
-		printf("--vlan-id %s%d ", (vlaninfo->invflags & EBT_VLAN_ID) ? "! " : "", vlaninfo->id);
+		printf("%s--vlan-id %d ",
+		       (vlaninfo->invflags & EBT_VLAN_ID) ? "! " : "",
+		       vlaninfo->id);
 	}
 	if (vlaninfo->bitmask & EBT_VLAN_PRIO) {
-		printf("--vlan-prio %s%d ", (vlaninfo->invflags & EBT_VLAN_PRIO) ? "! " : "", vlaninfo->prio);
+		printf("%s--vlan-prio %d ",
+		       (vlaninfo->invflags & EBT_VLAN_PRIO) ? "! " : "",
+		       vlaninfo->prio);
 	}
 	if (vlaninfo->bitmask & EBT_VLAN_ENCAP) {
-		printf("--vlan-encap %s", (vlaninfo->invflags & EBT_VLAN_ENCAP) ? "! " : "");
-		printf("%4.4X ", ntohs(vlaninfo->encap));
+		printf("%s--vlan-encap %4.4X ",
+		       (vlaninfo->invflags & EBT_VLAN_ENCAP) ? "! " : "",
+		       ntohs(vlaninfo->encap));
 	}
 }
 
diff --git a/extensions/libebt_vlan.t b/extensions/libebt_vlan.t
index 3ec0559953331..e009ad71a9548 100644
--- a/extensions/libebt_vlan.t
+++ b/extensions/libebt_vlan.t
@@ -1,13 +1,13 @@
 :INPUT,FORWARD,OUTPUT
 -p 802_1Q --vlan-id 42;=;OK
--p 802_1Q --vlan-id ! 42;=;OK
+-p 802_1Q ! --vlan-id 42;=;OK
 -p 802_1Q --vlan-prio 1;=;OK
--p 802_1Q --vlan-prio ! 1;=;OK
+-p 802_1Q ! --vlan-prio 1;=;OK
 -p 802_1Q --vlan-encap ip;-p 802_1Q --vlan-encap 0800 -j CONTINUE;OK
 -p 802_1Q --vlan-encap 0800;=;OK
--p 802_1Q --vlan-encap ! 0800;=;OK
--p 802_1Q --vlan-encap IPv6 ! --vlan-id 1;-p 802_1Q --vlan-id ! 1 --vlan-encap 86DD -j CONTINUE;OK
--p 802_1Q --vlan-id ! 1 --vlan-encap 86DD;=;OK
+-p 802_1Q ! --vlan-encap 0800;=;OK
+-p 802_1Q --vlan-encap IPv6 --vlan-id ! 1;-p 802_1Q ! --vlan-id 1 --vlan-encap 86DD -j CONTINUE;OK
+-p 802_1Q ! --vlan-id 1 --vlan-encap 86DD;=;OK
 --vlan-encap ip;=;FAIL
 --vlan-id 2;=;FAIL
 --vlan-prio 1;=;FAIL
diff --git a/extensions/libebt_vlan.txlate b/extensions/libebt_vlan.txlate
index 5d21e3eba0dca..6e12e2d024bde 100644
--- a/extensions/libebt_vlan.txlate
+++ b/extensions/libebt_vlan.txlate
@@ -1,7 +1,7 @@
 ebtables-translate -A INPUT -p 802_1Q --vlan-id 42
 nft 'add rule bridge filter INPUT vlan id 42 counter'
 
-ebtables-translate -A INPUT -p 802_1Q --vlan-prio ! 1
+ebtables-translate -A INPUT -p 802_1Q ! --vlan-prio 1
 nft 'add rule bridge filter INPUT vlan pcp != 1 counter'
 
 ebtables-translate -A INPUT -p 802_1Q --vlan-encap ip
diff --git a/iptables/ebtables-nft.8 b/iptables/ebtables-nft.8
index 301f2f1f9178a..29c7d9faf8106 100644
--- a/iptables/ebtables-nft.8
+++ b/iptables/ebtables-nft.8
@@ -372,7 +372,7 @@ and the
 .BR "WATCHER EXTENSIONS" 
 below.
 .TP
-.BR "-p, --protocol " "[!] \fIprotocol\fP"
+.RB [ ! ] " -p" , " --protocol " \fIprotocol\fP
 The protocol that was responsible for creating the frame. This can be a
 hexadecimal number, above 
 .IR 0x0600 ,
@@ -402,7 +402,7 @@ See that file for more information. The flag
 .B --proto
 is an alias for this option.
 .TP 
-.BR "-i, --in-interface " "[!] \fIname\fP"
+.RB [ ! ] " -i" , " --in-interface " \fIname\fP
 The interface (bridge port) via which a frame is received (this option is useful in the
 .BR INPUT ,
 .BR FORWARD ,
@@ -413,7 +413,7 @@ The flag
 .B --in-if
 is an alias for this option.
 .TP
-.BR "--logical-in " "[!] \fIname\fP"
+.RB [ ! ] " --logical-in " \fIname\fP
 The (logical) bridge interface via which a frame is received (this option is useful in the
 .BR INPUT ,
 .BR FORWARD ,
@@ -422,7 +422,7 @@ chains).
 If the interface name ends with '+', then
 any interface name that begins with this name (disregarding '+') will match.
 .TP
-.BR "-o, --out-interface " "[!] \fIname\fP"
+.RB [ ! ] " -o" , " --out-interface " \fIname\fP
 The interface (bridge port) via which a frame is going to be sent (this option is useful in the
 .BR OUTPUT ,
 .B FORWARD
@@ -434,7 +434,7 @@ The flag
 .B --out-if
 is an alias for this option.
 .TP
-.BR "--logical-out " "[!] \fIname\fP"
+.RB [ ! ] " --logical-out " \fIname\fP
 The (logical) bridge interface via which a frame is going to be sent (this option
 is useful in the
 .BR OUTPUT ,
@@ -445,7 +445,7 @@ chains).
 If the interface name ends with '+', then
 any interface name that begins with this name (disregarding '+') will match.
 .TP
-.BR "-s, --source " "[!] \fIaddress\fP[/\fImask\fP]"
+.RB [ ! ] " -s" , " --source " \fIaddress\fP[ / \fImask\fP]
 The source MAC address. Both mask and address are written as 6 hexadecimal
 numbers separated by colons. Alternatively one can specify Unicast,
 Multicast, Broadcast or BGA (Bridge Group Address):
@@ -459,7 +459,7 @@ address will also match the multicast specification. The flag
 .B --src
 is an alias for this option.
 .TP
-.BR "-d, --destination " "[!] \fIaddress\fP[/\fImask\fP]"
+.RB [ ! ] " -d" , " --destination " \fIaddress\fP[ / \fImask\fP]
 The destination MAC address. See
 .B -s
 (above) for more details on MAC addresses. The flag
@@ -484,11 +484,11 @@ the core ebtables code.
 Specify 802.3 DSAP/SSAP fields or SNAP type.  The protocol must be specified as
 .IR "LENGTH " "(see the option " " -p " above).
 .TP
-.BR "--802_3-sap " "[!] \fIsap\fP"
+.RB [ ! ] " --802_3-sap " \fIsap\fP
 DSAP and SSAP are two one byte 802.3 fields.  The bytes are always
 equal, so only one byte (hexadecimal) is needed as an argument.
 .TP
-.BR "--802_3-type " "[!] \fItype\fP"
+.RB [ ! ] " --802_3-type " \fItype\fP
 If the 802.3 DSAP and SSAP values are 0xaa then the SNAP type field must
 be consulted to determine the payload protocol.  This is a two byte
 (hexadecimal) argument.  Only 802.3 frames with DSAP/SSAP 0xaa are
@@ -503,88 +503,88 @@ the MAC address is optional. Multiple MAC/IP address pairs with the same MAC add
 but different IP address (and vice versa) can be specified. If the MAC address doesn't
 match any entry from the list, the frame doesn't match the rule (unless "!" was used).
 .TP
-.BR "--among-dst " "[!] \fIlist\fP"
+.RB [ ! ] " --among-dst " \fIlist\fP
 Compare the MAC destination to the given list. If the Ethernet frame has type
 .IR IPv4 " or " ARP ,
 then comparison with MAC/IP destination address pairs from the
 list is possible.
 .TP
-.BR "--among-src " "[!] \fIlist\fP"
+.RB [ ! ] " --among-src " \fIlist\fP
 Compare the MAC source to the given list. If the Ethernet frame has type
 .IR IPv4 " or " ARP ,
 then comparison with MAC/IP source address pairs from the list
 is possible.
 .TP
-.BR "--among-dst-file " "[!] \fIfile\fP"
+.RB [ ! ] " --among-dst-file " \fIfile\fP
 Same as
 .BR --among-dst " but the list is read in from the specified file."
 .TP
-.BR "--among-src-file " "[!] \fIfile\fP"
+.RB [ ! ] " --among-src-file " \fIfile\fP
 Same as
 .BR --among-src " but the list is read in from the specified file."
 .SS arp
 Specify (R)ARP fields. The protocol must be specified as
 .IR ARP " or " RARP .
 .TP
-.BR "--arp-opcode " "[!] \fIopcode\fP"
+.RB [ ! ] " --arp-opcode " \fIopcode\fP
 The (R)ARP opcode (decimal or a string, for more details see
 .BR "ebtables -h arp" ).
 .TP
-.BR "--arp-htype " "[!] \fIhardware type\fP"
+.RB [ ! ] " --arp-htype " \fIhardware-type\fP
 The hardware type, this can be a decimal or the string
 .I Ethernet
 (which sets
 .I type
 to 1). Most (R)ARP packets have Eternet as hardware type.
 .TP
-.BR "--arp-ptype " "[!] \fIprotocol type\fP"
+.RB [ ! ] " --arp-ptype " \fIprotocol-type\fP
 The protocol type for which the (r)arp is used (hexadecimal or the string
 .IR IPv4 ,
 denoting 0x0800).
 Most (R)ARP packets have protocol type IPv4.
 .TP
-.BR "--arp-ip-src " "[!] \fIaddress\fP[/\fImask\fP]"
+.RB [ ! ] " --arp-ip-src " \fIaddress\fP[ / \fImask\fP]
 The (R)ARP IP source address specification.
 .TP
-.BR "--arp-ip-dst " "[!] \fIaddress\fP[/\fImask\fP]"
+.RB [ ! ] " --arp-ip-dst " \fIaddress\fP[ / \fImask\fP]
 The (R)ARP IP destination address specification.
 .TP
-.BR "--arp-mac-src " "[!] \fIaddress\fP[/\fImask\fP]"
+.RB [ ! ] " --arp-mac-src " \fIaddress\fP[ / \fImask\fP]
 The (R)ARP MAC source address specification.
 .TP
-.BR "--arp-mac-dst " "[!] \fIaddress\fP[/\fImask\fP]"
+.RB [ ! ] " --arp-mac-dst " \fIaddress\fP[ / \fImask\fP]
 The (R)ARP MAC destination address specification.
 .TP
-.BR "" "[!]" " --arp-gratuitous"
+.RB [ ! ] " --arp-gratuitous"
 Checks for ARP gratuitous packets: checks equality of IPv4 source
 address and IPv4 destination address inside the ARP header.
 .SS ip
 Specify IPv4 fields. The protocol must be specified as
 .IR IPv4 .
 .TP
-.BR "--ip-source " "[!] \fIaddress\fP[/\fImask\fP]"
+.RB [ ! ] " --ip-source " \fIaddress\fP[ / \fImask\fP]
 The source IP address.
 The flag
 .B --ip-src
 is an alias for this option.
 .TP
-.BR "--ip-destination " "[!] \fIaddress\fP[/\fImask\fP]"
+.RB [ ! ] " --ip-destination " \fIaddress\fP[ / \fImask\fP]
 The destination IP address.
 The flag
 .B --ip-dst
 is an alias for this option.
 .TP
-.BR "--ip-tos " "[!] \fItos\fP"
+.RB [ ! ] " --ip-tos " \fItos\fP
 The IP type of service, in hexadecimal numbers.
 .BR IPv4 .
 .TP
-.BR "--ip-protocol " "[!] \fIprotocol\fP"
+.RB [ ! ] " --ip-protocol " \fIprotocol\fP
 The IP protocol.
 The flag
 .B --ip-proto
 is an alias for this option.
 .TP
-.BR "--ip-source-port " "[!] \fIport1\fP[:\fIport2\fP]"
+.RB [ ! ] " --ip-source-port " \fIport1\fP[ : \fIport2\fP]
 The source port or port range for the IP protocols 6 (TCP), 17
 (UDP), 33 (DCCP) or 132 (SCTP). The
 .B --ip-protocol
@@ -596,7 +596,7 @@ The flag
 .B --ip-sport
 is an alias for this option.
 .TP
-.BR "--ip-destination-port " "[!] \fIport1\fP[:\fIport2\fP]"
+.RB [ ! ] " --ip-destination-port " \fIport1\fP[ : \fIport2\fP]
 The destination port or port range for ip protocols 6 (TCP), 17
 (UDP), 33 (DCCP) or 132 (SCTP). The
 .B --ip-protocol
@@ -611,28 +611,28 @@ is an alias for this option.
 Specify IPv6 fields. The protocol must be specified as
 .IR IPv6 .
 .TP
-.BR "--ip6-source " "[!] \fIaddress\fP[/\fImask\fP]"
+.RB [ ! ] " --ip6-source " \fIaddress\fP[ / \fImask\fP]
 The source IPv6 address.
 The flag
 .B --ip6-src
 is an alias for this option.
 .TP
-.BR "--ip6-destination " "[!] \fIaddress\fP[/\fImask\fP]"
+.RB [ ! ] " --ip6-destination " \fIaddress\fP[ / \fImask\fP]
 The destination IPv6 address.
 The flag
 .B --ip6-dst
 is an alias for this option.
 .TP
-.BR "--ip6-tclass " "[!] \fItclass\fP"
+.RB [ ! ] " --ip6-tclass " \fItclass\fP
 The IPv6 traffic class, in hexadecimal numbers.
 .TP
-.BR "--ip6-protocol " "[!] \fIprotocol\fP"
+.RB [ ! ] " --ip6-protocol " \fIprotocol\fP
 The IP protocol.
 The flag
 .B --ip6-proto
 is an alias for this option.
 .TP
-.BR "--ip6-source-port " "[!] \fIport1\fP[:\fIport2\fP]"
+.RB [ ! ] " --ip6-source-port " \fIport1\fP[ : \fIport2\fP]
 The source port or port range for the IPv6 protocols 6 (TCP), 17
 (UDP), 33 (DCCP) or 132 (SCTP). The
 .B --ip6-protocol
@@ -644,7 +644,7 @@ The flag
 .B --ip6-sport
 is an alias for this option.
 .TP
-.BR "--ip6-destination-port " "[!] \fIport1\fP[:\fIport2\fP]"
+.RB [ ! ] " --ip6-destination-port " \fIport1\fP[ : \fIport2\fP]
 The destination port or port range for IPv6 protocols 6 (TCP), 17
 (UDP), 33 (DCCP) or 132 (SCTP). The
 .B --ip6-protocol
@@ -656,7 +656,7 @@ The flag
 .B --ip6-dport
 is an alias for this option.
 .TP
-.BR "--ip6-icmp-type " "[!] {\fItype\fP[:\fItype\fP]/\fIcode\fP[:\fIcode\fP]|\fItypename\fP}"
+.RB [ ! ] " --ip6-icmp-type " {\fItype\fP[ : \fItype\fP] / \fIcode\fP[ : \fIcode\fP]|\fItypename\fP}
 Specify ipv6\-icmp type and code to match.
 Ranges for both type and code are supported. Type and code are
 separated by a slash. Valid numbers for type and range are 0 to 255.
@@ -685,7 +685,7 @@ number; the default is
 .IR 5 .
 .SS mark_m
 .TP
-.BR "--mark " "[!] [\fIvalue\fP][/\fImask\fP]"
+.RB [ ! ] " --mark " [\fIvalue\fP][ / \fImask\fP]
 Matches frames with the given unsigned mark value. If a
 .IR value " and " mask " are specified, the logical AND of the mark value of the frame and"
 the user-specified
@@ -704,7 +704,7 @@ non-zero. Only specifying a
 .IR mask " is useful to match multiple mark values."
 .SS pkttype
 .TP
-.BR "--pkttype-type " "[!] \fItype\fP"
+.RB [ ! ] " --pkttype-type " \fItype\fP
 Matches on the Ethernet "class" of the frame, which is determined by the
 generic networking code. Possible values:
 .IR broadcast " (MAC destination is the broadcast address),"
@@ -721,46 +721,46 @@ if the lower bound is omitted (but the colon is not), then the lowest possible l
 for that option is used, while if the upper bound is omitted (but the colon again is not), the
 highest possible upper bound for that option is used.
 .TP
-.BR "--stp-type " "[!] \fItype\fP"
+.RB [ ! ] " --stp-type " \fItype\fP
 The BPDU type (0\(en255), recognized non-numerical types are
 .IR config ", denoting a configuration BPDU (=0), and"
 .IR tcn ", denothing a topology change notification BPDU (=128)."
 .TP
-.BR "--stp-flags " "[!] \fIflag\fP"
+.RB [ ! ] " --stp-flags " \fIflag\fP
 The BPDU flag (0\(en255), recognized non-numerical flags are
 .IR topology-change ", denoting the topology change flag (=1), and"
 .IR topology-change-ack ", denoting the topology change acknowledgement flag (=128)."
 .TP
-.BR "--stp-root-prio " "[!] [\fIprio\fP][:\fIprio\fP]"
+.RB [ ! ] " --stp-root-prio " [\fIprio\fP][ : \fIprio\fP]
 The root priority (0\(en65535) range.
 .TP
-.BR "--stp-root-addr " "[!] [\fIaddress\fP][/\fImask\fP]"
+.RB [ ! ] " --stp-root-addr " [\fIaddress\fP][ / \fImask\fP]
 The root mac address, see the option
 .BR -s " for more details."
 .TP
-.BR "--stp-root-cost " "[!] [\fIcost\fP][:\fIcost\fP]"
+.RB [ ! ] " --stp-root-cost " [\fIcost\fP][ : \fIcost\fP]
 The root path cost (0\(en4294967295) range.
 .TP
-.BR "--stp-sender-prio " "[!] [\fIprio\fP][:\fIprio\fP]"
+.RB [ ! ] " --stp-sender-prio " [\fIprio\fP][ : \fIprio\fP]
 The BPDU's sender priority (0\(en65535) range.
 .TP
-.BR "--stp-sender-addr " "[!] [\fIaddress\fP][/\fImask\fP]"
+.RB [ ! ] " --stp-sender-addr " [\fIaddress\fP][ / \fImask\fP]
 The BPDU's sender mac address, see the option
 .BR -s " for more details."
 .TP
-.BR "--stp-port " "[!] [\fIport\fP][:\fIport\fP]"
+.RB [ ! ] " --stp-port " [\fIport\fP][ : \fIport\fP]
 The port identifier (0\(en65535) range.
 .TP
-.BR "--stp-msg-age " "[!] [\fIage\fP][:\fIage\fP]"
+.RB [ ! ] " --stp-msg-age " [\fIage\fP][ : \fIage\fP]
 The message age timer (0\(en65535) range.
 .TP
-.BR "--stp-max-age " "[!] [\fIage\fP][:\fIage\fP]"
+.RB [ ! ] " --stp-max-age " [\fIage\fP][ : \fIage\fP]
 The max age timer (0\(en65535) range.
 .TP
-.BR "--stp-hello-time " "[!] [\fItime\fP][:\fItime\fP]"
+.RB [ ! ] " --stp-hello-time " [\fItime\fP][ : \fItime\fP]
 The hello time timer (0\(en65535) range.
 .TP
-.BR "--stp-forward-delay " "[!] [\fIdelay\fP][:\fIdelay\fP]"
+.RB [ ! ] " --stp-forward-delay " [\fIdelay\fP][ : \fIdelay\fP]
 The forward delay timer (0\(en65535) range.
 .\" .SS string
 .\" This module matches on a given string using some pattern matching strategy.
@@ -774,10 +774,10 @@ The forward delay timer (0\(en65535) range.
 .\" .BR "--string-to " "\fIoffset\fP"
 .\" The highest offset from which a match can start. (default: size of frame)
 .\" .TP
-.\" .BR "--string " "[!] \fIpattern\fP"
+.\" .RB [ ! ] " --string " \fIpattern\fP
 .\" Matches the given pattern.
 .\" .TP
-.\" .BR "--string-hex " "[!] \fIpattern\fP"
+.\" .RB [ ! ] " --string-hex " \fIpattern\fP
 .\" Matches the given pattern in hex notation, e.g. '|0D 0A|', '|0D0A|', 'www|09|netfilter|03|org|00|'
 .\" .TP
 .\" .BR "--string-icase"
@@ -787,15 +787,15 @@ Specify 802.1Q Tag Control Information fields.
 The protocol must be specified as
 .IR 802_1Q " (0x8100)."
 .TP
-.BR "--vlan-id " "[!] \fIid\fP"
+.RB [ ! ] " --vlan-id " \fIid\fP
 The VLAN identifier field (VID). Decimal number from 0 to 4095.
 .TP
-.BR "--vlan-prio " "[!] \fIprio\fP"
+.RB [ ! ] " --vlan-prio " \fIprio\fP
 The user priority field, a decimal number from 0 to 7.
 The VID should be set to 0 ("null VID") or unspecified
 (in the latter case the VID is deliberately set to 0).
 .TP
-.BR "--vlan-encap " "[!] \fItype\fP"
+.RB [ ! ] " --vlan-encap " \fItype\fP
 The encapsulated Ethernet frame type/length.
 Specified as a hexadecimal
 number from 0x0000 to 0xFFFF or as a symbolic name
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index ae63f96fb9a3f..2470010e4713b 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -213,7 +213,7 @@ static bool nft_rule_to_ebtables_command_state(struct nft_handle *h,
 static void print_iface(const char *option, const char *name, bool invert)
 {
 	if (*name)
-		printf("%s%s %s ", option, invert ? " !" : "", name);
+		printf("%s%s %s ", invert ? "! " : "", option, name);
 }
 
 static void nft_bridge_print_table_header(const char *tablename)
@@ -258,9 +258,7 @@ static void print_mac(char option, const unsigned char *mac,
 		      const unsigned char *mask,
 		      bool invert)
 {
-	printf("-%c ", option);
-	if (invert)
-		printf("! ");
+	printf("%s-%c ", invert ? "! " : "", option);
 	ebt_print_mac_and_mask(mac, mask);
 	printf(" ");
 }
@@ -275,9 +273,7 @@ static void print_protocol(uint16_t ethproto, bool invert, unsigned int bitmask)
 	if (bitmask & EBT_NOPROTO)
 		return;
 
-	printf("-p ");
-	if (invert)
-		printf("! ");
+	printf("%s-p ", invert ? "! " : "");
 
 	if (bitmask & EBT_802_3) {
 		printf("Length ");
diff --git a/iptables/tests/shell/testcases/ebtables/0008-ebtables-among_0 b/iptables/tests/shell/testcases/ebtables/0008-ebtables-among_0
index b5df972559e47..962b1e0396b9c 100755
--- a/iptables/tests/shell/testcases/ebtables/0008-ebtables-among_0
+++ b/iptables/tests/shell/testcases/ebtables/0008-ebtables-among_0
@@ -71,27 +71,35 @@ bf_client_ip1="10.167.11.2"
 pktsize=64
 
 # --among-src [mac,IP]
+among="$bf_bridge_mac0=$bf_bridge_ip0,$bf_client_mac1=$bf_client_ip1"
 ip netns exec "$nsb" $XT_MULTI ebtables -F
-ip netns exec "$nsb" $XT_MULTI ebtables -A FORWARD -p ip --ip-dst $bf_server_ip1 --among-src $bf_bridge_mac0=$bf_bridge_ip0,$bf_client_mac1=$bf_client_ip1 -j DROP > /dev/null
+ip netns exec "$nsb" $XT_MULTI ebtables -A FORWARD \
+	-p ip --ip-dst $bf_server_ip1 --among-src "$among" -j DROP > /dev/null
 ip netns exec "$nsc" ping -q $bf_server_ip1 -c 1 -s $pktsize -W 1 >/dev/null
 assert_fail $? "--among-src [match]"
 
 # ip netns exec "$nsb" $XT_MULTI ebtables -L --Ln --Lc
 
+among="$bf_bridge_mac0=$bf_bridge_ip0,$bf_client_mac1=$bf_client_ip1"
 ip netns exec "$nsb" $XT_MULTI ebtables -F
-ip netns exec "$nsb" $XT_MULTI ebtables -A FORWARD -p ip --ip-dst $bf_server_ip1 --among-src ! $bf_bridge_mac0=$bf_bridge_ip0,$bf_client_mac1=$bf_client_ip1 -j DROP > /dev/null
+ip netns exec "$nsb" $XT_MULTI ebtables -A FORWARD \
+	-p ip --ip-dst $bf_server_ip1 ! --among-src "$among" -j DROP > /dev/null
 ip netns exec "$nsc" ping $bf_server_ip1 -c 1 -s $pktsize -W 1 >/dev/null
 assert_pass $? "--among-src [not match]"
 
 # --among-dst [mac,IP]
+among="$bf_client_mac1=$bf_client_ip1,$bf_server_mac1=$bf_server_ip1"
 ip netns exec "$nsb" $XT_MULTI ebtables -F
-ip netns exec "$nsb" $XT_MULTI ebtables -A FORWARD -p ip --ip-src $bf_client_ip1 --among-dst $bf_client_mac1=$bf_client_ip1,$bf_server_mac1=$bf_server_ip1 -j DROP > /dev/null
+ip netns exec "$nsb" $XT_MULTI ebtables -A FORWARD \
+	-p ip --ip-src $bf_client_ip1 --among-dst "$among" -j DROP > /dev/null
 ip netns exec "$nsc" ping -q $bf_server_ip1 -c 1 -s $pktsize -W 1 > /dev/null
 assert_fail $? "--among-dst [match]"
 
-# --among-dst ! [mac,IP]
+# ! --among-dst [mac,IP]
+among="$bf_client_mac1=$bf_client_ip1,$bf_server_mac1=$bf_server_ip1"
 ip netns exec "$nsb" $XT_MULTI ebtables -F
-ip netns exec "$nsb" $XT_MULTI ebtables -A FORWARD -p ip --ip-src $bf_client_ip1 --among-dst ! $bf_client_mac1=$bf_client_ip1,$bf_server_mac1=$bf_server_ip1 -j DROP > /dev/null
+ip netns exec "$nsb" $XT_MULTI ebtables -A FORWARD \
+	-p ip --ip-src $bf_client_ip1 ! --among-dst "$among" -j DROP > /dev/null
 ip netns exec "$nsc" ping -q $bf_server_ip1 -c 1 -s $pktsize -W 1 > /dev/null
 assert_pass $? "--among-dst [not match]"
 
-- 
2.43.0

