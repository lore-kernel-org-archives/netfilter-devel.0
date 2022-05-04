Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4844C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 May 2022 10:34:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234922AbiEDKiI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 May 2022 06:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbiEDKiH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 May 2022 06:38:07 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077CB1402B
        for <netfilter-devel@vger.kernel.org>; Wed,  4 May 2022 03:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3Fhn/MUFqUcMBcohBa30YTqgUO9oanVp4oyNMNBA0uI=; b=StnTH0EwxIa9zTa6KSCkd8EI1t
        Ub66/4RApcLyPEJLcI/+fB+T25c1iTvXVhAWiToz5K0OMT24t7F0/qjqX6KIgu2I+fqPhjewxvOps
        9VkWnDmTmyINEEm2yTszVypcfVU1qUmzgSCoEwrZE3FEIRQ6rU7c2DcbJ+3t1cFIBnHpKnGaLZjlZ
        IaI0ajUhQ2pkISgMpJiW4fhIxSWwvjyJRU0WKYJpmDe5bALsj347bJt3hGsSmL+qR0PoyJgrTwRSY
        9s+EEOCouc78yPU4bWSvfyroRej6E/4hHja4A9rJ5i+4fglgSb+8kH/C8bIKyJ4Y+a0b+1IXG3/Sc
        09T3gCKw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nmCL0-0008PX-Ds; Wed, 04 May 2022 12:34:30 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/4] man: *NAT: Review --random* option descriptions
Date:   Wed,  4 May 2022 12:34:14 +0200
Message-Id: <20220504103416.19712-3-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220504103416.19712-1-phil@nwl.cc>
References: <20220504103416.19712-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Stating the option again in the first (single?) sentence is pointless.
Get rid of that initial half-sentence in MASQUERADE options and unify
the texts a bit.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_DNAT.man       |  4 +---
 extensions/libxt_MASQUERADE.man | 10 ++--------
 extensions/libxt_REDIRECT.man   |  4 +---
 extensions/libxt_SNAT.man       |  8 ++------
 4 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/extensions/libxt_DNAT.man b/extensions/libxt_DNAT.man
index 12d334af5a479..af9a3f06f6aaf 100644
--- a/extensions/libxt_DNAT.man
+++ b/extensions/libxt_DNAT.man
@@ -25,9 +25,7 @@ For a single port or \fIbaseport\fP, a service name as listed in
 \fB/etc/services\fP may be used.
 .TP
 \fB\-\-random\fP
-If option
-\fB\-\-random\fP
-is used then port mapping will be randomized (kernel >= 2.6.22).
+Randomize source port mapping (kernel >= 2.6.22).
 .TP
 \fB\-\-persistent\fP
 Gives a client the same source-/destination-address for each connection.
diff --git a/extensions/libxt_MASQUERADE.man b/extensions/libxt_MASQUERADE.man
index 7746f4734a31a..26d91ddba6b15 100644
--- a/extensions/libxt_MASQUERADE.man
+++ b/extensions/libxt_MASQUERADE.man
@@ -20,16 +20,10 @@ if the rule also specifies one of the following protocols:
 \fBtcp\fP, \fBudp\fP, \fBdccp\fP or \fBsctp\fP.
 .TP
 \fB\-\-random\fP
-Randomize source port mapping
-If option
-\fB\-\-random\fP
-is used then port mapping will be randomized (kernel >= 2.6.21).
+Randomize source port mapping (kernel >= 2.6.21).
 Since kernel 5.0, \fB\-\-random\fP is identical to \fB\-\-random-fully\fP.
 .TP
 \fB\-\-random-fully\fP
-Full randomize source port mapping
-If option
-\fB\-\-random-fully\fP
-is used then port mapping will be fully randomized (kernel >= 3.13).
+Fully randomize source port mapping (kernel >= 3.13).
 .TP
 IPv6 support available since Linux kernels >= 3.7.
diff --git a/extensions/libxt_REDIRECT.man b/extensions/libxt_REDIRECT.man
index 10305597f87a3..1cbdb9bae988c 100644
--- a/extensions/libxt_REDIRECT.man
+++ b/extensions/libxt_REDIRECT.man
@@ -19,8 +19,6 @@ if the rule also specifies one of the following protocols:
 For a single port, a service name as listed in \fB/etc/services\fP may be used.
 .TP
 \fB\-\-random\fP
-If option
-\fB\-\-random\fP
-is used then port mapping will be randomized (kernel >= 2.6.22).
+Randomize source port mapping (kernel >= 2.6.22).
 .TP
 IPv6 support available starting Linux kernels >= 3.7.
diff --git a/extensions/libxt_SNAT.man b/extensions/libxt_SNAT.man
index 087664471d110..80a698a64738b 100644
--- a/extensions/libxt_SNAT.man
+++ b/extensions/libxt_SNAT.man
@@ -21,14 +21,10 @@ will be mapped to ports below 1024, and other ports will be mapped to
 1024 or above. Where possible, no port alteration will occur.
 .TP
 \fB\-\-random\fP
-If option
-\fB\-\-random\fP
-is used then port mapping will be randomized through a hash-based algorithm (kernel >= 2.6.21).
+Randomize source port mapping through a hash-based algorithm (kernel >= 2.6.21).
 .TP
 \fB\-\-random-fully\fP
-If option
-\fB\-\-random-fully\fP
-is used then port mapping will be fully randomized through a PRNG (kernel >= 3.14).
+Fully randomize source port mapping through a PRNG (kernel >= 3.14).
 .TP
 \fB\-\-persistent\fP
 Gives a client the same source-/destination-address for each connection.
-- 
2.34.1

