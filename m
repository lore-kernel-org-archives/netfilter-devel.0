From: Roberto Nibali <ratz@tac.ch>
Subject: Re: [PATCH 2.4] raw table and NOTRACK support
Date: Wed, 23 Nov 2005 14:04:40 +0100
Message-ID: <438468E8.4090309@tac.ch>
References: <4381A0C3.7020406@tac.ch>
	<438327D2.5090506@tac.ch>	<43833BE3.8060909@tac.ch>
	<43833F1D.3060309@tac.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, Willy Tarreau <willy@w.ods.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Developers <netfilter-devel@lists.netfilter.org>
In-Reply-To: <43833F1D.3060309@tac.ch>
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

> Damn! I wish I understood that conntrack stuff better ...

Ok, so NOTRACK registers itself into the conntrack table upon target
entry using nf_conntrack_get((*pskb)->nfct). And each skb updates the
nfct counter, but when deregistering the conntrack we still have
references of the fake connection tracking entry of the NOTRACK hook.
This was discussed already and a Patrick submitted a patchset:

http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b31e5b1bb53b99dfd5e890aa07e943aff114ae1c

Patrick, in the thread leading to this patch we concluded that you would
forward the nf_reset patch to Marcelo for 2.4.x inclusion. I only
realised now that this did not happen and thus the following patch is
needed for 2.4.x to have rmmod ip_conntrack working correctly when
having either bridging or NOTRACK (both not in vanilla) loaded and used
in the kernel:

--- linux-2.4.32-orig/net/ipv4/ip_output.c      2005-11-21 11:29:41 +0100
+++ linux-2.4.32-pab2/net/ipv4/ip_output.c      2005-11-23 11:42:13 +0100
@@ -167,6 +167,9 @@
        nf_debug_ip_finish_output2(skb);
 #endif /*CONFIG_NETFILTER_DEBUG*/

+       /* Drop conntrack reference when packet leaves IP */
+       nf_reset(skb);
+
        if (hh) {
                int hh_alen;

Is there a reason not to include this patch in 2.4.x?

Thanks and regards,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Kasinostrasse 30, CH-5001 Aarau tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
