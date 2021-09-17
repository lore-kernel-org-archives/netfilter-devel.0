Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FDC0C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Sep 2021 04:43:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CB5360F93
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Sep 2021 04:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhIQEpK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Sep 2021 00:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhIQEpC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Sep 2021 00:45:02 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B121C061574
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Sep 2021 21:43:41 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id k23-20020a17090a591700b001976d2db364so6446804pji.2
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Sep 2021 21:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mxrrWB+8rNfH/KP5CvGS/kgprJnwqFM86wZPL7O6IyM=;
        b=Kz8UYs4I9Txf82QtRhMFvpP7n9UnUXe0XsiVhqhjBuuec8oaJ2pyBmAxHNGeGUlz97
         ciXYhkuedfUYsdOXzRtePC9q5PvI8OjyTPYYbYkxfM28NOTtbhL54sfi+UTDB/ATQ1z+
         +79cXajL40bf/mH2lQ1kncKezeyKuoWOjRqniy7P8kkCQ5ic4/kMCn9wH4/gCbiA8nuD
         /g6xgqXN0J5LSt9CPanDGQaY8/uM9wL8xlI2tW4P7fOB3ENfepVw6VoqJI+gL7biF7JV
         5kjNPRZ9itP/3lsvwc1tPwFrABWKTIAvvuTcMdcpFpm5FpXV6TPndffFMKhdjwF7zidt
         ofyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=mxrrWB+8rNfH/KP5CvGS/kgprJnwqFM86wZPL7O6IyM=;
        b=IXf78EWzVFls1ul13WBdFo8Ltguoj7LTzbL5/vKlRByn1PPSV5KGbW+mVaUoOFDO6y
         02U3MBlgkcpneBLWf4Bdu3Mk0dlPQMOCOTvz6v7ySAn0yMz0yyXf6Oqi63+KweAFFo8B
         7mvg1xRytKQgYj9sm8d+qSEyD+xAV4FEQj84sxVqw/itBZ1yeACdLDli9YBHNLqNrBbR
         N4sbMXNW/msGi7YWto1Nw+sRXynyS5FzQgKcbKav5oXeJ2W257B4K9vDf3zLbM5vmNoD
         wcndipajrQa4TptZ3YC/6JHhelfyZcnbUPTP0N784D41cjLqL3D+3KzGik28iPjTdlPy
         lJAQ==
X-Gm-Message-State: AOAM531krOKdr2E3LVYNK0CBQAs71dphELA8FEc8Bpz+kAWgJX7lhmpj
        x8BtOHj/3McNR/GXKDUgooPaWqGy7U4=
X-Google-Smtp-Source: ABdhPJzbu3y7OVuRanDN1T74jLRTcy5yFOdn+ttzgTuT4bJtlslnzYlDqszRtFN2HDlKnUn6+FlgEg==
X-Received: by 2002:a17:90b:4b06:: with SMTP id lx6mr19023513pjb.160.1631853820719;
        Thu, 16 Sep 2021 21:43:40 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id b12sm4568428pff.63.2021.09.16.21.43.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 21:43:40 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_log v2] src: doc: revise doxygen for all other modules
Date:   Fri, 17 Sep 2021 14:43:35 +1000
Message-Id: <20210917044335.15568-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I.e. all modules except "Netlink message helper functions"
- different cross-reference for man page and html
- remove duplicate description for nflog_fd
- try to differentiate between "rare" and "common" errors
- gh is a Netfilter log *group* handle (cf h)
- minor native English corrections
- update Linux source reference
- document actual return values

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
v2: Add man page cross reference for LibrarySetup
 src/libnetfilter_log.c | 100 +++++++++++++++++++++++++++++------------
 1 file changed, 71 insertions(+), 29 deletions(-)

diff --git a/src/libnetfilter_log.c b/src/libnetfilter_log.c
index 546d667..8124a30 100644
--- a/src/libnetfilter_log.c
+++ b/src/libnetfilter_log.c
@@ -207,8 +207,21 @@ struct nfnl_handle *nflog_nfnlh(struct nflog_handle *h)
 	}
 \endverbatim
  *
