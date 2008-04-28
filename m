From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 3/3] Update default configuration to fit last changes
Date: Mon, 28 Apr 2008 15:53:58 +0200
Message-ID: <1209390838-12953-4-git-send-email-eric@inl.fr>
References: <4815D4B0.6040703@netfilter.org>
 <1209390838-12953-1-git-send-email-eric@inl.fr>
 <1209390838-12953-2-git-send-email-eric@inl.fr>
 <1209390838-12953-3-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:45034 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932572AbYD1NyA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Apr 2008 09:54:00 -0400
In-Reply-To: <1209390838-12953-3-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Default stacks needed to be modified to be in sync MAC2STR plugin which
is used by database output modules. The new label configuration variable
has been added to some ULOG and NFLOG instances to show that it exists.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 ulogd.conf.in |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/ulogd.conf.in b/ulogd.conf.in
index 3def8d1..7f78242 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -97,6 +97,7 @@ group=0
 [log2]
 group=1 # Group has to be different from the one use in log1
 addressfamily=10 # 10 is value of AF_INET6
+numeric_label=1 # label can be used to define the decision applied to packet
 
 # ebtables logging through NFLOG
 [log3]
@@ -106,6 +107,7 @@ addressfamily=7 # 7 is value of AF_BRIDGE
 [ulog1]
 # netlink multicast group (the same as the iptables --ulog-nlgroup param)
 nlgroup=1
+#numeric_label=0 # optionnal argument
 
 [emu1]
 file="/var/log/ulogd_syslogemu.log"
-- 
1.5.4.3

