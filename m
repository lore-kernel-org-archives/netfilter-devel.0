From: Jan Engelhardt <jengelh@medozas.de>
Subject: ipset: 2.6.39 is fine to have
Date: Fri, 30 Dec 2011 23:13:37 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1112302313090.2804@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:42199 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484Ab1L3WNk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Dec 2011 17:13:40 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Available through git://dev.medozas.de/ipset master.

parent a6899564887b80090d082f3c2fdeaf177e6bd7f1 (v6.10-6-ga689956)
commit 42dc039c7c27d7d6cd1fc381986b1c900852ae57
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Fri Dec 30 23:07:48 2011 +0100

doc: Linux 2.6.39 already has the defs
---
 README |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/README b/README
index e5c0ddf..dd6e66b 100644
--- a/README
+++ b/README
@@ -4,7 +4,7 @@ instructions too.
 
 0. You need the source tree of your kernel (version >= 2.6.34)
    and it have to be configured with ip6tables support enabled,
-   modules compiled. For kernel versions <= 2.6.39 please apply
+   modules compiled. For kernel versions < 2.6.39 please apply
    the netlink.patch against your kernel tree, which adds the
    new subsystem identifier for ipset.
 
-- 
# Created with git-export-patch

