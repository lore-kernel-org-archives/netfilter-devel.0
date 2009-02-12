From: jamal <hadi@cyberus.ca>
Subject: [PATCH] libxtables: Dont initialize global xt_params
Date: Thu, 12 Feb 2009 11:39:38 -0500
Message-ID: <1234456778.3271.14.camel@dogo.mojatatu.com>
References: <1234448162.3271.1.camel@dogo.mojatatu.com>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-YbCMqiUWRgu9LRLOamI/"
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:36496 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713AbZBLQle (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2009 11:41:34 -0500
Received: by ewy14 with SMTP id 14so664034ewy.13
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Feb 2009 08:41:32 -0800 (PST)
In-Reply-To: <1234448162.3271.1.camel@dogo.mojatatu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-YbCMqiUWRgu9LRLOamI/
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


This is a resend with attachment instead of inlining.

cheers,
jamal

--=-YbCMqiUWRgu9LRLOamI/
Content-Disposition: attachment; filename=iptv2-fix01
Content-Type: text/plain; name=iptv2-fix01; charset=UTF-8
Content-Transfer-Encoding: 7bit

commit 7aad144ecaf7603b17af5372886fe491c3bc6a2f
Author: Jamal Hadi Salim <hadi@cyberus.ca>
Date:   Wed Feb 11 16:19:30 2009 -0500

    Dont initialize global xt_params
    To quote Jan Engelhardt <jengelh@medozas.de>
    "
    Do not initialize static members - this takes up extra space
    and adds no benefit. (zeroed anyway even in .bss)
    "
    
    Signed-off-by: Jamal Hadi Salim <hadi@cyberus.ca>

diff --git a/xtables.c b/xtables.c
index 8e28d5e..114a393 100644
--- a/xtables.c
+++ b/xtables.c
@@ -48,7 +48,7 @@
 
 void basic_exit_err(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
 
-struct xtables_globals *xt_params = NULL;
+struct xtables_globals *xt_params;
 
 void basic_exit_err(enum xtables_exittype status, const char *msg, ...)
 {

--=-YbCMqiUWRgu9LRLOamI/--