- * Data and information about the packet can be fetch by using message parsing
- * functions (See \link Parsing \endlink).
+ * Data and information about the packet can be fetched by using message parsing
+ * \htmlonly
+ functions (See <a class="el" href="group__Parsing.html">Parsing</a>).
+\endhtmlonly
+ * \manonly
+functions.
+.PP
+\fBSee also:\fP
+.RS 4
+\fBLibrarySetup\fP man page (\fBman nflog_open\fP)
+.br
+\fBParsing\fP man page (\fBman nflog_get_gid\fP)
+.RE
+.PP
+\endmanonly
  * @{
  */
 
@@ -220,9 +233,6 @@ struct nfnl_handle *nflog_nfnlh(struct nflog_handle *h)
  * given log connection handle. The file descriptor can then be used for
  * receiving the logged packets for processing.
  *
- * This function returns a file descriptor that can be used for communication
- * over the netlink connection associated with the given log connection
- * handle.
  */
 int nflog_fd(struct nflog_handle *h)
 {
@@ -279,7 +289,9 @@ out_free:
  * it by calling nflog_close(). A new netlink connection is obtained internally
  * and associated with the log connection handle returned.
  *
- * \return a pointer to a new log handle or NULL on failure.
+ * \return a pointer to a new log handle or NULL on failure with \b errno set.
+ * \par Errors
+ * from underlying calls, in exceptional circumstances
  */
 struct nflog_handle *nflog_open(void)
 {
@@ -335,7 +347,9 @@ int nflog_handle_packet(struct nflog_handle *h, char *buf, int len)
  *
  * This function closes the nflog handler and free associated resources.
  *
- * \return 0 on success, non-zero on failure.
+ * \return 0 on success, -1 on failure with \b errno set.
+ * \par Errors
+ * as for __close__(2)
  */
 int nflog_close(struct nflog_handle *h)
 {
@@ -352,7 +366,9 @@ int nflog_close(struct nflog_handle *h)
  * Binds the given log connection handle to process packets belonging to
  * the given protocol family (ie. PF_INET, PF_INET6, etc).
  *
- * \return integer inferior to 0 in case of failure
+ * \return 0 on success, -1 on failure with \b errno set.
+ * \par Errors
+ * \b EOPNOTSUPP Not running as root
  */
 int nflog_bind_pf(struct nflog_handle *h, uint16_t pf)
 {
@@ -367,6 +383,9 @@ int nflog_bind_pf(struct nflog_handle *h, uint16_t pf)
  *
  * Unbinds the given nflog handle from processing packets belonging
  * to the given protocol family.
+ * \return 0 on success, -1 on failure with \b errno set.
+ * \par Errors
+ * \b EOPNOTSUPP Not running as root
  */
 int nflog_unbind_pf(struct nflog_handle *h, uint16_t pf)
 {
@@ -387,15 +406,22 @@ int nflog_unbind_pf(struct nflog_handle *h, uint16_t pf)
  * \param h Netfilter log handle obtained via call to nflog_open()
  * \param num the number of the group to bind to
  *
- * \return a nflog_g_handle pointing to the newly created group
+ * \return an nflog_g_handle for the newly created group or NULL on failure.
+ * \par Errors
+ * \b EBUSY This process has already binded to the group
+ * \n
+ * \b EOPNOTSUPP Request rejected by kernel. Another process has already
+ * binded to the group, or this process is not running as root
  */
 struct nflog_g_handle *
 nflog_bind_group(struct nflog_handle *h, uint16_t num)
 {
 	struct nflog_g_handle *gh;
 
-	if (find_gh(h, num))
+	if (find_gh(h, num)) {
+		errno = EBUSY;
 		return NULL;
+	}
 
 	gh = calloc(1, sizeof(*gh));
 	if (!gh)
@@ -426,7 +452,9 @@ nflog_bind_group(struct nflog_handle *h, uint16_t num)
  * nflog_unbind_group - unbind a group handle.
  * \param gh Netfilter log group handle obtained via nflog_bind_group()
  *
- * \return -1 in case of error and errno is explicity in case of error.
+ * \return 0 on success, -1 on failure with \b errno set.
+ * \par Errors
+ * from underlying calls, in exceptional circumstances
  */
 int nflog_unbind_group(struct nflog_g_handle *gh)
 {
@@ -441,7 +469,7 @@ int nflog_unbind_group(struct nflog_g_handle *gh)
 
 /**
  * nflog_set_mode - set the amount of packet data that nflog copies to userspace
- * \param gh Netfilter log handle obtained by call to nflog_bind_group().
+ * \param gh Netfilter log group handle obtained by call to nflog_bind_group().
  * \param mode the part of the packet that we are interested in
  * \param range size of the packet that we want to get
  *
@@ -452,7 +480,9 @@ int nflog_unbind_group(struct nflog_g_handle *gh)
  * - NFULNL_COPY_META - copy only packet metadata
  * - NFULNL_COPY_PACKET - copy entire packet
  *
- * \return -1 on error; >= otherwise.
+ * \return 0 on success, -1 on failure with \b errno set.
+ * \par Errors
+ * from underlying calls, in exceptional circumstances
  */
 int nflog_set_mode(struct nflog_g_handle *gh,
 		   uint8_t mode, uint32_t range)
@@ -477,7 +507,7 @@ int nflog_set_mode(struct nflog_g_handle *gh,
 
 /**
  * nflog_set_timeout - set the maximum time to push log buffer for this group
- * \param gh Netfilter log handle obtained by call to nflog_bind_group().
+ * \param gh Netfilter log group handle obtained by call to nflog_bind_group().
  * \param timeout Time to wait until the log buffer is pushed to userspace
  *
  * This function allows to set the maximum time that nflog waits until it
@@ -485,7 +515,9 @@ int nflog_set_mode(struct nflog_g_handle *gh,
  * Basically, nflog implements a buffer to reduce the computational cost
  * of delivering the log message to userspace.
  *
- * \return -1 in case of error and errno is explicity set.
+ * \return 0 on success, -1 on failure with \b errno set.
+ * \par Errors
+ * from underlying calls, in exceptional circumstances
  */
 int nflog_set_timeout(struct nflog_g_handle *gh, uint32_t timeout)
 {
@@ -504,13 +536,15 @@ int nflog_set_timeout(struct nflog_g_handle *gh, uint32_t timeout)
 
 /**
  * nflog_set_qthresh - set the maximum amount of logs in buffer for this group
- * \param gh Netfilter log handle obtained by call to nflog_bind_group().
+ * \param gh Netfilter log group handle obtained by call to nflog_bind_group().
  * \param qthresh Maximum number of log entries
  *
  * This function determines the maximum number of log entries in the buffer
  * until it is pushed to userspace.
  *
- * \return -1 in case of error and errno is explicity set.
+ * \return 0 on success, -1 on failure with \b errno set.
+ * \par Errors
+ * from underlying calls, in exceptional circumstances
  */
 int nflog_set_qthresh(struct nflog_g_handle *gh, uint32_t qthresh)
 {
@@ -529,17 +563,19 @@ int nflog_set_qthresh(struct nflog_g_handle *gh, uint32_t qthresh)
 
 /**
  * nflog_set_nlbufsiz - set the size of the nflog buffer for this group
- * \param gh Netfilter log handle obtained by call to nflog_bind_group().
+ * \param gh Netfilter log group handle obtained by call to nflog_bind_group().
  * \param nlbufsiz Size of the nflog buffer
  *
  * This function sets the size (in bytes) of the buffer that is used to
  * stack log messages in nflog.
  *
- * NOTE: The use of this function is strongly discouraged. The default
+ * \warning The use of this function is strongly discouraged. The default
  * buffer size (which is one memory page) provides the optimum results
  * in terms of performance. Do not use this function in your applications.
  *
- * \return -1 in case of error and errno is explicity set.
+ * \return 0 on success, -1 on failure with \b errno set.
+ * \par Errors
+ * from underlying calls, in exceptional circumstances
  */
 int nflog_set_nlbufsiz(struct nflog_g_handle *gh, uint32_t nlbufsiz)
 {
@@ -565,7 +601,7 @@ int nflog_set_nlbufsiz(struct nflog_g_handle *gh, uint32_t nlbufsiz)
 
 /**
  * nflog_set_flags - set the nflog flags for this group
- * \param gh Netfilter log handle obtained by call to nflog_bind_group().
+ * \param gh Netfilter log group handle obtained by call to nflog_bind_group().
  * \param flags Flags that you want to set
  *
  * There are two existing flags:
@@ -573,7 +609,9 @@ int nflog_set_nlbufsiz(struct nflog_g_handle *gh, uint32_t nlbufsiz)
  *	- NFULNL_CFG_F_SEQ: This enables local nflog sequence numbering.
  *	- NFULNL_CFG_F_SEQ_GLOBAL: This enables global nflog sequence numbering.
  *
- * \return -1 in case of error and errno is explicity set.
+ * \return 0 on success, -1 on failure with \b errno set.
+ * \par Errors
+ * from underlying calls, in exceptional circumstances
  */
 int nflog_set_flags(struct nflog_g_handle *gh, uint16_t flags)
 {
@@ -671,9 +709,11 @@ uint32_t nflog_get_nfmark(struct nflog_data *nfad)
  * \param nfad Netlink packet data handle passed to callback function
  * \param tv structure to fill with timestamp info
  *
- * Retrieves the received timestamp when the given logged packet.
+ * Retrieves the received timestamp from the given logged packet.
  *
- * \return 0 on success, a negative value on failure.
+ * \return 0 on success, -1 on failure with \b errno set.
+ * \par Errors
+ * from underlying calls, in exceptional circumstances
  */
 int nflog_get_timestamp(struct nflog_data *nfad, struct timeval *tv)
 {
@@ -698,8 +738,8 @@ int nflog_get_timestamp(struct nflog_data *nfad, struct timeval *tv)
  * returned index is 0, the packet was locally generated or the input
  * interface is not known (ie. POSTROUTING?).
  *
- * \warning all nflog_get_dev() functions return 0 if not set, since linux
- * only allows ifindex >= 1, see net/core/dev.c:2600  (in 2.6.13.1)
+ * \warning all nflog_get_dev() functions return 0 if not set, since Linux
+ * only allows ifindex >= 1, see net/core/dev.c:9819  (in 5.14.3)
  */
 uint32_t nflog_get_indev(struct nflog_data *nfad)
 {
@@ -782,7 +822,7 @@ struct nfulnl_msg_packet_hw *nflog_get_packet_hw(struct nflog_data *nfad)
  * data retrieved by this function will depend on the mode set with the
  * nflog_set_mode() function.
  *
- * \return -1 on error, otherwise > 0.
+ * \return payload length, or -1 if this is not available
  */
 int nflog_get_payload(struct nflog_data *nfad, char **data)
 {
@@ -798,7 +838,7 @@ int nflog_get_payload(struct nflog_data *nfad, char **data)
  * \param nfad Netlink packet data handle passed to callback function
  *
  * \return the string prefix that is specified as argument to the iptables'
- * NFLOG target.
+ * NFLOG target or NULL if this is not available.
  */
 char *nflog_get_prefix(struct nflog_data *nfad)
 {
@@ -919,11 +959,13 @@ do {								\
  *	- NFLOG_XML_TIME: include the timestamp
  *	- NFLOG_XML_ALL: include all the logging information (all flags set)
  *
- * You can combine this flags with an binary OR.
+ * You can combine these flags with a bitwise OR.
  *
  * \return -1 in case of failure, otherwise the length of the string that
  * would have been printed into the buffer (in case that there is enough
  * room in it). See snprintf() return value for more information.
+ * \par Errors
+ * from underlying calls, in exceptional circumstances
  */
 int nflog_snprintf_xml(char *buf, size_t rem, struct nflog_data *tb, int flags)
 {
-- 
2.17.5

