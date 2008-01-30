From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 67/69]: nf_conntrack: fix sparse warning
Date: Wed, 30 Jan 2008 21:18:36 +0100 (MET)
Message-ID: <20080130201834.29874.42434.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60813 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933503AbYA3USi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:18:38 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack: fix sparse warning

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f4b1df40b6a6978e862bffcaa8d36aecf1220978
tree 52fa9c7e72ecbc5d8263489f99aa83b45784257c
parent 810b07fadc47c72a1372724d150abe96b15fc1ad
author Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:18 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:18 +0100

 net/netfilter/nf_conntrack_standalone.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index ea34090..e88e96a 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -384,7 +384,7 @@ static ctl_table nf_ct_netfilter_table[] = {
 	{ .ctl_name = 0 }
 };
 
-struct ctl_path nf_ct_path[] = {
+static struct ctl_path nf_ct_path[] = {
 	{ .procname = "net", .ctl_name = CTL_NET, },
 	{ }
 };
