From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 03/13] src: add const qualifiers
Date: Sat, 23 Oct 2010 07:44:40 +0200
Message-ID: <1287812691-14470-4-git-send-email-jengelh@medozas.de>
References: <1287812691-14470-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55095 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495Ab0JWFpC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Oct 2010 01:45:02 -0400
In-Reply-To: <1287812691-14470-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 src/attr.c     |    8 ++++----
 src/callback.c |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/src/attr.c b/src/attr.c
index 9c17f4d..cafd2c7 100644
--- a/src/attr.c
+++ b/src/attr.c
@@ -138,7 +138,7 @@ static int __mnl_attr_validate(const struct nlattr *attr,
 			       enum mnl_attr_data_type type, size_t exp_len)
 {
 	uint16_t attr_len = mnl_attr_get_payload_len(attr);
-	char *attr_data = mnl_attr_get_payload(attr);
+	const char *attr_data = mnl_attr_get_payload(attr);
 
 	if (attr_len < exp_len) {
 		errno = ERANGE;
@@ -188,7 +188,7 @@ static int __mnl_attr_validate(const struct nlattr *attr,
 	return 0;
 }
 
-static size_t mnl_attr_data_type_len[MNL_TYPE_MAX] = {
+static const size_t mnl_attr_data_type_len[MNL_TYPE_MAX] = {
 	[MNL_TYPE_U8]		= sizeof(uint8_t),
 	[MNL_TYPE_U16]		= sizeof(uint16_t),
 	[MNL_TYPE_U32]		= sizeof(uint32_t),
@@ -255,7 +255,7 @@ int mnl_attr_parse(const struct nlmsghdr *nlh, unsigned int offset,
 		   mnl_attr_cb_t cb, void *data)
 {
 	int ret = MNL_CB_OK;
-	struct nlattr *attr = mnl_nlmsg_get_payload_offset(nlh, offset);
+	const struct nlattr *attr = mnl_nlmsg_get_payload_offset(nlh, offset);
 	int len = nlh->nlmsg_len - MNL_NLMSG_HDRLEN - MNL_ALIGN(offset);
 
 	while (mnl_attr_ok(attr, len)) {
@@ -284,7 +284,7 @@ int mnl_attr_parse_nested(const struct nlattr *nested,
 			  mnl_attr_cb_t cb, void *data)
 {
 	int ret = MNL_CB_OK;
-	struct nlattr *attr = mnl_attr_get_payload(nested);
+	const struct nlattr *attr = mnl_attr_get_payload(nested);
 	int len = mnl_attr_get_payload_len(nested);
 
 	while (mnl_attr_ok(attr, len)) {
diff --git a/src/callback.c b/src/callback.c
index e1599ff..f5a6112 100644
--- a/src/callback.c
+++ b/src/callback.c
@@ -37,7 +37,7 @@ static int mnl_cb_stop(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_STOP;
 }
 
-static mnl_cb_t default_cb_array[NLMSG_MIN_TYPE] = {
+static const mnl_cb_t default_cb_array[NLMSG_MIN_TYPE] = {
 	[NLMSG_NOOP]	= mnl_cb_noop,
 	[NLMSG_ERROR]	= mnl_cb_error,
 	[NLMSG_DONE]	= mnl_cb_stop,
-- 
1.7.1

