From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: [PATCH] libipt6_mh.man: Correct command to display named mh types
Date: Tue, 09 Apr 2013 09:14:33 +0200
Message-ID: <5163BFD9.7060804@chello.at>
Reply-To: mart.frauenlob@chello.at
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020100030708040502000305"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fep11.mx.upcmail.net ([62.179.121.31]:36528 "EHLO
	fep11.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762255Ab3DIHPV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Apr 2013 03:15:21 -0400
Received: from edge04.upcmail.net ([192.168.13.239])
          by viefep11-int.chello.at
          (InterMail vM.8.01.05.05 201-2260-151-110-20120111) with ESMTP
          id <20130409071518.IWKB21781.viefep11-int.chello.at@edge04.upcmail.net>
          for <netfilter-devel@vger.kernel.org>;
          Tue, 9 Apr 2013 09:15:18 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020100030708040502000305
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

ip6tables -p ipv6-mh -h

does not display the named mh types as the man page says.
ip6tables -m mh -h does.

This patch updates the man page accordingly.

Best regards

Mart

--------------020100030708040502000305
Content-Type: text/plain; charset=windows-1252;
 name="libip6t_mh-Correct-command-to-list-named-mh-types-in-man.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="libip6t_mh-Correct-command-to-list-named-mh-types-in-man.pat";
 filename*1="ch"

>From 3df043fdd1ed58c0c07258e896e623a3ac06f69d Mon Sep 17 00:00:00 2001
From: Mart Frauenlob <mart.frauenlob@chello.at>
Date: Tue, 9 Apr 2013 09:04:17 +0200
Subject: [PATCH] libip6t_mh: Correct command to list named mh types in manpage.

---
 extensions/libip6t_mh.man |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/extensions/libip6t_mh.man b/extensions/libip6t_mh.man
index 4559e78..7106ef4 100644
--- a/extensions/libip6t_mh.man
+++ b/extensions/libip6t_mh.man
@@ -8,5 +8,5 @@ a numeric MH
 .IR type
 or one of the MH type names shown by the command
 .nf
- ip6tables \-p ipv6\-mh \-h
+ ip6tables \-m mh \-h
 .fi
-- 
1.7.2.5


--------------020100030708040502000305--
