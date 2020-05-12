Return-Path: <SRS0=em6Q=62=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D21E6C47076
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 May 2020 21:00:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5C5120769
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 May 2020 21:00:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731279AbgELVAl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 May 2020 17:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725938AbgELVAl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 May 2020 17:00:41 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15DC8C061A0C;
        Tue, 12 May 2020 14:00:41 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 65534)
        id CA85158730E9E; Tue, 12 May 2020 23:00:39 +0200 (CEST)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id 8D00458730E99;
        Tue, 12 May 2020 23:00:38 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     zenczykowski@gmail.com
Cc:     maze@google.com, pablo@netfilter.org, fw@strlen.de,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v2] doc: document danger of applying REJECT to INVALID CTs
Date:   Tue, 12 May 2020 23:00:38 +0200
Message-Id: <20200512210038.11447-1-jengelh@inai.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <CANP3RGe3fnCwj5NUxKu4VDcw=_95yNkCiC2Y4L9otJS1Hnyd-g@mail.gmail.com>
References: <CANP3RGe3fnCwj5NUxKu4VDcw=_95yNkCiC2Y4L9otJS1Hnyd-g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---

Simplify the trigger case by dropping mentions of P_3.
New -A commands as proposed.

 extensions/libip6t_REJECT.man | 20 ++++++++++++++++++++
 extensions/libipt_REJECT.man  | 20 ++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/extensions/libip6t_REJECT.man b/extensions/libip6t_REJECT.man
index 0030a51f..cc845e6f 100644
--- a/extensions/libip6t_REJECT.man
+++ b/extensions/libip6t_REJECT.man
@@ -30,3 +30,23 @@ TCP RST packet to be sent back.  This is mainly useful for blocking
 hosts (which won't accept your mail otherwise).
 \fBtcp\-reset\fP
 can only be used with kernel versions 2.6.14 or later.
+.PP
+\fIWarning:\fP You should not indiscrimnately apply the REJECT target to
+packets whose connection state is classified as INVALID; instead, you should
+only DROP these.
+.PP
+Consider a source host transmitting a packet P, with P experiencing so much
+delay along its path that the source host issues a retransmission, P_2, with
+P_2 being succesful in reaching its destination and advancing the connection
+state normally. It is conceivable that the late-arriving P may be considered to
+be not associated with any connection tracking entry. Generating a reject
+packet for this packet would then terminate the healthy connection.
+.PP
+So, instead of:
+.PP
+-A INPUT ... -j REJECT
+.PP
+do consider using:
+.PP
+-A INPUT ... -m conntrack --ctstate INVALID -j DROP
+-A INPUT ... -j REJECT
diff --git a/extensions/libipt_REJECT.man b/extensions/libipt_REJECT.man
index 8a360ce7..08a1955c 100644
--- a/extensions/libipt_REJECT.man
+++ b/extensions/libipt_REJECT.man
@@ -30,3 +30,23 @@ TCP RST packet to be sent back.  This is mainly useful for blocking
 hosts (which won't accept your mail otherwise).
 .IP
 (*) Using icmp\-admin\-prohibited with kernels that do not support it will result in a plain DROP instead of REJECT
+.PP
+\fIWarning:\fP You should not indiscrimnately apply the REJECT target to
+packets whose connection state is classified as INVALID; instead, you should
+only DROP these.
+.PP
+Consider a source host transmitting a packet P, with P experiencing so much
+delay along its path that the source host issues a retransmission, P_2, with
+P_2 being succesful in reaching its destination and advancing the connection
+state normally. It is conceivable that the late-arriving P may be considered to
+be not associated with any connection tracking entry. Generating a reject
+packet for this packet would then terminate the healthy connection.
+.PP
+So, instead of:
+.PP
+-A INPUT ... -j REJECT
+.PP
+do consider using:
+.PP
+-A INPUT ... -m conntrack --ctstate INVALID -j DROP
+-A INPUT ... -j REJECT
-- 
2.26.2

