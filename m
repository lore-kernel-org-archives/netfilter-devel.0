From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/2] doc: add VERSION section to manpages
Date: Tue,  1 Mar 2011 15:44:26 +0100
Message-ID: <1298990667-22518-3-git-send-email-jengelh@medozas.de>
References: <1298990667-22518-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46326 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754241Ab1CAOob (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2011 09:44:31 -0500
In-Reply-To: <1298990667-22518-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This shall make it easier to identify outdated HTML renditions on the
interwebs, since many of them do not display the .TH header like man(1)
does.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.8.in |    3 +++
 iptables.8.in  |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/ip6tables.8.in b/ip6tables.8.in
index 5688133..4306934 100644
--- a/ip6tables.8.in
+++ b/ip6tables.8.in
@@ -419,3 +419,6 @@ iptables man page written by Herve Eychenne <rv@wallfire.org>.
 .\" .. sexy, too ..
 .\" .. witty, charming, powerful ..
 .\" .. and most of all, modest ..
+.SH VERSION
+.PP
+This manual page applies to ip6tables @PACKAGE_VERSION@.
diff --git a/iptables.8.in b/iptables.8.in
index d29deb2..f36d220 100644
--- a/iptables.8.in
+++ b/iptables.8.in
@@ -427,3 +427,6 @@ Man page originally written by Herve Eychenne <rv@wallfire.org>.
 .\" .. sexy, too ..
 .\" .. witty, charming, powerful ..
 .\" .. and most of all, modest ..
+.SH VERSION
+.PP
+This manual page applies to iptables @PACKAGE_VERSION@.
-- 
1.7.1

