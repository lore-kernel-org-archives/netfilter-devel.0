From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 4/4]: Fix DHCP + MASQUERADE problem
Date: Tue, 13 Sep 2005 09:37:22 +0200
Message-ID: <432681B2.8090908@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030301070206020906030603"
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
--------------030301070206020906030603
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This is the fix for the DHCP+MASQUERADE regression.

@the -stable people: please apply this patch to -stable.
To avoid confusion, only this patch (4/4) is meant for
-stable, the first three patches were not CCed.

--------------030301070206020906030603
Content-Type: text/x-patch;
 name="04.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="04.diff"

[NETFILTER]: Fix DHCP + MASQUERADE problem

In 2.6.13-rcX the MASQUERADE target was changed not to exclude local
packets for better source address consistency. This breaks DHCP clients
using UDP sockets when the DHCP requests are caught by a MASQUERADE rule
because the MASQUERADE target drops packets when no address is configured
on the outgoing interface. This patch makes it ignore packets with a
source address of 0.

Thanks to Rusty for this suggestion.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5048a58f5d9643ca88593cda13433006599b77d3
tree fec8093ebdf5c8f44c87492fadcedbb7ad40f6ae
parent 9af9e2ec732d00e62b458b46829bc696987d68af
author Patrick McHardy <kaber@trash.net> Tue, 13 Sep 2005 09:32:06 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 13 Sep 2005 09:32:06 +0200

 net/ipv4/netfilter/ipt_MASQUERADE.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -90,6 +90,12 @@ masquerade_target(struct sk_buff **pskb,
 	IP_NF_ASSERT(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED
 	                    || ctinfo == IP_CT_RELATED + IP_CT_IS_REPLY));
 
+	/* Source address is 0.0.0.0 - locally generated packet that is
+	 * probably not supposed to be masqueraded.
+	 */
+	if (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip == 0)
+		return NF_ACCEPT;
+
 	mr = targinfo;
 	rt = (struct rtable *)(*pskb)->dst;
 	newsrc = inet_select_addr(out, rt->rt_gateway, RT_SCOPE_UNIVERSE);

--------------030301070206020906030603--
