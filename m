From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 3/3] fix for eui64 match
Date: Mon, 01 Nov 2004 17:43:36 +0900 (JST)
Message-ID: <200411010843.iA18hcfo019583@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Mon_Nov__1_17:43:36_2004_914)--"
Content-Transfer-Encoding: 7bit
Cc: kisza@sch.bme.hu, usagi-core@linux-ipv6.org, Peter.Ivancik@gympos.sk
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

----Next_Part(Mon_Nov__1_17:43:36_2004_914)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


According to report from Peter, user cannot insert rule with eui64 match
to FORWARD chain.

Signed-off-by Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>

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

----Next_Part(Mon_Nov__1_17:43:36_2004_914)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="eui64-fix.patch"

--- linux-2.6.9-rc3-nolin/net/ipv6/netfilter/ip6t_eui64.c	2004-09-30 19:36:23.000000000 +0900
+++ linux-2.6.9-rc3-nolin-extfix/net/ipv6/netfilter/ip6t_eui64.c	2004-10-27 14:29:23.929587368 +0900
@@ -69,7 +69,7 @@ ip6t_eui64_checkentry(const char *tablen
 {
 	if (hook_mask
 	    & ~((1 << NF_IP6_PRE_ROUTING) | (1 << NF_IP6_LOCAL_IN) |
-		(1 << NF_IP6_PRE_ROUTING) )) {
+		(1 << NF_IP6_FORWARD))) {
 		printk("ip6t_eui64: only valid for PRE_ROUTING, LOCAL_IN or FORWARD.\n");
 		return 0;
 	}

----Next_Part(Mon_Nov__1_17:43:36_2004_914)----
