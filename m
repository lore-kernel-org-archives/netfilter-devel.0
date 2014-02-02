From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: [PATCH] libxtables: Print meaninful error message for an invalid
 MAC address string
Date: Sun, 02 Feb 2014 19:39:01 +0100
Message-ID: <52EE90C5.3040407@chello.at>
Reply-To: mart.frauenlob@chello.at
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080002040106070809040208"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fep12.mx.upcmail.net ([62.179.121.32]:32823 "EHLO
	fep12.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaBBSi1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 2 Feb 2014 13:38:27 -0500
Received: from edge02.upcmail.net ([192.168.13.237])
          by viefep16-int.chello.at
          (InterMail vM.8.01.05.05 201-2260-151-110-20120111) with ESMTP
          id <20140202183728.WLSE771.viefep16-int.chello.at@edge02.upcmail.net>
          for <netfilter-devel@vger.kernel.org>;
          Sun, 2 Feb 2014 19:37:28 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080002040106070809040208
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

on usage of a malformed MAC address the error message was not descriptive.

Best regards,

Mart

--------------080002040106070809040208
Content-Type: text/plain; charset=windows-1252;
 name="libxtables-Print-meaningful-error-message-for-an-invalid.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="libxtables-Print-meaningful-error-message-for-an-invalid.pat";
 filename*1="ch"

>From e2b3628a66db473d230e83a6eb98389849e20de1 Mon Sep 17 00:00:00 2001
From: Mart Frauenlob <mart.frauenlob@chello.at>
Date: Sun, 2 Feb 2014 14:24:25 +0100
Subject: [PATCH] libxtables: Print meaningful error message for an invalid MAC address string

If an invalid MAC address is used on the commmand line, the error message
`ether' was not really describing the problem.

Signed-off-by: Mart Frauenlob <mart.frauenlob@chello.at>
---
 libxtables/xtoptions.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/libxtables/xtoptions.c b/libxtables/xtoptions.c
index 78e9abd..9b4c5aa 100644
--- a/libxtables/xtoptions.c
+++ b/libxtables/xtoptions.c
@@ -802,7 +802,7 @@ static void xtopt_parse_ethermac(struct xt_option_call *cb)
 		       sizeof(cb->val.ethermac));
 	return;
  out:
-	xt_params->exit_err(PARAMETER_PROBLEM, "ether");
+	xt_params->exit_err(PARAMETER_PROBLEM, "Invalid MAC address specified.");
 }
 
 static void (*const xtopt_subparse[])(struct xt_option_call *) = {
-- 
1.7.2.5


--------------080002040106070809040208--
