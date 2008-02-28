From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/32]: nf_conntrack_expect: show NF_CT_EXPECT_PERMANENT flag in /proc
Date: Thu, 28 Feb 2008 13:00:02 +0100 (MET)
Message-ID: <20080228115953.29267.64107.sendpatchset@localhost.localdomain>
References: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49971 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757122AbYB1MAD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Feb 2008 07:00:03 -0500
In-Reply-To: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_expect: show NF_CT_EXPECT_PERMANENT flag in /proc

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 80c19a28e05a8855425f7f8cc62384b700b208c1
tree bcae1a47f585c86d943c70b627b85fdaaefc7edd
parent f6c04977c6bfa6adcb366221cbaf20ed6f45bf55
author Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:08 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:08 +0100

 net/netfilter/nf_conntrack_expect.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 2926e0b..bc4c8e0 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -475,6 +475,10 @@ static int exp_seq_show(struct seq_file *s, void *v)
 		    __nf_ct_l3proto_find(expect->tuple.src.l3num),
 		    __nf_ct_l4proto_find(expect->tuple.src.l3num,
 				       expect->tuple.dst.protonum));
+
+	if (expect->flags & NF_CT_EXPECT_PERMANENT)
+		seq_printf(s, "PERMANENT ");
+
 	return seq_putc(s, '\n');
 }
 
