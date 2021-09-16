Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83A61C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Sep 2021 03:52:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6562C61165
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Sep 2021 03:52:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234179AbhIPDyC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Sep 2021 23:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232217AbhIPDyB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Sep 2021 23:54:01 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B298C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Sep 2021 20:52:42 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id c1so1737338pfp.10
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Sep 2021 20:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q70lojcpAK1sigofqZxkl8PBHhdksG9Uq7e8nbjXpaA=;
        b=aCJUS8gWNho7ys1BsBmthOIGW4FFMZEjX0DKgy2Bl0+HLT2NIOAH7Ls5PpIfApaBwM
         bBqQ1vDtZqzGfmOXyDjDlnbyqZQy6TYUTSVwnKqn88R2jh7jK7wBPZQI3cq7Y4GuELZY
         9kRPOTWDUzKaibl5QRjgGbSLdd09VYlWxmAQmS5PxDOZnB3SIEdCOI+b/+lvKSwj+jAy
         qMUMrFzhZpruQcE8YL0YRVFkyL55OMyNoE4+A+BJ8tswwNjkzyDp2+Ty7I7qC13Ruk7r
         Zs8QWdXWfH7RmhL1NhaqEW5NZgIt5zMYsncsMJXVUIfGV8J1V9TQVsG2KqYp5q7OqHTH
         lRrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=Q70lojcpAK1sigofqZxkl8PBHhdksG9Uq7e8nbjXpaA=;
        b=dt9YxUC+60LjqsB2LKEm9On5oFqJj89k9a+6zBsWKJqfc8E08hffu61bJKYKhx2g04
         epI1ftrZC504YNoRgKi6kQ6C0RPe0aMYXT7E3U5nz+jH4mAqst7MjYM7z3odS9YM2wfg
         DhXp7sbAiIvDdXpvJzpk6tGVHeQf6wFF1IHjO+SE4bn0t6VA+XFg6U0p4/w4kbM0v6dK
         maZTeMBfX11Nu/2l3wFBX4HLp6Vd35Pwt2KwEy+lUrag6AzH/5sT6pyqdMYPFHFbbRaR
         15RJ5TjuseMqeRsp24rk7Iao+wUJ6CzgwFW7z+RmBO48F3N7wLdYquaV+/4CdTBfgSel
         fIxg==
X-Gm-Message-State: AOAM533dVVtEJJnw9wfl//rXhTwXzRYnc7uSo0tn0Rc+i+gLsBfxG4nG
        zjMWvVye32voqgjR6n3gXg778+KclD0=
X-Google-Smtp-Source: ABdhPJwCut0HJasop7Y/tCpwl/be+l2FQOXPO09IocB0H0qeMPsOVPnfD4RPuDb4fWl7p77dhtfgxQ==
X-Received: by 2002:a05:6a00:1694:b0:440:3c9a:ea68 with SMTP id k20-20020a056a00169400b004403c9aea68mr3374860pfc.84.1631764361461;
        Wed, 15 Sep 2021 20:52:41 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id h127sm1146918pfe.191.2021.09.15.20.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 20:52:40 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_log] src: doc: revise doxygen for all other modules
Date:   Thu, 16 Sep 2021 13:52:36 +1000
Message-Id: <20210916035236.14327-1-duncan_roe@optusnet.com.au>
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
 src/libnetfilter_log.c | 98 +++++++++++++++++++++++++++++-------------
 1 file changed, 69 insertions(+), 29 deletions(-)

