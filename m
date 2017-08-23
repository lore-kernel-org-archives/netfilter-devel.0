From: Stijn Tintel <stijn@linux-ipv6.be>
Subject: [PATCH conntrack-tools] conntrackd: cthelper: ssdp: fix build with musl
Date: Wed, 23 Aug 2017 10:29:28 +0300
Message-ID: <20170823072928.18380-1-stijn@linux-ipv6.be>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tintel.eu ([62.213.201.86]:43328 "EHLO mail.tintel.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753329AbdHWHfj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Aug 2017 03:35:39 -0400
Received: from localhost (localhost [IPv6:::1])
        by mail.tintel.eu (Postfix) with ESMTP id 1FC122A4472
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Aug 2017 09:35:37 +0200 (CEST)
Received: from mail.tintel.eu ([IPv6:::1])
        by localhost (mail.tintel.eu [IPv6:::1]) (amavisd-new, port 10024)
        with ESMTP id ZxjnP9rxAZxX for <netfilter-devel@vger.kernel.org>;
        Wed, 23 Aug 2017 09:35:36 +0200 (CEST)
Received: from localhost (localhost [IPv6:::1])
        by mail.tintel.eu (Postfix) with ESMTP id 951832A4472
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Aug 2017 09:31:36 +0200 (CEST)
Received: from mail.tintel.eu ([IPv6:::1])
        by localhost (mail.tintel.eu [IPv6:::1]) (amavisd-new, port 10024)
        with ESMTP id e9hSOEWf1vwX for <netfilter-devel@vger.kernel.org>;
        Wed, 23 Aug 2017 09:31:36 +0200 (CEST)
Received: from localhost (localhost [IPv6:::1])
        by mail.tintel.eu (Postfix) with ESMTP id 213462A4472
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Aug 2017 09:29:31 +0200 (CEST)
Received: from mail.tintel.eu ([IPv6:::1])
        by localhost (mail.tintel.eu [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id 3b23AcS40lz8 for <netfilter-devel@vger.kernel.org>;
        Wed, 23 Aug 2017 09:29:30 +0200 (CEST)
Received: from localhost (localhost [IPv6:::1])
        by mail.tintel.eu (Postfix) with ESMTP id A433A2A4474
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Aug 2017 09:29:30 +0200 (CEST)
Received: from mail.tintel.eu ([IPv6:::1])
        by localhost (mail.tintel.eu [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id 4Ug1763UcZbz for <netfilter-devel@vger.kernel.org>;
        Wed, 23 Aug 2017 09:29:30 +0200 (CEST)
Received: from taz (unknown [IPv6:2001:67c:21bc:24::adb])
        (Authenticated sender: stijn@linux-ipv6.be)
        by mail.tintel.eu (Postfix) with ESMTPSA id ED5242A4472
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Aug 2017 09:29:28 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

For musl libc to expose the members of `struct tcphdr`, _GNU_SOURCE
needs to be defined.

Fixes: b61c4543cbde ("conntrackd: cthelper: ssdp: Track UPnP eventing")
Signed-off-by: Stijn Tintel <stijn@linux-ipv6.be>
---
 src/helpers/ssdp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/helpers/ssdp.c b/src/helpers/ssdp.c
index 1f7f76f..58658e3 100644
--- a/src/helpers/ssdp.c
+++ b/src/helpers/ssdp.c
@@ -49,6 +49,7 @@
 #include <stdlib.h>
 #include <arpa/inet.h>
 #include <netinet/ip.h>
+#define _GNU_SOURCE
 #include <netinet/tcp.h>
 #include <netinet/udp.h>
 #include <libmnl/libmnl.h>
-- 
2.13.5

