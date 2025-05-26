Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6A14C97
	for <netfilter-devel@vger.kernel.org>; Mon, 26 May 2025 17:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748279994; cv=none; b=k5LpmA854MZBiBZTRcpoILFd+0ymQLc75Y5YTH/d/I5JstMI41epaIoHsE/JAc19gLTayi4vy+7VY5jqnd7lTsTZ1eD43a0OSaQCIEzjKOAENZKG/A9NEks0OXVeRXudySICnVzPbcRFjH7QQT1YXlVghxagfZnQ2VzgTIi0mfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748279994; c=relaxed/simple;
	bh=gTx7iNh1xwewgZVkBhrV08QSWkJmVA7Ei4My69LAkmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UrGUVxGl44tFi4e2v3cytMisXZH1UTbbHTSTrX6xmoEYUqMiJQDYsZ1IQZTeU6EU2RnUDG4Pc6/Y8xoqCsFfj7K3TsCMwr4TBe9cTAKcZ6AzSgtd8qorkQvInooDza5jpBZv2gBYnlqnRJbI4H3BTiewx15XR/R+EkZvorQ+X3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=qu6jHehN; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="qu6jHehN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=RU529esybRaPK6qk3Ng5QvpRG5w9S6/DvYxVU0I5ya8=; b=qu6jHehNUDMfPTS44x2KKFT4hv
	jcdxxSnQYa28Vx97kOrtOgKicgpHQrQorUoUg33R20q74+Kg9abcmTMFMVMY3wnBWX3j/FBN+AROC
	6jhdlL7xRxxgbApZTSoATqzrWrivBQDKQl6la4tvwlrdlU+SxfllKx+2ngbbDAKjQo7AbCoq5vfXQ
	gQCHFIQGAg2/Kw75EyGoQ/cTATn5gqofoB+aBlEIHsP3YdDo9QVsqqGlNWk4WEOC3bJ1dvfyIOlI0
	qSSYDGyh9ixb9RLMvhbSyZA+al/2pHQnu3rW1k8z/u2LaV3XF1p1n76O368ScLB4v5HLJuS6CJK04
	PnaufrWQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1uJbUK-000rKJ-1q;
	Mon, 26 May 2025 18:19:48 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc: Slavko <linux@slavino.sk>
Subject: [PATCH ulogd2 v2 4/4] Add support for logging ARP packets
Date: Mon, 26 May 2025 18:19:04 +0100
Message-ID: <20250526171904.1733009-5-jeremy@azazel.net>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250526171904.1733009-1-jeremy@azazel.net>
References: <20250526171904.1733009-1-jeremy@azazel.net>
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

Hithero, ulogd has only fully supported handling ARP headers that are present in
`NFPROTO_BRIDGE` packets.

Add support for handling ARP packets in their own right.

Reported-by: Slavko <linux@slavino.sk>
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 filter/raw2packet/ulogd_raw2packet_BASE.c |  2 ++
 filter/ulogd_filter_IP2BIN.c              | 24 +++++++++++++++++++++--
 filter/ulogd_filter_IP2HBIN.c             | 23 +++++++++++++++++++++-
 filter/ulogd_filter_IP2STR.c              |  1 +
 util/printpkt.c                           |  3 +++
 5 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/filter/raw2packet/ulogd_raw2packet_BASE.c b/filter/raw2packet/ulogd_raw2packet_BASE.c
index 4b6096421b71..2c0d16449cf1 100644
--- a/filter/raw2packet/ulogd_raw2packet_BASE.c
+++ b/filter/raw2packet/ulogd_raw2packet_BASE.c
@@ -960,6 +960,8 @@ static int _interp_pkt(struct ulogd_pluginstance *pi)
 		return _interp_ipv6hdr(pi, len);
 	case NFPROTO_BRIDGE:
 		return _interp_bridge(pi, len);
+	case NFPROTO_ARP:
+		return _interp_arp(pi, len);
 	}
 	return ULOGD_IRET_OK;
 }
