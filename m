From: Greg KH <gregkh@suse.de>
Subject: [patch 03/20] tcp conntrack: accept SYN|URG as valid
Date: Fri, 9 Mar 2007 22:16:53 -0800
Message-ID: <20070310061653.GD31412@kroah.com>
References: <20070310061234.465093436@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>, davem@davemloft.net
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752324AbXCJGTA@vger.kernel.org>
Content-Disposition: inline; filename="tcp-conntrack-accept-syn-urg-as-valid.patch"
In-Reply-To: <20070310061603.GA31412@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Patrick McHardy <kaber@trash.net>

[NETFILTER]: tcp conntrack: accept SYN|URG as valid

Some stacks apparently send packets with SYN|URG set. Linux accepts
these packets, so TCP conntrack should to.

Pointed out by Martijn Posthuma <posthuma@sangine.com>.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
 net/ipv4/netfilter/ip_conntrack_proto_tcp.c |    4 +++-
 net/netfilter/nf_conntrack_proto_tcp.c      |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
@@ -821,8 +821,10 @@ void ip_conntrack_tcp_update(struct sk_b
 static const u8 tcp_valid_flags[(TH_FIN|TH_SYN|TH_RST|TH_PUSH|TH_ACK|TH_URG) + 1] =
 {
 	[TH_SYN]			= 1,
-	[TH_SYN|TH_ACK]			= 1,
 	[TH_SYN|TH_PUSH]		= 1,
+	[TH_SYN|TH_URG]			= 1,
+	[TH_SYN|TH_PUSH|TH_URG]		= 1,
+	[TH_SYN|TH_ACK]			= 1,
 	[TH_SYN|TH_ACK|TH_PUSH]		= 1,
 	[TH_RST]			= 1,
 	[TH_RST|TH_ACK]			= 1,
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -778,8 +778,10 @@ EXPORT_SYMBOL_GPL(nf_conntrack_tcp_updat
 static u8 tcp_valid_flags[(TH_FIN|TH_SYN|TH_RST|TH_PUSH|TH_ACK|TH_URG) + 1] =
 {
 	[TH_SYN]			= 1,
-	[TH_SYN|TH_ACK]			= 1,
 	[TH_SYN|TH_PUSH]		= 1,
+	[TH_SYN|TH_URG]			= 1,
+	[TH_SYN|TH_PUSH|TH_URG]		= 1,
+	[TH_SYN|TH_ACK]			= 1,
 	[TH_SYN|TH_ACK|TH_PUSH]		= 1,
 	[TH_RST]			= 1,
 	[TH_RST|TH_ACK]			= 1,

-- 
