From: "Wojciech \"Sas\" Cieciwa" <cieciwa@alpha.zarz.agh.edu.pl>
Subject: [FWD][PATCH] ip6t-align
Date: Mon, 19 May 2003 16:47:59 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44L.0305191645580.32612-100000@alpha.zarz.agh.edu.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

This is patch from my friend.

		=== *** === *** === 

The calculated padding used for alignment in struct ip6t_table_info
type definition is wrong.
char[SMP_ALIGN((NF_IP6_NUMHOOKS*2+2)*sizeof(unsigned int))]
has _its size_ (not end address) aligned to cache line size; also note
that there are 3 ints, not 2 before arrays. And if whole ip6t_table_info
started on address aligned to 8, entries were placed on address not
aligned to 8. On some machines (at least ppc - IBM RS/6000)
__alignof__(struct ip6t_entry) is 8 - so loading any ip6table_* module
failed with "Bad offset".

Probably padding was meant to be something like
char padding[SMP_ALIGN((NF_IP6_NUMHOOKS*2+3)*sizeof(unsigned int)) -
	((NF_IP6_NUMHOOKS*2+3)*sizeof(unsigned int))]
but it's simpler to use gcc's aligned attribute through
____cacheline_aligned macro (just like in ipt_table_info struct in
ip_tables module for ipv4/netfilter).


	Jakub Bogusz <qboosh@pld.org.pl>

--- linux-2.4.20/net/ipv6/netfilter/ip6_tables.c.orig	Fri May 16 10:17:40 2003
+++ linux-2.4.20/net/ipv6/netfilter/ip6_tables.c	Fri May 16 14:37:52 2003
@@ -113,10 +113,8 @@
 	unsigned int hook_entry[NF_IP6_NUMHOOKS];
 	unsigned int underflow[NF_IP6_NUMHOOKS];
 
-	char padding[SMP_ALIGN((NF_IP6_NUMHOOKS*2+2)*sizeof(unsigned int))];
-
 	/* ip6t_entry tables: one per CPU */
-	char entries[0];
+	char entries[0] ____cacheline_aligned;
 };
 
 static LIST_HEAD(ip6t_target);
@@ -1533,7 +1531,7 @@
 	int ret;
 	struct ip6t_table_info *newinfo;
 	static struct ip6t_table_info bootstrap
-		= { 0, 0, 0, { 0 }, { 0 }, { }, { } };
+		= { 0, 0, 0, { 0 }, { 0 }, { } };
 
 	MOD_INC_USE_COUNT;
 	newinfo = vmalloc(sizeof(struct ip6t_table_info)

Thanx.
-- 
{Wojciech 'Sas' Cieciwa}  {Member of PLD Team                               }
{e-mail: cieciwa@alpha.zarz.agh.edu.pl, http://www2.zarz.agh.edu.pl/~cieciwa}
