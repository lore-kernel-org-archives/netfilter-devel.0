From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 2.4 4/10]: fixes for ip6t_eui64
Date: Wed, 01 Dec 2004 17:06:16 +0900 (JST)
Message-ID: <200412010806.iB186GJC004277@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Wed_Dec__1_17:06:16_2004_310)--"
Content-Transfer-Encoding: 7bit
Cc: usagi-core@linux-ipv6.org
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

----Next_Part(Wed_Dec__1_17:06:16_2004_310)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


According to report from Peter, user cannot insert rule with eui64 match
to FORWARD chain.

Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>

From: kisza@sch.bme.hu
Date: Sat, 09 Oct 2004 18:09:59 +0200

> Could you fix this problem in the next patch, please?
> There is a wrong condition at the loading :(
> 
> Thank you in advance,
> 
> Andras
> 
> From: Peter Ivancik <Peter.Ivancik@gympos.sk>
> Date: Sat, 09 Oct 2004 17:37:45 +0200
> > 
> > 
> > 
> > Hi again,
> > 
> > it looks, that there's problem in source code of ip6t_eui64.c file.
> > (linux/net/ipv6/netfilter/ip6t_eui64.c).
> > There's twice deffined PRE_ROUTING table and isn't there FORWARD table.
> > This is diff between original and modified version:
> > 61c61
> >  <               (1 << NF_IP6_PRE_ROUTING) )) {
> >    ---
> >  >               (1 << NF_IP6_FORWARD) )) {
> > 
> > I'm not sure, if I'm right, but it works for me good now :)
> > Bye.
> > 
> > 	Peter 

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Wed_Dec__1_17:06:16_2004_310)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="eui64.patch"

--- linux-2.4.28-rc1/./net/ipv6/netfilter/ip6t_eui64.c	2002-11-29 08:53:15.000000000 +0900
+++ linux-2.4.28-rc1-extfix/./net/ipv6/netfilter/ip6t_eui64.c	2004-11-10 00:51:45.000000000 +0900
@@ -58,7 +58,7 @@ ip6t_eui64_checkentry(const char *tablen
 {
 	if (hook_mask
 	    & ~((1 << NF_IP6_PRE_ROUTING) | (1 << NF_IP6_LOCAL_IN) |
-		(1 << NF_IP6_PRE_ROUTING) )) {
+		(1 << NF_IP6_FORWARD))) {
 		printk("ip6t_eui64: only valid for PRE_ROUTING, LOCAL_IN or FORWARD.\n");
 		return 0;
 	}

----Next_Part(Wed_Dec__1_17:06:16_2004_310)----
