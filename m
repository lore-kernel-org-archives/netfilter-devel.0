From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 11/43] Introduces DEST_IPT_LIBDIR to simplify
 $(DESTDIR)$(LIBDIR)/iptables
Date: Sun, 15 Jul 2007 02:23:39 +0900 (JST)
Message-ID: <200707141723.l6EHNeX1023578@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
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


---
 Makefile            |    1 +
 extensions/Makefile |   17 +++++++++--------
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/Makefile b/Makefile
index 1cadaf5..e29ecd4 100644
--- a/Makefile
+++ b/Makefile
@@ -62,6 +62,7 @@ endif
 ifndef IPT_LIBDIR
 IPT_LIBDIR:=$(LIBDIR)/iptables
 endif
+DEST_IPT_LIBDIR:=$(DESTDIR)$(LIBDIR)/iptables
 
 ifndef NO_SHARED_LIBS
 DEPFILES = $(SHARED_LIBS:%.so=%.d)
diff --git a/extensions/Makefile b/extensions/Makefile
index 5921763..c149375 100644
--- a/extensions/Makefile
+++ b/extensions/Makefile
@@ -49,15 +49,16 @@ OPTIONALS+=$(patsubst %,IPv6:%,$(PF6_EXT_SLIB_OPTS))
 ifndef NO_SHARED_LIBS
 SHARED_LIBS+=$(foreach T,$(PF_EXT_SLIB),extensions/libipt_$(T).so)
 SHARED_SE_LIBS+=$(foreach T,$(PF_EXT_SE_SLIB),extensions/libipt_$(T).so)
-EXTRA_INSTALLS+=$(foreach T, $(PF_EXT_SLIB), $(DESTDIR)$(LIBDIR)/iptables/libipt_$(T).so)
-EXTRA_INSTALLS+=$(foreach T, $(PF_EXT_SE_SLIB), $(DESTDIR)$(LIBDIR)/iptables/libipt_$(T).so)
+EXTRA_INSTALLS+=$(foreach T, $(PF_EXT_SLIB), $(DEST_IPT_LIBDIR)/libipt_$(T).so)
+EXTRA_INSTALLS+=$(foreach T, $(PF_EXT_SE_SLIB), $(DEST_IPT_LIBDIR)/libipt_$(T).so)
 
 ifeq ($(DO_IPV6), 1)
 SHARED_LIBS+=$(foreach T,$(PF6_EXT_SLIB),extensions/libip6t_$(T).so)
 SHARED_SE_LIBS+=$(foreach T,$(PF6_EXT_SE_SLIB),extensions/libip6t_$(T).so)
-EXTRA_INSTALLS+=$(foreach T, $(PF6_EXT_SLIB), $(DESTDIR)$(LIBDIR)/iptables/libip6t_$(T).so)
-EXTRA_INSTALLS+=$(foreach T, $(PF6_EXT_SE_SLIB), $(DESTDIR)$(LIBDIR)/iptables/libip6t_$(T).so)
+EXTRA_INSTALLS+=$(foreach T, $(PF6_EXT_SLIB), $(DEST_IPT_LIBDIR)/libip6t_$(T).so)
+EXTRA_INSTALLS+=$(foreach T, $(PF6_EXT_SE_SLIB), $(DEST_IPT_LIBDIR)/libip6t_$(T).so)
 endif
+
 else 	# NO_SHARED_LIBS
 EXT_OBJS+=$(foreach T,$(PF_EXT_SLIB),extensions/libipt_$(T).o)
 EXT_OBJS+=$(foreach T,$(PF_EXT_SE_SLIB),extensions/libipt_$(T).o)
@@ -171,10 +172,10 @@ extensions/libip6t_matches.man: $(patsubst %, extensions/libip6t_%.man, $(PF6_EX
 	    done ;\
        	fi >>extensions/libip6t_matches.man
 
-$(DESTDIR)$(LIBDIR)/iptables/libipt_%.so: extensions/libipt_%.so
-	@[ -d $(DESTDIR)$(LIBDIR)/iptables ] || mkdir -p $(DESTDIR)$(LIBDIR)/iptables
+$(DEST_IPT_LIBDIR)/libipt_%.so: extensions/libipt_%.so
+	@[ -d $(DEST_IPT_LIBDIR)/ ] || mkdir -p $(DEST_IPT_LIBDIR)/
 	cp $< $@
 
-$(DESTDIR)$(LIBDIR)/iptables/libip6t_%.so: extensions/libip6t_%.so
-	@[ -d $(DESTDIR)$(LIBDIR)/iptables ] || mkdir -p $(DESTDIR)$(LIBDIR)/iptables
+$(DEST_IPT_LIBDIR)/libip6t_%.so: extensions/libip6t_%.so
+	@[ -d $(DEST_IPT_LIBDIR)/ ] || mkdir -p $(DEST_IPT_LIBDIR)/
 	cp $< $@
-- 
1.5.2.2
