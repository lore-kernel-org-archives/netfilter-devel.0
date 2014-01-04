From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: [PATCH] extensions: libxt_set: Add missing hyphen to --bytes-eq synopsis
 in manpage
Date: Sat, 04 Jan 2014 16:57:46 +0100
Message-ID: <52C82F7A.8040308@chello.at>
Reply-To: mart.frauenlob@chello.at
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040001020009060802080609"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fep12.mx.upcmail.net ([62.179.121.32]:36302 "EHLO
	fep12.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373AbaADQMv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 4 Jan 2014 11:12:51 -0500
Received: from edge01.upcmail.net ([192.168.13.236])
          by viefep18-int.chello.at
          (InterMail vM.8.01.05.05 201-2260-151-110-20120111) with ESMTP
          id <20140104155625.YCWL29288.viefep18-int.chello.at@edge01.upcmail.net>
          for <netfilter-devel@vger.kernel.org>;
          Sat, 4 Jan 2014 16:56:25 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040001020009060802080609
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

small fix which adds a missing hyphen in the manpage.

Good day!

Mart

--------------040001020009060802080609
Content-Type: text/plain; charset=windows-1252;
 name="extensions-libxt_set-Add-missing-hyphen-to-bytes-eq-syno.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="extensions-libxt_set-Add-missing-hyphen-to-bytes-eq-syno.pat";
 filename*1="ch"

>From fb7aa04245e1c709d5f9c1811780eb90a71f50cc Mon Sep 17 00:00:00 2001
From: Mart Frauenlob <mart.frauenlob@chello.at>
Date: Sat, 4 Jan 2014 16:41:49 +0100
Subject: [PATCH] extensions: libxt_set: Add missing hyphen to --bytes-eq synopsis.


Signed-off-by: Mart Frauenlob <mart.frauenlob@chello.at>
---
 extensions/libxt_set.man |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_set.man b/extensions/libxt_set.man
index 7012ef2..dbc1586 100644
--- a/extensions/libxt_set.man
+++ b/extensions/libxt_set.man
@@ -43,7 +43,7 @@ packet counter of the element is less than the given value as well.
 If the packet is matched an element in the set, match only if the
 packet counter of the element is greater than the given value as well.
 .TP
-[\fB!\fP] \fB\-bytes\-eq\fP \fIvalue\fP
+[\fB!\fP] \fB\-\-bytes\-eq\fP \fIvalue\fP
 If the packet is matched an element in the set, match only if the
 byte counter of the element matches the given value too.
 .TP
-- 
1.7.2.5


--------------040001020009060802080609--
