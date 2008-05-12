From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] Module aliases for xt_iprange
Date: Mon, 12 May 2008 10:42:46 -0700
Message-ID: <20080512174246.GA28222@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ibTvN161/egqYuK8"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:51538
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753417AbYELRt2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2008 13:49:28 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Using iptables 1.3.8 with kernel 2.6.25, rules which include '-m iprange'
don't automatically pull in xt_iprange module.  Below patch adds module
aliases to fix that.  Patch against latest -git, but seems like a good 
candidate for -stable also.

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>



--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-xt_range-alias

--- linux-2.6.25.i686/net/netfilter/xt_iprange.c.orig	2008-05-12 12:25:55.000000000 -0400
+++ linux-2.6.25.i686/net/netfilter/xt_iprange.c	2008-05-12 12:23:55.000000000 -0400
@@ -179,3 +179,5 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, Jan Engelhardt <jengelh@computergmbh.de>");
 MODULE_DESCRIPTION("Xtables: arbitrary IPv4 range matching");
+MODULE_ALIAS("ipt_iprange");
+MODULE_ALIAS("ip6t_iprange");

--ibTvN161/egqYuK8--
