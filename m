Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7053D994
	for <netfilter-devel@vger.kernel.org>; Mon, 26 May 2025 17:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748279994; cv=none; b=WOPOfRCR+09Y+g8alXdOWD+bFqIbyF1CiDHH8ZffsGtJYo8V8XXZCCDUT7fI+n0AV2MAgDeakd8trThp6sOBT9FIOzxzXQrHUct8jjIJHv4Z96hD8+yBUHZUphLefj2nh9J34xmXFX5k24jufdQsJj8CAim5APqqQWot9POQ8Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748279994; c=relaxed/simple;
	bh=0M0ILUK2inMbaMYFGjietxMQr/DBe4eefWzhWgLAtXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJudCHNFGXm46aJoFCzcO+LGSZejQRmGRThY+rxtRRLW/shjWRSx+DtS5k5wimoaouWD9BGNMqmqHOBmIT8+e53N0LOL/7HWn4Q/9NZpBbc8EVc4Kk5oChTLH5C6WGnwygx+X6HGc+anSaG8aPXjwZk5cLWqEiNlMOP/K/+R9Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=W6trcO/r; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="W6trcO/r"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=g3D4PalZngzU4nHP42RijKSm26g4BqrOQvrDgL5eHEE=; b=W6trcO/rhDe0ExI0Fe+Er1vPzk
	QJykEvOq9AyvyfGnLSupo8YYMNx0FF6WpqubYzBxEh8fjjZyVQMIuDgsgr8R+JMHarn0OMfBNq1ZS
	d9kt9aWq+H0IU3YPLPAOs/dgDgbOqiyCfeTi2sra4VWOOWWxBOn/mHJ/H+plX5J1w6dzjbBoa4r8f
	t2dFTQUf5rxoj/B8ayAc+ufwh3d8Yv1HItRtljvAlsC9KitZFEH3BFJXYSJY0qonOs4/5IyL/3gMf
	+57y68O9MfmkSga8UkpzDBQXBPPTwI4vrwdI4wwJD1joJ8CqaM1N0alObvakozJJMJVbwlnKK8F7v
	JEuvkIkw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1uJbUK-000rKJ-1P;
	Mon, 26 May 2025 18:19:48 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc: Slavko <linux@slavino.sk>
Subject: [PATCH ulogd2 v2 1/4] db, IP2BIN: correct `format_ipv6()` output buffer sizes
Date: Mon, 26 May 2025 18:19:01 +0100
Message-ID: <20250526171904.1733009-2-jeremy@azazel.net>
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

`format_ipv6()` formats IPv6 addresses as hex-strings.  However, sizing for the
output buffer is not done quite right.

The elements of the `ipbin_array` array in ulogd_filter_IP2BIN.c are sized using
a local macro, `IPADDR_LENGTH`, which is defined as 128, the number of bits in
an IPv6 address; this is much larger than necessary.

Define an appropriate macro and use that instead.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 filter/ulogd_filter_IP2BIN.c |  6 ++----
 include/ulogd/ulogd.h        | 11 ++++++++++-
 util/db.c                    |  2 +-
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/filter/ulogd_filter_IP2BIN.c b/filter/ulogd_filter_IP2BIN.c
index 7f7bea5071a7..f1ca4eee7d76 100644
--- a/filter/ulogd_filter_IP2BIN.c
+++ b/filter/ulogd_filter_IP2BIN.c
@@ -28,8 +28,6 @@
 #include <ulogd/ulogd.h>
 #include <netinet/if_ether.h>
 
-#define IPADDR_LENGTH 128
-
 enum input_keys {
 	KEY_OOB_FAMILY,
 	KEY_OOB_PROTOCOL,
@@ -114,7 +112,7 @@ static struct ulogd_key ip2bin_keys[] = {
 
 };
 
-static char ipbin_array[MAX_KEY - START_KEY + 1][IPADDR_LENGTH];
+static char ipbin_array[MAX_KEY - START_KEY + 1][FORMAT_IPV6_BUFSZ];
 
 static int ip2bin(struct ulogd_key *inp, int index, int oindex)
 {
@@ -161,7 +159,7 @@ static int ip2bin(struct ulogd_key *inp, int index, int oindex)
 			return ULOGD_IRET_ERR;
 	}
 
-	format_ipv6(ipbin_array[oindex], IPADDR_LENGTH, addr);
+	format_ipv6(ipbin_array[oindex], sizeof(ipbin_array[oindex]), addr);
 
 	return ULOGD_IRET_OK;
 }
diff --git a/include/ulogd/ulogd.h b/include/ulogd/ulogd.h
index 5eafb21f9cfe..29082dfbe1b2 100644
--- a/include/ulogd/ulogd.h
+++ b/include/ulogd/ulogd.h
@@ -23,6 +23,15 @@
 
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 
+/*
+ * Minimum size of buffer required to hold an ipv6 address encoded as a
+ * hex-string, e.g.:
+ *
+ *                          ::1 -> "0x00000000000000000000000000000001"
+ * 2600:1408:ec00:36::1736:7f28 -> "0x26001408ec0000360000000017367f28"
+ */
+#define FORMAT_IPV6_BUFSZ (2 + sizeof(struct in6_addr) * 2 + 1)
+
 /* All types with MSB = 1 make use of value.ptr
  * other types use one of the union's member */
 
@@ -233,7 +242,7 @@ format_ipv6(char *buf, size_t size, const struct in6_addr *ipv6)
 {
 	unsigned i = 0;
 
-	if (size > 2 + sizeof (*ipv6) * 2) {
+	if (size >= FORMAT_IPV6_BUFSZ) {
 		buf[i++] = '0';
 		buf[i++] = 'x';
 
diff --git a/util/db.c b/util/db.c
index 11c3e6ad8454..69f4290f5c87 100644
--- a/util/db.c
+++ b/util/db.c
@@ -370,7 +370,7 @@ static void __format_query_db(struct ulogd_pluginstance *upi, char *start)
 				sprintf(stmt_ins, "%u,", res->u.value.ui32);
 			else {
 				struct in6_addr ipv6;
-				char addrbuf[2 + sizeof(ipv6) * 2  + 1];
+				char addrbuf[FORMAT_IPV6_BUFSZ];
 
 				memcpy(ipv6.s6_addr, res->u.value.ui128,
 				       sizeof(ipv6.s6_addr));
-- 
2.47.2

