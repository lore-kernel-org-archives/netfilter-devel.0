From: Paul Bolle <pebolle@tiscali.nl>
Subject: netfilter: remnants of ulog targets
Date: Wed, 23 Jul 2014 11:28:14 +0200
Message-ID: <1406107694.12441.8.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:60397 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932406AbaGWJ2R (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jul 2014 05:28:17 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo,

Your commit 7200135bc1e6 ("netfilter: kill ulog targets") landed in
today's linux-next (ie, next-20140723). It removes two Kconfig symbols:
IP_NF_TARGET_ULOG and BRIDGE_EBT_ULOG.

It left a few references to the related macros untouched:
    $ git grep -n -e IP_NF_TARGET_ULOG -e BRIDGE_EBT_ULOG next-20140723 | grep -v defconf
    next-20140723:include/net/netns/x_tables.h:18:#if IS_ENABLED(CONFIG_IP_NF_TARGET_ULOG)
    next-20140723:include/net/netns/x_tables.h:21:#if IS_ENABLED(CONFIG_BRIDGE_EBT_ULOG)
    next-20140723:net/bridge/netfilter/Makefile:39:obj-$(CONFIG_BRIDGE_EBT_ULOG) += ebt_ulog.o
    next-20140723:net/ipv4/netfilter/Makefile:60:obj-$(CONFIG_IP_NF_TARGET_ULOG) += ipt_ULOG.o

Is the trivial patch to clean up these remnants of the ulog targets
queued somewhere? If not, should I submit it?


Paul Bolle

