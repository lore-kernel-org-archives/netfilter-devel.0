Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1B4AC00A8F
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Oct 2023 17:01:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232862AbjJXRBg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Oct 2023 13:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232602AbjJXRBf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2023 13:01:35 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18597C2
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2023 10:01:30 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qvKmW-0006Bw-4s; Tue, 24 Oct 2023 19:01:28 +0200
Date:   Tue, 24 Oct 2023 19:01:28 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/6] man: encode minushyphen the way groff/man requires it
Message-ID: <ZTf4aLqaO9Zma7lZ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
References: <20231024131919.28665-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="JC663wwgEN02gtaf"
Content-Disposition: inline
In-Reply-To: <20231024131919.28665-1-jengelh@inai.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--JC663wwgEN02gtaf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jan,

On Tue, Oct 24, 2023 at 03:19:14PM +0200, Jan Engelhardt wrote:
> Sparked by a recent LWN article[1], I made a sweep over the iptables
> manpages for incorrectly encoded dashes.
> 
> If the output is supposed to be a U+002D character (which is the case
> for options and everything that is going to be copy-and-pasted), \-
> must be used.
> 
> [1] https://lwn.net/Articles/947941/ (paywalled until about 2023-11-06)

Your patches lack an SoB.

After applying them, I checked the remaining unescaped dashes in man
pages and found a few spots you missed. Could you please review the
attached series and incorporate into yours as you see fit?

Thanks, Phil

--JC663wwgEN02gtaf
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-extensions-osf-Use-.TP-for-lists-in-man-page.patch"

From ee820870f594b2a19ee50b59c52c9c9b313e7e5d Mon Sep 17 00:00:00 2001
From: Phil Sutter <phil@nwl.cc>
Date: Tue, 24 Oct 2023 17:49:13 +0200
Subject: [iptables PATCH 01/15] extensions: osf: Use .TP for lists in man page

Value and description are more clearly set apart, also using .RS/.RE
pairs adds proper indenting.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_osf.man | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/extensions/libxt_osf.man b/extensions/libxt_osf.man
index e68440f525b0f..bc3f0ec1babee 100644
--- a/extensions/libxt_osf.man
+++ b/extensions/libxt_osf.man
@@ -8,24 +8,34 @@ Match an operating system genre by using a passive fingerprinting.
 \fB\-\-ttl\fP \fIlevel\fP
 Do additional TTL checks on the packet to determine the operating system.
 \fIlevel\fP can be one of the following values:
