From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] IRC Zero Port Fix
Date: Tue, 25 Jan 2005 18:08:48 +1100
Message-ID: <1106636928.19186.47.camel@localhost.localdomain>
References: <1106412163.7965.10.camel@debian>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Ian Kumlien <pomac@vapor.com>
In-Reply-To: <1106412163.7965.10.camel@debian>
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

On Sat, 2005-01-22 at 17:42 +0100, Ian Kumlien wrote:
> Hi, 
> 
> I just noticed that the dcc helper doesn't work, it just sets the source
> ip to 0. And since i have no clue of that code, i choose not to dive in
> to it with no prior knowledge to structures and stuff.. I decided to ask
> you instead.
> 
> So is this known?
> And you don't do anything to the size with the new code right?

Here's the fix, thanks for the bug report.

Rusty (who just learnt a lot about the IRC protocol).

Name: IRC Zero Port Fix
Status: Tested under nfsim, booted under qemu
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Ian Kumlien reported that new NAT code started sending out DCC
requests with 0 as the IP address.  That prompted me to write a simple
IRC test case, which both illustrated the bug, and found another one
in that the wrong expectation was being set up when NAT occurred.

Index: linux-2.6.11-rc2-bk2-Netfilter/net/ipv4/netfilter/ip_nat_irc.c
===================================================================
--- linux-2.6.11-rc2-bk2-Netfilter.orig/net/ipv4/netfilter/ip_nat_irc.c	2005-01-24 11:14:14.000000000 +1100
+++ linux-2.6.11-rc2-bk2-Netfilter/net/ipv4/netfilter/ip_nat_irc.c	2005-01-25 16:30:31.006522720 +1100
@@ -83,7 +83,10 @@
 	 *              0x01, \n:  terminators
 	 */
 
-	sprintf(buffer, "%u %u", ntohl(exp->tuple.src.ip), port);
+	/* AAA = "us", ie. where server normally talks to. */
+	sprintf(buffer, "%u %u",
+		ntohl(exp->master->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip),
+		port);
 	DEBUGP("ip_nat_irc: Inserting '%s' == %u.%u.%u.%u, port %u\n",
 	       buffer, NIPQUAD(exp->tuple.src.ip), port);
 
Index: linux-2.6.11-rc2-bk2-Netfilter/net/ipv4/netfilter/ip_conntrack_irc.c
===================================================================
--- linux-2.6.11-rc2-bk2-Netfilter.orig/net/ipv4/netfilter/ip_conntrack_irc.c	2005-01-24 11:14:14.000000000 +1100
+++ linux-2.6.11-rc2-bk2-Netfilter/net/ipv4/netfilter/ip_conntrack_irc.c	2005-01-25 16:46:57.998477136 +1100
@@ -209,9 +209,14 @@
 			DEBUGP("tcph->seq = %u\n", th->seq);
 			seq = ntohl(th->seq) + (addr_beg_p - ib_ptr);
 
+			/* We refer to the reverse direction ("!dir")
+			 * tuples here, because we're expecting
+			 * something in the other * direction.
+			 * Doesn't matter unless NAT is happening.  */
 			exp->tuple = ((struct ip_conntrack_tuple)
 				{ { 0, { 0 } },
-				  { ct->tuplehash[dir].tuple.src.ip, { .tcp = { htons(dcc_port) } },
+				  { ct->tuplehash[!dir].tuple.dst.ip,
+				    { .tcp = { htons(dcc_port) } },
 				    IPPROTO_TCP }});
 			exp->mask = ((struct ip_conntrack_tuple)
 				{ { 0, { 0 } },

-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
