From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ipset-5: 7/9] Add parser function to handle IPv4 and IPv6 differently.
Date: Tue,  2 Nov 2010 15:35:32 +0100
Message-ID: <1288708534-14510-8-git-send-email-kadlec@blackhole.kfki.hu>
References: <1288708534-14510-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1288708534-14510-2-git-send-email-kadlec@blackhole.kfki.hu>
 <1288708534-14510-3-git-send-email-kadlec@blackhole.kfki.hu>
 <1288708534-14510-4-git-send-email-kadlec@blackhole.kfki.hu>
 <1288708534-14510-5-git-send-email-kadlec@blackhole.kfki.hu>
 <1288708534-14510-6-git-send-email-kadlec@blackhole.kfki.hu>
 <1288708534-14510-7-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------1.7.0.4"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:33596 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959Ab0KBOfg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Nov 2010 10:35:36 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 547E11F4131
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Nov 2010 15:35:35 +0100 (CET)
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WCq0-0RIi9ni for <netfilter-devel@vger.kernel.org>;
	Tue,  2 Nov 2010 15:35:35 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.0.114])
	by smtp2.kfki.hu (Postfix) with ESMTP id 2EC451F4138
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Nov 2010 15:35:35 +0100 (CET)
In-Reply-To: <1288708534-14510-7-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------1.7.0.4
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit


At present IPv6 does not support adding/deleting multiple IPv6 addresses
specified as an ip-ip range or ip/prefix block. A parser function is
added by which can enforce it at parsing the address pattern.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/libipset/parse.h |    2 ++
 lib/parse.c              |   40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+), 0 deletions(-)


--------------1.7.0.4
Content-Type: text/x-patch; name="0007-Add-parser-function-to-handle-IPv4-and-IPv6-differen.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline; filename="0007-Add-parser-function-to-handle-IPv4-and-IPv6-differen.patch"

diff --git a/include/libipset/parse.h b/include/libipset/parse.h
index aaa1577..2e3f8a8 100644
--- a/include/libipset/parse.h
+++ b/include/libipset/parse.h
@@ -54,6 +54,8 @@ extern int ipset_parse_iprange(struct ipset_session *session,
 			       enum ipset_opt opt, const char *str);
 extern int ipset_parse_ipnet(struct ipset_session *session,
 			     enum ipset_opt opt, const char *str);
+extern int ipset_parse_ip4_single6(struct ipset_session *session,
+				enum ipset_opt opt, const char *str);
 extern int ipset_parse_name(struct ipset_session *session,
                             enum ipset_opt opt, const char *str);
 extern int ipset_parse_before(struct ipset_session *session,
diff --git a/lib/parse.c b/lib/parse.c
index 28192d8..08e3d7c 100644
--- a/lib/parse.c
+++ b/lib/parse.c
@@ -904,6 +904,46 @@ ipset_parse_ipnet(struct ipset_session *session,
 }
 
 /**
+ * ipset_parse_ip4_single6 - parse IPv4 address, range or netblock or IPv6 address
+ * @session: session structure
+ * @opt: option kind of the data
+ * @str: string to parse
+ *
+ * Parse string as an IPv4 address or address range
+ * or netblock or and IPv6 address. Hostnames are resolved. If family
+ * is not set yet in the data blob, INET is assumed.
+ * The values are stored in the data blob of the session.
+ *
+ * FIXME: if the hostname resolves to multiple addresses,
+ * the first one is used only.
+ *
+ * Returns 0 on success or a negative error code.
+ */
+int
+ipset_parse_ip4_single6(struct ipset_session *session,
+			enum ipset_opt opt, const char *str)
+{
+	struct ipset_data *data;
+	uint8_t family;
+
+	assert(session);
+	assert(opt == IPSET_OPT_IP || opt == IPSET_OPT_IP2);
+	assert(str);
+	
+	data = ipset_session_data(session);
+	family = ipset_data_family(data);
+	
+	if (family == AF_UNSPEC) {
+		family = AF_INET;
+		ipset_data_set(data, IPSET_OPT_FAMILY, &family);
+	}
+	
+	return family == AF_INET ? ipset_parse_ip(session, opt, str)
+				 : ipset_parse_single_ip(session, opt, str);
+
+}
+
+/**
  * ipset_parse_iptimeout - parse IPv4|IPv6 address and timeout
  * @session: session structure
  * @opt: option kind of the data

--------------1.7.0.4--


