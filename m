From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: nf_nat: fix IPsec policy checks
Date: Mon, 06 Nov 2006 15:56:42 +0100
Message-ID: <454F4D2A.1040907@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090506020609010400010709"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------090506020609010400010709
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Fix IPsec NAT with new NAT code. I'll fold it into the main NAT
patch when a few more fixes have accumulated.


--------------090506020609010400010709
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: nf_nat: fix IPsec policy checks

Use corrent config option for nf_nat in nf_nat_decode_session.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 2f20bca4b86255ad356dd1fbc8f28e2a6c2c9e6b
tree 30fe7565159d867b6918afff8ca74823548f2fa9
parent d2cde0011de62b34c5c0f95ba584962046277953
author Patrick McHardy <kaber@trash.net> Mon, 06 Nov 2006 15:55:47 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 06 Nov 2006 15:55:47 +0100

 include/linux/netfilter.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index b7e67d1..2d21fb5 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -331,7 +331,7 @@ extern void (*ip_nat_decode_session)(str
 static inline void
 nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl, int family)
 {
-#ifdef CONFIG_IP_NF_NAT_NEEDED
+#if defined(CONFIG_IP_NF_NAT_NEEDED) || defined(CONFIG_NF_NAT_NEEDED)
 	void (*decodefn)(struct sk_buff *, struct flowi *);
 
 	if (family == AF_INET && (decodefn = ip_nat_decode_session) != NULL)

--------------090506020609010400010709--
