Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6189DC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Jun 2022 17:10:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbiF2RKD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Jun 2022 13:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbiF2RKC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Jun 2022 13:10:02 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F26F1057F
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jun 2022 10:10:00 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id k20so1704056edj.13
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jun 2022 10:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yzTRyN2EjetyKIbKQwgHWDtZKYNTC9gOBnknIxBDlig=;
        b=evozWzbmVN4bNZdJaQgK2yI94NExlf0263XErw55/nMvaD3bBIfekeQz/X+GdNKzI8
         yaKEXClPEht0deyLRquGAa51g7s/BzrK2+CcabzUuxPitVUV0aVI5G2VDMVMz/q+k1wb
         0vbWMr/aMyCQvAOz7uupP1Y69OZ7QF5dI6FxVZrZCY8cGt7lUPNPghESdd3vhC6E0j1Q
         fHN3F4bnguZ7ast4v2vPdvZYX4znm0CthwTpqFHZajSLqv1rzXAI4CR0X/INIxrfW//Q
         rrdY5RJbG1ACAelIgbfGqVYEPaB0KWhi19NVghNznWZPSa3ng80lEY20xRpq8oq6k7h9
         PpUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yzTRyN2EjetyKIbKQwgHWDtZKYNTC9gOBnknIxBDlig=;
        b=VbD2Ace1GwEEZuPIrcbCzXeinecDnWBm0h81OGCYzcXYYNV/sZTxpeRl/XoDASbbBo
         oVImvAYafPadq2HAFsLf0q68OA+ZyKYpk2e0MvZZZ++Zd+utRSy6U7srorJmI6MPD/9q
         ohyJZ5TXIjdG0NZFq0Y4EupVobp2+oMsUfSinp8PD5okoD6JvCHaW8gW2L/l6Nhy6ZOI
         rdMwJeutSqz7ExZJh/JWc49nG0jpZH7pvp9pwTF06ZgdhNYLvnC7hopIwLiut0D2anoQ
         EhlAmkhgp5WJAAgTUOB5B7tlPhc/xutFVyGbrGxdoEvPO53Z15QYroZtsyx5HHtV4xcp
         uTsA==
X-Gm-Message-State: AJIora+lPPCDVi+fYS7OYICCpEPY2at2HbZBlsikk0DIGQLvKFnO/xeJ
        psY+nG7q7aB7rqSDi2Y8j9tLfKkqyoULcQ==
X-Google-Smtp-Source: AGRyM1uy4fXUP0/AQ7XcKC6U8zkmBvKEPoYsUMqcZ1jDRfySm+7zTRlxdY9wDCRNTSr3ovYTrR7Hww==
X-Received: by 2002:a05:6402:2554:b0:435:a3fb:9ab4 with SMTP id l20-20020a056402255400b00435a3fb9ab4mr5583924edb.5.1656522597459;
        Wed, 29 Jun 2022 10:09:57 -0700 (PDT)
Received: from msennikovskii4.fkb.profitbricks.net ([85.214.13.132])
        by smtp.gmail.com with ESMTPSA id s6-20020a1709062ec600b00711d88ae162sm8008829eji.24.2022.06.29.10.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 10:09:56 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovsky@gmail.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH v2 2/3] conntrack: use C99 initializer syntax for opts map
Date:   Wed, 29 Jun 2022 19:09:40 +0200
Message-Id: <20220629170941.46219-3-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220629170941.46219-1-mikhail.sennikovskii@ionos.com>
References: <20220629170941.46219-1-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The old way of the commands_v_options initialization made it more
difficult and error-prone to add a map for a new command, because one
would have to calculate a proper "index" for the initializer and fill
the gap with zeros.

As a preparation step for adding the new "-A" command support,
switch to C99 initializer syntax for commands_v_options.

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
---
 extensions/libct_proto_dccp.c    |  32 +++++-----
 extensions/libct_proto_gre.c     |  32 +++++-----
 extensions/libct_proto_icmp.c    |  32 +++++-----
 extensions/libct_proto_icmpv6.c  |  32 +++++-----
 extensions/libct_proto_sctp.c    |  32 +++++-----
 extensions/libct_proto_tcp.c     |  32 +++++-----
 extensions/libct_proto_udp.c     |  32 +++++-----
 extensions/libct_proto_udplite.c |  32 +++++-----
 include/conntrack.h              |  65 +++++++++++++++++++-
 src/conntrack.c                  | 102 ++++++-------------------------
 10 files changed, 212 insertions(+), 211 deletions(-)

