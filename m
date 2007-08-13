From: joe@perches.com
Subject: [PATCH] [334/2many] MAINTAINERS - NETFILTER/IPTABLES/IPCHAINS
Date: Sun, 12 Aug 2007 23:32:32 -0700
Message-ID: <46bffb00.MIU7+dJ2jzwTaehX%joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: torvalds@linux-foundation.org, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org, kaber@trash.net,
	coreteam@netfilter.org, akpm@linux-foundation.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S936493AbXHMKUo@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 7e3b438..bc571b8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3200,6 +3200,12 @@ L:	coreteam@netfilter.org
 W:	http://www.netfilter.org/
 W:	http://www.iptables.org/
 S:	Supported
+F:	include/linux/netfilter*
+F:	include/linux/netfilter/
+F:	include/net/netfilter/
+F:	net/*/netfilter.c
+F:	net/*/netfilter/
+F:	net/netfilter/
 
 NETLABEL
 P:	Paul Moore
