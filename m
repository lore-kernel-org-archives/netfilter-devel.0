From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: [FIX V2] sip: add missing RCU reader lock
Date: Fri, 20 Sep 2013 22:43:04 +0200
Message-ID: <20130920204304.GA12439@imap.eitzenberger.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="BXVAT5kNtrzKuDFl"
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:50022 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab3ITUnH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:43:07 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I noticed that set_expected_rtp_rtcp() in net-next misses a 2nd
RCU reader lock when dereferencing the 2nd hook function.  Same
bug is present in kernel v3.8 at least.

This is a resend, which extend the RCU protected area as needed.

Please check.

 /Holger


--BXVAT5kNtrzKuDFl
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline; filename="sip-add-missing-RCU-reader-lock.diff"

sip: add missing RCU reader lock in set_expected_rtp_rtcp()

Currently set_expected_rtp_rtcp() in the SIP helper uses
rcu_dereference() two times to access two different NAT hook
functions.  However, only the first one is protected by the RCU
reader lock, but the 2nd isn't.

Fix it by extending the RCU protected area.

Signed-off-by: Holger Eitzenberger <holger.eitzenberger@sophos.com>

Index: net-next/net/netfilter/nf_conntrack_sip.c
===================================================================
--- net-next.orig/net/netfilter/nf_conntrack_sip.c
+++ net-next/net/netfilter/nf_conntrack_sip.c
@@ -966,7 +966,6 @@ static int set_expected_rtp_rtcp(struct
 #endif
 			skip_expect = 1;
 	} while (!skip_expect);
-	rcu_read_unlock();
 
 	base_port = ntohs(tuple.dst.u.udp.port) & ~1;
 	rtp_port = htons(base_port);
@@ -980,8 +979,10 @@ static int set_expected_rtp_rtcp(struct
 			goto err1;
 	}
 
-	if (skip_expect)
+	if (skip_expect) {
+		rcu_read_unlock();
 		return NF_ACCEPT;
+	}
 
 	rtp_exp = nf_ct_expect_alloc(ct);
 	if (rtp_exp == NULL)
@@ -1012,6 +1013,7 @@ static int set_expected_rtp_rtcp(struct
 err2:
 	nf_ct_expect_put(rtp_exp);
 err1:
+	rcu_read_unlock();
 	return ret;
 }
 

--BXVAT5kNtrzKuDFl--
