From: Patrick McHardy <kaber@cvs.netfilter.org>
Subject: [PATCH] fix a similar bug to ip6t_TTL.c in ip6t_HL.c
Date: Wed, 28 Jul 2004 12:35:27 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <516930513.20040728123527@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Resent-Message-Id: <E1Bplmt-0001uC-I7@vishnu.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

A similar bug to the one fixed by kaber exists in
patch-o-matic-ng/HOPLIMIT/linux/net/ipv6/netfilter/ip6t_HL.c

Please apply,
Regards,
Maciej

Index: ip6t_HL.c
===================================================================
RCS file: /cvspublic/patch-o-matic-ng/HOPLIMIT/linux/net/ipv6/netfilter/ip6t_HL.c,v
retrieving revision 1.3
diff -u -r1.3 ip6t_HL.c
--- ip6t_HL.c   5 Mar 2004 09:30:26 -0000       1.3
+++ ip6t_HL.c   28 Jul 2004 10:33:07 -0000
@@ -36,7 +36,7 @@
                                new_hl = 255;
                        break;
                case IP6T_HL_DEC:
-                       new_hl = ip6h->hop_limit + info->hop_limit;
+                       new_hl = ip6h->hop_limit - info->hop_limit;
                        if (new_hl < 0)
                                new_hl = 0;
                        break;
