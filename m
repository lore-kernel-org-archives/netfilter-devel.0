From: Anton Blanchard <anton@samba.org>
Subject: [PATCH] netfilter: Don't hide NETFILTER_XT_MATCH_ADDRTYPE behind
 NETFILTER_ADVANCED
Date: Wed, 21 Jan 2015 10:53:50 +1100
Message-ID: <20150121105350.77e77534@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	"David S. Miller" <davem@davemloft.net>, sfr@canb.auug.org.au,
	mpe@ellerman.id.au
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:44581 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbbATXxw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Jan 2015 18:53:52 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Docker needs NETFILTER_XT_MATCH_ADDRTYPE, so move it out from behind
NETFILTER_ADVANCED and make it default to a module.

Signed-off-by: Anton Blanchard <anton@samba.org>
---
 net/netfilter/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index b02660f..c68c3b4 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -951,7 +951,7 @@ comment "Xtables matches"
 
 config NETFILTER_XT_MATCH_ADDRTYPE
 	tristate '"addrtype" address type match support'
-	depends on NETFILTER_ADVANCED
+	default m if NETFILTER_ADVANCED=n
 	---help---
 	  This option allows you to match what routing thinks of an address,
 	  eg. UNICAST, LOCAL, BROADCAST, ...
-- 
2.1.0

