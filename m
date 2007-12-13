From: Greg KH <gregkh@suse.de>
Subject: [patch 07/36] nf_nat: fix memset error
Date: Wed, 12 Dec 2007 22:34:19 -0800
Message-ID: <20071213063419.GH25301@kroah.com>
References: <20071213062511.265908583@mini.kroah.org>
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
	Domenico Andreoli <cavokz@gmail.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Li Zefan <lizf@cn.fujitsu.com>,
	Patrick McHardy <kaber@trash.net>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:56247 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794AbXLMGhC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:37:02 -0500
Content-Disposition: inline; filename="nf_nat-fix-memset-error.patch"
In-Reply-To: <20071213063308.GA25301@kroah.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Li Zefan <lizf@cn.fujitsu.com>

This patch fixes an incorrect memset in the NAT code, causing
misbehaviour when unloading and reloading the NAT module.
Applies to stable-2.6.22 and stable-2.6.23.

Please apply, thanks.
[NETFILTER]: nf_nat: fix memset error

Upstream commit e0bf9cf15fc30d300b7fbd821c6bc975531fab44

The size passing to memset is the size of a pointer. Fixes
misbehaviour when unloading and reloading the NAT module.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 net/ipv4/netfilter/nf_nat_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -633,7 +633,7 @@ static int clean_nat(struct nf_conn *i, 
 
 	if (!nat)
 		return 0;
-	memset(nat, 0, sizeof(nat));
+	memset(nat, 0, sizeof(*nat));
 	i->status &= ~(IPS_NAT_MASK | IPS_NAT_DONE_MASK | IPS_SEQ_ADJUST);
 	return 0;
 }

-- 
