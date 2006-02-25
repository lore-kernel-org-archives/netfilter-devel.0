From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: H.323 helper: Missing module owner initialization
Date: Sat, 25 Feb 2006 10:06:54 +0100
Message-ID: <44001E2E.5070708@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="04.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jing Min Zhao <zhaojingmin@hotmail.com>
Content-Disposition: inline;
 filename="04.diff"
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

[NETFILTER]: H.323 helper: Missing module owner initialization

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5f82d1be86080aa5981557cf1431b1f96c636c20
tree a114daf1fa3624a78dd1ab0853c807c2fb61c134
parent 9141da3e4912a8df591add5ea10dc55b5df83c21
author Patrick McHardy <kaber@trash.net> Thu, 23 Feb 2006 19:06:25 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 23 Feb 2006 19:06:25 +0100

 net/ipv4/netfilter/ip_conntrack_helper_h323.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_helper_h323.c b/net/ipv4/netfilter/ip_conntrack_helper_h323.c
index 212e258..0250055 100644
--- a/net/ipv4/netfilter/ip_conntrack_helper_h323.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_h323.c
@@ -458,6 +458,7 @@ out_unlock:
 /****************************************************************************/
 static struct ip_conntrack_helper ip_conntrack_helper_h245 = {
 	.name = "H.245",
+	.me = THIS_MODULE,
 	.max_expected = H323_CHANNEL_MAX * 2,
 	.timeout = 240,
 	.tuple = {.dst = {.protonum = IPPROTO_TCP}},
