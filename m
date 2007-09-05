From: Laszlo Attila Toth <panther@balabit.hu>
Subject: Re: [PATCH] Makefile for man pages of xtables extensions + connrate
Date: Wed, 05 Sep 2007 17:58:15 +0200
Message-ID: <46DED217.7090101@balabit.hu>
References: <46DC0293.6010307@balabit.hu> <46DEB2EC.6080107@trash.net>
Reply-To: panther@balabit.hu
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000007070104020609010701"
Cc: netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46DEB2EC.6080107@trash.net>
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
--------------000007070104020609010701
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Patrick McHardy =EDrta:
> Laszlo Attila Toth wrote:
>> But I found that in the generated man pages of the svn version of
>> modules the title is
>>   ... (not supported, see Patch-O-Matic)
>> for instance helper, length, limit etc. Is it intended?
>=20
>=20
> No, matches and targets available in the kernel should not be
> marked as not supported. Care to send another patch to fix this?
>=20

I made a new patch for connrate: it was not optional (not tested) and
wasn't in the Makefile's PF_EXT_SLIB: line. It is not in the kernel
version 2.6.23-rc3 (linus.git)


I made the following changes in extensions/Makefile:

 * no extra target/match by default :)
 * man page of fix modules (PF_EXT_SLIB etc.) plus optional
  (...SLIB_OPTS)  modules generated, but not all.
 * because of the previous one I had to rename PF_EXT_SE_SLIB to
   PF_EXT_SELINUX_SLIB etc. as a non-optional variable, original
   PF_EXT_SE_SLIB gets the value of PF_EXT_SELINUX_SLIB if DO_SELINUX is
   set to 1.

Regards,
	Attila

--------------000007070104020609010701
Content-Type: text/x-patch;
 name="iptables-connrate-test.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables-connrate-test.diff"

--- /dev/null	2007-07-09 10:36:18.000000000 +0200
+++ iptables/extensions/.connrate-test	2007-09-05 17:25:26.000000000 +0200
@@ -0,0 +1,3 @@
+#!/bin/bash
+
+[[ -e "$KERNEL_DIR/linux/netfilter_ipv4/ipt_connrate.h" ]] && echo connrate

--------------000007070104020609010701
Content-Type: text/x-patch;
 name="iptables-make2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables-make2.diff"

--- iptables.r7035/extensions/Makefile	2007-09-05 16:39:46.000000000 +0200
+++ iptables/extensions/Makefile	2007-09-05 17:51:30.000000000 +0200
@@ -9,10 +9,14 @@
 PF6_EXT_SLIB:=ah dst eui64 frag hbh hl icmp6 ipv6header mh owner policy rt HL LOG REJECT
 PFX_EXT_SLIB:=connbytes connmark connlimit comment dccp dscp esp hashlimit helper length limit mac mark multiport physdev pkttype quota sctp state statistic standard string tcp tcpmss udp CLASSIFY CONNMARK DSCP MARK NFLOG NFQUEUE NOTRACK TCPMSS TRACE
 
+PF_EXT_SELINUX_SLIB:=
+PF6_EXT_SELINUX_SLIB:=
+PFX_EXT_SELINUX_SLIB:=CONNSECMARK SECMARK
+
 ifeq ($(DO_SELINUX), 1)
-PF_EXT_SE_SLIB:=
-PF6_EXT_SE_SLIB:=
-PFX_EXT_SE_SLIB:=CONNSECMARK SECMARK
+PF_EXT_SE_SLIB:=$(PF_EXT_SELINUX_SLIB)
+PF6_EXT_SE_SLIB:=$(PF_EXT_SELINUX_SLIB)
+PFX_EXT_SE_SLIB:=$(PF_EXT_SELINUX_SLIB)
 endif
 
 # Optionals
@@ -20,9 +24,9 @@
 PF6_EXT_SLIB_OPTS:=$(foreach T,$(wildcard extensions/.*-test6),$(shell KERNEL_DIR=$(KERNEL_DIR) $(T)))
 PFX_EXT_SLIB_OPTS:=$(foreach T,$(wildcard extensions/.*-testx),$(shell KERNEL_DIR=$(KERNEL_DIR) $(T)))
 
