From: Patrick McHardy <kaber@trash.net>
Subject: Re: {PATCH]: fix expectation eviction order
Date: Wed, 01 Oct 2003 05:00:16 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F7A4340.2010003@trash.net>
References: <3F775469.6070107@trash.net> <20030930195427.GC734@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020002020109070803060200"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030930195427.GC734@obroa-skai.de.gnumonks.org>
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
--------------020002020109070803060200
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Harald Welte wrote:

>Committed to CVS now.
>
Status: Pending for kernel inclusion, needs testing

I may have changed a bit too much for a simple bugfix, since I wanted
to be sure to keep correct behaviour in case of multiple manglings
to one packet I just deleted and rewrote it. At that occasion I changed
the lookup stuff to list_for_each_entry ;) This patch is a little less
intrusive, IIRC Martin is working on the list stuff anyways so maybe
it's more appropriate.

Best regards,
Patrick


--------------020002020109070803060200
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

===== net/ipv4/netfilter/ip_conntrack_core.c 1.26 vs edited =====
--- 1.26/net/ipv4/netfilter/ip_conntrack_core.c	Mon Aug 25 22:38:24 2003
+++ edited/net/ipv4/netfilter/ip_conntrack_core.c	Wed Oct  1 04:46:05 2003
@@ -997,7 +997,7 @@
 		       NIPQUAD(related_to->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip));
  
 		/* choose the the oldest expectation to evict */
-		list_for_each(cur_item, &related_to->sibling_list) { 
+		list_for_each_prev(cur_item, &related_to->sibling_list) { 
 			struct ip_conntrack_expect *cur;
 
 			cur = list_entry(cur_item, 

--------------020002020109070803060200--
