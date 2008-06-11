From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 01/02: Make nflog quiet when no one listen in userspace.
Date: Wed, 11 Jun 2008 14:42:04 +0200
Message-ID: <484FC81C.9080904@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060103040406090805080100"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: "David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40129 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbYFKMmM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2008 08:42:12 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060103040406090805080100
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Dave,

following are two fixes for netfilter:

- silence a noisy warning when no logging backend is active

- fix a ctnetlink related crash in nf_nat_setup_info()

The second one is a regression present since 2.6.23, I'll
also send that one to -stable.

I have another patch queued to fix a NAT crash probably caused
by a RCU race, but I'd like to get confirmation that it actually
fixes the problem before sending it upstream, so I'll hold on
to it for a few more days.

Please apply, thanks.


--------------060103040406090805080100
Content-Type: text/x-diff;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

netfilter: Make nflog quiet when no one listen in userspace.

The message "nf_log_packet: can't log since no backend logging module loaded
in! Please either load one, or disable logging explicitly" was displayed for
each logged packet when no userspace application is listening to nflog events.
The message seems to warn for a problem with a kernel module missing but as
said before this is not the case. I thus propose to suppress the message (I
don't see any reason to flood the log because a user application has crashed.)

Signed-off-by: Eric Leblond <eric@inl.fr>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 21fa91adce646ad0449e898a64edaa828ca131e7
tree 48ef8d9b33e312af5f55bf0d6795fab46c70fda2
parent 2e761e0532a784816e7e822dbaaece8c5d4be14d
author Eric Leblond <eric@inl.fr> Tue, 10 Jun 2008 07:54:34 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 10 Jun 2008 07:54:34 +0200

 net/netfilter/nf_log.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index bc11d70..9fda6ee 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -92,10 +92,6 @@ void nf_log_packet(int pf,
 		vsnprintf(prefix, sizeof(prefix), fmt, args);
 		va_end(args);
 		logger->logfn(pf, hooknum, skb, in, out, loginfo, prefix);
-	} else if (net_ratelimit()) {
-		printk(KERN_WARNING "nf_log_packet: can\'t log since "
-		       "no backend logging module loaded in! Please either "
-		       "load one, or disable logging explicitly\n");
 	}
 	rcu_read_unlock();
 }

--------------060103040406090805080100--
