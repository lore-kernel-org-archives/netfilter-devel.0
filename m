From: Sergei Zhirikov <sfzhi@yahoo.com>
Subject: [PATCH] netfilter: LED: fix man page fragment inclusion
Date: Wed, 30 Jun 2010 21:54:17 +0200
Message-ID: <i0g7db$5e3$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060709090900060803000003"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:59815 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691Ab0F3UKF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jun 2010 16:10:05 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1OU3bg-0001nq-Fg
	for netfilter-devel@vger.kernel.org; Wed, 30 Jun 2010 22:10:04 +0200
Received: from h20244.upc-h.chello.nl ([62.194.20.244])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Jun 2010 22:10:04 +0200
Received: from sfzhi by h20244.upc-h.chello.nl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Jun 2010 22:10:04 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060709090900060803000003
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The man page fragment of the recently added LED target does not get included into iptables.8 and ip6tables.8 produced during build. This patch fixes that.

--------------060709090900060803000003
Content-Type: text/plain;
 name="LED-man.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="LED-man.patch"

diff --git a/extensions/libxt_LED.c b/extensions/libxt_LED.c
index af0e091..9a08e89 100644
--- a/extensions/libxt_LED.c
+++ b/extensions/libxt_LED.c
@@ -137,7 +137,7 @@ static void LED_save(const void *ip, const struct xt_entry_target *target)
 static struct xtables_target led_tg_reg = {
 	.version       = XTABLES_VERSION,
 	.name          = "LED",
-	.family        = PF_UNSPEC,
+	.family        = NFPROTO_UNSPEC,
 	.revision      = 0,
 	.size          = XT_ALIGN(sizeof(struct xt_led_info)),
 	.userspacesize = offsetof(struct xt_led_info, internal_data),

--------------060709090900060803000003--