-.IP \(bu 4
-0 - True IP address and fingerprint TTL comparison. This generally works for
+.RS
+.TP
+.B 0
+True IP address and fingerprint TTL comparison. This generally works for
 LANs.
-.IP \(bu 4
-1 - Check if the IP header's TTL is less than the fingerprint one. Works for
+.TP
+.B 1
+Check if the IP header's TTL is less than the fingerprint one. Works for
 globally-routable addresses.
-.IP \(bu 4
-2 - Do not compare the TTL at all.
+.TP
+.B 2
+Do not compare the TTL at all.
+.RE
 .TP
 \fB\-\-log\fP \fIlevel\fP
 Log determined genres into dmesg even if they do not match the desired one.
 \fIlevel\fP can be one of the following values:
-.IP \(bu 4
-0 - Log all matched or unknown signatures
-.IP \(bu 4
-1 - Log only the first one
-.IP \(bu 4
-2 - Log all known matched signatures
+.RS
+.TP
+.B 0
+Log all matched or unknown signatures
+.TP
+.B 1
+Log only the first one
+.TP
+.B 2
+Log all known matched signatures
+.RE
 .PP
 You may find something like this in syslog:
 .PP
-- 
2.41.0


--JC663wwgEN02gtaf
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-extensions-rateest-Reveal-combination-categories.patch"

From 94c0866f61ca332d437f4ae66ebb1a950db67f3b Mon Sep 17 00:00:00 2001
From: Phil Sutter <phil@nwl.cc>
Date: Tue, 24 Oct 2023 17:52:01 +0200
Subject: [iptables PATCH 02/15] extensions: rateest: Reveal combination
 categories

The '.\"'-prefix made them invisible in at least regular man page
output. Turn them into tags instead.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_rateest.man | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_rateest.man b/extensions/libxt_rateest.man
index 42a82f3229071..d2561fcbb8907 100644
--- a/extensions/libxt_rateest.man
+++ b/extensions/libxt_rateest.man
@@ -4,22 +4,26 @@ estimators and matching on the difference between two rate estimators.
 .PP
 For a better understanding of the available options, these are all possible
 combinations:
-.\" * Absolute:
+.TP
+Absolute:
 .IP \(bu 4
 \fBrateest\fP \fIoperator\fP \fBrateest-bps\fP
 .IP \(bu 4
 \fBrateest\fP \fIoperator\fP \fBrateest-pps\fP
-.\" * Absolute + Delta:
+.TP
+Absolute + Delta:
 .IP \(bu 4
 (\fBrateest\fP minus \fBrateest-bps1\fP) \fIoperator\fP \fBrateest-bps2\fP
 .IP \(bu 4
 (\fBrateest\fP minus \fBrateest-pps1\fP) \fIoperator\fP \fBrateest-pps2\fP
-.\" * Relative:
+.TP
+Relative:
 .IP \(bu 4
 \fBrateest1\fP \fIoperator\fP \fBrateest2\fP \fBrateest-bps\fP(without rate!)
 .IP \(bu 4
 \fBrateest1\fP \fIoperator\fP \fBrateest2\fP \fBrateest-pps\fP(without rate!)
-.\" * Relative + Delta:
+.TP
+Relative + Delta:
 .IP \(bu 4
 (\fBrateest1\fP minus \fBrateest-bps1\fP) \fIoperator\fP
 (\fBrateest2\fP minus \fBrateest-bps2\fP)
-- 
2.41.0


--JC663wwgEN02gtaf
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0003-extensions-MASQUERADE-Grammar-fix.patch"

From 0f97a28a9a60a1a3c3398bd49fd0d37bf69ed2d4 Mon Sep 17 00:00:00 2001
From: Phil Sutter <phil@nwl.cc>
Date: Tue, 24 Oct 2023 17:56:56 +0200
Subject: [iptables PATCH 03/15] extensions: MASQUERADE: Grammar fix

No need for a dash in "SNAT source port selection heuristics", is there?

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_MASQUERADE.man | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libxt_MASQUERADE.man b/extensions/libxt_MASQUERADE.man
index e2009086c6310..b0dac4b87814a 100644
--- a/extensions/libxt_MASQUERADE.man
+++ b/extensions/libxt_MASQUERADE.man
@@ -15,7 +15,7 @@ any established connections are lost anyway).
 \fB\-\-to\-ports\fP \fIport\fP[\fB\-\fP\fIport\fP]
 This specifies a range of source ports to use, overriding the default
 .B SNAT
-source port-selection heuristics (see above).  This is only valid
+source port selection heuristics (see above).  This is only valid
 if the rule also specifies one of the following protocols:
 \fBtcp\fP, \fBudp\fP, \fBdccp\fP or \fBsctp\fP.
 .TP
-- 
2.41.0


--JC663wwgEN02gtaf
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0004-extensions-rateest-Use-em-for-that-one-dash.patch"

From 1bdac1e9a81a9dac9ac3735cce736abe6feeccbc Mon Sep 17 00:00:00 2001
From: Phil Sutter <phil@nwl.cc>
Date: Tue, 24 Oct 2023 18:00:25 +0200
Subject: [iptables PATCH 04/15] extensions: rateest: Use \(em for that one
 dash

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_rateest.man | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libxt_rateest.man b/extensions/libxt_rateest.man
index d2561fcbb8907..a4c0ee0c8324a 100644
--- a/extensions/libxt_rateest.man
+++ b/extensions/libxt_rateest.man
@@ -72,7 +72,7 @@ The names of the two rate estimators for relative mode.
 \fB\-\-rateest\-pps2\fP [\fIvalue\fP]
 Compare the estimator(s) by bytes or packets per second, and compare against
 the chosen value. See the above bullet list for which option is to be used in
-which case. A unit suffix may be used - available ones are: bit, [kmgt]bit,
+which case. A unit suffix may be used \(em available ones are: bit, [kmgt]bit,
 [KMGT]ibit, Bps, [KMGT]Bps, [KMGT]iBps.
 .PP
 Example: This is what can be used to route outgoing data connections from an
-- 
2.41.0


--JC663wwgEN02gtaf
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0005-extensions-TRACE-Put-commands-in-bold-font.patch"

From 8e850fca417de96abe7543ddd30b2e0bf9272617 Mon Sep 17 00:00:00 2001
From: Phil Sutter <phil@nwl.cc>
Date: Tue, 24 Oct 2023 18:03:27 +0200
Subject: [iptables PATCH 05/15] extensions: TRACE: Put commands in bold font

Also have to escape the dash.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_TRACE.man | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_TRACE.man b/extensions/libxt_TRACE.man
index 9cfa271151e6c..a23c71cc7170a 100644
--- a/extensions/libxt_TRACE.man
+++ b/extensions/libxt_TRACE.man
@@ -4,14 +4,14 @@ the
 .BR raw
 table.
 .PP
-With iptables-legacy, a logging backend, such as ip(6)t_LOG or nfnetlink_log,
+With \fBiptables\-legacy\fP, a logging backend, such as ip(6)t_LOG or nfnetlink_log,
 must be loaded for this to be visible.
 The packets are logged with the string prefix:
 "TRACE: tablename:chainname:type:rulenum " where type can be "rule" for 
 plain rule, "return" for implicit rule at the end of a user defined chain 
 and "policy" for the policy of the built in chains. 
 .PP
-With iptables-nft, the target is translated into nftables'
+With \fBiptables\-nft\fP, the target is translated into nftables'
 .B "meta nftrace"
 expression. Hence the kernel sends trace events via netlink to userspace where
 they may be displayed using
-- 
2.41.0


--JC663wwgEN02gtaf
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0006-extensions-cluster-Put-commands-in-bold-font.patch"

From 2ade37c135c7900981a5e4f112725d89a3dd16da Mon Sep 17 00:00:00 2001
From: Phil Sutter <phil@nwl.cc>
Date: Tue, 24 Oct 2023 18:04:08 +0200
Subject: [iptables PATCH 06/15] extensions: cluster: Put commands in bold font

Also have to escape the dash.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_cluster.man | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_cluster.man b/extensions/libxt_cluster.man
index 630544717fbf0..3a5ec7039d125 100644
--- a/extensions/libxt_cluster.man
+++ b/extensions/libxt_cluster.man
@@ -56,9 +56,9 @@ arptables \-A INPUT \-i eth2 \-\-h\-length 6
 \-j mangle \-\-mangle\-mac\-d 00:zz:yy:xx:5a:27
 .PP
 \fBNOTE\fP: the arptables commands above use mainstream syntax. If you
-are using arptables-jf included in some RedHat, CentOS and Fedora
+are using \fBarptables\-jf\fP included in some RedHat, CentOS and Fedora
 versions, you will hit syntax errors. Therefore, you'll have to adapt
-these to the arptables-jf syntax to get them working.
+these to the \fBarptables\-jf\fP syntax to get them working.
 .PP
 In the case of TCP connections, pickup facility has to be disabled
 to avoid marking TCP ACK packets coming in the reply direction as
-- 
2.41.0


--JC663wwgEN02gtaf
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0007-extensions-S-D-NPT-Properly-format-examples.patch"

From e4dc5af8048513e29a73232a9dd53a4311533c4d Mon Sep 17 00:00:00 2001
From: Phil Sutter <phil@nwl.cc>
Date: Tue, 24 Oct 2023 18:13:56 +0200
Subject: [iptables PATCH 07/15] extensions: {S,D}NPT: Properly format examples

Do not break the long lines, wide displays might be able to print them
in a single one. Also enclose in .EX/.EE macros and remove newlines in
between them, the two belong together.

In addition to the above, escape the dash immediately before 'pfx' as
well.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libip6t_DNPT.man | 9 ++++-----
 extensions/libip6t_SNPT.man | 9 ++++-----
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/extensions/libip6t_DNPT.man b/extensions/libip6t_DNPT.man
index a9c06700a7dcd..bdcd86040ce5f 100644
--- a/extensions/libip6t_DNPT.man
+++ b/extensions/libip6t_DNPT.man
@@ -15,11 +15,10 @@ Set destination prefix that you want to use in the translation and length
 .PP
 You have to use the SNPT target to undo the translation. Example:
 .IP
-ip6tables \-t mangle \-I POSTROUTING \-s fd00::/64 \! \-o vboxnet0
-\-j SNPT \-\-src-pfx fd00::/64 \-\-dst-pfx 2001:e20:2000:40f::/64
-.IP
-ip6tables \-t mangle \-I PREROUTING \-i wlan0 \-d 2001:e20:2000:40f::/64
-\-j DNPT \-\-src-pfx 2001:e20:2000:40f::/64 \-\-dst\-pfx fd00::/64
+.EX
+ip6tables \-t mangle \-I POSTROUTING \-s fd00::/64 \! \-o vboxnet0 \-j SNPT \-\-src\-pfx fd00::/64 \-\-dst\-pfx 2001:e20:2000:40f::/64
+ip6tables \-t mangle \-I PREROUTING \-i wlan0 \-d 2001:e20:2000:40f::/64 \-j DNPT \-\-src\-pfx 2001:e20:2000:40f::/64 \-\-dst\-pfx fd00::/64
+.EE
 .PP
 You may need to enable IPv6 neighbor proxy:
 .IP
diff --git a/extensions/libip6t_SNPT.man b/extensions/libip6t_SNPT.man
index 1185d9c01ce8a..540d64e370fba 100644
--- a/extensions/libip6t_SNPT.man
+++ b/extensions/libip6t_SNPT.man
@@ -15,11 +15,10 @@ Set destination prefix that you want to use in the translation and length
 .PP
 You have to use the DNPT target to undo the translation. Example:
 .IP
-ip6tables \-t mangle \-I POSTROUTING \-s fd00::/64 \! \-o vboxnet0
-\-j SNPT \-\-src-pfx fd00::/64 \-\-dst-pfx 2001:e20:2000:40f::/64
-.IP
-ip6tables \-t mangle \-I PREROUTING \-i wlan0 \-d 2001:e20:2000:40f::/64
-\-j DNPT \-\-src-pfx 2001:e20:2000:40f::/64 \-\-dst\-pfx fd00::/64
+.EX
+ip6tables \-t mangle \-I POSTROUTING \-s fd00::/64 \! \-o vboxnet0 \-j SNPT \-\-src\-pfx fd00::/64 \-\-dst\-pfx 2001:e20:2000:40f::/64
+ip6tables \-t mangle \-I PREROUTING \-i wlan0 \-d 2001:e20:2000:40f::/64 \-j DNPT \-\-src\-pfx 2001:e20:2000:40f::/64 \-\-dst\-pfx fd00::/64
+.EE
 .PP
 You may need to enable IPv6 neighbor proxy:
 .IP
-- 
2.41.0


--JC663wwgEN02gtaf
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0008-extensions-HMARK-Properly-format-examples.patch"

From 0a64783c05e292567658c23002db4456b6cf753b Mon Sep 17 00:00:00 2001
From: Phil Sutter <phil@nwl.cc>
Date: Tue, 24 Oct 2023 18:18:51 +0200
Subject: [iptables PATCH 08/15] extensions: HMARK: Properly format examples

Drop the line breaks, these commands are supposed to go into a single
line. Also enclose in .EX/.EE macros and escape the dash immediately
before 'tuple' as well.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_HMARK.man | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/extensions/libxt_HMARK.man b/extensions/libxt_HMARK.man
index 63d18cb56d012..e19083f78cf09 100644
--- a/extensions/libxt_HMARK.man
+++ b/extensions/libxt_HMARK.man
@@ -52,9 +52,10 @@ A 32 bit random custom value to feed hash calculation.
 .PP
 \fIExamples:\fP
 .PP
-iptables \-t mangle \-A PREROUTING \-m conntrack \-\-ctstate NEW
- \-j HMARK \-\-hmark-tuple ct,src,dst,proto \-\-hmark\-offset 10000
-\-\-hmark\-mod 10 \-\-hmark\-rnd 0xfeedcafe
+.EX
+iptables \-t mangle \-A PREROUTING \-m conntrack \-\-ctstate NEW \-j HMARK \-\-hmark\-tuple ct,src,dst,proto \-\-hmark\-offset 10000 \-\-hmark\-mod 10 \-\-hmark\-rnd 0xfeedcafe
+.EE
 .PP
-iptables \-t mangle \-A PREROUTING \-j HMARK \-\-hmark\-offset 10000
-\-\-hmark-tuple src,dst,proto \-\-hmark-mod 10 \-\-hmark\-rnd 0xdeafbeef
+.EX
+iptables \-t mangle \-A PREROUTING \-j HMARK \-\-hmark\-offset 10000 \-\-hmark\-tuple src,dst,proto \-\-hmark\-mod 10 \-\-hmark\-rnd 0xdeafbeef
+.EE
-- 
2.41.0


--JC663wwgEN02gtaf
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0009-extensions-osf-Properly-format-the-log-sample.patch"

From c68c8dc06363f060fbd7532a7194b3e24a72432e Mon Sep 17 00:00:00 2001
From: Phil Sutter <phil@nwl.cc>
Date: Tue, 24 Oct 2023 18:37:24 +0200
Subject: [iptables PATCH 09/15] extensions: osf: Properly format the log
 sample

Put on a single line as it appears in syslog, enclose in .RE/.EE macros
and escape all three dashes, not just the first one.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_osf.man | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_osf.man b/extensions/libxt_osf.man
index bc3f0ec1babee..49b2646ae20ae 100644
--- a/extensions/libxt_osf.man
+++ b/extensions/libxt_osf.man
@@ -39,8 +39,9 @@ Log all known matched signatures
 .PP
 You may find something like this in syslog:
 .PP
-Windows [2000:SP3:Windows XP Pro SP1, 2000 SP3]: 11.22.33.55:4024 \->
-11.22.33.44:139 hops=3 Linux [2.5-2.6:] : 1.2.3.4:42624 -> 1.2.3.5:22 hops=4
+.RE
+Windows [2000:SP3:Windows XP Pro SP1, 2000 SP3]: 11.22.33.55:4024 \-> 11.22.33.44:139 hops=3 Linux [2.5\-2.6:] : 1.2.3.4:42624 \-> 1.2.3.5:22 hops=4
+.EE
 .PP
 OS fingerprints are loadable using the \fBnfnl_osf\fP program. To load
 fingerprints from a file, use:
-- 
2.41.0


--JC663wwgEN02gtaf
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0010-extensions-.man-Use-U-002D-dash-for-ranges-and-math-.patch"

From c8d64245511f09691de448a66a08f4130a3293aa Mon Sep 17 00:00:00 2001
From: Phil Sutter <phil@nwl.cc>
Date: Tue, 24 Oct 2023 18:40:52 +0200
Subject: [iptables PATCH 10/15] extensions: *.man: Use U+002D dash for ranges
 and math terms

This seems like the proper choice here.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libipt_ULOG.man   |  2 +-
 extensions/libxt_NFLOG.man   |  2 +-
 extensions/libxt_cpu.man     |  2 +-
 extensions/libxt_dscp.man    |  2 +-
 extensions/libxt_rateest.man |  2 +-
 extensions/libxt_u32.man     | 16 ++++++++--------
 6 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/extensions/libipt_ULOG.man b/extensions/libipt_ULOG.man
index 453a5600a5fb3..ac3efe907d0a0 100644
--- a/extensions/libipt_ULOG.man
+++ b/extensions/libipt_ULOG.man
@@ -9,7 +9,7 @@ Like LOG, this is a "non-terminating target", i.e. rule traversal
 continues at the next rule.
 .TP
 \fB\-\-ulog\-nlgroup\fP \fInlgroup\fP
-This specifies the netlink group (1-32) to which the packet is sent.
+This specifies the netlink group (1\-32) to which the packet is sent.
 Default value is 1.
 .TP
 \fB\-\-ulog\-prefix\fP \fIprefix\fP
diff --git a/extensions/libxt_NFLOG.man b/extensions/libxt_NFLOG.man
index 99f1b66dd52a8..0932d55aa1fad 100644
--- a/extensions/libxt_NFLOG.man
+++ b/extensions/libxt_NFLOG.man
@@ -9,7 +9,7 @@ may subscribe to the group to receive the packets. Like LOG, this is a
 non-terminating target, i.e. rule traversal continues at the next rule.
 .TP
 \fB\-\-nflog\-group\fP \fInlgroup\fP
-The netlink group (0 - 2^16\-1) to which packets are (only applicable for
+The netlink group (0 \- 2^16\-1) to which packets are (only applicable for
 nfnetlink_log). The default value is 0.
 .TP
 \fB\-\-nflog\-prefix\fP \fIprefix\fP
diff --git a/extensions/libxt_cpu.man b/extensions/libxt_cpu.man
index c89ef08afbfbb..158d50cb677cd 100644
--- a/extensions/libxt_cpu.man
+++ b/extensions/libxt_cpu.man
@@ -1,6 +1,6 @@
 .TP
 [\fB!\fP] \fB\-\-cpu\fP \fInumber\fP
-Match cpu handling this packet. cpus are numbered from 0 to NR_CPUS-1
+Match cpu handling this packet. cpus are numbered from 0 to NR_CPUS\-1
 Can be used in combination with RPS (Remote Packet Steering) or
 multiqueue NICs to spread network traffic on different queues.
 .PP
diff --git a/extensions/libxt_dscp.man b/extensions/libxt_dscp.man
index 63a17dac1f88e..9d34af540b78f 100644
--- a/extensions/libxt_dscp.man
+++ b/extensions/libxt_dscp.man
@@ -2,7 +2,7 @@ This module matches the 6 bit DSCP field within the TOS field in the
 IP header.  DSCP has superseded TOS within the IETF.
 .TP
 [\fB!\fP] \fB\-\-dscp\fP \fIvalue\fP
-Match against a numeric (decimal or hex) value [0-63].
+Match against a numeric (decimal or hex) value [0\-63].
 .TP
 [\fB!\fP] \fB\-\-dscp\-class\fP \fIclass\fP
 Match the DiffServ class. This value may be any of the
diff --git a/extensions/libxt_rateest.man b/extensions/libxt_rateest.man
index a4c0ee0c8324a..b1779eb392382 100644
--- a/extensions/libxt_rateest.man
+++ b/extensions/libxt_rateest.man
@@ -35,7 +35,7 @@ For a better understanding of the available options, these are all possible
 For each estimator (either absolute or relative mode), calculate the difference
 between the estimator-determined flow rate and the static value chosen with the
 BPS/PPS options. If the flow rate is higher than the specified BPS/PPS, 0 will
-be used instead of a negative value. In other words, "max(0, rateest#_rate -
+be used instead of a negative value. In other words, "max(0, rateest#_rate \-
 rateest#_bps)" is used.
 .TP
 [\fB!\fP] \fB\-\-rateest\-lt\fP
diff --git a/extensions/libxt_u32.man b/extensions/libxt_u32.man
index 40a69f8e3fd0a..c593472b1f714 100644
--- a/extensions/libxt_u32.man
+++ b/extensions/libxt_u32.man
@@ -69,13 +69,13 @@ to enclose the arguments in quotes.
 .IP
 match IP packets with total length >= 256
 .IP
-The IP header contains a total length field in bytes 2-3.
+The IP header contains a total length field in bytes 2\-3.
 .IP
 \-\-u32 "\fB0 & 0xFFFF = 0x100:0xFFFF\fP"
 .IP
-read bytes 0-3
+read bytes 0\-3
 .IP
-AND that with 0xFFFF (giving bytes 2-3), and test whether that is in the range
+AND that with 0xFFFF (giving bytes 2\-3), and test whether that is in the range
 [0x100:0xFFFF]
 .PP
 Example: (more realistic, hence more complicated)
@@ -86,7 +86,7 @@ First test that it is an ICMP packet, true iff byte 9 (protocol) = 1
 .IP
 \-\-u32 "\fB6 & 0xFF = 1 &&\fP ...
 .IP
-read bytes 6-9, use \fB&\fP to throw away bytes 6-8 and compare the result to
+read bytes 6\-9, use \fB&\fP to throw away bytes 6\-8 and compare the result to
 1. Next test that it is not a fragment. (If so, it might be part of such a
 packet but we cannot always tell.) N.B.: This test is generally needed if you
 want to match anything beyond the IP header. The last 6 bits of byte 6 and all
@@ -101,11 +101,11 @@ stored in the right half of byte 0 of the IP header itself.
 .IP
  ... \fB0 >> 22 & 0x3C @ 0 >> 24 = 0\fP"
 .IP
-The first 0 means read bytes 0-3, \fB>>22\fP means shift that 22 bits to the
+The first 0 means read bytes 0\-3, \fB>>22\fP means shift that 22 bits to the
 right. Shifting 24 bits would give the first byte, so only 22 bits is four
 times that plus a few more bits. \fB&3C\fP then eliminates the two extra bits
 on the right and the first four bits of the first byte. For instance, if IHL=5,
-then the IP header is 20 (4 x 5) bytes long. In this case, bytes 0-1 are (in
+then the IP header is 20 (4 x 5) bytes long. In this case, bytes 0\-1 are (in
 binary) xxxx0101 yyzzzzzz, \fB>>22\fP gives the 10 bit value xxxx0101yy and
 \fB&3C\fP gives 010100. \fB@\fP means to use this number as a new offset into
 the packet, and read four bytes starting from there. This is the first 4 bytes
@@ -115,7 +115,7 @@ the result with 0.
 .PP
 Example:
 .IP
-TCP payload bytes 8-12 is any of 1, 2, 5 or 8
+TCP payload bytes 8\-12 is any of 1, 2, 5 or 8
 .IP
 First we test that the packet is a tcp packet (similar to ICMP).
 .IP
@@ -130,5 +130,5 @@ makes this the new offset into the packet, which is the start of the TCP
 header. The length of the TCP header (again in 32 bit words) is the left half
 of byte 12 of the TCP header. The \fB12>>26&3C\fP computes this length in bytes
 (similar to the IP header before). "@" makes this the new offset, which is the
-start of the TCP payload. Finally, 8 reads bytes 8-12 of the payload and
+start of the TCP payload. Finally, 8 reads bytes 8\-12 of the payload and
 \fB=\fP checks whether the result is any of 1, 2, 5 or 8.
-- 
2.41.0


--JC663wwgEN02gtaf
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0011-extensions-NFQUEUE-Escape-dash-in-queue-bypass.patch"

From 6d61a8f0f8e942dd1a871922168bfeab924f07f8 Mon Sep 17 00:00:00 2001
From: Phil Sutter <phil@nwl.cc>
Date: Tue, 24 Oct 2023 18:41:56 +0200
Subject: [iptables PATCH 11/15] extensions: NFQUEUE: Escape dash in
 queue-bypass

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_NFQUEUE.man | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libxt_NFQUEUE.man b/extensions/libxt_NFQUEUE.man
index 5126609d9c200..cb963becd2eeb 100644
--- a/extensions/libxt_NFQUEUE.man
+++ b/extensions/libxt_NFQUEUE.man
@@ -8,7 +8,7 @@ for details.
 nfnetlink_queue
 was added in Linux 2.6.14. The \fBqueue\-balance\fP option was added in Linux
 2.6.31,
-\fBqueue-bypass\fP in 2.6.39.
+\fBqueue\-bypass\fP in 2.6.39.
 .TP
 \fB\-\-queue\-num\fP \fIvalue\fP
 This specifies the QUEUE number to use. Valid queue numbers are 0 to 65535. The default value is 0.
-- 
2.41.0


--JC663wwgEN02gtaf
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0012-extensions-SET-Escape-dash-in-set-name.patch"

From 25a32c720cfc057739a1391d1bc2c604330582e7 Mon Sep 17 00:00:00 2001
From: Phil Sutter <phil@nwl.cc>
Date: Tue, 24 Oct 2023 18:42:37 +0200
Subject: [iptables PATCH 12/15] extensions: SET: Escape dash in set-name

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_SET.man | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libxt_SET.man b/extensions/libxt_SET.man
index 037969ea881b4..2fe17f5a58c9a 100644
--- a/extensions/libxt_SET.man
+++ b/extensions/libxt_SET.man
@@ -26,7 +26,7 @@ when adding an entry if it already exists, reset the timeout value
 to the specified one or to the default from the set definition
 .TP
 \fB\-\-map\-set\fP \fIset\-name\fP
-the set-name should be created with \-\-skbinfo option
+the \fIset\-name\fP should be created with \-\-skbinfo option
 \fB\-\-map\-mark\fP
 map firewall mark to packet by lookup of value in the set
 \fB\-\-map\-prio\fP
-- 
2.41.0


--JC663wwgEN02gtaf
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0013-extensions-SYNPROXY-Drop-linebreaks-from-example.patch"

From 4c2f874143deae020faca2c1c5076208370d1f14 Mon Sep 17 00:00:00 2001
From: Phil Sutter <phil@nwl.cc>
Date: Tue, 24 Oct 2023 18:46:43 +0200
Subject: [iptables PATCH 13/15] extensions: SYNPROXY: Drop linebreaks from
 example

Also enclose in .EX/.EE macros and escape the '-c' tcpdump option's
dash.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_SYNPROXY.man | 35 ++++++++++++++---------------------
 1 file changed, 14 insertions(+), 21 deletions(-)

diff --git a/extensions/libxt_SYNPROXY.man b/extensions/libxt_SYNPROXY.man
index bc2b3eec1cd81..f24db7f4bfd91 100644
--- a/extensions/libxt_SYNPROXY.man
+++ b/extensions/libxt_SYNPROXY.man
@@ -22,33 +22,24 @@ also needed for selective acknowledgement and window scaling).
 .PP
 Determine tcp options used by backend, from an external system
 .IP
-tcpdump \-pni eth0 -c 1 'tcp[tcpflags] == (tcp\-syn|tcp\-ack)'
-.br
-    port 80 &
-.br
+.EX
+tcpdump \-pni eth0 \-c 1 'tcp[tcpflags] == (tcp\-syn|tcp\-ack)' port 80 &
 telnet 192.0.2.42 80
-.br
-18:57:24.693307 IP 192.0.2.42.80 > 192.0.2.43.48757:
-.br
-    Flags [S.], seq 360414582, ack 788841994, win 14480,
-.br
-    options [mss 1460,sackOK,
-.br
-    TS val 1409056151 ecr 9690221,
-.br
-    nop,wscale 9],
-.br
-    length 0
+18:57:24.693307 IP 192.0.2.42.80 > 192.0.2.43.48757: Flags [S.], seq 360414582, ack 788841994, win 14480, options [mss 1460,sackOK, TS val 1409056151 ecr 9690221, nop,wscale 9], length 0
+.EX
 .PP
 Switch tcp_loose mode off, so conntrack will mark out-of-flow
 packets as state INVALID.
 .IP
+.EX
 echo 0 > /proc/sys/net/netfilter/nf_conntrack_tcp_loose
+.EE
 .PP
 Make SYN packets untracked
 .IP
-iptables \-t raw \-A PREROUTING \-i eth0 \-p tcp \-\-dport 80
-    \-\-syn \-j CT \-\-notrack
+.EX
+iptables \-t raw \-A PREROUTING \-i eth0 \-p tcp \-\-dport 80 \-\-syn \-j CT \-\-notrack
+.EE
 .PP
 Catch UNTRACKED (SYN packets) and INVALID (3WHS ACK packets) states
 and send them to SYNPROXY. This rule will respond to SYN packets with
@@ -56,11 +47,13 @@ SYN+ACK syncookies, create ESTABLISHED for valid client response (3WHS ACK
 packets) and drop incorrect cookies. Flags combinations not expected
 during 3WHS will not match and continue (e.g. SYN+FIN, SYN+ACK).
 .IP
-iptables \-A INPUT \-i eth0 \-p tcp \-\-dport 80
-    \-m state \-\-state UNTRACKED,INVALID \-j SYNPROXY
-    \-\-sack\-perm \-\-timestamp \-\-mss 1460 \-\-wscale 9
+.EX
+iptables \-A INPUT \-i eth0 \-p tcp \-\-dport 80 \-m state \-\-state UNTRACKED,INVALID \-j SYNPROXY \-\-sack\-perm \-\-timestamp \-\-mss 1460 \-\-wscale 9
+.EE
 .PP
 Drop invalid packets, this will be out\-of\-flow packets that were not
 matched by SYNPROXY.
 .IP
+.EX
 iptables \-A INPUT \-i eth0 \-p tcp \-\-dport 80 \-m state \-\-state INVALID \-j DROP
+.EE
-- 
2.41.0


--JC663wwgEN02gtaf
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0014-extensions-.man-Escape-dash-in-version-strings.patch"

From 185d7bdbbcea6c51ce6867fd20fdd454bf155ba2 Mon Sep 17 00:00:00 2001
From: Phil Sutter <phil@nwl.cc>
Date: Tue, 24 Oct 2023 18:48:27 +0200
Subject: [iptables PATCH 14/15] extensions: *.man: Escape dash in version
 strings

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_AUDIT.man | 2 +-
 extensions/libxt_DNAT.man  | 2 +-
 extensions/libxt_SNAT.man  | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_AUDIT.man b/extensions/libxt_AUDIT.man
index 8c513d227b88a..7c05915462b84 100644
--- a/extensions/libxt_AUDIT.man
+++ b/extensions/libxt_AUDIT.man
@@ -3,7 +3,7 @@ It can be used to record accepted, dropped, and rejected packets. See
 auditd(8) for additional details.
 .TP
 \fB\-\-type\fP {\fBaccept\fP|\fBdrop\fP|\fBreject\fP}
-Set type of audit record. Starting with linux-4.12, this option has no effect
+Set type of audit record. Starting with linux\-4.12, this option has no effect
 on generated audit messages anymore. It is still accepted by iptables for
 compatibility reasons, but ignored.
 .PP
diff --git a/extensions/libxt_DNAT.man b/extensions/libxt_DNAT.man
index af9a3f06f6aaf..7b80f127fa648 100644
--- a/extensions/libxt_DNAT.man
+++ b/extensions/libxt_DNAT.man
@@ -30,6 +30,6 @@ Randomize source port mapping (kernel >= 2.6.22).
 \fB\-\-persistent\fP
 Gives a client the same source-/destination-address for each connection.
 This supersedes the SAME target. Support for persistent mappings is available
-from 2.6.29-rc2.
+from 2.6.29\-rc2.
 .TP
 IPv6 support available since Linux kernels >= 3.7.
diff --git a/extensions/libxt_SNAT.man b/extensions/libxt_SNAT.man
index d879c8714ec58..dfc678b5d9ceb 100644
--- a/extensions/libxt_SNAT.man
+++ b/extensions/libxt_SNAT.man
@@ -29,9 +29,9 @@ Fully randomize source port mapping through a PRNG (kernel >= 3.14).
 \fB\-\-persistent\fP
 Gives a client the same source-/destination-address for each connection.
 This supersedes the SAME target. Support for persistent mappings is available
-from 2.6.29-rc2.
+from 2.6.29\-rc2.
 .PP
-Kernels prior to 2.6.36-rc1 don't have the ability to
+Kernels prior to 2.6.36\-rc1 don't have the ability to
 .B SNAT
 in the
 .B INPUT
-- 
2.41.0


--JC663wwgEN02gtaf
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0015-extensions-time-Escape-dash-in-time-strings.patch"

From 7f67e07fc76bd98c3e6b5599a5e8b8ad58d0b5c5 Mon Sep 17 00:00:00 2001
From: Phil Sutter <phil@nwl.cc>
Date: Tue, 24 Oct 2023 18:48:46 +0200
Subject: [iptables PATCH 15/15] extensions: time: Escape dash in time strings

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_time.man | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/extensions/libxt_time.man b/extensions/libxt_time.man
index 5b749a484bc8c..9775e6d23415f 100644
--- a/extensions/libxt_time.man
+++ b/extensions/libxt_time.man
@@ -6,10 +6,10 @@ as UTC by default.
 .TP
 \fB\-\-datestop\fP \fIYYYY\fP[\fB\-\fP\fIMM\fP[\fB\-\fP\fIDD\fP[\fBT\fP\fIhh\fP[\fB:\fP\fImm\fP[\fB:\fP\fIss\fP]]]]]
 Only match during the given time, which must be in ISO 8601 "T" notation.
-The possible time range is 1970-01-01T00:00:00 to 2038-01-19T04:17:07.
+The possible time range is 1970\-01\-01T00:00:00 to 2038\-01\-19T04:17:07.
 .IP
-If \-\-datestart or \-\-datestop are not specified, it will default to 1970-01-01
-and 2038-01-19, respectively.
+If \-\-datestart or \-\-datestop are not specified, it will default to
+1970\-01\-01 and 2038\-01\-19, respectively.
 .TP
 \fB\-\-timestart\fP \fIhh\fP\fB:\fP\fImm\fP[\fB:\fP\fIss\fP]
 .TP
-- 
2.41.0


--JC663wwgEN02gtaf--
