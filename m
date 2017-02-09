From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next] netfilter: update MAINTAINERS
Date: Thu,  9 Feb 2017 17:55:54 +0100
Message-ID: <1486659354-10128-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47850 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932082AbdBIRTH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Feb 2017 12:19:07 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 79B49137B88
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Feb 2017 17:56:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6BA26DA846
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Feb 2017 17:56:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 816CBDA846
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Feb 2017 17:55:59 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It's been a while since Patrick has been suspended as coreteam member [1].
Update this file to remove him.

While at this, remove references to all foo-tables variants, given the
project hosts more than just that, eg. ipset, conntrack, ...

[1] https://marc.info/?l=netfilter-devel&m=146887464512702

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 MAINTAINERS | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3960e7faaa99..694d434ff0b8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8566,9 +8566,8 @@ F:	Documentation/networking/s2io.txt
 F:	Documentation/networking/vxge.txt
 F:	drivers/net/ethernet/neterion/
 
-NETFILTER ({IP,IP6,ARP,EB,NF}TABLES)
+NETFILTER
 M:	Pablo Neira Ayuso <pablo@netfilter.org>
-M:	Patrick McHardy <kaber@trash.net>
 M:	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
 L:	netfilter-devel@vger.kernel.org
 L:	coreteam@netfilter.org
-- 
2.1.4

