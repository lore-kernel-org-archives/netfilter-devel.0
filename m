From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: Re: [PATCH] iptables manpage: Update NETMAP target
Date: Wed, 10 Apr 2013 18:49:25 +0200
Message-ID: <51659815.4040805@chello.at>
References: <516593B3.7070309@chello.at>
Reply-To: mart.frauenlob@chello.at
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070209080905090008090901"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fep11.mx.upcmail.net ([62.179.121.31]:38984 "EHLO
	fep11.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936102Ab3DJQuN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:50:13 -0400
Received: from edge01.upcmail.net ([192.168.13.236])
          by viefep11-int.chello.at
          (InterMail vM.8.01.05.05 201-2260-151-110-20120111) with ESMTP
          id <20130410165010.GHJH21781.viefep11-int.chello.at@edge01.upcmail.net>
          for <netfilter-devel@vger.kernel.org>;
          Wed, 10 Apr 2013 18:50:10 +0200
In-Reply-To: <516593B3.7070309@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070209080905090008090901
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 10.04.2013 18:31, netfilter-devel-owner@vger.kernel.org wrote:
> Hello,
>
> this patch renames libipt_NETMAP.man to libxt_NETMAP.man thus informing
> about the IPv6 version.


I'm very sorry, I messed up the author lines, resending.


--------------070209080905090008090901
Content-Type: text/plain; charset=windows-1252;
 name="manpage-Rename-libipt_NETMAP.man-to-libxt_NETMAP.man.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="manpage-Rename-libipt_NETMAP.man-to-libxt_NETMAP.man.patch"

>From 5f14adf02e7320eed1b88fe610a59b056b43589f Mon Sep 17 00:00:00 2001
From: Mart Frauenlob <mart.frauenlob@chello.at>
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


--------------070209080905090008090901--
