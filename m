From: Marcus Sundberg <marcus@ingate.com>
Subject: Re: [PATCH] Compile fixes
Date: 04 Jun 2002 13:10:17 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <ve660zwb8m.fsf@inigo.ingate.se>
References: <veg005rd9b.fsf@inigo.ingate.se>
	<20020604094437.B13631@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20020604094437.B13631@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte <laforge@gnumonks.org> writes:

> On Sun, Jun 02, 2002 at 04:01:04PM +0200, Marcus Sundberg wrote:
> > Hi,
> > 
> > some fixes to make current CVS compile properly.
> 
> thanks, applied.

Seems I forgot to include the patch for the POOL target in the first
mail, so here it comes:

Index: userspace/extensions/libipt_POOL.c
===================================================================
RCS file: /cvsroot/netfilter/userspace/extensions/libipt_POOL.c,v
retrieving revision 1.3
diff -u -r1.3 libipt_POOL.c
--- userspace/extensions/libipt_POOL.c  29 May 2002 13:08:16 -0000
+++ userspace/extensions/libipt_POOL.c  2 Jun 2002 13:48:14 -0000
@@ -15,6 +15,9 @@
 #include <libippool/ip_pool_support.h>
 
 /* FIXME --RR */
+#define ip_pool_init           ip_POOL_init
+#define ip_pool_get_index      ip_POOL_get_index
+#define ip_pool_get_name       ip_POOL_get_name
 #include "../ippool/libippool.c"
 
 /* Function which prints out usage message. */

//Marcus
-- 
---------------------------------------+--------------------------
  Marcus Sundberg <marcus@ingate.com>  | Firewalls with SIP & NAT
 Firewall Developer, Ingate Systems AB |  http://www.ingate.com/