-PF_EXT_ALL_SLIB:=$(patsubst extensions/libipt_%.c, %, $(wildcard extensions/libipt_*.c))
-PF6_EXT_ALL_SLIB:=$(patsubst extensions/libip6t_%.c, %, $(wildcard extensions/libip6t_*.c))
-PFX_EXT_ALL_SLIB:=$(patsubst extensions/libxt_%.c, %, $(wildcard extensions/libxt_*.c))
+PF_EXT_ALL_SLIB:=$(PF_EXT_SLIB) $(PF_EXT_SE_SLIB) $(PF_EXT_SLIB_OPTS)
+PF6_EXT_ALL_SLIB:=$(PF6_EXT_SLIB) $(PF6_EXT_SE_SLIB) $(PF6_EXT_SLIB_OPTS)
+PFX_EXT_ALL_SLIB:=$(PFX_EXT_SLIB) $(PFX_EXT_SE_SLIB) $(PFX_EXT_SLIB_OPTS)
 
 PF_EXT_MAN_ALL_MATCHES:=$(foreach T,$(PF_EXT_ALL_SLIB),$(shell test -f extensions/libipt_$(T).man && grep -q register_match extensions/libipt_$(T).c  && echo $(T)))
 PF_EXT_MAN_ALL_TARGETS:=$(foreach T,$(PF_EXT_ALL_SLIB),$(shell test -f extensions/libipt_$(T).man && grep -q register_target extensions/libipt_$(T).c && echo $(T)))
@@ -34,15 +38,43 @@
 PF6_EXT_MAN_ALL_MATCHES+=$(foreach T,$(PFX_EXT_ALL_SLIB),$(shell test -f extensions/libip6t_$(T).man && grep -q xtables_register_match extensions/libxt_$(T).c  && echo $(T)))
 PF6_EXT_MAN_ALL_TARGETS+=$(foreach T,$(PFX_EXT_ALL_SLIB),$(shell test -f extensions/libip6t_$(T).man && grep -q xtables_register_target extensions/libxt_$(T).c && echo $(T)))
 
-PF_EXT_MAN_MATCHES:=$(filter $(PF_EXT_ALL_SLIB), $(PF_EXT_MAN_ALL_MATCHES))
-PF_EXT_MAN_TARGETS:=$(filter $(PF_EXT_ALL_SLIB), $(PF_EXT_MAN_ALL_TARGETS))
+PF_EXT_MAN_MATCHES:=$(filter $(PF_EXT_SLIB), $(PF_EXT_MAN_ALL_MATCHES))
+PF_EXT_MAN_MATCHES+=$(filter $(PFX_EXT_SLIB), $(PF_EXT_MAN_ALL_MATCHES))
+PF_EXT_MAN_MATCHES+=$(filter $(PF_EXT_SE_SLIB), $(PF_EXT_MAN_ALL_MATCHES))
+PF_EXT_MAN_MATCHES+=$(filter $(PFX_EXT_SE_SLIB), $(PF_EXT_MAN_ALL_MATCHES))
+
+PF_EXT_MAN_TARGETS:=$(filter $(PF_EXT_SLIB), $(PF_EXT_MAN_ALL_TARGETS))
+PF_EXT_MAN_TARGETS+=$(filter $(PFX_EXT_SLIB), $(PF_EXT_MAN_ALL_TARGETS))
+PF_EXT_MAN_TARGETS+=$(filter $(PF_EXT_SE_SLIB), $(PF_EXT_MAN_ALL_TARGETS))
+PF_EXT_MAN_TARGETS+=$(filter $(PFX_EXT_SE_SLIB), $(PF_EXT_MAN_ALL_TARGETS))
+
 PF_EXT_MAN_EXTRA_MATCHES:=$(filter-out $(PF_EXT_MAN_MATCHES), $(PF_EXT_MAN_ALL_MATCHES))
 PF_EXT_MAN_EXTRA_TARGETS:=$(filter-out $(PF_EXT_MAN_TARGETS), $(PF_EXT_MAN_ALL_TARGETS))
