Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DD55C433EF
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Sep 2021 02:33:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D187B60F56
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Sep 2021 02:33:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232665AbhIECe3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 4 Sep 2021 22:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbhIECe2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 4 Sep 2021 22:34:28 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A198CC061575
        for <netfilter-devel@vger.kernel.org>; Sat,  4 Sep 2021 19:33:26 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id s11so3087236pgr.11
        for <netfilter-devel@vger.kernel.org>; Sat, 04 Sep 2021 19:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=glJFzOyJmQam8PjD9GDOPHcu5SXMZZMosRGoWf8f6JE=;
        b=ZermdxdZZDSWFM3py2/QeJRJ6OZt0bdJD58pdAb3ZUhiMgERrRiJoX4viqe//LyIC7
         X+61/sdb/0yNHGFHPrHP+tBfohnL1zczGtrzrgPLfpQwspapBGUpt38PakOmNsD6EqC2
         No3Z76qH8R1bVait0BEr1wwAF4t8tbaRLNFTKiENjyXvTJCeDZnhQTvPPKwmSz1wzegm
         DLxW6NRrMREmt2v6JbFgFNijeBRz4Z/HfPMPqgw2WrM6zr1HL1S6qcv0wygfhkdQ7KFP
         B/dSAm1Ly/Jxm7GNwQUSl1V4kFbZsRZjG46663XThE/Tee18PxMhUIY8K6N0bX9tTonN
         0ybg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=glJFzOyJmQam8PjD9GDOPHcu5SXMZZMosRGoWf8f6JE=;
        b=ZpcvYMC4NdJNB/AnwQOmi6JVYFdiD3Jp8M7L4wp76G6bL5VbKqDALDBhHMWYCeD17N
         orXnTi1n/6TgByzI2M8l6CsoxhERj3s/va/K6j7dmDFGTN/yZLUXh9c2RbQV27qS+/c0
         Ei/1KBMzmE2paQQmjnJACaYkNHC11m+4d8NT2f14tK+wQH7pA5ZnmM9SZ8lJCaDz3VSz
         g81vs+Qx7Pnfya0YR0+8WG8Taw/HliKuVMyCB/6z02egt1zqxBFAbrS+xiUfB/Sh+SKj
         kciGS77EmqoHs016vaMoYFetoLighAFmiWu04VxfgJoV5FKSf302kyF1vUjdfIDSeLcf
         WbrA==
X-Gm-Message-State: AOAM532gaaNdGevwoqEVowIOpQ15gawOdas54gauee14Dsof2SuIpcxP
        iWD/qvUxzcgJWE4QmDQLBfri42Vi/yc=
X-Google-Smtp-Source: ABdhPJzVuGaVYM5bbmyyPjj0SSwyTyH+dmS58AP5bLlPkQc05mNqqF+xA1Bl/s5cgMxSdzYJ8dswzQ==
X-Received: by 2002:a63:d017:: with SMTP id z23mr5849610pgf.108.1630809205805;
        Sat, 04 Sep 2021 19:33:25 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id d5sm3359930pjs.53.2021.09.04.19.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Sep 2021 19:33:25 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_log] src: doc: revise doxygen for module "Netlink message helper functions"
Date:   Sun,  5 Sep 2021 12:33:20 +1000
Message-Id: <20210905023320.29740-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Adjust style to work better in a man page.
Document actual return values.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/nlmsg.c | 53 +++++++++++++++++++++++++----------------------------
 1 file changed, 25 insertions(+), 28 deletions(-)

diff --git a/src/nlmsg.c b/src/nlmsg.c
index 3ebb364..399b19a 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -18,15 +18,15 @@
  */
 
 /**
- * nflog_nlmsg_put_header - reserve and prepare room for nflog Netlink header
- * \param buf memory already allocated to store the Netlink header
- * \param type message type one of the enum nfulnl_msg_types
- * \param family protocol family to be an object of
- * \param qnum queue number to be an object of
+ * nflog_nlmsg_put_header - convert memory buffer into an nflog Netlink header
+ * \param buf pointer to memory buffer
+ * \param type either NFULNL_MSG_PACKET or NFULNL_MSG_CONFIG
+ * \param family protocol family
+ * \param qnum queue number
  *
- * This function creates Netlink header in the memory buffer passed
- * as parameter that will send to nfnetlink log. This function
- * returns a pointer to the Netlink header structure.
+ * Creates a Netlink header in _buf_ followed by
+ * a log\-subsystem\-specific extra header.
+ * \return pointer to created Netlink header structure
  */
 struct nlmsghdr *
 nflog_nlmsg_put_header(char *buf, uint8_t type, uint8_t family, uint16_t qnum)
