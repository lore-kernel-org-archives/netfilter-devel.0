From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] conntrackd: basic TIPC implementation for NOTRACK mode
Date: Fri, 10 Feb 2012 11:26:53 +0100
Message-ID: <20120210102653.GA9617@1984>
References: <20120121085217.4272940o8fmk4v80@www.usherbrooke.ca>
 <20120122174140.GA18764@1984>
 <20120122162720.10123t2longq3zac@www.usherbrooke.ca>
 <20120123100733.GB23857@1984>
 <20120123132537.198937ydqdx1n3gg@www.usherbrooke.ca>
 <20120124010145.GA28314@1984>
 <20120124120058.234342gq75ohof6s@www.usherbrooke.ca>
 <20120126001928.GA10554@1984>
 <20120126211344.33964cmak17akti0@www.usherbrooke.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Quentin Aebischer <Quentin.Aebischer@USherbrooke.ca>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54976 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758930Ab2BJK04 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Feb 2012 05:26:56 -0500
Content-Disposition: inline
In-Reply-To: <20120126211344.33964cmak17akti0@www.usherbrooke.ca>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Quentin,

On Thu, Jan 26, 2012 at 09:13:44PM -0500, Quentin Aebischer wrote:
> Ok, time for an other try !

I'm trying to apply this patch but it seems you mail client has
mangled the patch.

$ patch -p1 < tipc.patch
patching file include/Makefile.am
Hunk #1 FAILED at 1.
1 out of 1 hunk FAILED -- saving rejects to file
include/Makefile.am.rej
patching file include/channel.h
Hunk #1 FAILED at 4.
Hunk #2 FAILED at 13.
Hunk #3 FAILED at 31.
Hunk #4 FAILED at 41.
Hunk #5 FAILED at 97.

If I display the file it shows:

diff --git a/include/channel.h b/include/channel.h
index 9b5fad8..704d384 100644
--- a/include/channel.h
+++ b/include/channel.h
@@ -4,6 +4,7 @@
  #include "mcast.h"
  #include "udp.h"
  #include "tcp.h"
+#include "tipc.h"

Note the strange extra space.

Can you resend it to me, please? I'd like to apply them to
git.netfilter.org. Thanks.
