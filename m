Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 922B0C25B70
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Oct 2023 08:55:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344784AbjJZIzW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Oct 2023 04:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234947AbjJZIzT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Oct 2023 04:55:19 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9E21B8
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Oct 2023 01:55:12 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 65534)
        id C214B587266A7; Thu, 26 Oct 2023 10:55:08 +0200 (CEST)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id B761C58726694;
        Thu, 26 Oct 2023 10:55:06 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH 08/10] man: use native bullet point markup
Date:   Thu, 26 Oct 2023 10:55:04 +0200
Message-ID: <20231026085506.94343-8-jengelh@inai.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231026085506.94343-1-jengelh@inai.de>
References: <20231026085506.94343-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Replace some "fake" bullet point by the official syntax/markup
for bulleted lists.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/libxt_connlimit.man | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/extensions/libxt_connlimit.man b/extensions/libxt_connlimit.man
index 980bf6c5..aa7df2b2 100644
--- a/extensions/libxt_connlimit.man
+++ b/extensions/libxt_connlimit.man
@@ -20,23 +20,28 @@ Apply the limit onto the source group. This is the default if
 Apply the limit onto the destination group.
 .PP
 Examples:
-.TP
-# allow 2 telnet connections per client host
+.IP \(bu 4
+allow 2 telnet connections per client host:
+.br
 iptables \-A INPUT \-p tcp \-\-syn \-\-dport 23 \-m connlimit \-\-connlimit\-above 2 \-j REJECT
-.TP
-# you can also match the other way around:
+.IP \(bu 4
+you can also match the other way around:
+.br
 iptables \-A INPUT \-p tcp \-\-syn \-\-dport 23 \-m connlimit \-\-connlimit\-upto 2 \-j ACCEPT
-.TP
-# limit the number of parallel HTTP requests to 16 per class C sized \
-source network (24 bit netmask)
+.IP \(bu 4
+limit the number of parallel HTTP requests to 16 per class C sized \
+source network (24 bit netmask):
+.br
 iptables \-p tcp \-\-syn \-\-dport 80 \-m connlimit \-\-connlimit\-above 16
 \-\-connlimit\-mask 24 \-j REJECT
-.TP
-# limit the number of parallel HTTP requests to 16 for the link local network
-(IPv6)
+.IP \(bu 4
+limit the number of parallel HTTP requests to 16 for the link local network
+(IPv6):
+.br
 ip6tables \-p tcp \-\-syn \-\-dport 80 \-s fe80::/64 \-m connlimit \-\-connlimit\-above
 16 \-\-connlimit\-mask 64 \-j REJECT
-.TP
-# Limit the number of connections to a particular host:
+.IP \(bu 4
+Limit the number of connections to a particular host:
+.br
 ip6tables \-p tcp \-\-syn \-\-dport 49152:65535 \-d 2001:db8::1 \-m connlimit
 \-\-connlimit\-above 100 \-j REJECT
-- 
2.42.0

