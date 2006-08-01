From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: SIP helper: expect RTP streams in both directions
Date: Tue, 01 Aug 2006 08:39:50 +0200
Message-ID: <44CEF736.4020105@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080508010304090001050804"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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

This is a multi-part message in MIME format.
--------------080508010304090001050804
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hi Dave,

following are two small fixes for 2.6.18. The second patch fixes
missing string validation in two netfilter modules. James sent a
similar patch for SECMARK to -stable, in my opinion this is not
necessary since CAP_NET_ADMIN in practice always means root and
mainline doesn't support virtualization yet. But if you feel
otherwise please pass it on. Thanks.


--------------080508010304090001050804
Content-Type: text/plain;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

[NETFILTER]: SIP helper: expect RTP streams in both directions

Since we don't know in which direction the first packet will arrive, we
need to create one expectation for each direction, which is currently
prevented by max_expected beeing set to 1.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit e8b121382d0690c0d92b6134bb60e7626cd49284
tree 2a85a79242cb160e35d207d504886e770db2ed6f
parent 49b1e3ea19b1c95c2f012b8331ffb3b169e4c042
author Patrick McHardy <kaber@trash.net> Tue, 01 Aug 2006 07:26:21 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 01 Aug 2006 07:26:21 +0200

 net/ipv4/netfilter/ip_conntrack_sip.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_sip.c b/net/ipv4/netfilter/ip_conntrack_sip.c
index fc87ce0..4f222d6 100644
--- a/net/ipv4/netfilter/ip_conntrack_sip.c
+++ b/net/ipv4/netfilter/ip_conntrack_sip.c
@@ -442,7 +442,7 @@ static int __init init(void)
 		sip[i].tuple.src.u.udp.port = htons(ports[i]);
 		sip[i].mask.src.u.udp.port = 0xFFFF;
 		sip[i].mask.dst.protonum = 0xFF;
-		sip[i].max_expected = 1;
+		sip[i].max_expected = 2;
 		sip[i].timeout = 3 * 60; /* 3 minutes */
 		sip[i].me = THIS_MODULE;
 		sip[i].help = sip_help;

--------------080508010304090001050804--
