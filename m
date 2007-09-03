From: Laszlo Attila Toth <panther@balabit.hu>
Subject: [PATCH] Makefile for man pages of xtables extensions
Date: Mon, 03 Sep 2007 14:48:19 +0200
Message-ID: <46DC0293.6010307@balabit.hu>
Reply-To: panther@balabit.hu
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000502050904060904020604"
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

This is a multi-part message in MIME format.
--------------000502050904060904020604
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit

Hello,

I made this patch to include all available matches and targets to
iptables.8 and ip6tables.8 man pages. The source file is lixt_*.c but
the man page is libipt_*.man or libip6t.man as expected.

If there are additional matches and targets (extra, as in POM), the
variable named "extra" is used which was unescaped.

But I found that in the generated man pages of the svn version of
modules the title is
  ... (not supported, see Patch-O-Matic)
for instance helper, length, limit etc. Is it intended?


Regards,
Laszlo Attila Toth

--------------000502050904060904020604
Content-Type: text/x-patch;
 name="iptables-make.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables-make.diff"

--- iptables.orig/extensions/Makefile	2007-08-07 10:03:05.000000000 +0200
+++ iptables/extensions/Makefile	2007-09-03 14:28:44.000000000 +0200
@@ -29,6 +29,11 @@
 PF6_EXT_MAN_ALL_MATCHES:=$(foreach T,$(PF6_EXT_ALL_SLIB),$(shell test -f extensions/libip6t_$(T).man && grep -q register_match6 extensions/libip6t_$(T).c  && echo $(T)))
 PF6_EXT_MAN_ALL_TARGETS:=$(foreach T,$(PF6_EXT_ALL_SLIB),$(shell test -f extensions/libip6t_$(T).man && grep -q register_target6 extensions/libip6t_$(T).c && echo $(T)))
 
+PF_EXT_MAN_ALL_MATCHES+=$(foreach T,$(PFX_EXT_ALL_SLIB),$(shell test -f extensions/libipt_$(T).man && grep -q register_match extensions/libxt_$(T).c  && echo $(T)))
+PF_EXT_MAN_ALL_TARGETS+=$(foreach T,$(PFX_EXT_ALL_SLIB),$(shell test -f extensions/libipt_$(T).man && grep -q register_target extensions/libxt_$(T).c && echo $(T)))
+PF6_EXT_MAN_ALL_MATCHES+=$(foreach T,$(PFX_EXT_ALL_SLIB),$(shell test -f extensions/libip6t_$(T).man && grep -q register_match6 extensions/libxt_$(T).c  && echo $(T)))
+PF6_EXT_MAN_ALL_TARGETS+=$(foreach T,$(PFX_EXT_ALL_SLIB),$(shell test -f extensions/libip6t_$(T).man && grep -q register_target6 extensions/libxt_$(T).c && echo $(T)))
+
 PF_EXT_MAN_MATCHES:=$(filter $(PF_EXT_ALL_SLIB), $(PF_EXT_MAN_ALL_MATCHES))
 PF_EXT_MAN_TARGETS:=$(filter $(PF_EXT_ALL_SLIB), $(PF_EXT_MAN_ALL_TARGETS))
 PF_EXT_MAN_EXTRA_MATCHES:=$(filter-out $(PF_EXT_MAN_MATCHES), $(PF_EXT_MAN_ALL_MATCHES))
@@ -141,7 +146,7 @@
 	    cat extensions/libipt_$$ext.man ;\
 	done >extensions/libipt_targets.man
 	@if [ -n "$(PF_EXT_MAN_EXTRA_TARGETS)" ]; then \
-	    extra=$(PF_EXT_MAN_EXTRA_TARGETS) ;\
+	    extra="$(PF_EXT_MAN_EXTRA_TARGETS)" ;\
 	    for ext in $${extra:-""}; do \
 		echo ".SS $$ext (not supported, see Patch-O-Matic)" ;\
 		cat extensions/libipt_$$ext.man ;\
@@ -155,7 +160,7 @@
 	    cat extensions/libipt_$$ext.man ;\
 	done >extensions/libipt_matches.man
 	@if [ -n "$(PF_EXT_MAN_EXTRA_MATCHES)" ]; then \
-	    extra=$(PF_EXT_MAN_EXTRA_MATCHES) ;\
+	    extra="$(PF_EXT_MAN_EXTRA_MATCHES)" ;\
 	    for ext in $${extra:-""}; do \
 		echo ".SS $$ext (not supported, see Patch-O-Matic)" ;\
 		cat extensions/libipt_$$ext.man ;\
@@ -169,7 +174,7 @@
 	    cat extensions/libip6t_$$ext.man ;\
 	done >extensions/libip6t_targets.man
 	@if [ -n "$(PF6_EXT_MAN_EXTRA_TARGETS)" ]; then \
-	    extra=$(PF6_EXT_MAN_EXTRA_TARGETS) ;\
+	    extra="$(PF6_EXT_MAN_EXTRA_TARGETS)" ;\
 	    for ext in $${extra:-""}; do \
 		echo ".SS $$ext (not supported, see Patch-O-Matic)" ;\
 		cat extensions/libip6t_$$ext.man ;\
@@ -183,7 +188,7 @@
 	    cat extensions/libip6t_$$ext.man ;\
 	done >extensions/libip6t_matches.man
 	@if [ -n "$(PF6_EXT_MAN_EXTRA_MATCHES)" ]; then \
-	    extra=$(PF6_EXT_MAN_EXTRA_MATCHES) ;\
+	    extra="$(PF6_EXT_MAN_EXTRA_MATCHES)" ;\
 	    for ext in $${extra:-""}; do \
 		echo ".SS $$ext (not supported, see Patch-O-Matic)" ;\
 		cat extensions/libip6t_$$ext.man ;\

--------------000502050904060904020604--
