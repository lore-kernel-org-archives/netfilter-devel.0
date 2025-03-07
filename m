Received: from smtpdh20-2.aruba.it (smtpdh20-2.aruba.it [62.149.155.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E7C219EB8
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Mar 2025 13:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.155.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741354935; cv=none; b=dvLh8CqzcmpI8MhwYPxIidGPNhm4MjiPoi+ZCW6XBChvsw9sq23oT3Q3qQp/v7U1RS2mTRcDFFsBLswvtTnTCLBtBIkJ7ROJ4a3xjbI9WtUzJfz3/zdtDlYl9+a0lFehOcPRVtfUJbgPLfe0o+zP55eAYrdKvTXifFDEEpCgiz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741354935; c=relaxed/simple;
	bh=Wy8mIN84K72GMSXdhAypeO+6QNUYHqt6ip8SIAkdv8w=;
	h=Message-ID:Subject:From:To:Date:Content-Type:Mime-Version; b=hNsV/aH5QE3GOccmC6cZ/5a28vOBb/fsfNS+5PIvFNvAgkaAeSbMLq9udmmr//BsObgScV2pSWzWPegGyxHOe+IaLS3YdiRDmTgETqK9wJhenhgL09JFbNKduMczP+TDO73Z8Jh5uyQ/a+sSfgbdRZIZvUR9qT/zEqDShQ3W/Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trentalancia.com; spf=pass smtp.mailfrom=trentalancia.com; dkim=temperror (0-bit key) header.d=aruba.it header.i=@aruba.it header.b=PN/Y9acN; arc=none smtp.client-ip=62.149.155.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trentalancia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trentalancia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror (0-bit key) header.d=aruba.it header.i=@aruba.it header.b="PN/Y9acN"
Received: from [192.168.43.2] ([109.54.139.178])
	by Aruba SMTP with ESMTPSA
	id qXxotlBWMqg4pqXxotKZhK; Fri, 07 Mar 2025 14:42:09 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1741354929; bh=Wy8mIN84K72GMSXdhAypeO+6QNUYHqt6ip8SIAkdv8w=;
	h=Subject:From:To:Date:Content-Type:Mime-Version;
	b=PN/Y9acNzdwQnNv2ADBu4Zq5SqoWAGtmJHIu/XCHWj+d6IsPu++zKtp6QKGBPbRYr
	 iP4I5dbU6/om2q5RETFEgejvdC9a4l+yxJSIGv13/ufEib9SCysb/z7G52L6G8Mj1u
	 629rrVWHPG64o9Tlx8dOT8JsDIaj2/XUGyzeZRHYhq6V6siyPwo1g1ifVwbrSPDySX
	 jOC/xORjCU0hP92tVcz+oWFqDUaXuG1JBsgsf0ChRkgXiVb9RBl62ZtnmBVfNVpjay
	 epNU3lAvbeIzmchSedo8vIIsxwbKJj8TuJlsEX8JWbbWcqbNXCykHIVV9ewBa6UZbd
	 VjZFIjTZUBcow==
Message-ID: <1741354928.22595.4.camel@trentalancia.com>
Subject: [PATCH iptables]: xtables: tolerate DNS lookup failures
From: Guido Trentalancia <guido@trentalancia.com>
To: netfilter-devel@vger.kernel.org
Date: Fri, 07 Mar 2025 14:42:08 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfHGFxZ2pZUIwE3/c88FSoosDSWzA7FNtEzKv9q/vDtDVSZC4OrQy9n2f62K+n/KZjzJvATshbr1HJK2oqctC5UmatUwtXtqZmYhgiVVCJ792T73gvLyl
 zfT13HXkCvMbRrft1NBNviv6I05YCpdSJgfmmdzRKysReftTuPU4jl4rPv1uSZFHRRdue8dVr+TJOT4kqdYvkeqEPGT4MAyOrNo=

libxtables: tolerate DNS lookup failures

Do not abort on DNS lookup failure, just skip the
rule and keep processing the rest of the rules.

This is particularly useful, for example, when
iptables-restore is called at system bootup
before the network is up and the DNS can be
reached.

Signed-off-by: Guido Trentalancia <guido@trentalancia.com>
---
 libxtables/xtables.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -pru iptables-1.8.9-orig/libxtables/xtables.c iptables-1.8.9-new/libxtables/xtables.c
--- iptables-1.8.9-orig/libxtables/xtables.c	2023-01-12 11:27:35.000000000 +0100
+++ iptables-1.8.9-new/libxtables/xtables.c	2025-03-07 14:03:35.907011754 +0100
@@ -1710,7 +1710,8 @@ ipparse_hostnetwork(const char *name, un
 	if ((addrptmp = host_to_ipaddr(name, naddrs)) != NULL)
 		return addrptmp;
 
-	xt_params->exit_err(PARAMETER_PROBLEM, "host/network `%s' not found", name);
+	fprintf(stderr, "host/network `%s' not found - skipping rule\n", name);
+	return NULL;
 }
 
 static struct in_addr *parse_ipmask(const char *mask)
@@ -1788,6 +1789,8 @@ void xtables_ipparse_multiple(const char
 			strcpy(buf, "0.0.0.0");
 
 		addrp = ipparse_hostnetwork(buf, &n);
+		if (addrp == NULL)
+			continue;
 		if (n > 1) {
 			count += n - 1;
 			*addrpp = xtables_realloc(*addrpp,
@@ -1847,6 +1850,8 @@ void xtables_ipparse_any(const char *nam
 		strcpy(buf, "0.0.0.0");
 
 	addrp = *addrpp = ipparse_hostnetwork(buf, naddrs);
+	if (addrp == NULL)
+		return;
 	n = *naddrs;
 	for (i = 0, j = 0; i < n; ++i) {
 		addrp[j++].s_addr &= maskp->s_addr;
@@ -2005,7 +2010,8 @@ ip6parse_hostnetwork(const char *name, u
 	if ((addrp = host_to_ip6addr(name, naddrs)) != NULL)
 		return addrp;
 
-	xt_params->exit_err(PARAMETER_PROBLEM, "host/network `%s' not found", name);
+	fprintf(stderr, "host/network `%s' not found - skipping rule\n", name);
+	return NULL;
 }
 
 static struct in6_addr *parse_ip6mask(char *mask)
@@ -2084,6 +2090,8 @@ xtables_ip6parse_multiple(const char *na
 			strcpy(buf, "::");
 
 		addrp = ip6parse_hostnetwork(buf, &n);
+		if (addrp == NULL)
+			continue;
 		if (n > 1) {
 			count += n - 1;
 			*addrpp = xtables_realloc(*addrpp,
@@ -2137,6 +2145,8 @@ void xtables_ip6parse_any(const char *na
 		strcpy(buf, "::");
 
 	addrp = *addrpp = ip6parse_hostnetwork(buf, naddrs);
+	if (addrp == NULL)
+		return;
 	n = *naddrs;
 	for (i = 0, j = 0; i < n; ++i) {
 		for (k = 0; k < 4; ++k)
