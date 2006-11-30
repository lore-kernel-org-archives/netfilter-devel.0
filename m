From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 12/12]: install libxt_*.so to DEST_IPT_LIBIDR and link
 libip[6]t_*.so to it.
Date: Thu, 30 Nov 2006 18:52:58 +0900 (JST)
Message-ID: <200611300952.kAU9qxej009157@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


---
 extensions/Makefile |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/extensions/Makefile b/extensions/Makefile
index 2aad889..3f300f8 100644
--- a/extensions/Makefile
+++ b/extensions/Makefile
@@ -16,9 +16,11 @@ endif
 # Optionals
 PF_EXT_SLIB_OPTS:=$(foreach T,$(wildcard extensions/.*-test),$(shell KERNEL_DIR=$(KERNEL_DIR) $(T)))
 PF6_EXT_SLIB_OPTS:=$(foreach T,$(wildcard extensions/.*-test6),$(shell KERNEL_DIR=$(KERNEL_DIR) $(T)))
+PFX_EXT_SLIB_OPTS:=$(foreach T,$(wildcard extensions/.*-testx),$(shell KERNEL_DIR=$(KERNEL_DIR) $(T)))
 
 PF_EXT_ALL_SLIB:=$(patsubst extensions/libipt_%.c, %, $(wildcard extensions/libipt_*.c))
 PF6_EXT_ALL_SLIB:=$(patsubst extensions/libip6t_%.c, %, $(wildcard extensions/libip6t_*.c))
+PFX_EXT_ALL_SLIB:=$(patsubst extensions/libxt_%.c, %, $(wildcard extensions/libxt_*.c))
 
 PF_EXT_MAN_ALL_MATCHES:=$(foreach T,$(PF_EXT_ALL_SLIB),$(shell test -f extensions/libipt_$(T).man && grep -q register_match extensions/libipt_$(T).c  && echo $(T)))
 PF_EXT_MAN_ALL_TARGETS:=$(foreach T,$(PF_EXT_ALL_SLIB),$(shell test -f extensions/libipt_$(T).man && grep -q register_target extensions/libipt_$(T).c && echo $(T)))
@@ -42,6 +44,7 @@ allman:
 
 PF_EXT_SLIB+=$(PF_EXT_SLIB_OPTS)
 PF6_EXT_SLIB+=$(PF6_EXT_SLIB_OPTS)
+PFX_EXT_SLIB+=$(PFX_EXT_SLIB_OPTS)
 
 OPTIONALS+=$(patsubst %,IPv4:%,$(PF_EXT_SLIB_OPTS))
 OPTIONALS+=$(patsubst %,IPv6:%,$(PF6_EXT_SLIB_OPTS))