diff --git a/filter/ulogd_filter_IP2BIN.c b/filter/ulogd_filter_IP2BIN.c
index 9bbeebbb711e..9e6f3a929058 100644
--- a/filter/ulogd_filter_IP2BIN.c
+++ b/filter/ulogd_filter_IP2BIN.c
@@ -39,7 +39,9 @@ enum input_keys {
 	KEY_ORIG_IP_DADDR,
 	KEY_REPLY_IP_SADDR,
 	KEY_REPLY_IP_DADDR,
-	MAX_KEY = KEY_REPLY_IP_DADDR,
+	KEY_ARP_SPA,
+	KEY_ARP_TPA,
+	MAX_KEY = KEY_ARP_TPA,
 };
 
 static struct ulogd_key ip2bin_inp[] = {
@@ -83,6 +85,16 @@ static struct ulogd_key ip2bin_inp[] = {
 		.flags	= ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
 		.name	= "reply.ip.daddr",
 	},
+	[KEY_ARP_SPA] = {
+		.type = ULOGD_RET_IPADDR,
+		.flags = ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
+		.name = "arp.saddr",
+	},
+	[KEY_ARP_TPA] = {
+		.type = ULOGD_RET_IPADDR,
+		.flags = ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
+		.name = "arp.daddr",
+	},
 };
 
 static struct ulogd_key ip2bin_keys[] = {
@@ -110,7 +122,14 @@ static struct ulogd_key ip2bin_keys[] = {
 		.type = ULOGD_RET_RAWSTR,
 		.name = "reply.ip.daddr.bin",
 	},
-
+	{
+		.type = ULOGD_RET_RAWSTR,
+		.name = "arp.saddr.bin",
+	},
+	{
+		.type = ULOGD_RET_RAWSTR,
+		.name = "arp.daddr.bin",
+	},
 };
 
 static char ipbin_array[MAX_KEY - START_KEY + 1][FORMAT_IPV6_BUFSZ];
@@ -150,6 +169,7 @@ static int interp_ip2bin(struct ulogd_pluginstance *pi)
 		addr_family = AF_INET6;
 		break;
 	case NFPROTO_IPV4:
+	case NFPROTO_ARP:
 		addr_family = AF_INET;
 		break;
 	case NFPROTO_BRIDGE:
diff --git a/filter/ulogd_filter_IP2HBIN.c b/filter/ulogd_filter_IP2HBIN.c
index 081b757a6f1a..38306e8406a2 100644
--- a/filter/ulogd_filter_IP2HBIN.c
+++ b/filter/ulogd_filter_IP2HBIN.c
@@ -40,7 +40,9 @@ enum input_keys {
 	KEY_ORIG_IP_DADDR,
 	KEY_REPLY_IP_SADDR,
 	KEY_REPLY_IP_DADDR,
-	MAX_KEY = KEY_REPLY_IP_DADDR,
+	KEY_ARP_SPA,
+	KEY_ARP_TPA,
+	MAX_KEY = KEY_ARP_TPA,
 };
 
 static struct ulogd_key ip2hbin_inp[] = {
@@ -84,6 +86,16 @@ static struct ulogd_key ip2hbin_inp[] = {
 		.flags	= ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
 		.name	= "reply.ip.daddr",
 	},
+	[KEY_ARP_SPA] = {
+		.type = ULOGD_RET_IPADDR,
+		.flags = ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
+		.name = "arp.saddr",
+	},
+	[KEY_ARP_TPA] = {
+		.type = ULOGD_RET_IPADDR,
+		.flags = ULOGD_RETF_NONE|ULOGD_KEYF_OPTIONAL,
+		.name = "arp.daddr",
+	},
 };
 
 static struct ulogd_key ip2hbin_keys[] = {
@@ -111,6 +123,14 @@ static struct ulogd_key ip2hbin_keys[] = {
 		.type = ULOGD_RET_IPADDR,
 		.name = "reply.ip.hdaddr",
 	},
+	{
+		.type = ULOGD_RET_IPADDR,
+		.name = "arp.hsaddr",
+	},
+	{
+		.type = ULOGD_RET_IPADDR,
+		.name = "arp.hdaddr",
+	},
 };
 
 static void ip2hbin(struct ulogd_key *inp, int i, struct ulogd_key *outp, int o,
@@ -140,6 +160,7 @@ static int interp_ip2hbin(struct ulogd_pluginstance *pi)
 		addr_family = AF_INET6;
 		break;
 	case NFPROTO_IPV4:
+	case NFPROTO_ARP:
 		addr_family = AF_INET;
 		break;
 	case NFPROTO_BRIDGE:
diff --git a/filter/ulogd_filter_IP2STR.c b/filter/ulogd_filter_IP2STR.c
index 3d4d6e9dc897..12a376efafe4 100644
--- a/filter/ulogd_filter_IP2STR.c
+++ b/filter/ulogd_filter_IP2STR.c
@@ -175,6 +175,7 @@ static int interp_ip2str(struct ulogd_pluginstance *pi)
 		addr_family = AF_INET6;
 		break;
 	case NFPROTO_IPV4:
+	case NFPROTO_ARP:
 		addr_family = AF_INET;
 		break;
 	case NFPROTO_BRIDGE:
diff --git a/util/printpkt.c b/util/printpkt.c
index 2fecd50e233c..93fe4722d63c 100644
--- a/util/printpkt.c
+++ b/util/printpkt.c
@@ -467,6 +467,9 @@ int printpkt_print(struct ulogd_key *res, char *buf)
 	case NFPROTO_BRIDGE:
 		buf_cur += printpkt_bridge(res, buf_cur);
 		break;
+	case NFPROTO_ARP:
+		buf_cur += printpkt_arp(res, buf_cur);
+		break;
 	}
 
 	if (pp_is_valid(res, KEY_OOB_UID))
-- 
2.47.2

