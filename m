From: Patrick McHardy <kaber@trash.net>
Subject: Re: nat/conntrack helper locking problem?
Date: Thu, 20 Nov 2003 12:52:23 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FBCAAF7.3040704@trash.net>
References: <Pine.LNX.4.44.0311201137310.2389-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050807020504020407010001"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
 Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0311201137310.2389-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------050807020504020407010001
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

It's a relative uncritical error, ip_nat_helper_register races with
ip_conntrack_helper_unregister. The attached patch should
fix it.

Best regards,
Patrick

Henrik Nordstrom wrote:

>The warning have been isolated to the nat helpers only. The conntrack 
>helpers are silent.
>
>The full trace is
>
>#0  printk (fmt=0xa2812140 "ASSERT %s:%u %s not readlocked\n") at 
>printk.c:416
>#1  0xa280efec in ip_ct_find_helper (tuple=0xa282aab4)
>    at ip_conntrack_core.c:630
>#2  0xa281dd24 in ip_nat_helper_register (me=0xa282aaa0) at 
>ip_nat_helper.c:474
>#3  0xa282a724 in init () at ip_nat_ftp.c:327
>#4  0xa0010eb3 in sys_init_module (name_user=0x807cfe8 "ip_nat_ftp", 
>    mod_user=0x80a7578) at module.c:563
>
>this is not 100% the exact same kernel so the line number differs 
>slightly, but it is the exact same error.
>
>Regards
>Henrik
>  
>


--------------050807020504020407010001
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

===== net/ipv4/netfilter/ip_nat_helper.c 1.11 vs edited =====
--- 1.11/net/ipv4/netfilter/ip_nat_helper.c	Mon Oct 13 21:40:48 2003
+++ edited/net/ipv4/netfilter/ip_nat_helper.c	Thu Nov 20 12:48:17 2003
@@ -469,10 +469,13 @@
 	int ret = 0;
 
 	if (me->me && !(me->flags & IP_NAT_HELPER_F_STANDALONE)) {
-		struct ip_conntrack_helper *ct_helper;
+		struct ip_conntrack_helper *ct_helper = NULL;
 		
-		if ((ct_helper = ip_ct_find_helper(&me->tuple))
-		    && ct_helper->me) {
+		READ_LOCK(&ip_conntrack_lock);
+		ct_helper = ip_ct_find_helper(&me->tuple);
+		READ_UNLOCK(&ip_conntrack_lock);
+
+		if (ct_helper && ct_helper->me) {
 			__MOD_INC_USE_COUNT(ct_helper->me);
 		} else {
 

--------------050807020504020407010001--
