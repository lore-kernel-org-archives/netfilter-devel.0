From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Conntrackd Segmentation fault due to nfexp_get_attr returning
 NULL
Date: Wed, 3 Oct 2012 22:33:38 +0200
Message-ID: <20121003203338.GA10154@1984>
References: <3E070A3A9446DB43B8A316366DBEABBE1F26A591@palm.evergreen.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="vtzGhvizbBRQ85DL"
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Gutholm, James" <gutholmj@evergreen.edu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38978 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485Ab2JCUdp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Oct 2012 16:33:45 -0400
Content-Disposition: inline
In-Reply-To: <3E070A3A9446DB43B8A316366DBEABBE1F26A591@palm.evergreen.edu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 03, 2012 at 06:52:08PM +0000, Gutholm, James wrote:
> 
> Under heavy load conntrackd is crashing. Running under gdb I was able to determine that the crashes are caused by an unchecked null pointer returned by nfexp_get_attr in both exp_filter_find() in filter.c and exp_build_str() in build.c
> i
> This only happens when expectation sync is being used. Setting "ExpectationSync Off" in conntrackd.conf stops the crashes.
> 
> I coded in a couple of checks on the pointer returned which at least stop the errors. I've included the changes as diffs and also the gdb output in case it is helpful. If there's something else I can provide, I'm happy to help but this might be pushing the limit of my expertise.
> 
> James
> 
> This is on RHEL6 (2.6.32-300.32.2.el6uek.x86_64) with conntrack-tool built from source.

I see, I forgot to document that Linux kernel >= 3.5 to get
ExpectationSync working flawlessly is required.

I have attached the following patch. It fixes the crash, and document
this accordingly but you still will have to upgrade your kernel if you
want expectation synchronization.

BTW, thanks a lot for the report, really accurate.

I'd appreciate if you give it a test, just to make sure we don't crash
anymore, even if you will not get the expectsync feature working
correctly in all possible scenarios.

--vtzGhvizbBRQ85DL
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-conntrackd-fix-crash-if-ExpectationSync-is-enabled-o.patch"

>From 597d10a74acbb17bba5db48ca71c3a76ce2d9305 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Wed, 3 Oct 2012 22:19:25 +0200
Subject: [PATCH] conntrackd: fix crash if ExpectationSync is enabled on old
 Linux kernels

ExpectationSync requires Linux kernel >= 3.5 to work sanely, document this.
Still, we don't want to crash if someone enables expectation sync with
old Linux kernels (like 2.6.32).

Reported-by: James Gutholm <gutholmj@evergreen.edu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/manual/conntrack-tools.tmpl  |    7 +++++++
 doc/sync/alarm/conntrackd.conf   |    3 ++-
 doc/sync/ftfw/conntrackd.conf    |    3 ++-
 doc/sync/notrack/conntrackd.conf |    3 ++-
 src/build.c                      |    3 ++-
 src/filter.c                     |   12 +++++++++++-
 6 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/doc/manual/conntrack-tools.tmpl b/doc/manual/conntrack-tools.tmpl
index 47e6f84..63a53e4 100644
--- a/doc/manual/conntrack-tools.tmpl
+++ b/doc/manual/conntrack-tools.tmpl
@@ -660,6 +660,13 @@ Sync {
 
 <sect3 id="sync-expect"><title>Synchronization of expectations</title>
 
+   <note><title>Check your Linux kernel version first</title>
+    <para>
+     The synchronization of expectations require a Linux kernel &gt;= 3.5
+     to work appropriately.
+    </para>
+   </note>
+
  <para>The connection tracking system provides helpers that allows you to
  filter multi-flow application protocols like FTP, H.323 and SIP among many
  others. These protocols usually split the control and data traffic in
diff --git a/doc/sync/alarm/conntrackd.conf b/doc/sync/alarm/conntrackd.conf
index b9520fb..0223745 100644
--- a/doc/sync/alarm/conntrackd.conf
+++ b/doc/sync/alarm/conntrackd.conf
@@ -194,7 +194,8 @@ Sync {
 
 		# Set this option on if you want to enable the synchronization
 		# of expectations. You have to specify the list of helpers that
-		# you want to enable. Default is off.
+		# you want to enable. Default is off. This feature requires
+		# a Linux kernel >= 3.5.
 		#
 		# ExpectationSync {
 		#       ftp
diff --git a/doc/sync/ftfw/conntrackd.conf b/doc/sync/ftfw/conntrackd.conf
index 53a7d0f..65e7b77 100644
--- a/doc/sync/ftfw/conntrackd.conf
+++ b/doc/sync/ftfw/conntrackd.conf
@@ -217,7 +217,8 @@ Sync {
 
 		# Set this option on if you want to enable the synchronization
 		# of expectations. You have to specify the list of helpers that
-		# you want to enable. Default is off.
+		# you want to enable. Default is off. This feature requires
+		# a Linux kernel >= 3.5.
 		#
 		# ExpectationSync {
 		#	ftp
diff --git a/doc/sync/notrack/conntrackd.conf b/doc/sync/notrack/conntrackd.conf
index 11f022e..3d036fb 100644
--- a/doc/sync/notrack/conntrackd.conf
+++ b/doc/sync/notrack/conntrackd.conf
@@ -256,7 +256,8 @@ Sync {
 
 		# Set this option on if you want to enable the synchronization
 		# of expectations. You have to specify the list of helpers that
-		# you want to enable. Default is off.
+		# you want to enable. Default is off. This feature requires
+		# a Linux kernel >= 3.5.
 		#
 		# ExpectationSync {
 		#       ftp
diff --git a/src/build.c b/src/build.c
index 7d4ef12..e15eb4f 100644
--- a/src/build.c
+++ b/src/build.c
@@ -356,7 +356,8 @@ void exp2msg(const struct nf_expect *exp, struct nethdr *n)
 
 		exp_build_u32(exp, ATTR_EXP_NAT_DIR, n, NTA_EXP_NAT_DIR);
 	}
-	exp_build_str(exp, ATTR_EXP_HELPER_NAME, n, NTA_EXP_HELPER_NAME);
+	if (nfexp_attr_is_set(exp, ATTR_EXP_HELPER_NAME))
+		exp_build_str(exp, ATTR_EXP_HELPER_NAME, n, NTA_EXP_HELPER_NAME);
 	if (nfexp_attr_is_set(exp, ATTR_EXP_FN))
 		exp_build_str(exp, ATTR_EXP_FN, n, NTA_EXP_FN);
 }
diff --git a/src/filter.c b/src/filter.c
index 39dd4ca..02a8078 100644
--- a/src/filter.c
+++ b/src/filter.c
@@ -473,7 +473,17 @@ int exp_filter_find(struct exp_filter *f, const struct nf_expect *exp)
 		return 1;
 
 	list_for_each_entry(item, &f->list, head) {
-		const char *name = nfexp_get_attr(exp, ATTR_EXP_HELPER_NAME);
+		const char *name;
+
+		if (nfexp_attr_is_set(exp, ATTR_EXP_HELPER_NAME))
+			name = nfexp_get_attr(exp, ATTR_EXP_HELPER_NAME);
+		else {
+			/* No helper name, this is likely to be a kernel older
+			 * which does not include the helper name, just skip
+			 * this so we don't crash.
+			 */
+			return 0;
+		}
 
 		/* we allow partial matching to support things like sip-PORT. */
 		if (strncasecmp(item->helper_name, name,
-- 
1.7.10.4


--vtzGhvizbBRQ85DL--
