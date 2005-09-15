From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 8/8]: pptp helper: missing expectation flags
	initialisation
Date: Fri, 16 Sep 2005 00:44:59 +0200
Message-ID: <4329F96B.1010306@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="08.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Content-Disposition: inline;
 filename="08.diff"
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

[NETFILTER]: pptp helper: missing expectation flags initialisation

Support for permanent expectations added a flags field to the expectation
that needs to be initialized to 0.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 0ddb4c0a3fcf3cded1b34ec48b66e8874d13f105
tree 0d855d26740383efac8514fdd890786b86921cd6
parent ac7e4424f98eef582b9923011d27c208252a0096
author Patrick McHardy <kaber@trash.net> Fri, 16 Sep 2005 00:21:34 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 16 Sep 2005 00:21:34 +0200

 net/ipv4/netfilter/ip_conntrack_helper_pptp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
--- a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
@@ -250,6 +250,7 @@ exp_gre(struct ip_conntrack *master,
 		
 	exp_orig->master = master;
 	exp_orig->expectfn = pptp_expectfn;
+	exp_orig->flags = 0;
 
 	exp_orig->dir = IP_CT_DIR_ORIGINAL;
 
