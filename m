From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 54/64]: Kill function prototype for non-existing function
Date: Tue, 18 Dec 2007 00:47:26 +0100 (MET)
Message-ID: <20071217234726.23601.56672.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39049 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933172AbXLQXr2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:47:28 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: Kill function prototype for non-existing function

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 50a04a644a2d717be1306a9b6121c12180b66dd1
tree a11dfc1c472c600f25d3b4437412a142f20a8f6c
parent fcf0f585c5a36051119f250330feac0a672a73c2
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:58:47 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:59 +0100

 include/linux/netfilter.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 368b7ed..bd4a2dd 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -206,9 +206,6 @@ int compat_nf_setsockopt(struct sock *sk, int pf, int optval,
 int compat_nf_getsockopt(struct sock *sk, int pf, int optval,
 		char __user *opt, int *len);
 
-/* FIXME: Before cache is ever used, this must be implemented for real. */
-extern void nf_invalidate_cache(int pf);
-
 /* Call this before modifying an existing packet: ensures it is
    modifiable and linear to the point you care about (writable_len).
    Returns true or false. */
