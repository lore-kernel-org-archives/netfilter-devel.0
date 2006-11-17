From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: H.323 conntrack: fix crash with CONFIG_IP_NF_CT_ACCT
Date: Fri, 17 Nov 2006 21:08:11 +0100
Message-ID: <455E16AB.1010101@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080405010200040101030103"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	stable@kernel.org
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
--------------080405010200040101030103
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

The following patch fixes a crash in ip_ct_refresh_acct() with the
H.323 helper caused by a NULL-ptr dereference. The patch applies
cleanly to current git and -stable.

Please apply, thanks.



--------------080405010200040101030103
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: H.323 conntrack: fix crash with CONFIG_IP_NF_CT_ACCT

H.323 connection tracking code calls ip_ct_refresh_acct() when
processing RCFs and URQs but passes NULL as the skb.
When CONFIG_IP_NF_CT_ACCT is enabled, the connection tracking core tries
to derefence the skb, which results in an obvious panic.
A similar fix was applied on the SIP connection tracking code some time
ago.

Signed-off-by: Faidon Liambotis <paravoid@debian.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 76b0c2b63fd5a2da358b36a22b7bf99298dde0b7
tree cd96ddb4c4cd5ffb44ed5a47fa3be41267eea99a
parent 1b9bb3c14c60324b54645ffefbe6d270f9fd191c
author Faidon Liambotis <paravoid@debian.org> Fri, 17 Nov 2006 21:01:25 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 17 Nov 2006 21:01:25 +0100

 net/ipv4/netfilter/ip_conntrack_helper_h323.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_helper_h323.c b/net/ipv4/netfilter/ip_conntrack_helper_h323.c
index 7b74412..aeb60dc 100644
--- a/net/ipv4/netfilter/ip_conntrack_helper_h323.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_h323.c
@@ -1417,7 +1417,7 @@ static int process_rcf(struct sk_buff **
 		DEBUGP
 		    ("ip_ct_ras: set RAS connection timeout to %u seconds\n",
 		     info->timeout);
-		ip_ct_refresh_acct(ct, ctinfo, NULL, info->timeout * HZ);
+		ip_ct_refresh(ct, *pskb, info->timeout * HZ);
 
 		/* Set expect timeout */
 		read_lock_bh(&ip_conntrack_lock);
@@ -1465,7 +1465,7 @@ static int process_urq(struct sk_buff **
 	info->sig_port[!dir] = 0;
 
 	/* Give it 30 seconds for UCF or URJ */
-	ip_ct_refresh_acct(ct, ctinfo, NULL, 30 * HZ);
+	ip_ct_refresh(ct, *pskb, 30 * HZ);
 
 	return 0;
 }

--------------080405010200040101030103--
