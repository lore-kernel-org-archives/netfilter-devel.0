Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34019C47089
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 May 2021 22:34:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10A5E611C9
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 May 2021 22:34:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235474AbhE0Wfc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 May 2021 18:35:32 -0400
Received: from mail.netfilter.org ([217.70.188.207]:42032 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233203AbhE0Wfc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 May 2021 18:35:32 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id DA9B9643DF
        for <netfilter-devel@vger.kernel.org>; Fri, 28 May 2021 00:32:55 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH conntrackd] doc: manual: Document userspace helper configuration at daemon startup
Date:   Fri, 28 May 2021 00:33:41 +0200
Message-Id: <20210527223341.28274-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210527223341.28274-1-pablo@netfilter.org>
References: <20210527223341.28274-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Describe how to configure conntrackd using the new simple setup approach.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/manual/conntrack-tools.tmpl | 42 ++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/doc/manual/conntrack-tools.tmpl b/doc/manual/conntrack-tools.tmpl
index 64ac5dd54690..822dd496747a 100644
--- a/doc/manual/conntrack-tools.tmpl
+++ b/doc/manual/conntrack-tools.tmpl
@@ -905,32 +905,13 @@ maintainance.</para></listitem>
 <para>The following steps describe how to enable the RPC portmapper helper for NFSv3 (this is similar for other helpers):</para>
 
 <orderedlist>
-<listitem><para>Register user-space helper:
-
-<programlisting>
-nfct add helper rpc inet udp
-nfct add helper rpc inet tcp
-</programlisting>
-
-This registers the portmapper helper for both UDP and TCP (NFSv3 traffic goes both over TCP and UDP).
-</para></listitem>
-
-<listitem><para>Add iptables rule using the CT target:
-
-<programlisting>
-# iptables -I OUTPUT -t raw -p udp --dport 111 -j CT --helper rpc
-# iptables -I OUTPUT -t raw -p tcp --dport 111 -j CT --helper rpc
-</programlisting>
-
-With this, packets matching port TCP/UDP/111 are passed to user-space for
-inspection. If there is no instance of conntrackd configured to support
-user-space helpers, no inspection happens and packets are not sent to
-user-space.</para></listitem>
 
 <listitem><para>Add configuration to conntrackd.conf:
 
 <programlisting>
 Helper {
+        Setup yes
+
         Type rpc inet udp {
                 QueueNum 1
 		QueueLen 10240
@@ -962,6 +943,25 @@ for inspection to user-space</para>
 
 </listitem>
 
+<listitem><para>Run conntrackd:
+<programlisting>
+# conntrackd -d -C /path/to/conntrackd.conf
+</programlisting>
+</para>
+</listitem>
+
+<listitem><para>Add iptables rule using the CT target:
+
+<programlisting>
+# iptables -I OUTPUT -t raw -p udp --dport 111 -j CT --helper rpc
+# iptables -I OUTPUT -t raw -p tcp --dport 111 -j CT --helper rpc
+</programlisting>
+
+With this, packets matching port TCP/UDP/111 are passed to user-space for
+inspection. If there is no instance of conntrackd configured to support
+user-space helpers, no inspection happens and packets are not sent to
+user-space.</para></listitem>
+
 </orderedlist>
 
 <para>Now you can test this (assuming you have some working NFSv3 setup) with:
-- 
2.30.2

