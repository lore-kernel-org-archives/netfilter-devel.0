From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH] Fix ip[6]t->xt symlinks during `make install`
Date: Tue, 31 Jul 2007 13:10:50 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707311304380.22515@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	kaber@trash.net
To: yasuyuki@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi,


I have just noticed that building a recent svn snapshot with rpm yields 
bogus symlinks:

lrwxrwxrwx 1 99 99    62 Jul 31 13:02 libipt_tcpmss.so -> 
/var/tmp/iptables-1.3.8-build/usr/lib/iptables/libxt_tcpmss.so

(make install with DESTDIR=/var/tmp/iptables-1.3.8)
Fix below.


Thanks,
	Jan
===

$< includes DESTDIR, which is not what DESTDIR is meant for.
Since ipt, ip6t and xt are all in the same directory, we can
even do without any paths.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 extensions/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: iptables/extensions/Makefile
===================================================================
--- iptables.orig/extensions/Makefile
+++ iptables/extensions/Makefile
@@ -195,12 +195,12 @@ extensions/libip6t_matches.man: $(patsub
 PF_XTLIBS=$(foreach T, $(PFX_EXT_SLIB), $(DEST_IPT_LIBDIR)/libipt_$(T).so)
 $(PF_XTLIBS): $(DEST_IPT_LIBDIR)/libipt_%.so : $(DEST_IPT_LIBDIR)/libxt_%.so
 	@[ -d $(DEST_IPT_LIBDIR)/ ] || mkdir -p $(DEST_IPT_LIBDIR)/
-	ln -sf $< $@
+	ln -sf libipt_$*.so $@
 
 PF6_XTLIBS=$(foreach T, $(PFX_EXT_SLIB), $(DEST_IPT_LIBDIR)/libip6t_$(T).so)
 $(PF6_XTLIBS): $(DEST_IPT_LIBDIR)/libip6t_%.so : $(DEST_IPT_LIBDIR)/libxt_%.so
 	@[ -d $(DEST_IPT_LIBDIR)/ ] || mkdir -p $(DEST_IPT_LIBDIR)/
-	ln -sf $< $@
+	ln -sf libip6t_$*.so $@
 
 $(DEST_IPT_LIBDIR)/libipt_%.so: extensions/libipt_%.so
 	@[ -d $(DEST_IPT_LIBDIR)/ ] || mkdir -p $(DEST_IPT_LIBDIR)/
