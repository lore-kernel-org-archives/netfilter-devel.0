From: Steven Van Acker <deepstar+NRpGDEuW@singularity.be>
Subject: iptables 1.3.6 compilation issues in libipt_iprange.c (non-existant
	__be32 type)
Date: Mon, 4 Dec 2006 16:48:45 +0100
Message-ID: <20061204154845.GA21750@ekonomika.be>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="IJpNTDwzlM2Ie8A6"
Cc: kulnet@kulnet.kuleuven.be
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
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


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

iptables 1.3.6 does not compile with the 2.6.19 kernel
because an undefined type __be32 is used in libipt_iprange.c

Apparently, a fix was issued before, which can be found here:
http://lists.netfilter.org/pipermail/netfilter/2006-October/066954.html

Before I started looking for a patch, I wrote one myself
and it's a bit different from the one found at the location mentioned
above.

Instead of #defining the __be32 type "manually", you could also #include
<linux/types.h>, which defines that datatype.

I'm not sure if it's a good idea to duplicate definitions of datatypes
in iptables. Is there a purpose I'm overlooking ?

Is it also possible to mention the fix for the __be32 issue on
netfilter.org ? I'm sure more people will run into it as 2.6.19 is going
mainstream, and we don't all use the SVN repository to compile iptables
:)

kind regards,
-- Steven
PS: my one-line patch is attached for reference
-- 
My amazon wishlist:
http://www.amazon.com/gp/registry/1DB4XNEIEQBPB

--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="001_____iprange-fix.patch"

diff -Naur iptables-1.3.6/extensions/libipt_iprange.c iptables-1.3.6-patched/extensions/libipt_iprange.c
--- iptables-1.3.6/extensions/libipt_iprange.c	2006-09-28 18:40:33.000000000 +0200
+++ iptables-1.3.6-patched/extensions/libipt_iprange.c	2006-12-04 15:23:38.000000000 +0100
@@ -6,6 +6,7 @@
 #include <getopt.h>
 
 #include <iptables.h>
+#include <linux/types.h>
 #include <linux/netfilter_ipv4/ipt_iprange.h>
 
 /* Function which prints out usage message. */

--IJpNTDwzlM2Ie8A6--
