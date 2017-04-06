From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] iptables: Remove explicit static variables
 initalization.
Date: Thu, 6 Apr 2017 18:22:14 +0200
Message-ID: <20170406162214.GA5655@salvia>
References: <cover.1490815157.git.rvarsha016@gmail.com>
 <58dc0a89.549c620a.6eb0a.5c33@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        outreachy-kernel <outreachy-kernel@googlegroups.com>
To: Varsha Rao <rvarsha016@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32986 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934201AbdDFQWg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Apr 2017 12:22:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CBC3D11ADC7
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Apr 2017 18:22:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BB814DA86B
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Apr 2017 18:22:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B4BB9DA872
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Apr 2017 18:22:29 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <58dc0a89.549c620a.6eb0a.5c33@mx.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 30, 2017 at 12:57:02AM +0530, Varsha Rao wrote:
> Static variables are initialized to zero by default, so remove explicit
> initalization. This patch fixes the checkpatch issue.

Applied.

But I had to add this chunk:

diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index a551c8c19f7f..6afa0d0ec5b1 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -24,7 +24,7 @@
 #define DEBUGP(x, args...)
 #endif
 
-static int counters = 0, verbose = 0, noflush = 0;
+static int counters, verbose, noflush;
 
 /* Keeping track of external matches and targets.  */
 static const struct option options[] = {

You have to be more careful. It's good if you just fix all spots in
one single go.

Thanks!
