From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: unused variable in skb_ip_make_writable()
Date: Fri, 25 Jun 2004 00:33:55 +0900 (JST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200406241533.AAA27611@toshiba.co.jp>
References: <200406241509.AAA00641@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Fri_Jun_25_00:33:55_2004_915)--"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200406241509.AAA00641@toshiba.co.jp>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

----Next_Part(Fri_Jun_25_00:33:55_2004_915)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Sorry, I misstook...

From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Date: Fri, 25 Jun 2004 00:09:51 +0900 (JST)

> 
> Hi, iplen in skb_ip_make_writable() is not used.
> 
> please apply this patch.
> 
> Regards,
> 
> -----------------------------------------------------------------
> Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Fri_Jun_25_00:33:55_2004_915)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="skb_ip_make_writable.patch"

Index: netfilter.c
===================================================================
RCS file: /cvsroot/usagi/usagi/kernel/linux26/net/core/netfilter.c,v
retrieving revision 1.1.1.23
diff -u -r1.1.1.23 netfilter.c
--- netfilter.c	8 Jun 2004 07:00:59 -0000	1.1.1.23
+++ netfilter.c	24 Jun 2004 12:25:16 -0000
@@ -677,7 +677,6 @@
 int skb_ip_make_writable(struct sk_buff **pskb, unsigned int writable_len)
 {
 	struct sk_buff *nskb;
-	unsigned int iplen;
 
 	if (writable_len > (*pskb)->len)
 		return 0;
@@ -690,8 +689,6 @@
 	if (writable_len <= (*pskb)->nh.iph->ihl*4)
 		return 1;
 
-	iplen = writable_len - (*pskb)->nh.iph->ihl*4;
-
 	/* DaveM says protocol headers are also modifiable. */
 	switch ((*pskb)->nh.iph->protocol) {
 	case IPPROTO_TCP: {

----Next_Part(Fri_Jun_25_00:33:55_2004_915)----
