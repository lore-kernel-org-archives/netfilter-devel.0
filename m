From: "Samuel Jean" <jix@bugmachine.ca>
Subject: [PATCH] Change URL for geoip repository
Date: Tue, 12 Dec 2006 03:20:31 -0000
Message-ID: <twig.1165893631.14369@bugmachine.ca>
Reply-To: jix@bugmachine.ca
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <kaber@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi Patrick,

Please apply the following patch to make patch-o-matic downloads
geoip patchlet from my people.netfilter.org

Sorry for the inconvenient, my personal network mynodes.net might
be down for a while due to the lack of good ISP here.

Regards,
Samuel

Index: sources.list
===================================================================
--- sources.list        (revision 6709)
+++ sources.list        (working copy)
@@ -2,7 +2,7 @@
 #

 # geoip, maintained by Samuel Jean <jix@bugmachine.ca>
-http://mynodes.net/pub/linux/netfilter/patchlets
+http://people.netfilter.org/peejix/patchlets

 # condition, maintained by Massimiliano Hofer <max@nucleus.it>
 http://www.nucleus.it/pom-repo
