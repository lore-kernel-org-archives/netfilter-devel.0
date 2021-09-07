Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF882C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Sep 2021 07:35:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86442610CB
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Sep 2021 07:35:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhIGHgn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Sep 2021 03:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbhIGHgm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Sep 2021 03:36:42 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 224E2C061575
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Sep 2021 00:35:37 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id j1so5740566pjv.3
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Sep 2021 00:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u6rErmDAyBKCsF/jmSmif8sDCWTzaGWLF+VfuKVVfL8=;
        b=l6fIMxlW7pqe880d1HVcfgQuFrcYkPR7dU80vykuPj+fL6ZI3JPHaipOstUtvtDf8V
         clRvaWofHbwNpMJJ+Ps8G45sNchhZFGehrdUkn4k6oz+dDOllxMdwVkAsjBu2iKGGcfQ
         dlaBs/URgzoM/td6S5NITsOQEwUftwgWuJynbiniKn8uXjJYgNpd7syolIwD+t0dWHHZ
         Gh0z9kSpnVCWtEXJd5VxVswVxodgvKZmwpjp4xVxERgmBJKifZNLy26nq377hKdDDUFh
         UYeHlxTKHcWJ3XoTdT4mcIaA6elHsSd2Pm38ltRZ32gYawVs7mG83L+QtbLNBjivYBfO
         i4jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=u6rErmDAyBKCsF/jmSmif8sDCWTzaGWLF+VfuKVVfL8=;
        b=orT72K9aA8m3xc9yCErLTru5Ssz+UFK7fIOwXF4WAjs9kvISRMVhllMSs3A0oQbHHG
         CkXGt7e2bsBXdFSYCPbGpb4rJHwDrqLuqbC8s6tcAm7plqX4fLUk28LqAeQ2SkVhRZZg
         q/HgTkntTYT2Tbm5vzJj/R1FofHiiO87xF980fQSAIJyXrpBk/8eR1CzkGwGUPToLQNq
         PZrnVrYxAHmIKjR0TCJEIGEoPxVviEgUwiELcth7jf+u/vaeI+RAWcPqSUZfKmQiwY3T
         LcicrFpWQ+9rIkI9WX+t+tRTtc7MLVCd+4e+7gAWRraRF7OjcAXcKjNl6D0hUdwUHF3S
         vUPg==
X-Gm-Message-State: AOAM531+sTTYbCqa4KZ2+W8vOz8misNpK0N7m1Hl8ZKRb9/VnWIYwQve
        yYTaLumcwugTawAgMv1aTtw2/5Vpbf0=
X-Google-Smtp-Source: ABdhPJxgWXXgyhhGhPJgGT9+EAVy3RTVkS018x2L+Yb/6AaDqoYXkVjTI/rNlx2+gAPO1rKB8w6fyw==
X-Received: by 2002:a17:902:c643:b0:138:b603:f93e with SMTP id s3-20020a170902c64300b00138b603f93emr13765759pls.66.1631000136566;
        Tue, 07 Sep 2021 00:35:36 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id e14sm1620725pjg.40.2021.09.07.00.35.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 00:35:36 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_log v2] src: doc: revise doxygen for module "Netlink message helper functions"
Date:   Tue,  7 Sep 2021 17:35:31 +1000
Message-Id: <20210907073531.3272-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Adjust style to work better in a man page.
Document actual return values.
Replace qnum with gnum (and in .h and utils/).

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
v2: Implement Pablo's suggestions
 include/libnetfilter_log/libnetfilter_log.h |  2 +-
 src/nlmsg.c                                 | 58 ++++++++++-----------
 utils/nf-log.c                              |  8 +--
 3 files changed, 33 insertions(+), 35 deletions(-)

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
index 3ebb364..f792f09 100644
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
@@ -40,19 +41,18 @@ nflog_nlmsg_put_header(char *buf, uint8_t type, uint8_t family, uint16_t qnum)
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
@@ -68,12 +68,11 @@ int nflog_attr_put_cfg_mode(struct nlmsghdr *nlh, uint8_t mode, uint32_t range)
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
@@ -148,11 +147,10 @@ static int nflog_parse_attr_cb(const struct nlattr *attr, void *data)
 
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
@@ -164,12 +162,12 @@ int nflog_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr)
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
@@ -181,12 +179,12 @@ int nflog_nlmsg_parse(const struct nlmsghdr *nlh, struct nlattr **attr)
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

