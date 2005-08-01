From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2.4 1/6]: Ignore PSH on SYN/ACK in ipt_unclean
Date: Mon, 01 Aug 2005 02:42:20 +0200
Message-ID: <42ED6FEC.7010304@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="1.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="1.diff"
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

[NETFILTER]: Ignore PSH on SYN/ACK in ipt_unclean

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 2a330e4e1da97267e1dd4a2ed3f8cd7cabdf21ca
tree 17f5c0f9146335f39cb9f36855de749b2cc1edc7
parent cbff79e43c1a47953098fdf3168dbc8320eba515
author Patrick McHardy <kaber@trash.net> Sun, 31 Jul 2005 18:47:20 +0200
committer Patrick McHardy <kaber@trash.net> Sun, 31 Jul 2005 18:47:20 +0200

 net/ipv4/netfilter/ipt_unclean.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_unclean.c b/net/ipv4/netfilter/ipt_unclean.c
--- a/net/ipv4/netfilter/ipt_unclean.c
+++ b/net/ipv4/netfilter/ipt_unclean.c
@@ -264,6 +264,7 @@ static u8 tcp_valid_flags[(TH_FIN|TH_SYN
 {
 	[TH_SYN]			= 1,
 	[TH_SYN|TH_ACK]			= 1,
+	[TH_SYN|TH_ACK|TH_PUSH]		= 1,
 	[TH_RST]			= 1,
 	[TH_RST|TH_ACK]			= 1,
 	[TH_RST|TH_ACK|TH_PUSH]		= 1,
