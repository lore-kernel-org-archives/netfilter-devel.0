From: Carl-Daniel Hailfinger <c-d.hailfinger.kernel.2004@gmx.net>
Subject: [PATCH] remove overzealous checks in REJECT target
Date: Wed, 01 Dec 2004 07:41:39 +0100
Message-ID: <41AD67A3.6090608@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi,

after wondering why the REJECT target didn't work as expected
when scanned with nmap -sO, I found a check in ipt_REJECT.c
for 8 or more bytes of proto header which caused all packets
gernated by nmap to be dropped although they were sent to the
REJECT target. Since I could not see any use for the proto
header length check, I replaced it with a warning.
Now the REJECT target works as expected for all packets I
could thow at it.

Regards,
Carl-Daniel
-- 
http://www.hailfinger.org/

Signed-off-by Carl-Daniel Hailfinger <c-d.hailfinger.kernel.2004@gmx.net>
--- linux-2.6.9/net/ipv4/netfilter/ipt_REJECT.c~	Wed Dec  1 06:38:06 2004
+++ linux-2.6.9/net/ipv4/netfilter/ipt_REJECT.c	Wed Dec  1 06:41:04 2004
@@ -255,7 +255,7 @@ static void send_unreach(struct sk_buff

 	/* Ensure we have at least 8 bytes of proto header. */
 	if (skb_in->len < skb_in->nh.iph->ihl*4 + 8)
-		return;
+		printk("REJECT: we have less than 8 bytes of proto header.\n");

 	/* if UDP checksum is set, verify it's correct */
 	if (iph->protocol == IPPROTO_UDP
