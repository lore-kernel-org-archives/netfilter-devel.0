From: Chris Wright <chrisw@sous-sol.org>
Subject: [patch 08/59] NETFILTER: tcp conntrack: fix IP_CT_TCP_FLAG_CLOSE_INIT value
Date: Fri, 02 Feb 2007 18:35:12 -0800
Message-ID: <20070203023848.631905000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@lists.netfilter.org, davem@davemloft.net
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1946209AbXBCCyH@vger.kernel.org>
Content-Disposition: inline; filename=netfilter-tcp-conntrack-fix-ip_ct_tcp_flag_close_init-value.patch
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Patrick McHardy <kaber@trash.net>

IP_CT_TCP_FLAG_CLOSE_INIT is a flag and should have a value of 0x4 instead
of 0x3, which is IP_CT_TCP_FLAG_WINDOW_SCALE | IP_CT_TCP_FLAG_SACK_PERM.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

 include/linux/netfilter/nf_conntrack_tcp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.19.2.orig/include/linux/netfilter/nf_conntrack_tcp.h
+++ linux-2.6.19.2/include/linux/netfilter/nf_conntrack_tcp.h
@@ -25,7 +25,7 @@ enum tcp_conntrack {
 #define IP_CT_TCP_FLAG_SACK_PERM		0x02
 
 /* This sender sent FIN first */
-#define IP_CT_TCP_FLAG_CLOSE_INIT		0x03
+#define IP_CT_TCP_FLAG_CLOSE_INIT		0x04
 
 #ifdef __KERNEL__
 

--
