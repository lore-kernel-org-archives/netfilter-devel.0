From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: Re: [PATCH] iptables manpage: Fix missing space for recent match
 --mask option
Date: Sat, 06 Apr 2013 11:20:51 +0200
Message-ID: <515FE8F3.5020700@chello.at>
References: <515FE4EC.1070900@chello.at>
Reply-To: mart.frauenlob@chello.at
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030401080905000401040800"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fep22.mx.upcmail.net ([62.179.121.42]:45187 "EHLO
	fep22.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1163189Ab3DFJVj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Apr 2013 05:21:39 -0400
Received: from edge02.upcmail.net ([192.168.13.237])
          by viefep22-int.chello.at
          (InterMail vM.8.01.05.05 201-2260-151-110-20120111) with ESMTP
          id <20130406092137.UEYD12132.viefep22-int.chello.at@edge02.upcmail.net>
          for <netfilter-devel@vger.kernel.org>;
          Sat, 6 Apr 2013 11:21:37 +0200
In-Reply-To: <515FE4EC.1070900@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030401080905000401040800
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 06.04.2013 11:04, netfilter-devel-owner@vger.kernel.org wrote:
> As the subject says...
>
> Best regards
>
> Mart

lol damn, must been blind, now I added an extra space :/
removed...


--------------030401080905000401040800
Content-Type: text/plain; charset=windows-1252;
 name="iptables-manpage-Fix-missing-space-for-recent-match.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="iptables-manpage-Fix-missing-space-for-recent-match.patch"

>From 937309f37f9000f18f88c191923192c5d31a07e8 Mon Sep 17 00:00:00 2001
From: Mart Frauenlob <mart.frauenlob@chello.at>
Date: Sat, 6 Apr 2013 10:49:47 +0200
Subject: [PATCH 2/2] iptables manpage: Fix missing space for recent match --mask option.

---
 extensions/libxt_recent.man |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_recent.man b/extensions/libxt_recent.man
index 8e6a8e9..05ae4fa 100644
--- a/extensions/libxt_recent.man
+++ b/extensions/libxt_recent.man
@@ -24,7 +24,7 @@ is the default.
 \fB\-\-rdest\fP
 Match/save the destination address of each packet in the recent list table.
 .TP
-\fB\-\-mask\fPnetmask
+\fB\-\-mask\fP \fnetmask\fP
 Netmask that will be applied to this recent list.
 .TP
 [\fB!\fP] \fB\-\-rcheck\fP
-- 
1.7.2.5


--------------030401080905000401040800--