diff --git a/extensions/libct_proto_dccp.c b/extensions/libct_proto_dccp.c
index e9da474..6103117 100644
--- a/extensions/libct_proto_dccp.c
+++ b/extensions/libct_proto_dccp.c
@@ -67,22 +67,22 @@ static const char *dccp_optflags[DCCP_OPT_MAX] = {
 static char dccp_commands_v_options[NUMBER_OF_CMD][DCCP_OPT_MAX] =
 /* Well, it's better than "Re: Sevilla vs Betis" */
 {
-	    	/* 1 2 3 4 5 6 7 8 9 10*/
-/*CT_LIST*/   	  {2,2,2,2,0,0,2,0,0,0},
-/*CT_CREATE*/	  {3,3,3,3,0,0,1,0,0,1},
-/*CT_UPDATE*/	  {2,2,2,2,0,0,2,0,0,0},
-/*CT_DELETE*/	  {2,2,2,2,0,0,2,0,0,0},
-/*CT_GET*/	  {3,3,3,3,0,0,2,0,0,0},
-/*CT_FLUSH*/	  {0,0,0,0,0,0,0,0,0,0},
-/*CT_EVENT*/	  {2,2,2,2,0,0,2,0,0,0},
-/*CT_VERSION*/	  {0,0,0,0,0,0,0,0,0,0},
-/*CT_HELP*/	  {0,0,0,0,0,0,0,0,0,0},
-/*EXP_LIST*/	  {0,0,0,0,0,0,0,0,0,0},
-/*EXP_CREATE*/	  {1,1,0,0,1,1,0,1,1,1},
-/*EXP_DELETE*/	  {1,1,1,1,0,0,0,0,0,0},
-/*EXP_GET*/	  {1,1,1,1,0,0,0,0,0,0},
-/*EXP_FLUSH*/	  {0,0,0,0,0,0,0,0,0,0},
-/*EXP_EVENT*/	  {0,0,0,0,0,0,0,0,0,0},
+				/* 1 2 3 4 5 6 7 8 9 10 */
+	[CT_LIST_BIT]		= {2,2,2,2,0,0,2,0,0,0},
+	[CT_CREATE_BIT]		= {3,3,3,3,0,0,1,0,0,1},
+	[CT_UPDATE_BIT]		= {2,2,2,2,0,0,2,0,0,0},
+	[CT_DELETE_BIT]		= {2,2,2,2,0,0,2,0,0,0},
+	[CT_GET_BIT]		= {3,3,3,3,0,0,2,0,0,0},
+	[CT_FLUSH_BIT]		= {0,0,0,0,0,0,0,0,0,0},
+	[CT_EVENT_BIT]		= {2,2,2,2,0,0,2,0,0,0},
+	[CT_VERSION_BIT]	= {0,0,0,0,0,0,0,0,0,0},
+	[CT_HELP_BIT]		= {0,0,0,0,0,0,0,0,0,0},
+	[EXP_LIST_BIT]		= {0,0,0,0,0,0,0,0,0,0},
+	[EXP_CREATE_BIT]	= {1,1,0,0,1,1,0,1,1,1},
+	[EXP_DELETE_BIT]	= {1,1,1,1,0,0,0,0,0,0},
+	[EXP_GET_BIT]		= {1,1,1,1,0,0,0,0,0,0},
+	[EXP_FLUSH_BIT]		= {0,0,0,0,0,0,0,0,0,0},
+	[EXP_EVENT_BIT]		= {0,0,0,0,0,0,0,0,0,0},
 };
 
 static const char *dccp_states[DCCP_CONNTRACK_MAX] = {
diff --git a/extensions/libct_proto_gre.c b/extensions/libct_proto_gre.c
index a36d111..c619db3 100644
--- a/extensions/libct_proto_gre.c
+++ b/extensions/libct_proto_gre.c
@@ -66,22 +66,22 @@ static void help(void)
 
 static char gre_commands_v_options[NUMBER_OF_CMD][GRE_OPT_MAX] =
 {
-		/* 1 2 3 4 5 6 7 8 */
-/*CT_LIST*/	  {2,2,2,2,0,0,0,0},
-/*CT_CREATE*/	  {3,3,3,3,0,0,0,0},
-/*CT_UPDATE*/	  {2,2,2,2,0,0,0,0},
-/*CT_DELETE*/	  {2,2,2,2,0,0,0,0},
-/*CT_GET*/	  {3,3,3,3,0,0,0,0},
-/*CT_FLUSH*/	  {0,0,0,0,0,0,0,0},
-/*CT_EVENT*/	  {2,2,2,2,0,0,0,0},
-/*CT_VERSION*/	  {0,0,0,0,0,0,0,0},
-/*CT_HELP*/	  {0,0,0,0,0,0,0,0},
-/*EXP_LIST*/	  {0,0,0,0,0,0,0,0},
-/*EXP_CREATE*/	  {1,1,1,1,1,1,1,1},
-/*EXP_DELETE*/	  {1,1,1,1,0,0,0,0},
-/*EXP_GET*/	  {1,1,1,1,0,0,0,0},
-/*EXP_FLUSH*/	  {0,0,0,0,0,0,0,0},
-/*EXP_EVENT*/	  {0,0,0,0,0,0,0,0},
+				/* 1 2 3 4 5 6 7 8 */
+	[CT_LIST_BIT]		= {2,2,2,2,0,0,0,0},
+	[CT_CREATE_BIT]		= {3,3,3,3,0,0,0,0},
+	[CT_UPDATE_BIT]		= {2,2,2,2,0,0,0,0},
+	[CT_DELETE_BIT]		= {2,2,2,2,0,0,0,0},
+	[CT_GET_BIT]		= {3,3,3,3,0,0,0,0},
+	[CT_FLUSH_BIT]		= {0,0,0,0,0,0,0,0},
+	[CT_EVENT_BIT]		= {2,2,2,2,0,0,0,0},
+	[CT_VERSION_BIT]	= {0,0,0,0,0,0,0,0},
+	[CT_HELP_BIT]		= {0,0,0,0,0,0,0,0},
+	[EXP_LIST_BIT]		= {0,0,0,0,0,0,0,0},
+	[EXP_CREATE_BIT]	= {1,1,1,1,1,1,1,1},
+	[EXP_DELETE_BIT]	= {1,1,1,1,0,0,0,0},
+	[EXP_GET_BIT]		= {1,1,1,1,0,0,0,0},
+	[EXP_FLUSH_BIT]		= {0,0,0,0,0,0,0,0},
+	[EXP_EVENT_BIT]		= {0,0,0,0,0,0,0,0},
 };
 
 static int parse_options(char c,
diff --git a/extensions/libct_proto_icmp.c b/extensions/libct_proto_icmp.c
index ec52c39..304018f 100644
--- a/extensions/libct_proto_icmp.c
+++ b/extensions/libct_proto_icmp.c
@@ -40,22 +40,22 @@ static const char *icmp_optflags[ICMP_NUMBER_OF_OPT] = {
 static char icmp_commands_v_options[NUMBER_OF_CMD][ICMP_NUMBER_OF_OPT] =
 /* Well, it's better than "Re: Maradona vs Pele" */
 {
-		/* 1 2 3 */
-/*CT_LIST*/	  {2,2,2},
-/*CT_CREATE*/	  {1,1,2},
-/*CT_UPDATE*/	  {2,2,2},
-/*CT_DELETE*/	  {2,2,2},
-/*CT_GET*/	  {1,1,2},
-/*CT_FLUSH*/	  {0,0,0},
-/*CT_EVENT*/	  {2,2,2},
-/*CT_VERSION*/	  {0,0,0},
-/*CT_HELP*/	  {0,0,0},
-/*EXP_LIST*/	  {0,0,0},
-/*EXP_CREATE*/	  {0,0,0},
-/*EXP_DELETE*/	  {0,0,0},
-/*EXP_GET*/	  {0,0,0},
-/*EXP_FLUSH*/	  {0,0,0},
-/*EXP_EVENT*/	  {0,0,0},
+				/* 1 2 3 */
+	[CT_LIST_BIT]		= {2,2,2},
+	[CT_CREATE_BIT]		= {1,1,2},
+	[CT_UPDATE_BIT]		= {2,2,2},
+	[CT_DELETE_BIT]		= {2,2,2},
+	[CT_GET_BIT]		= {1,1,2},
+	[CT_FLUSH_BIT]		= {0,0,0},
+	[CT_EVENT_BIT]		= {2,2,2},
+	[CT_VERSION_BIT]	= {0,0,0},
+	[CT_HELP_BIT]		= {0,0,0},
+	[EXP_LIST_BIT]		= {0,0,0},
+	[EXP_CREATE_BIT]	= {0,0,0},
+	[EXP_DELETE_BIT]	= {0,0,0},
+	[EXP_GET_BIT]		= {0,0,0},
+	[EXP_FLUSH_BIT]		= {0,0,0},
+	[EXP_EVENT_BIT]		= {0,0,0},
 };
 
 static void help(void)
diff --git a/extensions/libct_proto_icmpv6.c b/extensions/libct_proto_icmpv6.c
index fe16a1d..114bcac 100644
--- a/extensions/libct_proto_icmpv6.c
+++ b/extensions/libct_proto_icmpv6.c
@@ -43,22 +43,22 @@ static const char *icmpv6_optflags[ICMPV6_NUMBER_OF_OPT] = {
 static char icmpv6_commands_v_options[NUMBER_OF_CMD][ICMPV6_NUMBER_OF_OPT] =
 /* Well, it's better than "Re: Maradona vs Pele" */
 {
-		/* 1 2 3 */
-/*CT_LIST*/	  {2,2,2},
-/*CT_CREATE*/	  {1,1,2},
-/*CT_UPDATE*/	  {2,2,2},
-/*CT_DELETE*/	  {2,2,2},
-/*CT_GET*/	  {1,1,2},
-/*CT_FLUSH*/	  {0,0,0},
-/*CT_EVENT*/	  {2,2,2},
-/*CT_VERSION*/	  {0,0,0},
-/*CT_HELP*/	  {0,0,0},
-/*EXP_LIST*/	  {0,0,0},
-/*EXP_CREATE*/	  {0,0,0},
-/*EXP_DELETE*/	  {0,0,0},
-/*EXP_GET*/	  {0,0,0},
-/*EXP_FLUSH*/	  {0,0,0},
-/*EXP_EVENT*/	  {0,0,0},
+				/* 1 2 3 */
+	[CT_LIST_BIT]		= {2,2,2},
+	[CT_CREATE_BIT]		= {1,1,2},
+	[CT_UPDATE_BIT]		= {2,2,2},
+	[CT_DELETE_BIT]		= {2,2,2},
+	[CT_GET_BIT]		= {1,1,2},
+	[CT_FLUSH_BIT]		= {0,0,0},
+	[CT_EVENT_BIT]		= {2,2,2},
+	[CT_VERSION_BIT]	= {0,0,0},
+	[CT_HELP_BIT]		= {0,0,0},
+	[EXP_LIST_BIT]		= {0,0,0},
+	[EXP_CREATE_BIT]	= {0,0,0},
+	[EXP_DELETE_BIT]	= {0,0,0},
+	[EXP_GET_BIT]		= {0,0,0},
+	[EXP_FLUSH_BIT]		= {0,0,0},
+	[EXP_EVENT_BIT]		= {0,0,0},
 };
 
 static void help(void)
diff --git a/extensions/libct_proto_sctp.c b/extensions/libct_proto_sctp.c
index a58ccde..723a2cd 100644
--- a/extensions/libct_proto_sctp.c
+++ b/extensions/libct_proto_sctp.c
@@ -70,22 +70,22 @@ static const char *sctp_optflags[SCTP_OPT_MAX] = {
 static char sctp_commands_v_options[NUMBER_OF_CMD][SCTP_OPT_MAX] =
 /* Well, it's better than "Re: Sevilla vs Betis" */
 {
-	    	/* 1 2 3 4 5 6 7 8 9 10 11*/
-/*CT_LIST*/   	  {2,2,2,2,0,0,2,0,0,0,0},
-/*CT_CREATE*/	  {3,3,3,3,0,0,1,0,0,1,1},
-/*CT_UPDATE*/	  {2,2,2,2,0,0,2,0,0,2,2},
-/*CT_DELETE*/	  {2,2,2,2,0,0,2,0,0,0,0},
-/*CT_GET*/	  {3,3,3,3,0,0,2,0,0,2,2},
-/*CT_FLUSH*/	  {0,0,0,0,0,0,0,0,0,0,0},
-/*CT_EVENT*/	  {2,2,2,2,0,0,2,0,0,0,0},
-/*CT_VERSION*/	  {0,0,0,0,0,0,0,0,0,0,0},
-/*CT_HELP*/	  {0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_LIST*/	  {0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_CREATE*/	  {1,1,0,0,1,1,0,1,1,1,1},
-/*EXP_DELETE*/	  {1,1,1,1,0,0,0,0,0,0,0},
-/*EXP_GET*/	  {1,1,1,1,0,0,0,0,0,0,0},
-/*EXP_FLUSH*/	  {0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_EVENT*/	  {0,0,0,0,0,0,0,0,0,0,0},
+				/* 1 2 3 4 5 6 7 8 9 10 11 */
+	[CT_LIST_BIT]		= {2,2,2,2,0,0,2,0,0,0,0},
+	[CT_CREATE_BIT]		= {3,3,3,3,0,0,1,0,0,1,1},
+	[CT_UPDATE_BIT]		= {2,2,2,2,0,0,2,0,0,2,2},
+	[CT_DELETE_BIT]		= {2,2,2,2,0,0,2,0,0,0,0},
+	[CT_GET_BIT]		= {3,3,3,3,0,0,2,0,0,2,2},
+	[CT_FLUSH_BIT]		= {0,0,0,0,0,0,0,0,0,0,0},
+	[CT_EVENT_BIT]		= {2,2,2,2,0,0,2,0,0,0,0},
+	[CT_VERSION_BIT]	= {0,0,0,0,0,0,0,0,0,0,0},
+	[CT_HELP_BIT]		= {0,0,0,0,0,0,0,0,0,0,0},
+	[EXP_LIST_BIT]		= {0,0,0,0,0,0,0,0,0,0,0},
+	[EXP_CREATE_BIT]	= {1,1,0,0,1,1,0,1,1,1,1},
+	[EXP_DELETE_BIT]	= {1,1,1,1,0,0,0,0,0,0,0},
+	[EXP_GET_BIT]		= {1,1,1,1,0,0,0,0,0,0,0},
+	[EXP_FLUSH_BIT]		= {0,0,0,0,0,0,0,0,0,0,0},
+	[EXP_EVENT_BIT]		= {0,0,0,0,0,0,0,0,0,0,0},
 };
 
 static const char *sctp_states[SCTP_CONNTRACK_MAX] = {
diff --git a/extensions/libct_proto_tcp.c b/extensions/libct_proto_tcp.c
index 3da0dc6..7e4500c 100644
--- a/extensions/libct_proto_tcp.c
+++ b/extensions/libct_proto_tcp.c
@@ -54,22 +54,22 @@ static const char *tcp_optflags[TCP_NUMBER_OF_OPT] = {
 static char tcp_commands_v_options[NUMBER_OF_CMD][TCP_NUMBER_OF_OPT] =
 /* Well, it's better than "Re: Sevilla vs Betis" */
 {
-	    	/* 1 2 3 4 5 6 7 8 9 */
-/*CT_LIST*/   	  {2,2,2,2,0,0,2,0,0},
-/*CT_CREATE*/	  {3,3,3,3,0,0,1,0,0},
-/*CT_UPDATE*/	  {2,2,2,2,0,0,2,0,0},
-/*CT_DELETE*/	  {2,2,2,2,0,0,2,0,0},
-/*CT_GET*/	  {3,3,3,3,0,0,2,0,0},
-/*CT_FLUSH*/	  {0,0,0,0,0,0,0,0,0},
-/*CT_EVENT*/	  {2,2,2,2,0,0,2,0,0},
-/*CT_VERSION*/	  {0,0,0,0,0,0,0,0,0},
-/*CT_HELP*/	  {0,0,0,0,0,0,0,0,0},
-/*EXP_LIST*/	  {0,0,0,0,0,0,0,0,0},
-/*EXP_CREATE*/	  {1,1,0,0,1,1,0,1,1},
-/*EXP_DELETE*/	  {1,1,1,1,0,0,0,0,0},
-/*EXP_GET*/	  {1,1,1,1,0,0,0,0,0},
-/*EXP_FLUSH*/	  {0,0,0,0,0,0,0,0,0},
-/*EXP_EVENT*/	  {0,0,0,0,0,0,0,0,0},
+				/* 1 2 3 4 5 6 7 8 9 */
+	[CT_LIST_BIT]		= {2,2,2,2,0,0,2,0,0},
+	[CT_CREATE_BIT]		= {3,3,3,3,0,0,1,0,0},
+	[CT_UPDATE_BIT]		= {2,2,2,2,0,0,2,0,0},
+	[CT_DELETE_BIT]		= {2,2,2,2,0,0,2,0,0},
+	[CT_GET_BIT]		= {3,3,3,3,0,0,2,0,0},
+	[CT_FLUSH_BIT]		= {0,0,0,0,0,0,0,0,0},
+	[CT_EVENT_BIT]		= {2,2,2,2,0,0,2,0,0},
+	[CT_VERSION_BIT]	= {0,0,0,0,0,0,0,0,0},
+	[CT_HELP_BIT]		= {0,0,0,0,0,0,0,0,0},
+	[EXP_LIST_BIT]		= {0,0,0,0,0,0,0,0,0},
+	[EXP_CREATE_BIT]	= {1,1,0,0,1,1,0,1,1},
+	[EXP_DELETE_BIT]	= {1,1,1,1,0,0,0,0,0},
+	[EXP_GET_BIT]		= {1,1,1,1,0,0,0,0,0},
+	[EXP_FLUSH_BIT]		= {0,0,0,0,0,0,0,0,0},
+	[EXP_EVENT_BIT]		= {0,0,0,0,0,0,0,0,0},
 };
 
 static const char *tcp_states[TCP_CONNTRACK_MAX] = {
diff --git a/extensions/libct_proto_udp.c b/extensions/libct_proto_udp.c
index fe43548..fce489d 100644
--- a/extensions/libct_proto_udp.c
+++ b/extensions/libct_proto_udp.c
@@ -62,22 +62,22 @@ static void help(void)
 static char udp_commands_v_options[NUMBER_OF_CMD][UDP_NUMBER_OF_OPT] =
 /* Well, it's better than "Re: Galeano vs Vargas Llosa" */
 {
-		/* 1 2 3 4 5 6 7 8 */
-/*CT_LIST*/	  {2,2,2,2,0,0,0,0},
-/*CT_CREATE*/     {3,3,3,3,0,0,0,0},
-/*CT_UPDATE*/     {2,2,2,2,0,0,0,0},
-/*CT_DELETE*/     {2,2,2,2,0,0,0,0},
-/*CT_GET*/        {3,3,3,3,0,0,0,0},
-/*CT_FLUSH*/      {0,0,0,0,0,0,0,0},
-/*CT_EVENT*/      {2,2,2,2,0,0,0,0},
-/*CT_VERSION*/    {0,0,0,0,0,0,0,0},
-/*CT_HELP*/       {0,0,0,0,0,0,0,0},
-/*EXP_LIST*/      {0,0,0,0,0,0,0,0},
-/*EXP_CREATE*/    {1,1,0,0,1,1,1,1},
-/*EXP_DELETE*/    {1,1,1,1,0,0,0,0},
-/*EXP_GET*/       {1,1,1,1,0,0,0,0},
-/*EXP_FLUSH*/     {0,0,0,0,0,0,0,0},
-/*EXP_EVENT*/     {0,0,0,0,0,0,0,0},
+				/* 1 2 3 4 5 6 7 8 */
+	[CT_LIST_BIT]		= {2,2,2,2,0,0,0,0},
+	[CT_CREATE_BIT]		= {3,3,3,3,0,0,0,0},
+	[CT_UPDATE_BIT]		= {2,2,2,2,0,0,0,0},
+	[CT_DELETE_BIT]		= {2,2,2,2,0,0,0,0},
+	[CT_GET_BIT]		= {3,3,3,3,0,0,0,0},
+	[CT_FLUSH_BIT]		= {0,0,0,0,0,0,0,0},
+	[CT_EVENT_BIT]		= {2,2,2,2,0,0,0,0},
+	[CT_VERSION_BIT]	= {0,0,0,0,0,0,0,0},
+	[CT_HELP_BIT]		= {0,0,0,0,0,0,0,0},
+	[EXP_LIST_BIT]		= {0,0,0,0,0,0,0,0},
+	[EXP_CREATE_BIT]	= {1,1,0,0,1,1,1,1},
+	[EXP_DELETE_BIT]	= {1,1,1,1,0,0,0,0},
+	[EXP_GET_BIT]		= {1,1,1,1,0,0,0,0},
+	[EXP_FLUSH_BIT]		= {0,0,0,0,0,0,0,0},
+	[EXP_EVENT_BIT]		= {0,0,0,0,0,0,0,0},
 };
 
 static int parse_options(char c,
diff --git a/extensions/libct_proto_udplite.c b/extensions/libct_proto_udplite.c
index 2bece38..8d42d1a 100644
--- a/extensions/libct_proto_udplite.c
+++ b/extensions/libct_proto_udplite.c
@@ -70,22 +70,22 @@ static void help(void)
 
 static char udplite_commands_v_options[NUMBER_OF_CMD][UDP_OPT_MAX] =
 {
-		/* 1 2 3 4 5 6 7 8 */
-/*CT_LIST*/	  {2,2,2,2,0,0,0,0},
-/*CT_CREATE*/	  {3,3,3,3,0,0,0,0},
-/*CT_UPDATE*/	  {2,2,2,2,0,0,0,0},
-/*CT_DELETE*/	  {2,2,2,2,0,0,0,0},
-/*CT_GET*/	  {3,3,3,3,0,0,0,0},
-/*CT_FLUSH*/	  {0,0,0,0,0,0,0,0},
-/*CT_EVENT*/	  {2,2,2,2,0,0,0,0},
-/*CT_VERSION*/	  {0,0,0,0,0,0,0,0},
-/*CT_HELP*/	  {0,0,0,0,0,0,0,0},
-/*EXP_LIST*/	  {0,0,0,0,0,0,0,0},
-/*EXP_CREATE*/	  {1,1,0,0,1,1,1,1},
-/*EXP_DELETE*/	  {1,1,1,1,0,0,0,0},
-/*EXP_GET*/	  {1,1,1,1,0,0,0,0},
-/*EXP_FLUSH*/	  {0,0,0,0,0,0,0,0},
-/*EXP_EVENT*/	  {0,0,0,0,0,0,0,0},
+				/* 1 2 3 4 5 6 7 8 */
+	[CT_LIST_BIT]		= {2,2,2,2,0,0,0,0},
+	[CT_CREATE_BIT]		= {3,3,3,3,0,0,0,0},
+	[CT_UPDATE_BIT]		= {2,2,2,2,0,0,0,0},
+	[CT_DELETE_BIT]		= {2,2,2,2,0,0,0,0},
+	[CT_GET_BIT]		= {3,3,3,3,0,0,0,0},
+	[CT_FLUSH_BIT]		= {0,0,0,0,0,0,0,0},
+	[CT_EVENT_BIT]		= {2,2,2,2,0,0,0,0},
+	[CT_VERSION_BIT]	= {0,0,0,0,0,0,0,0},
+	[CT_HELP_BIT]		= {0,0,0,0,0,0,0,0},
+	[EXP_LIST_BIT]		= {0,0,0,0,0,0,0,0},
+	[EXP_CREATE_BIT]	= {1,1,0,0,1,1,1,1},
+	[EXP_DELETE_BIT]	= {1,1,1,1,0,0,0,0},
+	[EXP_GET_BIT]		= {1,1,1,1,0,0,0,0},
+	[EXP_FLUSH_BIT]		= {0,0,0,0,0,0,0,0},
+	[EXP_EVENT_BIT]		= {0,0,0,0,0,0,0,0},
 };
 
 static int parse_options(char c,
diff --git a/include/conntrack.h b/include/conntrack.h
index 1c1720e..bc17af0 100644
--- a/include/conntrack.h
+++ b/include/conntrack.h
@@ -11,7 +11,70 @@
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
 
-#define NUMBER_OF_CMD   19
+enum ct_command {
+	CT_NONE		= 0,
+
+	CT_LIST_BIT 	= 0,
+	CT_LIST 	= (1 << CT_LIST_BIT),
+
+	CT_CREATE_BIT	= 1,
+	CT_CREATE	= (1 << CT_CREATE_BIT),
+
+	CT_UPDATE_BIT	= 2,
+	CT_UPDATE	= (1 << CT_UPDATE_BIT),
+
+	CT_DELETE_BIT	= 3,
+	CT_DELETE	= (1 << CT_DELETE_BIT),
+
+	CT_GET_BIT	= 4,
+	CT_GET		= (1 << CT_GET_BIT),
+
+	CT_FLUSH_BIT	= 5,
+	CT_FLUSH	= (1 << CT_FLUSH_BIT),
+
+	CT_EVENT_BIT	= 6,
+	CT_EVENT	= (1 << CT_EVENT_BIT),
+
+	CT_VERSION_BIT	= 7,
+	CT_VERSION	= (1 << CT_VERSION_BIT),
+
+	CT_HELP_BIT	= 8,
+	CT_HELP		= (1 << CT_HELP_BIT),
+
+	EXP_LIST_BIT 	= 9,
+	EXP_LIST 	= (1 << EXP_LIST_BIT),
+
+	EXP_CREATE_BIT	= 10,
+	EXP_CREATE	= (1 << EXP_CREATE_BIT),
+
+	EXP_DELETE_BIT	= 11,
+	EXP_DELETE	= (1 << EXP_DELETE_BIT),
+
+	EXP_GET_BIT	= 12,
+	EXP_GET		= (1 << EXP_GET_BIT),
+
+	EXP_FLUSH_BIT	= 13,
+	EXP_FLUSH	= (1 << EXP_FLUSH_BIT),
+
+	EXP_EVENT_BIT	= 14,
+	EXP_EVENT	= (1 << EXP_EVENT_BIT),
+
+	CT_COUNT_BIT	= 15,
+	CT_COUNT	= (1 << CT_COUNT_BIT),
+
+	EXP_COUNT_BIT	= 16,
+	EXP_COUNT	= (1 << EXP_COUNT_BIT),
+
+	CT_STATS_BIT	= 17,
+	CT_STATS	= (1 << CT_STATS_BIT),
+
+	EXP_STATS_BIT	= 18,
+	EXP_STATS	= (1 << EXP_STATS_BIT),
+
+	_CT_BIT_MAX	= 19,
+};
+
+#define NUMBER_OF_CMD   _CT_BIT_MAX
 #define NUMBER_OF_OPT   29
 
 struct nf_conntrack;
diff --git a/src/conntrack.c b/src/conntrack.c
index 6c999f4..e96e42d 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -153,68 +153,6 @@ static void free_tmpl_objects(struct ct_tmpl *tmpl)
 		nfct_bitmask_destroy(tmpl->label_modify);
 }
 
-enum ct_command {
-	CT_NONE		= 0,
-
-	CT_LIST_BIT 	= 0,
-	CT_LIST 	= (1 << CT_LIST_BIT),
-
-	CT_CREATE_BIT	= 1,
-	CT_CREATE	= (1 << CT_CREATE_BIT),
-
-	CT_UPDATE_BIT	= 2,
-	CT_UPDATE	= (1 << CT_UPDATE_BIT),
-
-	CT_DELETE_BIT	= 3,
-	CT_DELETE	= (1 << CT_DELETE_BIT),
-
-	CT_GET_BIT	= 4,
-	CT_GET		= (1 << CT_GET_BIT),
-
-	CT_FLUSH_BIT	= 5,
-	CT_FLUSH	= (1 << CT_FLUSH_BIT),
-
-	CT_EVENT_BIT	= 6,
-	CT_EVENT	= (1 << CT_EVENT_BIT),
-
-	CT_VERSION_BIT	= 7,
-	CT_VERSION	= (1 << CT_VERSION_BIT),
-
-	CT_HELP_BIT	= 8,
-	CT_HELP		= (1 << CT_HELP_BIT),
-
-	EXP_LIST_BIT 	= 9,
-	EXP_LIST 	= (1 << EXP_LIST_BIT),
-
-	EXP_CREATE_BIT	= 10,
-	EXP_CREATE	= (1 << EXP_CREATE_BIT),
-
-	EXP_DELETE_BIT	= 11,
-	EXP_DELETE	= (1 << EXP_DELETE_BIT),
-
-	EXP_GET_BIT	= 12,
-	EXP_GET		= (1 << EXP_GET_BIT),
-
-	EXP_FLUSH_BIT	= 13,
-	EXP_FLUSH	= (1 << EXP_FLUSH_BIT),
-
-	EXP_EVENT_BIT	= 14,
-	EXP_EVENT	= (1 << EXP_EVENT_BIT),
-
-	CT_COUNT_BIT	= 15,
-	CT_COUNT	= (1 << CT_COUNT_BIT),
-
-	EXP_COUNT_BIT	= 16,
-	EXP_COUNT	= (1 << EXP_COUNT_BIT),
-
-	CT_STATS_BIT	= 17,
-	CT_STATS	= (1 << CT_STATS_BIT),
-
-	EXP_STATS_BIT	= 18,
-	EXP_STATS	= (1 << EXP_STATS_BIT),
-};
-/* If you add a new command, you have to update NUMBER_OF_CMD in conntrack.h */
-
 enum ct_options {
 	CT_OPT_ORIG_SRC_BIT	= 0,
 	CT_OPT_ORIG_SRC 	= (1 << CT_OPT_ORIG_SRC_BIT),
@@ -413,26 +351,26 @@ static const char *getopt_str = ":L::I::U::D::G::E::F::hVs:d:r:q:"
 static char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
 /* Well, it's better than "Re: Linux vs FreeBSD" */
 {
-          /*   s d r q p t u z e [ ] { } a m i f n g o c b j w l < > ( ) */
-/*CT_LIST*/   {2,2,2,2,2,0,2,2,0,0,0,2,2,0,2,0,2,2,2,2,2,0,2,2,2,0,0,2,2},
-/*CT_CREATE*/ {3,3,3,3,1,1,2,0,0,0,0,0,0,2,2,0,0,2,2,0,0,0,0,2,0,2,0,2,2},
-/*CT_UPDATE*/ {2,2,2,2,2,2,2,0,0,0,0,2,2,0,2,2,2,2,2,2,0,0,0,0,2,2,2,0,0},
-/*CT_DELETE*/ {2,2,2,2,2,2,2,0,0,0,0,2,2,0,2,2,2,2,2,2,0,0,0,2,2,0,0,2,2},
-/*CT_GET*/    {3,3,3,3,1,0,0,0,0,0,0,0,0,0,0,2,0,0,0,2,0,0,0,0,2,0,0,0,0},
-/*CT_FLUSH*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0},
-/*CT_EVENT*/  {2,2,2,2,2,0,0,0,2,0,0,2,2,0,2,0,2,2,2,2,2,2,2,2,2,0,0,2,2},
-/*VERSION*/   {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*HELP*/      {0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_LIST*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,2,0,0,0,0,0,0,0,0,0},
-/*EXP_CREATE*/{1,1,2,2,1,1,2,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_DELETE*/{1,1,2,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_GET*/   {1,1,2,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_FLUSH*/ {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_EVENT*/ {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0},
-/*CT_COUNT*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_COUNT*/ {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*CT_STATS*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*EXP_STATS*/ {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+				/* s d r q p t u z e [ ] { } a m i f n g o c b j w l < > ( ) */
+	[CT_LIST_BIT]		= {2,2,2,2,2,0,2,2,0,0,0,2,2,0,2,0,2,2,2,2,2,0,2,2,2,0,0,2,2},
+	[CT_CREATE_BIT]		= {3,3,3,3,1,1,2,0,0,0,0,0,0,2,2,0,0,2,2,0,0,0,0,2,0,2,0,2,2},
+	[CT_UPDATE_BIT]		= {2,2,2,2,2,2,2,0,0,0,0,2,2,0,2,2,2,2,2,2,0,0,0,0,2,2,2,0,0},
+	[CT_DELETE_BIT]		= {2,2,2,2,2,2,2,0,0,0,0,2,2,0,2,2,2,2,2,2,0,0,0,2,2,0,0,2,2},
+	[CT_GET_BIT]		= {3,3,3,3,1,0,0,0,0,0,0,0,0,0,0,2,0,0,0,2,0,0,0,0,2,0,0,0,0},
+	[CT_FLUSH_BIT]		= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0},
+	[CT_EVENT_BIT]		= {2,2,2,2,2,0,0,0,2,0,0,2,2,0,2,0,2,2,2,2,2,2,2,2,2,0,0,2,2},
+	[CT_VERSION_BIT]	= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+	[CT_HELP_BIT]		= {0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+	[EXP_LIST_BIT]		= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,2,0,0,0,0,0,0,0,0,0},
+	[EXP_CREATE_BIT]	= {1,1,2,2,1,1,2,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+	[EXP_DELETE_BIT]	= {1,1,2,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+	[EXP_GET_BIT]		= {1,1,2,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+	[EXP_FLUSH_BIT]		= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+	[EXP_EVENT_BIT]		= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0},
+	[CT_COUNT_BIT]		= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+	[EXP_COUNT_BIT]		= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+	[CT_STATS_BIT]		= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
+	[EXP_STATS_BIT]		= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
 };
 
 static const int cmd2type[][2] = {
-- 
2.25.1

