Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85F2AC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Mar 2022 15:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348475AbiC3QBI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Mar 2022 12:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343762AbiC3QBH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Mar 2022 12:01:07 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA3643ED35
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Mar 2022 08:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8U1Zyq6vZ03PFJPD2OLHRqwBxSyQrZLchy7HJ45Peow=; b=mntOIfpIx7OJrbkB8x3gTGKumF
        ox+sSDfMZgAjrWVda/4IyruB7njtjT6forg4Eg/rwgx97joAhe+7u51LCfXGK+LBIoUUTXvQeKuWr
        yuewCGbN8I6tG0UPxzFzijaDgiX4akQTirtaEKcl2erm019EFf9hcKlEaxaonn1ekOeETF+7w+91B
        GLmaKrPZjPKmRTYt/ntqLVNac39IaGxggwzGNtHsNoPRNyviJbqfNlSXUhTi/GZBN4skKbqVyLcp4
        HrQLefz41rSI0JSsExk7ywaF/0obWsEol3WCnHfcOSDTMFd2DH5lo+iuCPxdc9+Rv++vf5rb6G81P
        l9NperLA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nZajA-0004XR-5k; Wed, 30 Mar 2022 17:59:20 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 9/9] extensions: DNAT: Support service names in all spots
Date:   Wed, 30 Mar 2022 17:58:51 +0200
Message-Id: <20220330155851.13249-10-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330155851.13249-1-phil@nwl.cc>
References: <20220330155851.13249-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When parsing (parts of) a port spec, if it doesn't start with a digit,
try to find the largest substring getservbyname() accepts.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libipt_DNAT.t    |  4 +++
 extensions/libxt_DNAT.c     | 70 +++++++++++++++++++++++++++----------
 extensions/libxt_REDIRECT.t |  2 ++
 3 files changed, 58 insertions(+), 18 deletions(-)

diff --git a/extensions/libipt_DNAT.t b/extensions/libipt_DNAT.t
index eb187bc91053b..c744dff3ec902 100644
--- a/extensions/libipt_DNAT.t
+++ b/extensions/libipt_DNAT.t
@@ -15,4 +15,8 @@
 -p tcp -j DNAT --to-destination 1.1.1.1:1000-2000/65536;;FAIL
 -p tcp -j DNAT --to-destination 1.1.1.1:ssh;-p tcp -j DNAT --to-destination 1.1.1.1:22;OK
 -p tcp -j DNAT --to-destination 1.1.1.1:ftp-data;-p tcp -j DNAT --to-destination 1.1.1.1:20;OK
+-p tcp -j DNAT --to-destination 1.1.1.1:ftp-data-ssh;-p tcp -j DNAT --to-destination 1.1.1.1:20-22;OK
+-p tcp -j DNAT --to-destination 1.1.1.1:echo-ftp-data;-p tcp -j DNAT --to-destination 1.1.1.1:7-20;OK
+-p tcp -j DNAT --to-destination 1.1.1.1:ftp-data-ssh/echo;-p tcp -j DNAT --to-destination 1.1.1.1:20-22/7;OK
+-p tcp -j DNAT --to-destination 1.1.1.1:echo-ftp-data/ssh;-p tcp -j DNAT --to-destination 1.1.1.1:7-20/22;OK
 -j DNAT;;FAIL
diff --git a/extensions/libxt_DNAT.c b/extensions/libxt_DNAT.c
index 754e244e0dbe6..70d2823568c7d 100644
--- a/extensions/libxt_DNAT.c
+++ b/extensions/libxt_DNAT.c
@@ -77,6 +77,49 @@ static const struct xt_option_entry REDIRECT_opts[] = {
 	XTOPT_TABLEEND,
 };
 
