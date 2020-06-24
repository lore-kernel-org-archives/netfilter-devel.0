Return-Path: <SRS0=o6T4=AF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2C82C433E1
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Jun 2020 13:30:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98DFD2053B
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Jun 2020 13:30:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403889AbgFXNaP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Jun 2020 09:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389616AbgFXNaN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Jun 2020 09:30:13 -0400
Received: from janet.servers.dxld.at (janet.servers.dxld.at [IPv6:2a01:4f8:201:89f4::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69263C061573
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Jun 2020 06:30:13 -0700 (PDT)
Received: janet.servers.dxld.at; Wed, 24 Jun 2020 15:30:11 +0200
From:   =?UTF-8?q?Daniel=20Gr=C3=B6ber?= <dxld@darkboxed.org>
To:     netfilter-devel@vger.kernel.org
Subject: [libnf_ct PATCH v2 9/9] Fix buffer overflows in __snprintf_protoinfo* like in *2str fns
Date:   Wed, 24 Jun 2020 15:30:05 +0200
Message-Id: <20200624133005.22046-9-dxld@darkboxed.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200624133005.22046-1-dxld@darkboxed.org>
References: <20200624133005.22046-1-dxld@darkboxed.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Daniel Gröber <dxld@darkboxed.org>
---
 src/conntrack/snprintf_default.c | 54 +++++++++++++++++++++++---------
 1 file changed, 39 insertions(+), 15 deletions(-)

diff --git a/src/conntrack/snprintf_default.c b/src/conntrack/snprintf_default.c
index d18d2f2..467f4a8 100644
--- a/src/conntrack/snprintf_default.c
+++ b/src/conntrack/snprintf_default.c
@@ -15,6 +15,9 @@ static int __snprintf_l3protocol(char *buf,
 {
 	uint8_t num = ct->head.orig.l3protonum;
 
+	if (!test_bit(ATTR_ORIG_L3PROTO, ct->head.set))
+		return -1;
+
 	return snprintf(buf, len, "%-8s %u ", __l3proto2str(num), num);
 }
 
@@ -24,6 +27,9 @@ int __snprintf_protocol(char *buf,
 {
 	uint8_t num = ct->head.orig.protonum;
 
+	if (!test_bit(ATTR_ORIG_L4PROTO, ct->head.set))
+		return -1;
+
 	return snprintf(buf, len, "%-8s %u ", __proto2str(num), num);
 }
 
@@ -38,30 +44,48 @@ static int __snprintf_protoinfo(char *buf,
 				unsigned int len,
 				const struct nf_conntrack *ct)
 {
-	return snprintf(buf, len, "%s ",
-			ct->protoinfo.tcp.state < TCP_CONNTRACK_MAX ?
-			states[ct->protoinfo.tcp.state] :
-			states[TCP_CONNTRACK_NONE]);
+	const char *str = NULL;
+	uint8_t state = ct->protoinfo.tcp.state;
+
+	if (state < ARRAY_SIZE(states))
+		str = states[state];
+
+	if (str == NULL)
+		str = states[TCP_CONNTRACK_NONE];
+
+	return snprintf(buf, len, "%s ", str);
 }
 
 static int __snprintf_protoinfo_sctp(char *buf,
 				     unsigned int len,
 				     const struct nf_conntrack *ct)
 {
-	return snprintf(buf, len, "%s ",
-			ct->protoinfo.sctp.state < SCTP_CONNTRACK_MAX ?
-			sctp_states[ct->protoinfo.sctp.state] :
-			sctp_states[SCTP_CONNTRACK_NONE]);
+	const char *str = NULL;
+	uint8_t state = ct->protoinfo.sctp.state;
+
+	if (state < ARRAY_SIZE(sctp_states))
+		str = sctp_states[state];
+
+	if (str == NULL)
+		str = sctp_states[SCTP_CONNTRACK_NONE];
+
+	return snprintf(buf, len, "%s ", str);
 }
 
 static int __snprintf_protoinfo_dccp(char *buf,
 				     unsigned int len,
 				     const struct nf_conntrack *ct)
 {
-	return snprintf(buf, len, "%s ",
-			ct->protoinfo.dccp.state < DCCP_CONNTRACK_MAX ?
-			sctp_states[ct->protoinfo.dccp.state] :
-			sctp_states[DCCP_CONNTRACK_NONE]);
+	const char *str = NULL;
+	uint8_t state = ct->protoinfo.dccp.state;
+
+	if (state < ARRAY_SIZE(dccp_states))
+		str = dccp_states[state];
+
+	if (str == NULL)
+		str = dccp_states[SCTP_CONNTRACK_NONE];
+
+	return snprintf(buf, len, "%s ", str);
 }
 
 static int __snprintf_address_ipv4(char *buf,
@@ -134,7 +158,7 @@ int __snprintf_address(char *buf,
 	return size;
 }
 
-int __snprintf_proto(char *buf, 
+int __snprintf_proto(char *buf,
 		     unsigned int len,
 		     const struct __nfct_tuple *tuple)
 {
@@ -197,7 +221,7 @@ static int __snprintf_status_not_seen_reply(char *buf,
 					    const struct nf_conntrack *ct)
 {
 	int size = 0;
-	
+
         if (!(ct->status & IPS_SEEN_REPLY))
                 size = snprintf(buf, len, "[UNREPLIED] ");
 
@@ -345,7 +369,7 @@ __snprintf_clabels(char *buf, unsigned int len,
 	return size;
 }
 
-int __snprintf_conntrack_default(char *buf, 
+int __snprintf_conntrack_default(char *buf,
 				 unsigned int len,
 				 const struct nf_conntrack *ct,
 				 unsigned int msg_type,
-- 
2.20.1

