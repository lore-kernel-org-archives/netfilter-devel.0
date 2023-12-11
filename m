Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="IjAjiozX"
X-Greylist: delayed 1153 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 11 Dec 2023 06:28:11 PST
Received: from azazel.net (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3457BFF
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Dec 2023 06:28:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sND4kHHBAEML1ys4/NsSQ9wmw7OIjgtiOmY7WvWJcNg=; b=IjAjiozXXtx1PLM35IAzqSXQ9S
	bP0pKmcKXjp9G5sMjLtWqp1mVhBaxrRVCM8GxUI/R4ySLmG+ZYNlL9zwV+QWhiNVY7zAFJetLF48Z
	7SV283mfIVoHozPU+KRE+6ZZoncTNE3cDUYlWPTkeC258PhZHSvzjM4GHd4BHVHeTFvt4FQzK8ORF
	EmhoskfGUNlNVnEp2dUBXYyMCmQxM10ntRP//KPlRghdoeb2bADbFRqePwVSuBt7xSkDxkNXC3dxi
	WticbuOiyR6mXc88ymeYUDy7v3yspn2FmzEcQt2at2aqhEvftqAxHn5+ILBX8f/7oM6Kx2VQF4YOf
	fPD0Z9ig==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
	by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1rCgxs-0001Qd-19
	for netfilter-devel@vger.kernel.org;
	Mon, 11 Dec 2023 14:08:56 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH iptables] Fix spelling mistakes
Date: Mon, 11 Dec 2023 14:08:48 +0000
Message-ID: <20231211140848.2960686-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false

Corrections for several spelling mistakes, typo's and non-native usages in
man-pages and error-messages.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/libxt_DNAT.man     | 2 +-
 extensions/libxt_TOS.man      | 2 +-
 extensions/libxt_multiport.c  | 2 +-
 extensions/libxt_set.h        | 4 ++--
 iptables/arptables-nft.8      | 2 +-
 iptables/ebtables-nft.8       | 4 ++--
 iptables/nft-arp.c            | 2 +-
 iptables/xtables-monitor.8.in | 2 +-
 utils/nfnl_osf.8.in           | 2 +-
 9 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/extensions/libxt_DNAT.man b/extensions/libxt_DNAT.man
index af9a3f06f6aa..090ecb42c02a 100644
--- a/extensions/libxt_DNAT.man
+++ b/extensions/libxt_DNAT.man
@@ -19,7 +19,7 @@ If no port range is specified, then the destination port will never be
 modified. If no IP address is specified then only the destination port
 will be modified.
 If \fBbaseport\fP is given, the difference of the original destination port and
-its value is used as offset into the mapping port range. This allows to create
+its value is used as offset into the mapping port range. This allows one to create
 shifted portmap ranges and is available since kernel version 4.18.
 For a single port or \fIbaseport\fP, a service name as listed in
 \fB/etc/services\fP may be used.
diff --git a/extensions/libxt_TOS.man b/extensions/libxt_TOS.man
index de2d22dc5a92..2c8d46940df3 100644
--- a/extensions/libxt_TOS.man
+++ b/extensions/libxt_TOS.man
@@ -32,5 +32,5 @@ longterm releases 2.6.32 (>=.42), 2.6.33 (>=.15), and 2.6.35 (>=.14), there is
 a bug whereby IPv6 TOS mangling does not behave as documented and differs from
 the IPv4 version. The TOS mask indicates the bits one wants to zero out, so it
 needs to be inverted before applying it to the original TOS field. However, the
-aformentioned kernels forgo the inversion which breaks \-\-set\-tos and its
+aforementioned kernels forgo the inversion which breaks \-\-set\-tos and its
 mnemonics.
diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index f3136d8a1ff5..813a35553e2e 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -248,7 +248,7 @@ static void multiport_parse6_v1(struct xt_option_call *cb)
 static void multiport_check(struct xt_fcheck_call *cb)
 {
 	if (cb->xflags == 0)
-		xtables_error(PARAMETER_PROBLEM, "multiport expection an option");
+		xtables_error(PARAMETER_PROBLEM, "no ports specified");
 }
 
 static const char *
