Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F249C761A6
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Mar 2023 22:36:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbjCaWgM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 Mar 2023 18:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjCaWgL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 Mar 2023 18:36:11 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627DE2032E
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Mar 2023 15:36:08 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 1122F32007BE
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Mar 2023 18:36:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Fri, 31 Mar 2023 18:36:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1680302164; x=1680388564; bh=1Sb7gLz35S
        xydsOkDbTh7S088c6astAo5R3/8pz2+Gw=; b=ZXNaST5kxP4SUqVEzpK5vRCZLd
        cMS9QpcodqbP3dE9PuVszxROwLLDinhks81eJjLzYYZQMdkE0fO+0KS8aYbGGpom
        SrgIRcPXeIGcTeKLtaxUyr2KdVGOMQCiqDPUUK/8dVtirByKRI2AejKFBXTckZsk
        D6wufIlgn0omjOUOhmuvhdRrbYSp1O/1lA5l+ejOgol4zndk9TUN19MxX33RB5ig
        KBa0OX12e41ZoDlBC/CQIE87wJXd6Gkrs4QJSvFQSdmezTXMZ8lxwIi61X543DuN
        NuQy999Qh+MUPLKlNJvP5HMC4OhvEWlE8DSCRjLt8sH/NRivvOwdiDrKHsFA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1680302164; x=1680388564; bh=1Sb7gLz35Sxyd
        sOkDbTh7S088c6astAo5R3/8pz2+Gw=; b=mI1ewSex7V9b/IAhlTGZupezk9iES
        rB/kNcDUk5G/MOE1BVNtbYgvHli7tWsiDqyWwHWujyEl4YDG5dynnQiiJ5gHKPh4
        Wb0b0VNksRIHI1uKmwQiWhf/B5OtaP0+FQ67MYYwWVkVRh0HGPuGyAzz+zpiTdtP
        wVXyj4pnVaYnv1ZIUACTa8I2uoX3GgX/Rm57mrsyOWLED8saYsG2JWVG+0df9GM/
        z8n5XmesT2YuFki9mjnqnbQZdi+KyzpE5MROwg0PflWeOGWMX3DddEiRAHGJOQ8c
        3VhgzoUHWNpOOEWm4ZM5/uSlhk+GoTXdVq31ikOqD01cD3INB/7Yxht0w==
X-ME-Sender: <xms:VGAnZIWAvStlUG5Ce42eRGTAI8xJez6yRcZsdt76LxZ_aJgPdrFiZw>
    <xme:VGAnZMlSufmRGua91kC9GoO5wODBMZ6o7HGBqJ3IXZLcuDNMaQvDXZijXjPSM9bOS
    u5p2IdUj8aLK1Dc_g>
X-ME-Received: <xmr:VGAnZMYt9WqDXoo61dIyyyn84FmOX6OVTHBg3hYtwsBkAD6oeiAfGX92utw9bo_Fp0NCNnSntR1S1ZUiWVZMx88o1vjXakiKzQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdeivddgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpeetlhihshhsrgcutfhoshhsuceohhhisegrlhihshhsrgdrihhs
    qeenucggtffrrghtthgvrhhnpeehkefgtdevtedtkeduudeguefgudejheeugfelgeettd
    fhffduhfehudfhudeuhfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehhihesrghlhihsshgrrdhish
X-ME-Proxy: <xmx:VGAnZHXN7_z7IJSTyIJn10pGr27JA8b7Wqm0liqkSIin6ie4G_U0Nw>
    <xmx:VGAnZCld0T5ejrAAwDQb0P3SB5EFpnK47vSnJsJ-Og3DkLI1Wh8ifw>
    <xmx:VGAnZMccisnvE_Fc8Xbaq6O_8KNLU8hl8vDQYdD4D85yzKVgrCJu2g>
    <xmx:VGAnZMS1H4nQltQRD5fSpGpZFZCzHqs98qtivIkG4wouLAwRzsfv1Q>
Feedback-ID: i12284293:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <netfilter-devel@vger.kernel.org>; Fri,
 31 Mar 2023 18:36:04 -0400 (EDT)
Received: by x220.qyliss.net (Postfix, from userid 1000)
        id 3EF4825FE; Fri, 31 Mar 2023 22:36:02 +0000 (UTC)
From:   Alyssa Ross <hi@alyssa.is>
To:     netfilter-devel@vger.kernel.org
Cc:     Alyssa Ross <hi@alyssa.is>
Subject: [PATCH iptables] build: use pkg-config for libpcap
Date:   Fri, 31 Mar 2023 22:36:01 +0000
Message-Id: <20230331223601.315215-1-hi@alyssa.is>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If building statically, with libpcap built with libnl support, linking
will fail, as the compiler won't be able to find the libnl symbols
since static libraries don't contain dependency information.  To fix
this, use pkg-config to find the flags for linking libpcap, since the
pkg-config files contain the neccesary dependency information.

Signed-off-by: Alyssa Ross <hi@alyssa.is>
---
 configure.ac      | 3 ++-
 utils/Makefile.am | 6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/configure.ac b/configure.ac
index bc2ed47b..e0bb26aa 100644
--- a/configure.ac
+++ b/configure.ac
@@ -114,7 +114,8 @@ AM_CONDITIONAL([ENABLE_NFTABLES], [test "$enable_nftables" = "yes"])
 AM_CONDITIONAL([ENABLE_CONNLABEL], [test "$enable_connlabel" = "yes"])
 
 if test "x$enable_bpfc" = "xyes" || test "x$enable_nfsynproxy" = "xyes"; then
-	AC_CHECK_LIB(pcap, pcap_compile,, AC_MSG_ERROR(missing libpcap library required by bpf compiler or nfsynproxy tool))
+	PKG_CHECK_MODULES([libpcap], [libpcap], [], [
+		AC_MSG_ERROR(missing libpcap library required by bpf compiler or nfsynproxy tool)])
 fi
 
 PKG_CHECK_MODULES([libnfnetlink], [libnfnetlink >= 1.0],
diff --git a/utils/Makefile.am b/utils/Makefile.am
index e9eec48f..34056514 100644
--- a/utils/Makefile.am
+++ b/utils/Makefile.am
@@ -2,7 +2,7 @@
 
 AM_CFLAGS = ${regular_CFLAGS}
 AM_CPPFLAGS = ${regular_CPPFLAGS} -I${top_builddir}/include \
-              -I${top_srcdir}/include ${libnfnetlink_CFLAGS}
+              -I${top_srcdir}/include ${libnfnetlink_CFLAGS} ${libpcap_CFLAGS}
 AM_LDFLAGS = ${regular_LDFLAGS}
 
 sbin_PROGRAMS =
@@ -25,12 +25,12 @@ endif
 if ENABLE_BPFC
 man_MANS += nfbpf_compile.8
 sbin_PROGRAMS += nfbpf_compile
-nfbpf_compile_LDADD = -lpcap
+nfbpf_compile_LDADD = ${libpcap_LIBS}
 endif
 
 if ENABLE_SYNCONF
 sbin_PROGRAMS += nfsynproxy
-nfsynproxy_LDADD = -lpcap
+nfsynproxy_LDADD = ${libpcap_LIBS}
 endif
 
 CLEANFILES = nfnl_osf.8 nfbpf_compile.8

base-commit: 09f0bfe2032454d21e3650e7ac75c4dc53f3c881
-- 
2.37.1

