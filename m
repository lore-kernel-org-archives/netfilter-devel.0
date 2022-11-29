Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B25C9C4708E
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Nov 2022 21:48:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237027AbiK2VsD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:48:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237053AbiK2VsC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2022 16:48:02 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0610D64566
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2022 13:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7xpPga0HslgUhSwPU2dE+FYHACNRGMh4x81kni2XThA=; b=h7RFCE+SpkIglfJplk8WSvXXkb
        5J3rTOPpG3dQrmjE1QksKQ3AuaiL79Ep+NeJakgbKjkIdkJoA1cq0Bu1IPR1Iib/QCYCvohxfV2Sf
        S/TrYftvKWecyd3kfmr8YlSpOPSrXK2GIUdBJqhq9gfG7nwE1WItocSheRvhY3JGEKWJIEw6wpaKm
        pf1gR3j7uAHEiPL20hJnkcIFRXeWvqQ5qaMT1fJHMRujf2MZA/oYx190suhbAvQCXNR+iYd77QCwL
        zsgo8hvQ5+n5IWRyZJPArGaSqUWp6E9jlXc72YE5qFVL9HSdSiGbqbEuJgjul6o/2hgUjoKHByvYB
        5J+YmbPQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1p08SJ-00DjQp-2m
        for netfilter-devel@vger.kernel.org; Tue, 29 Nov 2022 21:47:55 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 v2 v2 05/34] build: add checks to configure.ac
Date:   Tue, 29 Nov 2022 21:47:20 +0000
Message-Id: <20221129214749.247878-6-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221129214749.247878-1-jeremy@azazel.net>
References: <20221129214749.247878-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Autoscan complains about a number of missing function, header and type
checks.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac | 47 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 3 deletions(-)

diff --git a/configure.ac b/configure.ac
index 6ee29ce321d0..07c45cfb7b27 100644
--- a/configure.ac
+++ b/configure.ac
@@ -22,17 +22,58 @@ AC_SUBST([libdl_LIBS])
 
 dnl Checks for header files.
 AC_HEADER_DIRENT
-AC_CHECK_HEADERS([fcntl.h unistd.h])
+AC_CHECK_HEADER_STDBOOL
+AC_CHECK_HEADERS([arpa/inet.h  \
+                  fcntl.h      \
+                  inttypes.h   \
+                  netdb.h      \
+                  netinet/in.h \
+                  stdint.h     \
+                  sys/param.h  \
+                  sys/socket.h \
+                  sys/time.h   \
+                  syslog.h     \
+                  unistd.h])
 
 dnl Checks for typedefs, structures, and compiler characteristics.
 AC_C_CONST
-AC_TYPE_SIZE_T
+AC_C_INLINE
 AC_STRUCT_TM
 AC_SYS_LARGEFILE
+AC_TYPE_INT8_T
+AC_TYPE_INT16_T
+AC_TYPE_INT32_T
+AC_TYPE_INT64_T
+AC_TYPE_PID_T
+AC_TYPE_SIZE_T
+AC_TYPE_SSIZE_T
+AC_TYPE_UID_T
+AC_TYPE_UINT8_T
+AC_TYPE_UINT16_T
+AC_TYPE_UINT32_T
+AC_TYPE_UINT64_T
 
 dnl Checks for library functions.
+AC_FUNC_CHOWN
+AC_FUNC_MALLOC
+AC_FUNC_REALLOC
 AC_FUNC_VPRINTF
-AC_CHECK_FUNCS([socket strerror])
+AC_CHECK_FUNCS([alarm        \
+                ftruncate    \
+                gethostname  \
+                gettimeofday \
+                localtime_r  \
+                memmove      \
+                memset       \
+                select       \
+                socket       \
+                strcasecmp   \
+                strchr       \
+                strdup       \
+                strerror     \
+                strncasecmp  \
+                strndup      \
+                strtoul])
 
 AC_SEARCH_LIBS([pthread_create], [pthread], [libpthread_LIBS="$LIBS"; LIBS=""])
 AC_SUBST([libpthread_LIBS])
-- 
2.35.1

