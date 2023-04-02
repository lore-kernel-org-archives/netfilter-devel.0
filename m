Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20359C76196
	for <netfilter-devel@archiver.kernel.org>; Sun,  2 Apr 2023 23:32:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbjDBXc1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 2 Apr 2023 19:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjDBXc0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 2 Apr 2023 19:32:26 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B2076BA
        for <netfilter-devel@vger.kernel.org>; Sun,  2 Apr 2023 16:32:23 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 270A93200907;
        Sun,  2 Apr 2023 19:32:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sun, 02 Apr 2023 19:32:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1680478340; x=1680564740; bh=fWcxTLj8wZ
        WGlySC8DKi/i9EFl3+B3mNLJPR+Ir5LoI=; b=PuiiNpTnX43rZLDYCzH+zik0OA
        bceeT/Im577DwEdIuEU2AtbTXvhTcbtB81Qb+Y1jofNXPiyfakRy96S/e+OqUTp/
        pLvIPW2rM1f4g33pMDirhjRN3lpZob0ps2gHAXMeh0UxbG//u0vsUQORy5zHLUgo
        Olbue6DLNrsqgVSe0HZZNtdd20ywKMTi0zP8ZMCkI+iFik5Huf+6f7oMr0bAYmI+
        hf6IOBmry6OTcPsTdM/PzIwlYHCxOnkg8gIU6vIsDVvRtR1YPqHC8+QCgoju3FF1
        nDC/vk071OAY9kJJpZEOP68fC5KpCVq2HUkHGuDjNEpjBipFtigvnGEi2vAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1680478340; x=1680564740; bh=fWcxTLj8wZWGl
        ySC8DKi/i9EFl3+B3mNLJPR+Ir5LoI=; b=IZJ7aLokeXKNUHR48UmN9fPoHi8rz
        1KppJT2sGKoMXcqzx3v/7sQBCvHV61NroMtalfrc9v3CAdw0oTZ1inG/yYnI775Q
        pmkXlIW3XFQvcCVHJTQajlBJ4acvweAloBW2sNv12CfOv9afkccXJbvqxCCeEUjd
        HROzqHqd6bb8nqMudxGCx10bYUW2Lz3duElGFjNCSovd2eqnj/oA5wz/1NvCgLvU
        3/3kf4sRDeRxgLTQM955QE7KK2pKik9ZEPSzIKj5VuILsKlXI7jkDWEXg7UR8fpP
        2bYjRKejh7U/wfI0ngAy1ljVQBkNdH41klSulOoxXAYYrFmE5XWPcJOHw==
X-ME-Sender: <xms:hBAqZDa9tVkFneSYnRO1kuOa2N7vjsreXNJal5SDYtRZsrAZXtQ40w>
    <xme:hBAqZCYwHgRCVuTmYgkNLizcfHWhGrhqbuBuyqiyjKAje87PaS1jkUfZmZDmJihJh
    HLFPkpt49Zo6Qf0hw>
X-ME-Received: <xmr:hBAqZF_8hC5z2yjBTSH5Y_PaVhdNramU1KMxkQtylbXvlqrSZQ2owjXyDpv12i3L-XKjmUIiKI7OB6GoJH-JNpqTAuGf_oM_0A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdeiiedgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomheptehlhihsshgr
    ucftohhsshcuoehhihesrghlhihsshgrrdhisheqnecuggftrfgrthhtvghrnhepheekgf
    dtveettdekuddugeeugfdujeehuefgleegtedthfffudfhheduhfduuefhnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhephhhisegrlhihshhsrg
    drihhs
X-ME-Proxy: <xmx:hBAqZJo61Jflko6q0P9q3InPaOsL5pO9J4h8BUdRSjWqvrw3MajUDw>
    <xmx:hBAqZOoTPyCia6OGGMfGthFKGIoDdCa_Mnv8EdgSQoeqjRvhdBFFbA>
    <xmx:hBAqZPRSXi_lkTH8wKTIZfO_ZGTx3sIQPUZtFPkFVbk3DX02XXkEOg>
    <xmx:hBAqZFSm6zofG6u9NJXqZ8ABlnL5h52ViYAFo8ynBKuNLiHy1dKzSA>
Feedback-ID: i12284293:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 2 Apr 2023 19:32:20 -0400 (EDT)
Received: by x220.qyliss.net (Postfix, from userid 1000)
        id 70C6E262E; Sun,  2 Apr 2023 23:32:17 +0000 (UTC)
From:   Alyssa Ross <hi@alyssa.is>
To:     netfilter-devel@vger.kernel.org
Cc:     Jeremy Sowden <jeremy@azazel.net>, Alyssa Ross <hi@alyssa.is>
Subject: [PATCH iptables v2] build: use pkg-config for libpcap
Date:   Sun,  2 Apr 2023 23:29:40 +0000
Message-Id: <20230402232939.1060151-1-hi@alyssa.is>
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

autoconf will add code to the configure script for initializing
pkg-config the first time it seems PKG_CHECK_MODULES, so make the
libnfnetlink check the first one in the script, so the initialization
code is run unconditionally.

Signed-off-by: Alyssa Ross <hi@alyssa.is>
---
v2: move the conditional PKG_CHECK_MODULES to after the first
    unconditional one, to fix --disable-bpfc --disable-nfsynproxy
    as noticed by Jeremy.

 configure.ac      | 9 +++++----
 utils/Makefile.am | 6 +++---
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/configure.ac b/configure.ac
index bc2ed47b..488c01eb 100644
--- a/configure.ac
+++ b/configure.ac
@@ -113,14 +113,15 @@ AM_CONDITIONAL([ENABLE_SYNCONF], [test "$enable_nfsynproxy" = "yes"])
 AM_CONDITIONAL([ENABLE_NFTABLES], [test "$enable_nftables" = "yes"])
 AM_CONDITIONAL([ENABLE_CONNLABEL], [test "$enable_connlabel" = "yes"])
 
-if test "x$enable_bpfc" = "xyes" || test "x$enable_nfsynproxy" = "xyes"; then
-	AC_CHECK_LIB(pcap, pcap_compile,, AC_MSG_ERROR(missing libpcap library required by bpf compiler or nfsynproxy tool))
-fi
-
 PKG_CHECK_MODULES([libnfnetlink], [libnfnetlink >= 1.0],
 	[nfnetlink=1], [nfnetlink=0])
 AM_CONDITIONAL([HAVE_LIBNFNETLINK], [test "$nfnetlink" = 1])
 
+if test "x$enable_bpfc" = "xyes" || test "x$enable_nfsynproxy" = "xyes"; then
+	PKG_CHECK_MODULES([libpcap], [libpcap], [], [
+		AC_MSG_ERROR(missing libpcap library required by bpf compiler or nfsynproxy tool)])
+fi
+
 if test "x$enable_nftables" = "xyes"; then
 	PKG_CHECK_MODULES([libmnl], [libmnl >= 1.0], [mnl=1], [mnl=0])
 
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

