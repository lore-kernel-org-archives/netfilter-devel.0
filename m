From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/5] Plural forms
Date: Sat, 17 Dec 2011 22:02:22 +0100
Message-ID: <1324155743-25999-6-git-send-email-jengelh@medozas.de>
References: <1324155743-25999-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: eric@regit.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:50762 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134Ab1LQVCc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 16:02:32 -0500
In-Reply-To: <1324155743-25999-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

About the second hunk: it does need an article if one does not talk
about an unspecified plural form.
---
 secure-conntrack-helpers.rst |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/secure-conntrack-helpers.rst b/secure-conntrack-helpers.rst
index 18a7a81..4c56a8d 100644
--- a/secure-conntrack-helpers.rst
+++ b/secure-conntrack-helpers.rst
@@ -89,7 +89,7 @@ Following the preceding remarks, it appears that it is necessary to not
 blindly use helpers. You must take into account the topology of your network
 when setting parameters linked to a helper.
 
-For each helper, you must carefully open the RELATED flow. All iptables statement 
+For each helper, you must carefully open the RELATED flow. All iptables statements 
 using "-m conntrack --ctstate RELATED" should be used in conjunction with the
 choice of a helper and of IP parameters. By doing that, you will be able to describe
 how the helper must be used with respect to your network and information system
@@ -277,7 +277,7 @@ This has the great advantage of bypassing the connection tracking. This
 helps to reduce the load that could be created by some flooding.
 
 Anti-spoofing must be done on a per-interface basis. For each interface,
-we must list the authorized network on the interface. There is exception,
+we must list the authorized network on the interface. There is an exception,
 which is the interface with the default route where an inverted logic must
 be used. In our example, let's take eth1, which is a LAN interface, and have
 eth0 being the interface with the default route.
-- 
1.7.3.4

