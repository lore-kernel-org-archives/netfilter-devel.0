From: Chris Wilson <chris@netservers.co.uk>
Subject: ICMP DNAT bug fix no longer applies?
Date: Thu, 24 Apr 2003 14:34:11 +0100 (BST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0304241412470.24242-100000@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: John McEleney <john@netservers.co.uk>,
   Philippe Biondi <biondi@cartel-securite.fr>
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

Hi all,

Since the ICMP DNAT advisory came out last year
[http://www.iptables.org/security/2002-04-02-icmp-dnat.html], we have been 
applying this patch to all kernels we build. However, in between 
patch-o-matic 20030107 and 20030422 this has been broken and no longer 
applies.

I think the culprit is submitted/11_inner-icmp-translation-fix.patch, 
with the following change:

-               if (info->manips[i].hooknum == opposite_hook[hooknum]) {
+               if (info->manips[i].hooknum == hooknum) {

Since the ICMP DNAT bugfix wants to change the same line to:

+               if (map_innards(info->manips[i].hooknum, hooknum)) {

the patch does not apply.

The map_innards function appears to expect the hooknum to be the 
opposite_hook:

+static inline int
+map_innards(unsigned int maniphook, unsigned int hooknum)
+{
+       return (maniphook == opposite_hook[hooknum]
+               || (hooknum == NF_IP_LOCAL_OUT
+                    && HOOK2MANIP(maniphook) == IP_NAT_MANIP_SRC));
+}

It is only called from that one place, so changing the first condition to 
"return (maniphook == hooknum)" should make the logic of that test 
equivalent to the patched logic put in place by 
11_inner-icmp-translation-fix.patch. However, I'm not sure what change, if 
any, should be made to the second test for consistency.
Can anyone shed some light on this?

Does anyone know why the DNAT bug fix hasn't been incorporated into 
the main codebase yet?

Cheers, Chris.
-- 
   ___ __     _
 / __// / ,__(_)_  | Chris Wilson -- UNIX Firewall Lead Developer |
/ (_ / ,\/ _/ /_ \ | NetServers.co.uk http://www.netservers.co.uk |
\ _//_/_/_//_/___/ | 21 Signet Court, Cambridge, UK. 01223 576516 |
