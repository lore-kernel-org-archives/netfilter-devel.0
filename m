Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C852B20C48C
	for <netfilter-devel@vger.kernel.org>; Sun, 20 Apr 2025 17:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745169649; cv=none; b=DXg59dvMPBtqQnXDRuozlsz9GwPORLSpGH3ElMJv7dh/QL1dEb7IC8W6WVaXJT3COWcZbM8nWt5hEhmoJA17YQTnUrwCvsxD43M6BITgKn0UTjQFWK2M651mui78h3umDZST+/oPWDNtSgDy0+Aj7DS6Y555BZ4vy4kKl9COc0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745169649; c=relaxed/simple;
	bh=GAzS7+5/8sfNU6jLnMKq0skn4igMson3TNEf1bvches=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0My3IeDcjfbRa/KMhLrkBvY/72AtZOCKC9zTICM4Ew44hQ/OQLaKFuoDemhaGUjmJT3vkDlU30LNgYL6vxFjlfOEDVXE5V6oVuzTCHVEZdw+hXP0NyOVcMO4XeqMX0yvKiqtBuUyly8gJ9lU396YkpJCWInpkmFyrHCsUodIDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=OhBvG2ZQ; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="OhBvG2ZQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Xl4/kL0viNnxQx/R9VDGAXV77QAywMFGTjT8E9htAnA=; b=OhBvG2ZQ3NAjqHERNzlrEao9VA
	igDknjunzhakpP4fLm9XmWfsxFpeBLW7phRRQF0zTe7MxY9k82Fps8i2D/c65mrKjkmM2GsjAa1pX
	Orafsv9ZIScb2mCkIIFyIyQLX7zKn/OQOF7FgkQveRdX5QX9n+bBKUVDJHnmKCPe5Ew3R+q1X+229
	aGrhTi6SpgWTd7VHJ8PKULedtZ50zaSNHclE2i8Ffr9sHqzjGlip5GYcVwIYc3YuuM6NUw1pB0nBN
	WQjFCo+IANvSeUDgp729iDsTqTg9/P5WgOW/5IQQdKxDY9e99VW36yOaQOeWIMcB91BQs9c957nlt
	RFubEOLA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1u6YLO-005Uip-0N;
	Sun, 20 Apr 2025 18:20:38 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc: Slavko <linux@slavino.sk>
Subject: [PATCH ulogd2 2/6] db, IP2BIN: correct `format_ipv6()` output buffer sizes
Date: Sun, 20 Apr 2025 18:20:21 +0100
Message-ID: <20250420172025.1994494-3-jeremy@azazel.net>
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

`format_ipv6()` formats IPv6 addresses as hex-strings.  However, sizing for the
output buffer is not done quite right.

`format_ipv6()` itself uses the size of `struct in6_addr` to verify that the
buffer size is large enough, and the output buffer for the call in util/db.c is
sized the same way.  However, the size that should be used is that of the
`s6_addr` member of `struct in6_addr`, not that of the whole structure.

The elements of the `ipbin_array` array in ulogd_filter_IP2BIN.c are sized using
a local macro, `IPADDR_LENGTH`, which is defined as 128, the number of bits in
an IPv6 address; this is much larger than necessary.

Define an appropriate macro and use that instead.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 filter/ulogd_filter_IP2BIN.c |  6 ++----
 include/ulogd/ulogd.h        | 13 +++++++++++--
 util/db.c                    |  2 +-
 3 files changed, 14 insertions(+), 7 deletions(-)

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
index 5eafb21f9cfe..5b6134d94ea3 100644
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
+#define FORMAT_IPV6_BUFSZ (2 + sizeof(((struct in6_addr) {}).s6_addr) * 2 + 1)
+
 /* All types with MSB = 1 make use of value.ptr
  * other types use one of the union's member */
 
@@ -233,11 +242,11 @@ format_ipv6(char *buf, size_t size, const struct in6_addr *ipv6)
 {
 	unsigned i = 0;
 
-	if (size > 2 + sizeof (*ipv6) * 2) {
+	if (size >= FORMAT_IPV6_BUFSZ) {
 		buf[i++] = '0';
 		buf[i++] = 'x';
 
-		for (unsigned j = 0; i < sizeof(*ipv6); j += 4, i += 8) {
+		for (unsigned j = 0; i < sizeof(ipv6->s6_addr); j += 4, i += 8) {
 			sprintf(buf + i, "%02hhx%02hhx%02hhx%02hhx",
 				ipv6->s6_addr[j + 0],
 				ipv6->s6_addr[j + 1],
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

