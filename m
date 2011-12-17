From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/5] Selected corrections from Mr. Dash Four
Date: Sat, 17 Dec 2011 22:02:20 +0100
Message-ID: <1324155743-25999-4-git-send-email-jengelh@medozas.de>
References: <1324155743-25999-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: eric@regit.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:50758 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab1LQVCb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 16:02:31 -0500
In-Reply-To: <1324155743-25999-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

References: <4EDA2715.7030006@googlemail.com>
Date: 2011-12-03 13:41:41 +0000
---
 secure-conntrack-helpers.rst |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/secure-conntrack-helpers.rst b/secure-conntrack-helpers.rst
index 1acaf2e..13fc263 100644
--- a/secure-conntrack-helpers.rst
+++ b/secure-conntrack-helpers.rst
@@ -216,8 +216,8 @@ For example, if the option has been used for the ftp helper, one should use ::
 
 
 
-Antispoofing
-============
+Anti-spoofing
+=============
 Helpers and anti-spoofing
 -------------------------
 
@@ -232,7 +232,7 @@ Using rp_filter
 
 Linux provides a routing-based implementation of reverse path filtering.
 This is available for IPv4.  To activate it, you need to ensure that
-`/proc/sys/net/ipv4/conf/*/rp_filter` files contain 1.  The complete
+`/proc/sys/net/ipv4/conf/*/rp_filter` files contain 1.  Complete
 documentation about `rp_filter` is available in the file `ip-sysctl.txt`
 in the `Documentation/networking/` directory of the Linux tree.
 
@@ -265,7 +265,7 @@ The documentation at the time of the writing is reproduced here ::
     Default value is 0. Note that some distributions
     enable it in startup scripts.
 
-At the time of the writing there is no routing-based implementation of
+At the time of the writing, there is no routing-based implementation of
 `rp_filter` in the Linux kernel for IPv6. Manual anti-spoofing via Netfilter
 rules is thus needed.
 
@@ -276,7 +276,7 @@ The best way to do anti-spoofing is to use filtering rules in the RAW table.
 This has the great advantage of bypassing the connection tracking. This
 helps to reduce the load that could be created by some flooding.
 
-The anti-spoofing must be done on a per-interface basis. For each interface,
+Anti-spoofing must be done on a per-interface basis. For each interface,
 we must list the authorized network on the interface. There is exception,
 which is the interface with the default route where an inverted logic must
 be used. In our example, let's take eth1, which is a LAN interface, and have
-- 
1.7.3.4

