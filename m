From: Rob Radez <rob@osinvestor.com>
Subject: [PATCH] Tiny ip_nat_snmp_basic fix
Date: Sun, 23 Jun 2002 13:51:17 -0400
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020623135117.K9029@osinvestor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,
I looked at the pending patches page, tried to browse through the mailing
archives, and checked google, but didn't see if anyone had already addressed
this.  fini() in net/ipv4/netfilter/ip_nat_snmp_basic.c is marked __exit,
but on Sparc32 will fail to link into the kernel because of some btfixup
magic.  I saw two obvious ways to fix this, but only did one because I wasn't
sure about what kind of netfilter magic is going on in fini().  The attached
patch simply removes the __exit tag from fini() and lets the file link in ok.

The other option is to remove the br_write_lock_bh/br_write_unlock_bh calls
in fini() since they don't seem to be protecting anything.  I didn't do that
because I'm not sure if there are any side effects that are being taken
advantage of here.

Patch is against 2.4.19-pre10.

Regards,
Rob Radez

--- stock-2.4.19pre10/net/ipv4//netfilter/ip_nat_snmp_basic.c	Fri Jun 14 18:46:54 2002
+++ build/net/ipv4/netfilter/ip_nat_snmp_basic.c	Sun Jun 23 13:33:16 2002
@@ -1338,7 +1338,7 @@
 	return ret;
 }
 
-static void __exit fini(void)
+static void fini(void)
 {
 	ip_nat_helper_unregister(&snmp);
 	ip_nat_helper_unregister(&snmp_trap);