diff --git a/src/libnetfilter_log.c b/src/libnetfilter_log.c
index 546d667..cd37879 100644
--- a/src/libnetfilter_log.c
+++ b/src/libnetfilter_log.c
@@ -207,8 +207,19 @@ struct nfnl_handle *nflog_nfnlh(struct nflog_handle *h)
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
+\fBParsing\fP man page (\fBman nflog_get_gid\fP)
+.RE
+.PP
+\endmanonly
  * @{
  */
 
@@ -220,9 +231,6 @@ struct nfnl_handle *nflog_nfnlh(struct nflog_handle *h)
  * given log connection handle. The file descriptor can then be used for
  * receiving the logged packets for processing.
  *
- * This function returns a file descriptor that can be used for communication
- * over the netlink connection associated with the given log connection
- * handle.
  */
 int nflog_fd(struct nflog_handle *h)
 {
@@ -279,7 +287,9 @@ out_free:
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
@@ -335,7 +345,9 @@ int nflog_handle_packet(struct nflog_handle *h, char *buf, int len)
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
@@ -352,7 +364,9 @@ int nflog_close(struct nflog_handle *h)
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
@@ -367,6 +381,9 @@ int nflog_bind_pf(struct nflog_handle *h, uint16_t pf)
  *
  * Unbinds the given nflog handle from processing packets belonging
  * to the given protocol family.
+ * \return 0 on success, -1 on failure with \b errno set.
+ * \par Errors
+ * \b EOPNOTSUPP Not running as root
  */
 int nflog_unbind_pf(struct nflog_handle *h, uint16_t pf)
 {
@@ -387,15 +404,22 @@ int nflog_unbind_pf(struct nflog_handle *h, uint16_t pf)
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
@@ -426,7 +450,9 @@ nflog_bind_group(struct nflog_handle *h, uint16_t num)
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
@@ -441,7 +467,7 @@ int nflog_unbind_group(struct nflog_g_handle *gh)
 
 /**
  * nflog_set_mode - set the amount of packet data that nflog copies to userspace
- * \param gh Netfilter log handle obtained by call to nflog_bind_group().
+ * \param gh Netfilter log group handle obtained by call to nflog_bind_group().
  * \param mode the part of the packet that we are interested in
  * \param range size of the packet that we want to get
  *
@@ -452,7 +478,9 @@ int nflog_unbind_group(struct nflog_g_handle *gh)
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
@@ -477,7 +505,7 @@ int nflog_set_mode(struct nflog_g_handle *gh,
 
 /**
  * nflog_set_timeout - set the maximum time to push log buffer for this group
- * \param gh Netfilter log handle obtained by call to nflog_bind_group().
+ * \param gh Netfilter log group handle obtained by call to nflog_bind_group().
  * \param timeout Time to wait until the log buffer is pushed to userspace
  *
  * This function allows to set the maximum time that nflog waits until it
@@ -485,7 +513,9 @@ int nflog_set_mode(struct nflog_g_handle *gh,
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
@@ -504,13 +534,15 @@ int nflog_set_timeout(struct nflog_g_handle *gh, uint32_t timeout)
 
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
@@ -529,17 +561,19 @@ int nflog_set_qthresh(struct nflog_g_handle *gh, uint32_t qthresh)
 
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
@@ -565,7 +599,7 @@ int nflog_set_nlbufsiz(struct nflog_g_handle *gh, uint32_t nlbufsiz)
 
 /**
  * nflog_set_flags - set the nflog flags for this group
- * \param gh Netfilter log handle obtained by call to nflog_bind_group().
+ * \param gh Netfilter log group handle obtained by call to nflog_bind_group().
  * \param flags Flags that you want to set
  *
  * There are two existing flags:
@@ -573,7 +607,9 @@ int nflog_set_nlbufsiz(struct nflog_g_handle *gh, uint32_t nlbufsiz)
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
@@ -671,9 +707,11 @@ uint32_t nflog_get_nfmark(struct nflog_data *nfad)
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
@@ -698,8 +736,8 @@ int nflog_get_timestamp(struct nflog_data *nfad, struct timeval *tv)
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
@@ -782,7 +820,7 @@ struct nfulnl_msg_packet_hw *nflog_get_packet_hw(struct nflog_data *nfad)
  * data retrieved by this function will depend on the mode set with the
  * nflog_set_mode() function.
  *
- * \return -1 on error, otherwise > 0.
+ * \return payload length, or -1 if this is not available
  */
 int nflog_get_payload(struct nflog_data *nfad, char **data)
 {
@@ -798,7 +836,7 @@ int nflog_get_payload(struct nflog_data *nfad, char **data)
  * \param nfad Netlink packet data handle passed to callback function
  *
  * \return the string prefix that is specified as argument to the iptables'
- * NFLOG target.
+ * NFLOG target or NULL if this is not available.
  */
 char *nflog_get_prefix(struct nflog_data *nfad)
 {
@@ -919,11 +957,13 @@ do {								\
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

