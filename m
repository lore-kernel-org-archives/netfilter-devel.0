From: Patrick McHardy <kaber@trash.net>
Subject: Re: nat/conntrack helper locking problem?
Date: Thu, 20 Nov 2003 12:59:21 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FBCAC99.6020902@trash.net>
References: <Pine.LNX.4.44.0311201137310.2389-100000@filer.marasystems.com> <3FBCAAF7.3040704@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030903070503060908000304"
Cc: Henrik Nordstrom <hno@marasystems.com>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <3FBCAAF7.3040704@trash.net>
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
--------------030903070503060908000304
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Sorry Harald the last patch added an unneccessary NULL assignment,
this patch is better. It fixes ip_nat_helper_register calling 
ip_ct_find_helper
without holding ip_conntrack_lock.

Best regards,
Patrick

Patrick McHardy wrote:

> It's a relative uncritical error, ip_nat_helper_register races with
> ip_conntrack_helper_unregister. The attached patch should
> fix it.
>


--------------030903070503060908000304
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

===== net/ipv4/netfilter/ip_nat_helper.c 1.11 vs edited =====
--- 1.11/net/ipv4/netfilter/ip_nat_helper.c	Mon Oct 13 21:40:48 2003
+++ edited/net/ipv4/netfilter/ip_nat_helper.c	Thu Nov 20 12:57:22 2003
@@ -471,8 +471,11 @@
 	if (me->me && !(me->flags & IP_NAT_HELPER_F_STANDALONE)) {
 		struct ip_conntrack_helper *ct_helper;
 		
-		if ((ct_helper = ip_ct_find_helper(&me->tuple))
-		    && ct_helper->me) {
+		READ_LOCK(&ip_conntrack_lock);
+		ct_helper = ip_ct_find_helper(&me->tuple);
+		READ_UNLOCK(&ip_conntrack_lock);
+
+		if (ct_helper && ct_helper->me) {
 			__MOD_INC_USE_COUNT(ct_helper->me);
 		} else {
 

--------------030903070503060908000304--
