From: Patrick McHardy <kaber@trash.net>
Subject: Re: unaligned access in ipt_ULOG
Date: Mon, 02 Apr 2007 13:55:56 +0200
Message-ID: <4610EF4C.1050209@trash.net>
References: <20070330214857.GB24923@stardust.friedrich-kn.de>
	<20070330.150501.57156021.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090602070602040504030109"
Cc: sparclinux@vger.kernel.org, netfilter-devel@lists.netfilter.org,
	Joerg.Friedrich@friedrich-kn.de
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070330.150501.57156021.davem@davemloft.net>
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
--------------090602070602040504030109
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

David Miller wrote:
> From: Joerg Friedrich <Joerg.Friedrich@friedrich-kn.de>
> Date: Fri, 30 Mar 2007 23:48:57 +0200
> 
> 
>>I wanted to use the iptables ULOG target, but I ran into these error
>>messages. can anyone explain howto read this messge.
>>
>>Kernel unaligned access at TPC[1029e35c] ipt_ulog_packet+0x214/0x3fc [ipt_ULOG]
> 
> 
> It just means that unaligned accesses are occuring in the ipt_ulog
> module.  Things usually work fine when this happens, just very slowly,
> which is why the warning is printed.
> 
> Patrick, this is on sparc64, it appears to be this code:
> 
> 	pm->timestamp_sec = skb->tstamp.off_sec;
> 	pm->timestamp_usec = skb->tstamp.off_usec;
> 
> and the NLMSG_DATA() (and thus 'pm') is not 8-byte aligned.
> 
> I bet this is a 32-bit sparc binary, has the idea of a compat
> layer for the ULOG bits ever been discussed?


No, I can't imagine how to do this since we don't have any compat
infrastructure for netlink, so we would have to know whether the
receiving process is a 32 bit binary in ipt_ULOG itself. We have
some compat code in userspace to deal with the different structure
layout, so besides the unaligned accesses, it should already work
fine. Since ULOG is obsolete and nfnetlink_log shouldn't have
these issues, I think the best way to fix this is to use
put_unaligned in ipt_ULOG.

How does this look?


--------------090602070602040504030109
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: ipt_ULOG: use put_unaligned

Use put_unaligned to fix warnings about unaligned accesses.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit fea42a5760325392653d556b1087f8274adcfb2e
tree c4c32f0feb2f947fb4d4f747c39935b535aa29cf
parent 2e175a90047a2dbc76fde169c990164895b25dfc
author Patrick McHardy <kaber@trash.net> Mon, 02 Apr 2007 13:54:14 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 02 Apr 2007 13:54:14 +0200

 net/ipv4/netfilter/ipt_ULOG.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index a26404d..9acc018 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -61,6 +61,7 @@
 #include <linux/netfilter_ipv4/ipt_ULOG.h>
 #include <net/sock.h>
 #include <linux/bitops.h>
+#include <asm/unaligned.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
@@ -236,9 +237,9 @@ static void ipt_ulog_packet(unsigned int hooknum,
 
 	/* copy hook, prefix, timestamp, payload, etc. */
 	pm->data_len = copy_len;
-	pm->timestamp_sec = skb->tstamp.off_sec;
-	pm->timestamp_usec = skb->tstamp.off_usec;
-	pm->mark = skb->mark;
+	put_unaligned(skb->tstamp.off_sec, &pm->timestamp_sec);
+	put_unaligned(skb->tstamp.off_usec, &pm->timestamp_usec);
+	put_unaligned(skb->mark, &pm->mark);
 	pm->hook = hooknum;
 	if (prefix != NULL)
 		strncpy(pm->prefix, prefix, sizeof(pm->prefix));

--------------090602070602040504030109--
