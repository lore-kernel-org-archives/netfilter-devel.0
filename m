From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/04]: Use pskb_trim in {ip,ip6,nfnetlink}_queue
Date: Tue, 14 Nov 2006 08:03:29 +0100 (MET)
Message-ID: <20061114070329.13023.80436.sendpatchset@localhost.localdomain>
References: <20061114070325.13023.10720.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061114070325.13023.10720.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Use pskb_trim in {ip,ip6,nfnetlink}_queue

Based on patch by James D. Nurmi:

I've got some code very dependant on nfnetlink_queue, and turned up a
large number of warns coming from skb_trim.  While it's quite possibly
my code, having not seen it on older kernels made me a bit suspect.

Anyhow, based on some googling I turned up this thread:
http://lkml.org/lkml/2006/8/13/56

And believe the issue to be related, so attached is a small patch to
the kernel -- not sure if this is completely correct, but for anyone
else hitting the WARN_ON(1) in skbuff.h, it might be helpful..

Signed-off-by: James D. Nurmi <jdnurmi@gmail.com>

Ported to ip6_queue and nfnetlink_queue and added return value
checks.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 0c9a47cafdd2f6db3e090359392efd64d5d027cd
tree ebefab5aef3e079f489a11d1072318406a72e503
parent 7c1ac6f74a10cb9fe0800de7e9a1626497dde438
author Patrick McHardy <kaber@trash.net> Tue, 14 Nov 2006 07:57:11 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 14 Nov 2006 07:57:11 +0100

 net/ipv4/netfilter/ip_queue.c   |    7 ++++---
 net/ipv6/netfilter/ip6_queue.c  |    7 ++++---
 net/netfilter/nfnetlink_queue.c |    7 ++++---
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/netfilter/ip_queue.c b/net/ipv4/netfilter/ip_queue.c
index 7edad79..97556cc 100644
--- a/net/ipv4/netfilter/ip_queue.c
+++ b/net/ipv4/netfilter/ip_queue.c
@@ -351,9 +351,10 @@ ipq_mangle_ipv4(ipq_verdict_msg_t *v, st
 	if (v->data_len < sizeof(*user_iph))
 		return 0;
 	diff = v->data_len - e->skb->len;
-	if (diff < 0)
-		skb_trim(e->skb, v->data_len);
-	else if (diff > 0) {
+	if (diff < 0) {
+		if (pskb_trim(e->skb, v->data_len))
+			return -ENOMEM;
+	} else if (diff > 0) {
 		if (v->data_len > 0xFFFF)
 			return -EINVAL;
 		if (diff > skb_tailroom(e->skb)) {
diff --git a/net/ipv6/netfilter/ip6_queue.c b/net/ipv6/netfilter/ip6_queue.c
index 9510c24..9fec832 100644
--- a/net/ipv6/netfilter/ip6_queue.c
+++ b/net/ipv6/netfilter/ip6_queue.c
@@ -349,9 +349,10 @@ ipq_mangle_ipv6(ipq_verdict_msg_t *v, st
 	if (v->data_len < sizeof(*user_iph))
 		return 0;
 	diff = v->data_len - e->skb->len;
-	if (diff < 0)
-		skb_trim(e->skb, v->data_len);
-	else if (diff > 0) {
+	if (diff < 0) {
+		if (pskb_trim(e->skb, v->data_len))
+			return -ENOMEM;
+	} else if (diff > 0) {
 		if (v->data_len > 0xFFFF)
 			return -EINVAL;
 		if (diff > skb_tailroom(e->skb)) {
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 6e4ada3..e815a9a 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -622,9 +622,10 @@ nfqnl_mangle(void *data, int data_len, s
 	int diff;
 
 	diff = data_len - e->skb->len;
-	if (diff < 0)
-		skb_trim(e->skb, data_len);
-	else if (diff > 0) {
+	if (diff < 0) {
+		if (pskb_trim(e->skb, data_len))
+			return -ENOMEM;
+	} else if (diff > 0) {
 		if (data_len > 0xFFFF)
 			return -EINVAL;
 		if (diff > skb_tailroom(e->skb)) {
