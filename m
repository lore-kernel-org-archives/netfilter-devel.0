From: Chris Wright <chrisw@sous-sol.org>
Subject: [patch 20/59] NETFILTER: ctnetlink: fix leak in ctnetlink_create_conntrack error path
Date: Fri, 02 Feb 2007 18:35:24 -0800
Message-ID: <20070203024045.463533000@sous-sol.org>
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
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1946257AbXBCCxV@vger.kernel.org>
Content-Disposition: inline; filename=ctnetlink-fix-leak-in-ctnetlink_create_conntrack-error-path.patch
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Patrick McHardy <kaber@trash.net>

---

 net/ipv4/netfilter/ip_conntrack_netlink.c |    2 +-
 net/netfilter/nf_conntrack_netlink.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.19.2.orig/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ linux-2.6.19.2/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -955,7 +955,7 @@ ctnetlink_create_conntrack(struct nfattr
 	if (cda[CTA_PROTOINFO-1]) {
 		err = ctnetlink_change_protoinfo(ct, cda);
 		if (err < 0)
-			return err;
+			goto err;
 	}
 
 #if defined(CONFIG_IP_NF_CONNTRACK_MARK)
--- linux-2.6.19.2.orig/net/netfilter/nf_conntrack_netlink.c
+++ linux-2.6.19.2/net/netfilter/nf_conntrack_netlink.c
@@ -972,7 +972,7 @@ ctnetlink_create_conntrack(struct nfattr
 	if (cda[CTA_PROTOINFO-1]) {
 		err = ctnetlink_change_protoinfo(ct, cda);
 		if (err < 0)
-			return err;
+			goto err;
 	}
 
 #if defined(CONFIG_NF_CONNTRACK_MARK)

--
