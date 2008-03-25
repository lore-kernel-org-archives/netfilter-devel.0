From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 32/32]: nf_conntrack_sip: update copyright
Date: Tue, 25 Mar 2008 15:15:36 +0100 (MET)
Message-ID: <20080325141535.10539.44043.sendpatchset@localhost.localdomain>
References: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32991 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448AbYCYOPh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:15:37 -0400
In-Reply-To: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sip: update copyright

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5ada5a1adfeb1f7fdad61d02add18a4e47750b30
tree c41e7b0d5568d855a6afecdd92d0c244478a6c94
parent 5b4954e2047534f6f4347597a68cb7f09a3389ea
author Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 14:43:46 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 14:43:46 +0100

 net/ipv4/netfilter/nf_nat_sip.c  |    2 ++
 net/netfilter/nf_conntrack_sip.c |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_sip.c b/net/ipv4/netfilter/nf_nat_sip.c
index bcddccd..4334d5c 100644
--- a/net/ipv4/netfilter/nf_nat_sip.c
+++ b/net/ipv4/netfilter/nf_nat_sip.c
@@ -2,6 +2,8 @@
  *
  * (C) 2005 by Christian Hentschel <chentschel@arnet.com.ar>
  * based on RR's ip_nat_ftp.c and other modules.
+ * (C) 2007 United Security Providers
+ * (C) 2007, 2008 Patrick McHardy <kaber@trash.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 57de22c..da5dec6 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -2,6 +2,8 @@
  *
  * (C) 2005 by Christian Hentschel <chentschel@arnet.com.ar>
  * based on RR's ip_conntrack_ftp.c and other modules.
+ * (C) 2007 United Security Providers
+ * (C) 2007, 2008 Patrick McHardy <kaber@trash.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