@@ -47,12 +47,11 @@ nflog_nlmsg_put_header(char *buf, uint8_t type, uint8_t family, uint16_t qnum)
 
 /**
  * nflog_attr_put_cfg_mode - add a mode attribute to nflog netlink message
- * \param nlh pointer to the netlink message
+ * \param nlh pointer to netlink message
  * \param mode copy mode defined in linux/netfilter/nfnetlink_log.h
  * \param range copy range
  *
- * this function returns -1 and errno is explicitly set on error.
- * On success, this function returns 1.
+ * \return 0
  */
 int nflog_attr_put_cfg_mode(struct nlmsghdr *nlh, uint8_t mode, uint32_t range)
 {
@@ -68,12 +67,11 @@ int nflog_attr_put_cfg_mode(struct nlmsghdr *nlh, uint8_t mode, uint32_t range)
 }
 
 /**
- * nflog_attr_put_cfg_cmd - add a cmd attribute to nflog netlink message
- * \param nlh pointer to the netlink message
- * \param cmd command one of the enum nfulnl_msg_config_cmds
+ * nflog_attr_put_cfg_cmd - add a command attribute to nflog netlink message
+ * \param nlh pointer to netlink message
+ * \param cmd one of the enum nfulnl_msg_config_cmds
  *
- * this function returns -1 and errno is explicitly set on error.
- *  On success, this function returns 1.
+ * \return 0
  */
 int nflog_attr_put_cfg_cmd(struct nlmsghdr *nlh, uint8_t cmd)
 {
@@ -148,11 +146,10 @@ static int nflog_parse_attr_cb(const struct nlattr *attr, void *data)
 
 /**
  * nflog_nlmsg_parse - set nlattrs from netlink message
- * \param nlh netlink message that you want to read.
- * \param attr pointer to the array of nlattr which size is NFULA_MAX + 1
+ * \param nlh pointer to netlink message
+ * \param attr pointer to an array of nlattr of size NFULA_MAX + 1
  *
- * This function returns MNL_CB_ERROR if any error occurs, or MNL_CB_OK on
- * success.
+ * \return 0
  */
 int nflog_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr)
 {
@@ -164,12 +161,12 @@ int nflog_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr)
  * nflog_nlmsg_snprintf - print a nflog nlattrs to a buffer
  * \param buf buffer used to build the printable nflog
  * \param bufsiz size of the buffer
- * \param nlh netlink message (to get queue num in the futuer)
- * \param attr pointer to a nflog attrs
+ * \param nlh pointer to netlink message (to get queue num in the future)
+ * \param attr pointer to an array of nlattr of size NFULA_MAX + 1
  * \param type print message type in enum nflog_output_type
  * \param flags The flag that tell what to print into the buffer
  *
- * This function supports the following type - flags:
+ * This function supports the following types / flags:
  *
  *   type: NFLOG_OUTPUT_XML
  *	- NFLOG_XML_PREFIX: include the string prefix
@@ -181,12 +178,12 @@ int nflog_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr)
  *	- NFLOG_XML_TIME: include the timestamp
  *	- NFLOG_XML_ALL: include all the logging information (all flags set)
  *
- * You can combine this flags with an binary OR.
+ * You can combine these flags with a bitwise OR.
  *
- * this function returns -1 and errno is explicitly set in case of
- * failure, otherwise the length of the string that would have been
- * printed into the buffer (in case that there is enough room in
- * it). See snprintf() return value for more information.
+ * \return -1 on failure else same as snprintf
+ * \par Errors
+ * __EOPNOTSUPP__ _type_ is unsupported (i.e. not __NFLOG_OUTPUT_XML__)
+ * \sa __snprintf__(3)
  */
 int nflog_nlmsg_snprintf(char *buf, size_t bufsiz, const struct nlmsghdr *nlh,
 			 struct nlattr **attr, enum nflog_output_type type,
-- 
2.17.5

