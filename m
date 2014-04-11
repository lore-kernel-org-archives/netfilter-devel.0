From: Mariusz Mazur <mmazur@axeos.com>
Subject: [PATCH] ebtables printing of ipv6 masks
Date: Fri, 11 Apr 2014 15:28:41 +0200
Message-ID: <201404111528.42153.mmazur@axeos.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_K4+RT6VivjEp3Pq"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from srv.axeos.nl ([83.98.196.54]:35030 "EHLO srv.axeos.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756612AbaDKNf2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Apr 2014 09:35:28 -0400
Received: from localhost (localhost [127.0.0.1])
	by localhost.srv.axeos.nl (Postfix) with ESMTP id 740F5140F5
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Apr 2014 15:29:04 +0200 (CEST)
Received: from srv.axeos.nl ([127.0.0.1])
	by localhost (srv.axeos.nl [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jZI8Cmy25VTh for <netfilter-devel@vger.kernel.org>;
	Fri, 11 Apr 2014 15:28:43 +0200 (CEST)
Received: from mmaszyna.localnet (vpn.axeos.nl [83.98.196.63])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by srv.axeos.nl (Postfix) with ESMTPSA
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Apr 2014 15:28:43 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--Boundary-00=_K4+RT6VivjEp3Pq
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Currently ebtables is smart enough to not print /255.255.255.255 for ipv4 
addresses, not so however for ipv6 addresses. The attached patch fixes that.

(Not sure my kmail won't mangle it, so here it is uploaded: 
http://u.42.pl/2T8O )

--mmazur

--Boundary-00=_K4+RT6VivjEp3Pq
Content-Type: text/x-patch;
  charset="us-ascii";
  name="ipv6_netmask_printing_fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ipv6_netmask_printing_fix.patch"

diff --git a/extensions/ebt_ip6.c b/extensions/ebt_ip6.c
index 0465e77..52a8448 100644
--- a/extensions/ebt_ip6.c
+++ b/extensions/ebt_ip6.c
@@ -445,14 +445,14 @@ static void print(const struct ebt_u_entry *entry,
 		if (ipinfo->invflags & EBT_IP6_SOURCE)
 			printf("! ");
 		printf("%s", ebt_ip6_to_numeric(&ipinfo->saddr));
-		printf("/%s ", ebt_ip6_to_numeric(&ipinfo->smsk));
+		printf("%s ", ebt_ip6_mask_to_string(&ipinfo->smsk));
 	}
 	if (ipinfo->bitmask & EBT_IP6_DEST) {
 		printf("--ip6-dst ");
 		if (ipinfo->invflags & EBT_IP6_DEST)
 			printf("! ");
 		printf("%s", ebt_ip6_to_numeric(&ipinfo->daddr));
-		printf("/%s ", ebt_ip6_to_numeric(&ipinfo->dmsk));
+		printf("%s ", ebt_ip6_mask_to_string(&ipinfo->smsk));
 	}
 	if (ipinfo->bitmask & EBT_IP6_TCLASS) {
 		printf("--ip6-tclass ");
diff --git a/include/ebtables_u.h b/include/ebtables_u.h
index ab615c1..35a5bcc 100644
--- a/include/ebtables_u.h
+++ b/include/ebtables_u.h
@@ -303,6 +303,7 @@ char *ebt_mask_to_dotted(uint32_t mask);
 void ebt_parse_ip6_address(char *address, struct in6_addr *addr, 
 						   struct in6_addr *msk);
 char *ebt_ip6_to_numeric(const struct in6_addr *addrp);
+char *ebt_ip6_mask_to_string(const struct in6_addr *msk);
 
 
 int do_command(int argc, char *argv[], int exec_style,
diff --git a/useful_functions.c b/useful_functions.c
index d20b68e..2f73589 100644
--- a/useful_functions.c
+++ b/useful_functions.c
@@ -411,3 +411,16 @@ char *ebt_ip6_to_numeric(const struct in6_addr *addrp)
 	static char buf[50+1];
 	return (char *)inet_ntop(AF_INET6, addrp, buf, sizeof(buf));
 }
+
+char *ebt_ip6_mask_to_string(const struct in6_addr *msk)
+{
+   	/* /0000:0000:0000:0000:0000:000.000.000.000
+	 * /0000:0000:0000:0000:0000:0000:0000:0000 */
+	static char buf[51+1];
+	if (msk->s6_addr32[0] == 0xFFFFFFFFL && msk->s6_addr32[1] == 0xFFFFFFFFL &&
+			msk->s6_addr32[2] == 0xFFFFFFFFL && msk->s6_addr32[3] == 0xFFFFFFFFL)
+		*buf = '\0';
+	else
+		sprintf(buf, "/%s", ebt_ip6_to_numeric(msk));
+	return buf;
+}

--Boundary-00=_K4+RT6VivjEp3Pq--