-PF6_EXT_MAN_MATCHES:=$(filter $(PF6_EXT_ALL_SLIB), $(PF6_EXT_MAN_ALL_MATCHES))
-PF6_EXT_MAN_TARGETS:=$(filter $(PF6_EXT_ALL_SLIB), $(PF6_EXT_MAN_ALL_TARGETS))
+
+PF6_EXT_MAN_MATCHES:=$(filter $(PF6_EXT_SLIB), $(PF6_EXT_MAN_ALL_MATCHES))
+PF6_EXT_MAN_MATCHES+=$(filter $(PFX_EXT_SLIB), $(PF6_EXT_MAN_ALL_MATCHES))
+PF6_EXT_MAN_MATCHES+=$(filter $(PF6_EXT_SE_SLIB), $(PF6_EXT_MAN_ALL_MATCHES))
+PF6_EXT_MAN_MATCHES+=$(filter $(PFX_EXT_SE_SLIB), $(PF6_EXT_MAN_ALL_MATCHES))
+
+PF6_EXT_MAN_TARGETS:=$(filter $(PF6_EXT_SLIB), $(PF6_EXT_MAN_ALL_TARGETS))
+PF6_EXT_MAN_TARGETS+=$(filter $(PFX_EXT_SLIB), $(PF6_EXT_MAN_ALL_TARGETS))
+PF6_EXT_MAN_TARGETS+=$(filter $(PF6_EXT_SE_SLIB), $(PF6_EXT_MAN_ALL_TARGETS))
+PF6_EXT_MAN_TARGETS+=$(filter $(PFX_EXT_SE_SLIB), $(PF6_EXT_MAN_ALL_TARGETS))
+
 PF6_EXT_MAN_EXTRA_MATCHES:=$(filter-out $(PF6_EXT_MAN_MATCHES), $(PF6_EXT_MAN_ALL_MATCHES))
 PF6_EXT_MAN_EXTRA_TARGETS:=$(filter-out $(PF6_EXT_MAN_TARGETS), $(PF6_EXT_MAN_ALL_TARGETS))
 
+ifneq ($(DO_SELINUX), 1)
+PF_EXT_MAN_EXTRA_MATCHES:=$(filter-out $(PF_EXT_SELINUX_SLIB), $(PF_EXT_MAN_EXTRA_MATCHES))
+PF_EXT_MAN_EXTRA_TARGETS:=$(filter-out $(PF_EXT_SELINUX_SLIB), $(PF_EXT_MAN_EXTRA_TARGETS))
+PF_EXT_MAN_EXTRA_MATCHES:=$(filter-out $(PFX_EXT_SELINUX_SLIB), $(PF_EXT_MAN_EXTRA_MATCHES))
+PF_EXT_MAN_EXTRA_TARGETS:=$(filter-out $(PFX_EXT_SELINUX_SLIB), $(PF_EXT_MAN_EXTRA_TARGETS))
+
+PF6_EXT_MAN_EXTRA_MATCHES:=$(filter-out $(PF6_EXT_SELINUX_SLIB), $(PF6_EXT_MAN_EXTRA_MATCHES))
+PF6_EXT_MAN_EXTRA_TARGETS:=$(filter-out $(PF6_EXT_SELINUX_SLIB), $(PF6_EXT_MAN_EXTRA_TARGETS))
+PF6_EXT_MAN_EXTRA_MATCHES:=$(filter-out $(PFX_EXT_SELINUX_SLIB), $(PF6_EXT_MAN_EXTRA_MATCHES))
+PF6_EXT_MAN_EXTRA_TARGETS:=$(filter-out $(PFX_EXT_SELINUX_SLIB), $(PF6_EXT_MAN_EXTRA_TARGETS))
+endif
 
 allman:
 	@echo ALL_SLIB: $(PF_EXT_ALL_SLIB)

--------------000007070104020609010701--