+static char *strrchrs(const char *s, const char *chrs)
+{
+	int i;
+
+	for (i = strlen(s) - 1; i >= 0; i--) {
+		if (strchr(chrs, s[i]))
+			return (char *)s + i;
+	}
+	return NULL;
+}
+
+static bool parse_port(const char *orig_s, char **end, unsigned int *value,
+		       unsigned int min, unsigned int max)
+{
+	char *s, *pos;
+	int port;
+
+	if (xtables_strtoui(orig_s, end, value, min, max))
+		return true;
+
+	s = xtables_strdup(orig_s);
+	port = xtables_service_to_port(s, NULL);
+	if (port >= min && port <= max)
+		goto found;
+
+	pos = strrchrs(s, "-:/");
+	while (pos) {
+		*pos = '\0';
+		port = xtables_service_to_port(s, NULL);
+		if (port >= min && port <= max)
+			goto found;
+
+		pos = strrchrs(s, "-:/");
+	}
+	free(s);
+	return false;
+found:
+	*end = (char *)orig_s + strlen(s);
+	*value = port;
+	free(s);
+	return true;
+}
+
 /* Parses ports */
 static void
 parse_ports(const char *arg, bool portok, struct nf_nat_range2 *range)
@@ -90,12 +133,9 @@ parse_ports(const char *arg, bool portok, struct nf_nat_range2 *range)
 
 	range->flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
 
-	if (!xtables_strtoui(arg, &end, &port, 1, UINT16_MAX)) {
-		port = xtables_service_to_port(arg, NULL);
-		if (port == (unsigned)-1)
-			xtables_error(PARAMETER_PROBLEM,
-				      "Port `%s' not valid", arg);
-	}
+	if (!parse_port(arg, &end, &port, 1, UINT16_MAX))
+		xtables_error(PARAMETER_PROBLEM,
+			      "Port `%s' not valid", arg);
 
 	switch (*end) {
 	case '\0':
@@ -114,12 +154,9 @@ parse_ports(const char *arg, bool portok, struct nf_nat_range2 *range)
 			      "Garbage after port value: `%s'", end);
 	}
 
-	if (!xtables_strtoui(arg, &end, &maxport, 1, UINT16_MAX)) {
-		maxport = xtables_service_to_port(arg, NULL);
-		if (maxport == (unsigned)-1)
-			xtables_error(PARAMETER_PROBLEM,
-				      "Port `%s' not valid", arg);
-	}
+	if (!parse_port(arg, &end, &maxport, 1, UINT16_MAX))
+		xtables_error(PARAMETER_PROBLEM,
+			      "Port `%s' not valid", arg);
 	if (maxport < port)
 		/* People are stupid. */
 		xtables_error(PARAMETER_PROBLEM,
@@ -139,12 +176,9 @@ parse_ports(const char *arg, bool portok, struct nf_nat_range2 *range)
 			      "Garbage after port range: `%s'", end);
 	}
 
-	if (!xtables_strtoui(arg, &end, &baseport, 1, UINT16_MAX)) {
-		baseport = xtables_service_to_port(arg, NULL);
-		if (baseport == (unsigned)-1)
-			xtables_error(PARAMETER_PROBLEM,
-				      "Port `%s' not valid", arg);
-	}
+	if (!parse_port(arg, &end, &baseport, 1, UINT16_MAX))
+		xtables_error(PARAMETER_PROBLEM,
+			      "Port `%s' not valid", arg);
 
 	range->flags |= NF_NAT_RANGE_PROTO_OFFSET;
 	range->base_proto.tcp.port = htons(baseport);
diff --git a/extensions/libxt_REDIRECT.t b/extensions/libxt_REDIRECT.t
index 3f0b8a6000445..a50ef257ec956 100644
--- a/extensions/libxt_REDIRECT.t
+++ b/extensions/libxt_REDIRECT.t
@@ -6,4 +6,6 @@
 -p tcp -j REDIRECT --to-ports 42-1234/567;;FAIL
 -p tcp -j REDIRECT --to-ports ssh;-p tcp -j REDIRECT --to-ports 22;OK
 -p tcp -j REDIRECT --to-ports ftp-data;-p tcp -j REDIRECT --to-ports 20;OK
+-p tcp -j REDIRECT --to-ports ftp-data-ssh;-p tcp -j REDIRECT --to-ports 20-22;OK
+-p tcp -j REDIRECT --to-ports echo-ftp-data;-p tcp -j REDIRECT --to-ports 7-20;OK
 -j REDIRECT --to-ports 42;;FAIL
-- 
2.34.1

