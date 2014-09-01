From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: NETFILTER_XT_TARGET_LOG selects NF_LOG_*
Date: Mon,  1 Sep 2014 13:45:28 +0200
Message-ID: <1409571928-13365-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: zajec5@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57569 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985AbaIALoq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:44:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Pablo Neira Ayuso <pablo@soleta.eu>

CONFIG_NETFILTER_XT_TARGET_LOG is not selected anymore when jumping
from 3.16 to 3.17-rc1 if you don't set on the new NF_LOG_IPV4 and
NF_LOG_IPV6 switches.

Change this to select the three new symbols NF_LOG_COMMON, NF_LOG_IPV4
and NF_LOG_IPV6 instead, so NETFILTER_XT_TARGET_LOG remains enabled
when moving from old to new kernels.

Reported-by: Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@soleta.eu>
---
 net/netfilter/Kconfig |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 05eb177..4bef6eb 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -747,7 +747,9 @@ config NETFILTER_XT_TARGET_LED
=20
 config NETFILTER_XT_TARGET_LOG
 	tristate "LOG target support"
-	depends on NF_LOG_IPV4 && NF_LOG_IPV6
+	select NF_LOG_COMMON
+	select NF_LOG_IPV4
+	select NF_LOG_IPV6 if IPV6
 	default m if NETFILTER_ADVANCED=3Dn
 	help
 	  This option adds a `LOG' target, which allows you to create rules i=
n
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
