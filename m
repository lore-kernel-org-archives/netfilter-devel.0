From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER -stable]: nf_nat: fix memset error
Date: Wed, 28 Nov 2007 09:56:27 +0100
Message-ID: <474D2D3B.5030909@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070304050801040103050404"
Cc: "David S. Miller" <davem@davemloft.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40795 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbXK1I4d (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Nov 2007 03:56:33 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------070304050801040103050404
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

This patch fixes an incorrect memset in the NAT code, causing
misbehaviour when unloading and reloading the NAT module.
Applies to stable-2.6.22 and stable-2.6.23.

Please apply, thanks.



--------------070304050801040103050404
Content-Type: text/x-patch;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

[NETFILTER]: nf_nat: fix memset error

Upstream commit e0bf9cf15fc30d300b7fbd821c6bc975531fab44

The size passing to memset is the size of a pointer. Fixes
misbehaviour when unloading and reloading the NAT module.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>

---
commit 5811c2a0705a77524b2b12d927e874d2fa6520b3
tree e71651d274c89fea540c87b98b990db2e4cafe5b
parent 8996d0af900ec60b8b59435aa231e2d449bba6af
author Li Zefan <lizf@cn.fujitsu.com> Wed, 28 Nov 2007 09:24:42 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 28 Nov 2007 09:24:42 +0100

 net/ipv4/netfilter/nf_nat_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index deab27f..553ebb8 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -681,7 +681,7 @@ static int clean_nat(struct nf_conn *i, void *data)
 
 	if (!nat)
 		return 0;
-	memset(nat, 0, sizeof(nat));
+	memset(nat, 0, sizeof(*nat));
 	i->status &= ~(IPS_NAT_MASK | IPS_NAT_DONE_MASK | IPS_SEQ_ADJUST);
 	return 0;
 }

--------------070304050801040103050404--
