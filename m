Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7B613C66C
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Apr 2024 15:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712675651; cv=none; b=Rw5I485gRODmKFQQsyP/Av+h48OnyCujJX9oxxHuDKfDDvRoz6nQt1Y5kFtCtTK+ev00UtUU54NwhWHab0GGUlxQlf6opIfcN4lxYtuvjJwAlW+8wS+ZQPzL4Kll96p4ttAQOGFW29zDCgT3r+YMkqr9Pl1DfkI9+KdCFf7D1PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712675651; c=relaxed/simple;
	bh=h+Z0pnI3RPYeqeiUc2i88XMBWEaQHaB9bFUvMPpLnhs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LYNjq4fP7YHRG4Wm/C3QXHeZwQ9qx38V0R8wMHzYx+2AtfILHmGm0LFxVPvi5bx0+Bf7U1qPtGzoVSxOlPsUeak5yN2zY1B7hRZCJHyfSfgAgrYVlsFdu1/XlsmKUUU0EbAinQbs6wZNnT8CvfOZLtioDixeUFTaOA/pEpGEeMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=dCTOkgCy; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="dCTOkgCy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=YQ0w6dAJAEvPJv3nOr8KcJhTvRcVGq34JueZqVyHJi4=; b=dCTOkgCy5qfuYzZC1D+G/dhsye
	7VxJC1U+lgfXAUA6YoNvZpUYvBvbLCuwCy1jEwC6epZx0bVAehaHbfa63T9iwEIJZbKo2ib7pTfHi
	UYA0aj20n7CRjuH20PWFePdoEsZ/qePzOXueDdoFRnr8LaZxiH4GOiz6Yw/a0eY5++9uB0b9oA9VT
	Zj/WwQdryxCnrnn4gY0Nhy8MqJEzHBdESO/oOAXeAvrRCXHKVKWicrwRRyQFz1QaesOmKu2SDUKG4
	puF0RmycejI8Gr6I1OEM3LOFH2rTtNMO/yOgSxNRQEEVUC8TlZPHDP6kgL9HuTpGQC4Wmbj8hSUJJ
	LiW6q3fw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ruDAk-0000000035Z-1dAO;
	Tue, 09 Apr 2024 17:14:06 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Vitaly Chikunov <vt@altlinux.org>
Subject: [iptables PATCH] libxtables: Attenuate effects of functions' internal static buffers
Date: Tue,  9 Apr 2024 17:14:04 +0200
Message-ID: <20240409151404.30835-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While functions returning pointers to internal static buffers have
obvious limitations, users are likely unaware how they call each other
internally and thus won't notice unsafe use. One such case is calling
both xtables_ipaddr_to_numeric() and xtables_ipmask_to_numeric() as
parameters for a single printf() call.

Defuse this trap by avoiding the internal calls to
xtables_ip{,6}addr_to_numeric() which is easily doable since callers
keep their own static buffers already.

While being at it, make use of inet_ntop() everywhere and also use
INET_ADDRSTRLEN/INET6_ADDRSTRLEN defines for correct (and annotated)
static buffer sizes.

Reported-by: Vitaly Chikunov <vt@altlinux.org>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 libxtables/xtables.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index f2fcc5c22fb61..7b370d486f888 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -1513,11 +1513,9 @@ void xtables_param_act(unsigned int status, const char *p1, ...)
 
 const char *xtables_ipaddr_to_numeric(const struct in_addr *addrp)
 {
-	static char buf[16];
-	const unsigned char *bytep = (const void *)&addrp->s_addr;
+	static char buf[INET_ADDRSTRLEN];
 
-	sprintf(buf, "%u.%u.%u.%u", bytep[0], bytep[1], bytep[2], bytep[3]);
-	return buf;
+	return inet_ntop(AF_INET, addrp, buf, sizeof(buf));
 }
 
 static const char *ipaddr_to_host(const struct in_addr *addr)
@@ -1577,13 +1575,14 @@ int xtables_ipmask_to_cidr(const struct in_addr *mask)
 
 const char *xtables_ipmask_to_numeric(const struct in_addr *mask)
 {
-	static char buf[20];
+	static char buf[INET_ADDRSTRLEN + 1];
 	uint32_t cidr;
 
 	cidr = xtables_ipmask_to_cidr(mask);
 	if (cidr == (unsigned int)-1) {
 		/* mask was not a decent combination of 1's and 0's */
-		sprintf(buf, "/%s", xtables_ipaddr_to_numeric(mask));
+		buf[0] = '/';
+		inet_ntop(AF_INET, mask, buf + 1, sizeof(buf) - 1);
 		return buf;
 	} else if (cidr == 32) {
 		/* we don't want to see "/32" */
@@ -1863,9 +1862,8 @@ void xtables_ipparse_any(const char *name, struct in_addr **addrpp,
 
 const char *xtables_ip6addr_to_numeric(const struct in6_addr *addrp)
 {
-	/* 0000:0000:0000:0000:0000:0000:000.000.000.000
-	 * 0000:0000:0000:0000:0000:0000:0000:0000 */
-	static char buf[50+1];
+	static char buf[INET6_ADDRSTRLEN];
+
 	return inet_ntop(AF_INET6, addrp, buf, sizeof(buf));
 }
 
@@ -1923,12 +1921,12 @@ int xtables_ip6mask_to_cidr(const struct in6_addr *k)
 
 const char *xtables_ip6mask_to_numeric(const struct in6_addr *addrp)
 {
-	static char buf[50+2];
+	static char buf[INET6_ADDRSTRLEN + 1];
 	int l = xtables_ip6mask_to_cidr(addrp);
 
 	if (l == -1) {
 		strcpy(buf, "/");
-		strcat(buf, xtables_ip6addr_to_numeric(addrp));
+		inet_ntop(AF_INET6, addrp, buf + 1, sizeof(buf) - 1);
 		return buf;
 	}
 	/* we don't want to see "/128" */
-- 
2.43.0

