From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] netfilter: byte order issue in nf_ct_seqadj_set
Date: Sat, 16 Nov 2013 20:37:46 -0800
Message-ID: <20131117043745.GA12111@home>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="M9NhX3UHpAaciwkO"
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:65509 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab3KQEhq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Nov 2013 23:37:46 -0500
Received: by mail-pb0-f52.google.com with SMTP id wy17so4109158pbc.11
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Nov 2013 20:37:46 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

In commit 41d73ec053d2, sequence number adjustments were moved to a separate
file.  Unfortunately, a necessary ntohl call was removed when the call to 
adjust_tcp_sequence was collapsed into nf_ct_seqadj_set.  As reported by
Dawid Stawiarsk, this broke the FTP NAT helper.  Add back the byte order
conversions.

Fixes: 41d73ec053d2 ("netfilter: nf_conntrack: make sequence number adjustments usuable without NAT")
Signed-off-by: Phil Oester <kernel@linuxace.com>


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-seqadj

diff --git a/net/netfilter/nf_conntrack_seqadj.c b/net/netfilter/nf_conntrack_seqadj.c
index 5f9bfd0..17c1bcb 100644
--- a/net/netfilter/nf_conntrack_seqadj.c
+++ b/net/netfilter/nf_conntrack_seqadj.c
@@ -41,8 +41,8 @@ int nf_ct_seqadj_set(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 	spin_lock_bh(&ct->lock);
 	this_way = &seqadj->seq[dir];
 	if (this_way->offset_before == this_way->offset_after ||
-	    before(this_way->correction_pos, seq)) {
-		this_way->correction_pos = seq;
+	    before(this_way->correction_pos, ntohl(seq))) {
+		this_way->correction_pos = ntohl(seq);
 		this_way->offset_before	 = this_way->offset_after;
 		this_way->offset_after	+= off;
 	}

--M9NhX3UHpAaciwkO--
