From: Marcus Sundberg <marcus@ingate.com>
Subject: [PATCH] [LIBNFNETLINK] Fix endless loop on unknown netfilter
	attributes.
Date: Wed, 08 Aug 2007 21:59:14 +0200
Message-ID: <46BA2092.20702@ingate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Pablo Neira <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi!

[LIBNFNETLINK] Fix endless loop on unknown netfilter attributes.

This prevents an endless loop when nfnl_check_attributes() sees
an unknown attribute.

Signed-off-by: Marcus Sundberg <marcus@ingate.com>


--- libnfnetlink-0.0.30/src/libnfnetlink.c	2007/08/08 11:32:07
+++ libnfnetlink-0.0.30/src/libnfnetlink.c	2007/08/08 11:32:17
@@ -1129,6 +1129,7 @@ int nfnl_check_attributes(const struct n
  					 * the kernel which we don't understand
  					 * yet. We have to silently ignore this
  					 * for the sake of future compatibility */
+					attr = NFA_NEXT(attr, attrlen);
  					continue;
  				}
  				nfa[flavor - 1] = attr;

-- 
---------------------------------------+--------------------------
   Marcus Sundberg <marcus@ingate.com>  | Firewalls with SIP & NAT
  Software Developer, Ingate Systems AB |  http://www.ingate.com/
