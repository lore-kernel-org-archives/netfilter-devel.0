From: Stefano Sabatini <stefano.sabatini-lala@poste.it>
Subject: [PATCH] Document xt_statistic
Date: Sun, 11 Nov 2007 17:30:32 +0100
Message-ID: <20071111163032.GA22350@geppetto>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="WIyZ46R2i8wDzkSu"
To: netfilter-devel Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay-pt3.poste.it ([62.241.4.129]:57244 "EHLO
	relay-pt3.poste.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbXKKQv2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Nov 2007 11:51:28 -0500
Received: from geppetto.reilabs.com (84.222.213.110) by relay-pt3.poste.it (7.3.122) (authenticated as stefano.sabatini-lala@poste.it)
        id 4736469100002225 for netfilter-devel@vger.kernel.org; Sun, 11 Nov 2007 17:30:57 +0100
Received: from stefano by geppetto.reilabs.com with local (Exim 4.67)
	(envelope-from <stefano.sabatini-lala@poste.it>)
	id 1IrFhh-0007P4-2G
	for netfilter-devel@vger.kernel.org; Sun, 11 Nov 2007 17:30:33 +0100
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi to all netfilter developers,
and many thanks for your great work.

The attached patch is the result of this discussion:
http://thread.gmane.org/20071105150734.GA26774@santefisi.caos.org

Please consider integrating it into iptables, this may potentially
save many man hours, and improve your karma towards your users.

Best regards.
-- 
Stefano Sabatini
Linux user number 337176 (see http://counter.li.org)

--WIyZ46R2i8wDzkSu
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="document-xtstatistic.patch"

Index: extensions/libxt_statistic.man
===================================================================
--- extensions/libxt_statistic.man	(revision 0)
+++ extensions/libxt_statistic.man	(revision 0)
@@ -0,0 +1,30 @@
+This module matches packets based on some statistic condition.
+It supports two distinct modes settable with the 
+.B --mode
+option.
+.TP
+Supported options:
+.TP
+.BI "--mode " "mode"
+Set the matching mode of the matching rule, supported modes are
+.B random
+and
+.B nth. 
+.TP
+.BI "--probability " "p"
+Set the probability from 0 to 1 for a packet to be randomly
+matched. It works only with the
+.B random
+mode.
+.TP
+.BI "--every " "n"
+Match one packet every nth packet. It works only with the
+.B nth
+mode (see also the 
+.B --packet
+option).
+.TP
+.BI "--packet " "p"
+Set the initial counter value (0 <= p <= n-1, default 0) for the
+.B nth 
+mode.

--WIyZ46R2i8wDzkSu--
