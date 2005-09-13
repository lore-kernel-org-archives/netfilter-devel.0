From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 3/4]: Fix rcu race in ipt_REDIRECT
Date: Tue, 13 Sep 2005 09:37:20 +0200
Message-ID: <432681B0.6000705@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="03.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="03.diff"
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

[NETFILTER]: Fix rcu race in ipt_REDIRECT

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9af9e2ec732d00e62b458b46829bc696987d68af
tree 71ec0256101fad8d11b6aaec8330fc1845ba9a23
parent 32be69721bfef1f0ab1c271c60002b06f27bf589
author Patrick McHardy <kaber@trash.net> Sat, 10 Sep 2005 17:48:21 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 10 Sep 2005 17:48:21 +0200

 net/ipv4/netfilter/ipt_REDIRECT.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_REDIRECT.c b/net/ipv4/netfilter/ipt_REDIRECT.c
--- a/net/ipv4/netfilter/ipt_REDIRECT.c
+++ b/net/ipv4/netfilter/ipt_REDIRECT.c
@@ -88,14 +88,18 @@ redirect_target(struct sk_buff **pskb,
 		newdst = htonl(0x7F000001);
 	else {
 		struct in_device *indev;
+		struct in_ifaddr *ifa;
 
-		/* Device might not have an associated in_device. */
-		indev = (struct in_device *)(*pskb)->dev->ip_ptr;
-		if (indev == NULL || indev->ifa_list == NULL)
-			return NF_DROP;
+		newdst = 0;
+		
+		rcu_read_lock();
+		indev = __in_dev_get((*pskb)->dev);
+		if (indev && (ifa = indev->ifa_list))
+			newdst = ifa->ifa_local;
+		rcu_read_unlock();
 
-		/* Grab first address on interface. */
-		newdst = indev->ifa_list->ifa_local;
+		if (!newdst)
+			return NF_DROP;
 	}
 
 	/* Transfer from original range. */