diff --git a/extensions/libxt_set.h b/extensions/libxt_set.h
index 685bfab95559..b7de4cc48393 100644
--- a/extensions/libxt_set.h
+++ b/extensions/libxt_set.h
@@ -146,7 +146,7 @@ parse_dirs_v0(const char *opt_arg, struct xt_set_info_v0 *info)
 			info->u.flags[i++] |= IPSET_DST;
 		else
 			xtables_error(PARAMETER_PROBLEM,
-				"You must spefify (the comma separated list of) 'src' or 'dst'.");
+				"You must specify (the comma separated list of) 'src' or 'dst'.");
 	}
 
 	if (tmp)
@@ -170,7 +170,7 @@ parse_dirs(const char *opt_arg, struct xt_set_info *info)
 			info->flags |= (1 << info->dim);
 		else if (strncmp(ptr, "dst", 3) != 0)
 			xtables_error(PARAMETER_PROBLEM,
-				"You must spefify (the comma separated list of) 'src' or 'dst'.");
+				"You must specify (the comma separated list of) 'src' or 'dst'.");
 	}
 
 	if (tmp)
diff --git a/iptables/arptables-nft.8 b/iptables/arptables-nft.8
index 2bee9f2b37d2..c48a2cc2286b 100644
--- a/iptables/arptables-nft.8
+++ b/iptables/arptables-nft.8
@@ -209,7 +209,7 @@ of the
 .B arptables
 kernel table.
 
-.SS MISCELLANOUS COMMANDS
+.SS MISCELLANEOUS COMMANDS
 .TP
 .B "\-V, \-\-version"
 Show the version of the arptables userspace program.
diff --git a/iptables/ebtables-nft.8 b/iptables/ebtables-nft.8
index 60cf2d61793e..301f2f1f9178 100644
--- a/iptables/ebtables-nft.8
+++ b/iptables/ebtables-nft.8
@@ -321,7 +321,7 @@ of the ebtables kernel table.
 .TP
 .B "--init-table"
 Replace the current table data by the initial table data.
-.SS MISCELLANOUS COMMANDS
+.SS MISCELLANEOUS COMMANDS
 .TP
 .B "-v, --verbose"
 Verbose mode.
@@ -812,7 +812,7 @@ The log watcher writes descriptive data about a frame to the syslog.
 .TP
 .B "--log"
 .br
-Log with the default loggin options: log-level=
+Log with the default logging options: log-level=
 .IR info ,
 log-prefix="", no ip logging, no arp logging.
 .TP
diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 6011620cf52a..5d66e271720e 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -529,7 +529,7 @@ static void nft_arp_post_parse(int command,
 
 		if (cs->arp.arp.arhln != 6)
 			xtables_error(PARAMETER_PROBLEM,
-				      "Only harware address length of 6 is supported currently.");
+				      "Only hardware address length of 6 is supported currently.");
 	}
 	if (args->arp_opcode) {
 		if (get16_and_mask(args->arp_opcode, &cs->arp.arp.arpop,
diff --git a/iptables/xtables-monitor.8.in b/iptables/xtables-monitor.8.in
index a7f22c0d8c08..ed2c5fb4f9d1 100644
--- a/iptables/xtables-monitor.8.in
+++ b/iptables/xtables-monitor.8.in
@@ -43,7 +43,7 @@ Restrict output to IPv6.
 .PP
 The first line shows a packet entering rule set evaluation.
 The protocol number is shown (AF_INET in this case), then a packet
-identifier number that allows to correlate messages coming from rule set evaluation of
+identifier number that allows one to correlate messages coming from rule set evaluation of
 this packet.  After this, the rule that was matched by the packet is shown.
 This is the TRACE rule that turns on tracing events for this packet.
 
diff --git a/utils/nfnl_osf.8.in b/utils/nfnl_osf.8.in
index 7ade705a1658..1ef0c3873308 100644
--- a/utils/nfnl_osf.8.in
+++ b/utils/nfnl_osf.8.in
@@ -16,7 +16,7 @@ nfnl_osf \(em OS fingerprint loader utility
 .SH DESCRIPTION
 The
 .B nfnl_osf
-utility allows to load a set of operating system signatures into the kernel for
+utility allows one to load a set of operating system signatures into the kernel for
 later matching against using iptables'
 .B osf
 match.
-- 
2.42.0

