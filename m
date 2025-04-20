Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84D920C48A
	for <netfilter-devel@vger.kernel.org>; Sun, 20 Apr 2025 17:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745169649; cv=none; b=ljbDol6cvbDAm7/ANeQanJ9SvKSFus/eJX7rpLTOrvYyeccXL9KceI1Kt7BMUhBlagS1PIT5JOIsG32aMFTvUZ7pT+Vnp6ASMgDbr5EPdrsjvseYuAxm8KubPXe2Vmm3OB+J7r9Ce02bDum2PfNi0/HOz2EFlLSbuw15eioKpVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745169649; c=relaxed/simple;
	bh=mEJqElMwMXyM1n9ndojknXPjxicPuxWvyonzRoCxVHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJIp9S4u8H8VmzJmUkOb04ThCde9M6V7D8qdlYqT+Ztqr5XFrOc0tei+/OaNrEIGD+tyzN7fGliEl+vmXR2sQA00AUwG6tZ9TmOs26JfVxMaxGlN4ncIBpbOav5duWIVVsDTSa07x2VVJm3zBfpobEA0sRATq5ronvf9Xgh8gYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=f+Jt7xmY; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="f+Jt7xmY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ZXleh81JQR+7IkgLP5JaTxJ5XIVVJzzsQwfT/h+dt/g=; b=f+Jt7xmY+i/PSJdiQNDpqXf59D
	0i6AhdIQjSIPafeSf5fXhvJ7Kr/7rPYbZ0KkGbvnfgODb//hbqQqLjVEpFEBmrkwapSesgz5mboBZ
	SdjrRcbdXzHj2wy/t+jE7EE6NiOcS1HX80grAoYar135uBPOjTbfIslCjwpZorQWXSfijyoJYuoW8
	E36apmpRYlc6voa7fiAEb5rWXPXbdOyXh6glUtg3DQs+4/H52MFdJkF+G46VcgWNlSOk+2FQMIAEq
	TzZoulOBemfpvT3l0Ahpq39DWW5P7f5ntkySRyAK3H/6iDKK4v4HriVKK52r2bn8x1ySDpMOYgBcW
	80+fdLUw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1u6YLO-005Uip-0Y;
	Sun, 20 Apr 2025 18:20:38 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc: Slavko <linux@slavino.sk>
Subject: [PATCH ulogd2 3/6] IP2HBIN, IP2STR: correct typo's
Date: Sun, 20 Apr 2025 18:20:22 +0100
Message-ID: <20250420172025.1994494-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250420172025.1994494-1-jeremy@azazel.net>
References: <20250420172025.1994494-1-jeremy@azazel.net>
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

The `struct ulogd_plugin` object names have trailing g's.  Remove them.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 filter/ulogd_filter_IP2HBIN.c | 4 ++--
 filter/ulogd_filter_IP2STR.c  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/filter/ulogd_filter_IP2HBIN.c b/filter/ulogd_filter_IP2HBIN.c
index 081616edbc51..48ea6a2cbc14 100644
--- a/filter/ulogd_filter_IP2HBIN.c
+++ b/filter/ulogd_filter_IP2HBIN.c
@@ -173,7 +173,7 @@ static int interp_ip2hbin(struct ulogd_pluginstance *pi)
 	return ULOGD_IRET_OK;
 }
 
-static struct ulogd_plugin ip2hbin_pluging = {
+static struct ulogd_plugin ip2hbin_plugin = {
 	.name = "IP2HBIN",
 	.input = {
 		.keys = ip2hbin_inp,
@@ -193,5 +193,5 @@ void __attribute__ ((constructor)) init(void);
 
 void init(void)
 {
-	ulogd_register_plugin(&ip2hbin_pluging);
+	ulogd_register_plugin(&ip2hbin_plugin);
 }
diff --git a/filter/ulogd_filter_IP2STR.c b/filter/ulogd_filter_IP2STR.c
index c52824b79e65..fec892a62dac 100644
--- a/filter/ulogd_filter_IP2STR.c
+++ b/filter/ulogd_filter_IP2STR.c
@@ -206,7 +206,7 @@ static int interp_ip2str(struct ulogd_pluginstance *pi)
 	return ULOGD_IRET_OK;
 }
 
-static struct ulogd_plugin ip2str_pluging = {
+static struct ulogd_plugin ip2str_plugin = {
 	.name = "IP2STR",
 	.input = {
 		.keys = ip2str_inp,
@@ -226,5 +226,5 @@ void __attribute__ ((constructor)) init(void);
 
 void init(void)
 {
-	ulogd_register_plugin(&ip2str_pluging);
+	ulogd_register_plugin(&ip2str_plugin);
 }
-- 
2.47.2

