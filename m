From: Greg KH <gregkh@suse.de>
Subject: [patch 13/15] nf_conntrack_h323: fix memory leak in module
	initialization error path
Date: Thu, 19 Jun 2008 14:30:09 -0700
Message-ID: <20080619213009.GN20267@suse.de>
References: <20080619211313.834170620@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>, davem@davemloft.net
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42766 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798AbYFSVce (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2008 17:32:34 -0400
Content-Disposition: inline; filename="nf_conntrack_h323-fix-memory-leak-in-module-initialization-error-path.patch"
In-Reply-To: <20080619212621.GA20267@suse.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Patrick McHardy <kaber@trash.net>

netfilter: nf_conntrack_h323: fix memory leak in module initialization error path

Upstream commit 8a548868db62422113104ebc658065e3fe976951

Properly free h323_buffer when helper registration fails.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netfilter/nf_conntrack_h323_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -1799,6 +1799,7 @@ err3:
 err2:
 	nf_conntrack_helper_unregister(&nf_conntrack_helper_h245);
 err1:
+	kfree(h323_buffer);
 	return ret;
 }
 

-- 
