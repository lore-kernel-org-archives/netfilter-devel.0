From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: [PATCH] NETFILTER:  Make sure xt_policy.h is unifdef'ed.
Date: Sun, 17 Feb 2008 12:33:59 -0500 (EST)
Message-ID: <alpine.LFD.1.00.0802171231340.8002@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:34647 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbYBQReF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 Feb 2008 12:34:05 -0500
Received: from cpe001d60ad7267-cm001225dbafb6.cpe.net.cable.rogers.com ([99.236.100.208] helo=crashcourse.ca)
	by astoria.ccjclearline.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68)
	(envelope-from <rpjday@crashcourse.ca>)
	id 1JQnPE-0001J4-B5
	for netfilter-devel@vger.kernel.org; Sun, 17 Feb 2008 12:34:24 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Since the header file xt_policy.h tests __KERNEL__, it should be
unifdef'ed before exporting to userspace.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/Kbuild
index 91fef0c..3aff513 100644
--- a/include/linux/netfilter/Kbuild
+++ b/include/linux/netfilter/Kbuild
@@ -30,7 +30,6 @@ header-y += xt_mark.h
 header-y += xt_multiport.h
 header-y += xt_owner.h
 header-y += xt_pkttype.h
-header-y += xt_policy.h
 header-y += xt_rateest.h
 header-y += xt_realm.h
 header-y += xt_sctp.h
@@ -47,3 +46,4 @@ unifdef-y += nfnetlink.h
 unifdef-y += nfnetlink_compat.h
 unifdef-y += x_tables.h
 unifdef-y += xt_physdev.h
+unifdef-y += xt_policy.h

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
