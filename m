From: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH] nf_conntrack: add include to fix sparse warning
Date: Sat, 16 Mar 2013 10:00:28 -0700
Message-ID: <20130316100028.7c9655ef@nehalam.linuxnetplumber.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:54078 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab3CPRAc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Mar 2013 13:00:32 -0400
Received: by mail-pb0-f42.google.com with SMTP id xb4so5122688pbc.1
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Mar 2013 10:00:32 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Include header file to pickup prototype of nf_nat_seq_adjust_hook

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>

--- a/net/netfilter/nf_conntrack_core.c	2013-03-07 18:12:53.945286471 -0800
+++ b/net/netfilter/nf_conntrack_core.c	2013-03-16 09:48:42.312411171 -0700
@@ -48,6 +48,7 @@
 #include <net/netfilter/nf_conntrack_labels.h>
 #include <net/netfilter/nf_nat.h>
 #include <net/netfilter/nf_nat_core.h>
+#include <net/netfilter/nf_nat_helper.h>
 
 #define NF_CONNTRACK_VERSION	"0.5.0"
 
