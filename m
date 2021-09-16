Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D94CC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Sep 2021 02:58:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6919261186
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Sep 2021 02:58:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233856AbhIPC7s (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Sep 2021 22:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233847AbhIPC7s (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Sep 2021 22:59:48 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AED0C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Sep 2021 19:58:28 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id w8so4783092pgf.5
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Sep 2021 19:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y91MJPpfiRKrvQP3NxSWVvBnhIcPzWL+3g5Z1UUrQns=;
        b=T8od49URKhyxHAxSUeDbQ2fZ6i/jtNTJ53UW2Aq/XUVLrcpDXPDL7LkhS29ooDDqBO
         3X48np58ptFRpWpXxzRwN1yZ7r/hvUm1y6UPEucDQNXTARf0wrRJQWaPKsAEiP0aHBf2
         MLHFlrSgVRyG7G34kEjXV4p+kJkpyMSYwwi7GVggXVTxmgMDy3J88gQLymgQGC5BhsK4
         2fBFALj6ro3W4qYaH+OvZEY9Cbgs8gBu85gBBNvGrwH2O4klKmM7wRJyOk4bPxm4E3c9
         fNooMOyMmbYZ89qKwRW5fXXb13JRRGDKJQVVWROw14oR162ldp05TQoaKTeUvLpR1hSR
         YlEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=y91MJPpfiRKrvQP3NxSWVvBnhIcPzWL+3g5Z1UUrQns=;
        b=Yj+UIlR0LyNHIYzzu9JiWBHJJFEG/sKJX1GaR9Dk2wVH3/n2QE3cBe+c9/G1BYAa3q
         sdq1wtKOzmGbRDU0RLogMIf0kq/J0K/spxDwuDs4RRpZA8iHfaJFyRiInRtnikyythRj
         ttGpTQc/0cgF1S/kFmPP8lyyf1pF5+ips+0/pDa6DxjTM4+MsRYs8n5fHGM1UnVyEj0I
         FN2M/dxoW398BmXWpG/HxdbXIKV+WIi3QIqHn2o363QvEmne5q8bx5ZWfTFzQ9t8vTTK
         Wpu9LJVmSMT8o+GBpuKPdW2spOO6odS5hdKyF9ciMZ5doo6qMa2J8s0szFZFtytaipeh
         Gnow==
X-Gm-Message-State: AOAM533c6xOR1lQ/UIrMinqw3V7gR/veu8n8rfELRE4809SD/aHN4J11
        ddwZO5BNb73Yw3fzA/miDCM6u6wrQRU=
X-Google-Smtp-Source: ABdhPJyrZwNLL+EKQOc1aBi191YXCRYQGz7uHuVdCv4J3SJIrFMVXfUADZTuBtUSxddpIlPoLs+nxA==
X-Received: by 2002:a63:5c2:: with SMTP id 185mr2831610pgf.220.1631761108103;
        Wed, 15 Sep 2021 19:58:28 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id g19sm5598998pjl.25.2021.09.15.19.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 19:58:27 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_log v3] src: doc: revise doxygen for module "Netlink message helper functions"
Date:   Thu, 16 Sep 2021 12:58:22 +1000
Message-Id: <20210916025822.14231-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Adjust style to work better in a man page.
Document actual return values.
Replace qnum with gnum (and in .h and utils/).
Show possible copy modes (rather than refer users to header file)

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
v2: Implement Pablo's suggestions
v3: Show possible modes for nflog_attr_put_cfg_mode
 include/libnetfilter_log/libnetfilter_log.h |  2 +-
 src/nlmsg.c                                 | 61 ++++++++++-----------
 utils/nf-log.c                              |  8 +--
 3 files changed, 35 insertions(+), 36 deletions(-)

diff --git a/include/libnetfilter_log/libnetfilter_log.h b/include/libnetfilter_log/libnetfilter_log.h
index c27149f..16c4748 100644
--- a/include/libnetfilter_log/libnetfilter_log.h
+++ b/include/libnetfilter_log/libnetfilter_log.h
@@ -88,7 +88,7 @@ enum {
 extern int nflog_snprintf_xml(char *buf, size_t len, struct nflog_data *tb, int flags);
 
 extern struct nlmsghdr *
-nflog_nlmsg_put_header(char *buf, uint8_t type, uint8_t family, uint16_t qnum);
+nflog_nlmsg_put_header(char *buf, uint8_t type, uint8_t family, uint16_t gnum);
 extern int nflog_attr_put_cfg_mode(struct nlmsghdr *nlh, uint8_t mode, uint32_t range);
 extern int nflog_attr_put_cfg_cmd(struct nlmsghdr *nlh, uint8_t cmd);
 extern int nflog_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr);
diff --git a/src/nlmsg.c b/src/nlmsg.c
index 3ebb364..e4973a6 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -18,18 +18,19 @@
  */
 
 /**
- * nflog_nlmsg_put_header - reserve and prepare room for nflog Netlink header
- * \param buf memory already allocated to store the Netlink header
- * \param type message type one of the enum nfulnl_msg_types
- * \param family protocol family to be an object of
- * \param qnum queue number to be an object of
+ * nflog_nlmsg_put_header - populate memory buffer with nflog Netlink headers
+ * \param buf pointer to memory buffer
+ * \param type either NFULNL_MSG_PACKET or NFULNL_MSG_CONFIG
+ * (enum nfulnl_msg_types)
+ * \param family protocol family
+ * \param gnum group number
  *
- * This function creates Netlink header in the memory buffer passed
- * as parameter that will send to nfnetlink log. This function
- * returns a pointer to the Netlink header structure.
+ * Initialises _buf_ to start with a netlink header for the log subsystem
+ * followed by an nfnetlink header with the log group
+ * \return pointer to created Netlink header structure
  */
 struct nlmsghdr *
-nflog_nlmsg_put_header(char *buf, uint8_t type, uint8_t family, uint16_t qnum)
+nflog_nlmsg_put_header(char *buf, uint8_t type, uint8_t family, uint16_t gnum)
 {
 	struct nlmsghdr *nlh = mnl_nlmsg_put_header(buf);
 	struct nfgenmsg *nfg;
@@ -40,19 +41,19 @@ nflog_nlmsg_put_header(char *buf, uint8_t type, uint8_t family, uint16_t qnum)
 	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
 	nfg->nfgen_family = family;
 	nfg->version = NFNETLINK_V0;
-	nfg->res_id = htons(qnum);
+	nfg->res_id = htons(gnum);
 
 	return nlh;
 }
 
 /**
  * nflog_attr_put_cfg_mode - add a mode attribute to nflog netlink message
- * \param nlh pointer to the netlink message
- * \param mode copy mode defined in linux/netfilter/nfnetlink_log.h
+ * \param nlh pointer to netlink message
+ * \param mode copy mode: NFULNL_COPY_NONE, NFULNL_COPY_META or
+ * NFULNL_COPY_PACKET
  * \param range copy range
  *
- * this function returns -1 and errno is explicitly set on error.
- * On success, this function returns 1.
+ * \return 0
  */
 int nflog_attr_put_cfg_mode(struct nlmsghdr *nlh, uint8_t mode, uint32_t range)
 {
@@ -68,12 +69,11 @@ int nflog_attr_put_cfg_mode(struct nlmsghdr *nlh, uint8_t mode, uint32_t range)
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
@@ -148,11 +148,10 @@ static int nflog_parse_attr_cb(const struct nlattr *attr, void *data)
 
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
@@ -164,12 +163,12 @@ int nflog_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr)
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
@@ -181,12 +180,12 @@ int nflog_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr)
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
diff --git a/utils/nf-log.c b/utils/nf-log.c
index ad8369c..e6832b0 100644
--- a/utils/nf-log.c
+++ b/utils/nf-log.c
@@ -144,13 +144,13 @@ int main(int argc, char *argv[])
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 	int ret;
-	unsigned int portid, qnum;
+	unsigned int portid, gnum;
 
 	if (argc != 2) {
 		printf("Usage: %s [queue_num]\n", argv[0]);
 		exit(EXIT_FAILURE);
 	}
-	qnum = atoi(argv[1]);
+	gnum = atoi(argv[1]);
 
 	nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (nl == NULL) {
@@ -188,7 +188,7 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	nlh = nflog_nlmsg_put_header(buf, NFULNL_MSG_CONFIG, AF_INET, qnum);
+	nlh = nflog_nlmsg_put_header(buf, NFULNL_MSG_CONFIG, AF_INET, gnum);
 	if (nflog_attr_put_cfg_cmd(nlh, NFULNL_CFG_CMD_BIND) < 0) {
 		perror("nflog_attr_put_cfg_cmd");
 		exit(EXIT_FAILURE);
@@ -199,7 +199,7 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	nlh = nflog_nlmsg_put_header(buf, NFULNL_MSG_CONFIG, AF_UNSPEC, qnum);
+	nlh = nflog_nlmsg_put_header(buf, NFULNL_MSG_CONFIG, AF_UNSPEC, gnum);
 	if (nflog_attr_put_cfg_mode(nlh, NFULNL_COPY_PACKET, 0xffff) < 0) {
 		perror("nflog_attr_put_cfg_mode");
 		exit(EXIT_FAILURE);
-- 
2.17.5

