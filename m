From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/5] Selected corrections from Mr. Dash Four
Date: Sat, 17 Dec 2011 22:02:21 +0100
Message-ID: <1324155743-25999-5-git-send-email-jengelh@medozas.de>
References: <1324155743-25999-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: eric@regit.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:50761 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134Ab1LQVCb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 16:02:31 -0500
In-Reply-To: <1324155743-25999-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

References: <4EDA332F.2010409@googlemail.com>
References: http://marc.info/?l=netfilter&m=132292290523592&w=2
Date: 2011-12-03 14:33:19 +0000
---
 secure-conntrack-helpers.rst |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/secure-conntrack-helpers.rst b/secure-conntrack-helpers.rst
index 13fc263..18a7a81 100644
--- a/secure-conntrack-helpers.rst
+++ b/secure-conntrack-helpers.rst
@@ -43,12 +43,12 @@ IRC helper creates expectations whose destination address is the client address
 and source address is any address. This is due to the protocol: we do not know
 the IP address of the person who is the target of the DCC.
 
-The degree of freedom due to connection tracking helpers are thus dependent on
+The degree of freedom due to connection tracking helpers are therefore dependent on
 the nature of the protocol. Some protocols have dangerous extensions, and these
 are disabled by default by Netfilter. The user has to pass an option during
 loading of the module to enable this dangerous protocol features. For example,
 the FTP protocol can let the user choose to have the target server connect to
-another arbitrary server. This could lead to a hole in the DMZ and it is thus
+another arbitrary server. This could lead to a hole in the DMZ and it is therefore
 deactivated by default. To enable it, you've got to pass the `loose` option
 with the `1` value.
 
@@ -91,7 +91,7 @@ when setting parameters linked to a helper.
 
 For each helper, you must carefully open the RELATED flow. All iptables statement 
 using "-m conntrack --ctstate RELATED" should be used in conjunction with the
-choice of a helper and of IP parameters.  Doing that, you will be able to describe
+choice of a helper and of IP parameters. By doing that, you will be able to describe
 how the helper must be used with respect to your network and information system
 architecture.
 
@@ -144,7 +144,7 @@ Securing the signaling flow
 
 You will also need to build carefully crafted rules for the authorization
 of flows involving connection tracking helpers. In particular, you have
-to do a strict anti-spoofing (as described below) to avoid traffic injection
+to do strict anti-spoofing (as described below) to avoid traffic injection
 from other interfaces.
 
 
-- 
1.7.3.4

