From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: [FIX 1/1] sip: add missing RCU reader lock
Date: Fri, 20 Sep 2013 17:52:18 +0200
Message-ID: <20130920155817.660882995@eitzenberger.org>
References: <20130920155217.281613399@eitzenberger.org>
Cc: <kaber@trash.net>,
	Holger Eitzenberger <holger.eitzenberger@sophos.com>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:62775 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab3ITP6W (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Sep 2013 11:58:22 -0400
Content-Disposition: inline; filename=sip-add-missing-RCU-reader-lock.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently set_expected_rtp_rtcp() in the SIP helper uses
rcu_dereference() two times to access two different NAT hook
functions.  However, only the first one is protected properly by
the RCU reader lock, but the 2nd isn't.

I chose to not just extend the first RCU protected area but putting
the rcu_read_unlock() down, because there is a 'return' in between.

Signed-off-by: Holger Eitzenberger <holger.eitzenberger@sophos.com>

Index: net-next/net/netfilter/nf_conntrack_sip.c
===================================================================
--- net-next.orig/net/netfilter/nf_conntrack_sip.c
+++ net-next/net/netfilter/nf_conntrack_sip.c
@@ -983,6 +983,7 @@ static int set_expected_rtp_rtcp(struct
 	if (skip_expect)
 		return NF_ACCEPT;
 
+	rcu_read_lock();
 	rtp_exp = nf_ct_expect_alloc(ct);
 	if (rtp_exp == NULL)
 		goto err1;
@@ -1012,6 +1013,7 @@ static int set_expected_rtp_rtcp(struct
 err2:
 	nf_ct_expect_put(rtp_exp);
 err1:
+	rcu_read_unlock();
 	return ret;
 }
 

