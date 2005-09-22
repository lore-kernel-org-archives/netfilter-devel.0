From: Marcus Sundberg <marcus@ingate.com>
Subject: [PATCH 2.4.32-pre3] Fix bogus inline in ip_conntrack.h
Date: Thu, 22 Sep 2005 19:04:05 +0200
Message-ID: <4332E405.80307@ingate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
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

this patch fixes a compilation issue with gcc 3.4.3.

//Marcus

--- linux-2.4.32-pre3/include/linux/netfilter_ipv4/ip_conntrack.h	12 May 2005 08:46:44 -0000
+++ linux/include/linux/netfilter_ipv4/ip_conntrack.h	22 Sep 2005 16:53:37 -0000
@@ -229,7 +229,7 @@ extern struct ip_conntrack *
  ip_conntrack_get(struct sk_buff *skb, enum ip_conntrack_info *ctinfo);

  /* decrement reference count on a conntrack */
-extern inline void ip_conntrack_put(struct ip_conntrack *ct);
+extern void ip_conntrack_put(struct ip_conntrack *ct);

  /* find unconfirmed expectation based on tuple */
  struct ip_conntrack_expect *


Signed-off-by: Marcus Sundberg <marcus@ingate.com>

-- 
---------------------------------------+--------------------------
   Marcus Sundberg <marcus@ingate.com>  | Firewalls with SIP & NAT
  Software Developer, Ingate Systems AB |  http://www.ingate.com/
