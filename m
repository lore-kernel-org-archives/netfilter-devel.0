From: Felix Janda <felix.janda@posteo.de>
Subject: [PATCH iptables RFC 4/4] libxt_TCPOPTSTRIP: Use local copy of
 TCPOPTS constants
Date: Tue, 16 Jun 2015 21:25:04 +0200
Message-ID: <20150616192504.GF3247@euler>
Reply-To: musl@lists.openwall.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: musl@lists.openwall.com
To: netfilter-devel@vger.kernel.org
Return-path: <musl-return-7961-gllmg-musl=m.gmane.org@lists.openwall.com>
List-Post: <mailto:musl@lists.openwall.com>
List-Help: <mailto:musl-help@lists.openwall.com>
List-Unsubscribe: <mailto:musl-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:musl-subscribe@lists.openwall.com>
Content-Disposition: inline
List-Id: netfilter-devel.vger.kernel.org

musl does not provide these constants in <netinet/tcp.h>

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
It is not clear to me whether these constants belong to iptables or musl's
netinet/tcp.h. So this message is CC'd to the musl list.

In the code indexed by debian code search I have only found iptables and
traceroute using them without having a local copy of tcp.h.

Note that this patch is incomplete: utils/nfsynproxy.c uses them as well
---
 extensions/libxt_TCPOPTSTRIP.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_TCPOPTSTRIP.c b/extensions/libxt_TCPOPTSTRIP.c
index 6897857..1617081 100644
--- a/extensions/libxt_TCPOPTSTRIP.c
+++ b/extensions/libxt_TCPOPTSTRIP.c
@@ -7,11 +7,14 @@
 #include <stdio.h>
 #include <string.h>
 #include <xtables.h>
-#include <netinet/tcp.h>
 #include <linux/netfilter/xt_TCPOPTSTRIP.h>
-#ifndef TCPOPT_MD5SIG
-#	define TCPOPT_MD5SIG 19
-#endif
+
+#define TCPOPT_MAXSEG 2
+#define TCPOPT_WINDOW 3
+#define TCPOPT_SACK_PERMITTED 4
+#define TCPOPT_SACK 5
+#define TCPOPT_TIMESTAMP 8
+#define TCPOPT_MD5SIG 19
 
 enum {
 	O_STRIP_OPTION = 0,
-- 
2.3.6
