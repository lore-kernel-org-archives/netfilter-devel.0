From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [1/1] OSF: small documentation update.
Date: Sat, 10 Dec 2005 00:43:14 +0300
Message-ID: <20051209214314.GA21647@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@netfilter.org>, PatriK McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

Index: patch-o-matic-ng/patchlets/osf/help
===================================================================
--- patch-o-matic-ng/patchlets/osf/help	(revision 6310)
+++ patch-o-matic-ng/patchlets/osf/help	(working copy)
@@ -30,8 +30,13 @@
 	OSF will use initial TTL only if source of connection is in our local network.
   
   --netlink
-	If present, OSF will log all events also through netlink NETLINK_NFLOG groupt 1.
+	If present, OSF will log all events also through netlink NETLINK_NFLOG group 1.
 
+  --connector
+	2.6.14+ only.
+	If present, OSF will log all events also through netlink connector(1.0 id).
+	More about connector can be found in Documentation/connector in kernel source tree.
+
 Fingerprints can be loaded and read through /proc/sys/net/ipv4/osf file.
 One can flush all fingerprints with following command:
 echo -en FLUSH > /proc/sys/net/ipv4/osf

-- 
	Evgeniy Polyakov
