From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: [PATCH] iptables manpage: Update NETMAP target
Date: Wed, 10 Apr 2013 18:30:43 +0200
Message-ID: <516593B3.7070309@chello.at>
Reply-To: mart.frauenlob@chello.at
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090909040908030601030208"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fep19.mx.upcmail.net ([62.179.121.39]:48895 "EHLO
	fep19.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937045Ab3DJQba (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:31:30 -0400
Received: from edge04.upcmail.net ([192.168.13.239])
          by viefep19-int.chello.at
          (InterMail vM.8.01.05.05 201-2260-151-110-20120111) with ESMTP
          id <20130410163128.IJLO25472.viefep19-int.chello.at@edge04.upcmail.net>
          for <netfilter-devel@vger.kernel.org>;
          Wed, 10 Apr 2013 18:31:28 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090909040908030601030208
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

this patch renames libipt_NETMAP.man to libxt_NETMAP.man thus informing 
about the IPv6 version.


Best regards

Mart

--------------090909040908030601030208
Content-Type: text/plain; charset=windows-1252;
 name="manpage-Rename-libipt_NETMAP.man-to-libxt_NETMAP.man.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="manpage-Rename-libipt_NETMAP.man-to-libxt_NETMAP.man.patch"

>From 5f14adf02e7320eed1b88fe610a59b056b43589f Mon Sep 17 00:00:00 2001
From: AllKind <allkind@fastest.cc>
Date: Wed, 10 Apr 2013 17:00:36 +0200
Subject: [PATCH] manpage: Rename libipt_NETMAP.man to libxt_NETMAP.man.

---
 extensions/libipt_NETMAP.man |    9 ---------
 extensions/libxt_NETMAP.man  |    9 +++++++++
 2 files changed, 9 insertions(+), 9 deletions(-)
 delete mode 100644 extensions/libipt_NETMAP.man
 create mode 100644 extensions/libxt_NETMAP.man

diff --git a/extensions/libipt_NETMAP.man b/extensions/libipt_NETMAP.man
deleted file mode 100644
index a7e90b8..0000000
--- a/extensions/libipt_NETMAP.man
+++ /dev/null
@@ -1,9 +0,0 @@
-This target allows you to statically map a whole network of addresses onto
-another network of addresses.  It can only be used from rules in the
-.B nat
-table.
-.TP
-\fB\-\-to\fP \fIaddress\fP[\fB/\fP\fImask\fP]
-Network address to map to.  The resulting address will be constructed in the
-following way: All 'one' bits in the mask are filled in from the new `address'.
-All bits that are zero in the mask are filled in from the original address.
diff --git a/extensions/libxt_NETMAP.man b/extensions/libxt_NETMAP.man
new file mode 100644
index 0000000..a7e90b8
--- /dev/null
+++ b/extensions/libxt_NETMAP.man
@@ -0,0 +1,9 @@
+This target allows you to statically map a whole network of addresses onto
+another network of addresses.  It can only be used from rules in the
+.B nat
+table.
+.TP
+\fB\-\-to\fP \fIaddress\fP[\fB/\fP\fImask\fP]
+Network address to map to.  The resulting address will be constructed in the
+following way: All 'one' bits in the mask are filled in from the new `address'.
+All bits that are zero in the mask are filled in from the original address.
-- 
1.7.2.5


--------------090909040908030601030208--