@@ -51,25 +54,34 @@ SHARED_LIBS+=$(foreach T,$(PF_EXT_SLIB),
 SHARED_SE_LIBS+=$(foreach T,$(PF_EXT_SE_SLIB),extensions/libipt_$(T).so)
 EXTRA_INSTALLS+=$(foreach T, $(PF_EXT_SLIB), $(DEST_IPT_LIBDIR)/libipt_$(T).so)
 EXTRA_INSTALLS+=$(foreach T, $(PF_EXT_SE_SLIB), $(DEST_IPT_LIBDIR)/libipt_$(T).so)
+EXTRA_INSTALLS+=$(foreach T, $(PFX_EXT_SLIB), $(DEST_IPT_LIBDIR)/libipt_$(T).so)
 
 ifeq ($(DO_IPV6), 1)
 SHARED_LIBS+=$(foreach T,$(PF6_EXT_SLIB),extensions/libip6t_$(T).so)
 SHARED_SE_LIBS+=$(foreach T,$(PF6_EXT_SE_SLIB),extensions/libip6t_$(T).so)
 EXTRA_INSTALLS+=$(foreach T, $(PF6_EXT_SLIB), $(DEST_IPT_LIBDIR)/libip6t_$(T).so)
 EXTRA_INSTALLS+=$(foreach T, $(PF6_EXT_SE_SLIB), $(DEST_IPT_LIBDIR)/libip6t_$(T).so)
+EXTRA_INSTALLS+=$(foreach T, $(PFX_EXT_SLIB), $(DEST_IPT_LIBDIR)/libip6t_$(T).so)
 endif
 
+SHARED_LIBS+=$(foreach T,$(PFX_EXT_SLIB),extensions/libxt_$(T).so)
+EXTRA_INSTALLS+=$(foreach T, $(PFX_EXT_SLIB), $(DEST_IPT_LIBDIR)/libxt_$(T).so)
+
 else 	# NO_SHARED_LIBS
 EXT_OBJS+=$(foreach T,$(PF_EXT_SLIB),extensions/libipt_$(T).o)
 EXT_OBJS+=$(foreach T,$(PF_EXT_SE_SLIB),extensions/libipt_$(T).o)
+EXT_OBJS+=$(foreach T,$(PFX_EXT_SLIB),extensions/libxt_$(T).o)
 EXT_FUNC+=$(foreach T,$(PF_EXT_SLIB),ipt_$(T))
 EXT_FUNC+=$(foreach T,$(PF_EXT_SE_SLIB),ipt_$(T))
+EXT_FUNC+=$(foreach T,$(PFX_EXT_SLIB),ipxt_$(T))
 EXT_OBJS+= extensions/initext.o
 ifeq ($(DO_IPV6), 1)
 EXT6_OBJS+=$(foreach T,$(PF6_EXT_SLIB),extensions/libip6t_$(T).o)
 EXT6_OBJS+=$(foreach T,$(PF6_EXT_SE_SLIB),extensions/libip6t_$(T).o)
+EXT6_OBJS+=$(foreach T,$(PFX_EXT_SLIB),extensions/libxt_$(T).o)
 EXT6_FUNC+=$(foreach T,$(PF6_EXT_SLIB),ip6t_$(T))
 EXT6_FUNC+=$(foreach T,$(PF6_EXT_SE_SLIB),ip6t_$(T))
+EXT6_FUNC+=$(foreach T,$(PFX_EXT_SLIB),ipxt_$(T))
 EXT6_OBJS+= extensions/initext6.o
 endif	# DO_IPV6
 endif	# NO_SHARED_LIBS
@@ -172,6 +184,16 @@ extensions/libip6t_matches.man: $(patsub
 	    done ;\
        	fi >>extensions/libip6t_matches.man
 
+PF_XTLIBS=$(foreach T, $(PFX_EXT_SLIB), $(DEST_IPT_LIBDIR)/libipt_$(T).so)
+$(PF_XTLIBS): $(DEST_IPT_LIBDIR)/libipt_%.so : $(DEST_IPT_LIBDIR)/libxt_%.so
+	@[ -d $(DEST_IPT_LIBDIR)/ ] || mkdir -p $(DEST_IPT_LIBDIR)/
+	ln -sf $< $@
+
+PF6_XTLIBS=$(foreach T, $(PFX_EXT_SLIB), $(DEST_IPT_LIBDIR)/libip6t_$(T).so)
+$(PF6_XTLIBS): $(DEST_IPT_LIBDIR)/libip6t_%.so : $(DEST_IPT_LIBDIR)/libxt_%.so
+	@[ -d $(DEST_IPT_LIBDIR)/ ] || mkdir -p $(DEST_IPT_LIBDIR)/
+	ln -sf $< $@
+
 $(DEST_IPT_LIBDIR)/libipt_%.so: extensions/libipt_%.so
 	@[ -d $(DEST_IPT_LIBDIR)/ ] || mkdir -p $(DEST_IPT_LIBDIR)/
 	cp $< $@
@@ -179,3 +201,7 @@ $(DEST_IPT_LIBDIR)/libipt_%.so: extensio
 $(DEST_IPT_LIBDIR)/libip6t_%.so: extensions/libip6t_%.so
 	@[ -d $(DEST_IPT_LIBDIR)/ ] || mkdir -p $(DEST_IPT_LIBDIR)/
 	cp $< $@
+
+$(DEST_IPT_LIBDIR)/libxt_%.so: extensions/libxt_%.so
+	@[ -d $(DEST_IPT_LIBDIR)/ ] || mkdir -p $(DEST_IPT_LIBDIR)/
+	cp $< $@
-- 
1.4.4
