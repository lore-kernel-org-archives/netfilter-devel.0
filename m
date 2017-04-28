From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf] netfilter: update MAINTAINERS file
Date: Fri, 28 Apr 2017 16:54:37 +0200
Message-ID: <1493391277-10563-1-git-send-email-pablo@netfilter.org>
Cc: fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51696 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1032294AbdD1Oyr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Apr 2017 10:54:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E317A209932
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Apr 2017 16:54:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D3F0F1850E
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Apr 2017 16:54:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A5D41185C75
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Apr 2017 16:54:36 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Several updates on the MAINTAINERS section for Netfilter:

1) Add Florian Westphal, he's been part of the coreteam since October 2012.
   He's been dedicating tireless efforts to improve the Netfilter codebase,
   fix bugs and push ongoing new developments ever since.

2) Add http://www.nftables.org/ URL, currently pointing to
   http://www.netfilter.org.

3) Update project status from Supported to Maintained.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
@Florian: Let me add some lines on your inclusion, and update other stuff
          I wanted to include/update in the Netfilter section.

 MAINTAINERS | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 38d3e4ed7208..fc95cb06fb29 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8701,14 +8701,16 @@ F:	drivers/net/ethernet/neterion/
 NETFILTER
 M:	Pablo Neira Ayuso <pablo@netfilter.org>
 M:	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+M:	Florian Westphal <fw@strlen.de>
 L:	netfilter-devel@vger.kernel.org
 L:	coreteam@netfilter.org
 W:	http://www.netfilter.org/
 W:	http://www.iptables.org/
+W:	http://www.nftables.org/
 Q:	http://patchwork.ozlabs.org/project/netfilter-devel/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git
-S:	Supported
+S:	Maintained
 F:	include/linux/netfilter*
 F:	include/linux/netfilter/
 F:	include/net/netfilter/
-- 
2.1.4

