From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [1/1] OSF: real close for 399 bug.
Date: Sat, 10 Dec 2005 00:31:57 +0300
Message-ID: <20051209213157.GA14708@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@netfilter.org>, alex@nrbspb.ru,
	PatriK McHardy <kaber@trash.net>
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

Hello, developers.
I've just read bugzilla and found bug 399:
2.4 does not support connector, but I place define for that bit into
header file to shut compiler up.
It does not introduce any kind of regression, since 2.4 OSF version just
do not use that bit.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

Index: patch-o-matic-ng/patchlets/osf/linux/include/linux/netfilter_ipv4/ipt_osf.h
===================================================================
--- patch-o-matic-ng/patchlets/osf/linux/include/linux/netfilter_ipv4/ipt_osf.h	(revision 6310)
+++ patch-o-matic-ng/patchlets/osf/linux/include/linux/netfilter_ipv4/ipt_osf.h	(working copy)
@@ -29,6 +29,7 @@
 #define	IPT_OSF_SMART		2
 #define IPT_OSF_LOG		4
 #define IPT_OSF_NETLINK		8
+#define IPT_OSF_CONNECTOR	16
 
 #define IPT_OSF_LOGLEVEL_ALL	0
 #define IPT_OSF_LOGLEVEL_FIRST	1


-- 
	Evgeniy Polyakov
