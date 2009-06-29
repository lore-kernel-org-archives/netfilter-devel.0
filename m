From: Joe Perches <joe@perches.com>
Subject: [PATCH] MAINTAINERS: Add NETFILTER git
Date: Mon, 29 Jun 2009 08:59:58 -0700
Message-ID: <1246291198.10129.19.camel@Joe-Laptop.home>
References: <20090629142007.5728.63458.sendpatchset@x2.localnet>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2720 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbZF2QAA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Jun 2009 12:00:00 -0400
In-Reply-To: <20090629142007.5728.63458.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 2009-06-29 at 16:20 +0200, Patrick McHardy wrote:
> git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-2.6.git

Do you think this should be added to MAINTAINERS?

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index fa2a16d..a5042de 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4044,6 +4044,7 @@ L:	netfilter@vger.kernel.org
 L:	coreteam@netfilter.org
 W:	http://www.netfilter.org/
 W:	http://www.iptables.org/
+T:	git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-2.6.git
 S:	Supported
 F:	include/linux/netfilter*
 F:	include/linux/netfilter/


