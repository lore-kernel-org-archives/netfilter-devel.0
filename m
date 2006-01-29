From: Michael Rash <mbr@cipherdyne.org>
Subject: [PATCH] fix save() output in libipt_string.c
Date: Sun, 29 Jan 2006 16:08:29 -0500
Message-ID: <20060129210829.GA10213@minastirith.cipherdyne.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

This patch fixes bug #436 where save() in libipt_string.c outputs
"--to-offset" and "--from-offset" instead of "--to" and "--from"
respectively (breaks iptables-restore whenever string matching rules are
included).  Tested against iptables-1.3.4 and kernel 2.6.15.1.

--- iptables-1.3.4/extensions/libipt_string.c.orig      2006-01-29 15:49:56.000000000 -0500
+++ iptables-1.3.4/extensions/libipt_string.c   2006-01-29 15:51:16.000000000 -0500
@@ -327,9 +327,9 @@ save(const struct ipt_ip *ip, const stru
        }
        printf("--algo %s ", info->algo);
        if (info->from_offset != 0)
-               printf("--from-offset %u ", info->from_offset);
+               printf("--from %u ", info->from_offset);
        if (info->to_offset != 0)
-               printf("--to-offset %u ", info->to_offset);
+               printf("--to %u ", info->to_offset);
 }



--
Michael Rash
http://www.cipherdyne.org/
Key fingerprint = 53EA 13EA 472E 3771 894F  AC69 95D8 5D6B A742 839F
