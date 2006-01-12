From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ctnetlink: Make expect events work
Date: Thu, 12 Jan 2006 22:03:20 +0100
Message-ID: <43C6C418.6060104@trash.net>
References: <43C6A946.5070009@ingate.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070303010904000704030202"
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marcus Sundberg <marcus@ingate.com>
In-Reply-To: <43C6A946.5070009@ingate.com>
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
--------------070303010904000704030202
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Marcus Sundberg wrote:
> [NETFILTER] ctnetlink: Make expect events work
> 
> The ctnetlink expectation events should use the NFNL_SUBSYS_CTNETLINK_EXP
> subsystem, not NFNL_SUBSYS_CTNETLINK.

Thanks, applied with the same change in nfnetlink_conntrack.
For future patches please also check if bugs are present in
nfnetlink_conntrack.

--------------070303010904000704030202
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: ctnetlink: Fix subsystem used for expectation events

The ctnetlink expectation events should use the NFNL_SUBSYS_CTNETLINK_EXP
subsystem, not NFNL_SUBSYS_CTNETLINK.

Signed-off-by: Marcus Sundberg <marcus@ingate.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 078ff587a861c7d2499990ca46766c030bae5ecc
tree 0064472eb1373f544ac136d3cd35194b6493a437
parent d98b092ef1a291d2fd31cbf1152bd16cca2e925d
author Marcus Sundberg <marcus@ingate.com> Thu, 12 Jan 2006 22:00:52 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 12 Jan 2006 22:00:52 +0100

 net/ipv4/netfilter/ip_conntrack_netlink.c |    2 +-
 net/netfilter/nf_conntrack_netlink.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index c9ebbe0..b62518b 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -1216,7 +1216,7 @@ static int ctnetlink_expect_event(struct
 
 	b = skb->tail;
 
-	type |= NFNL_SUBSYS_CTNETLINK << 8;
+	type |= NFNL_SUBSYS_CTNETLINK_EXP << 8;
 	nlh   = NLMSG_PUT(skb, 0, 0, type, sizeof(struct nfgenmsg));
 	nfmsg = NLMSG_DATA(nlh);
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 73ab16b..e98d00c 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1232,7 +1232,7 @@ static int ctnetlink_expect_event(struct
 
 	b = skb->tail;
 
-	type |= NFNL_SUBSYS_CTNETLINK << 8;
+	type |= NFNL_SUBSYS_CTNETLINK_EXP << 8;
 	nlh   = NLMSG_PUT(skb, 0, 0, type, sizeof(struct nfgenmsg));
 	nfmsg = NLMSG_DATA(nlh);
 

--------------070303010904000704030202--
