From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libmnl] src: cleanup function definitions
Date: Fri,  1 Jul 2016 15:53:23 +0200
Message-ID: <1467381203-4390-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55844 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbcGANxj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Jul 2016 09:53:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 42E4F1B1DED
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Jul 2016 15:53:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2F1B1FAB45
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Jul 2016 15:53:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8128BFAB46
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Jul 2016 15:53:27 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Place the returned value, function name and parameters (as many as can
fit) in the same line.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/attr.c     | 69 ++++++++++++++++++++++++----------------------------------
 src/callback.c | 21 +++++++++---------
 src/nlmsg.c    | 25 ++++++++-------------
 src/socket.c   |  8 +++----
 4 files changed, 51 insertions(+), 72 deletions(-)

diff --git a/src/attr.c b/src/attr.c
index 5b418b0..4f13187 100644
--- a/src/attr.c
+++ b/src/attr.c
@@ -235,9 +235,8 @@ int mnl_attr_validate(const struct nlattr *attr, enum mnl_attr_data_type type)
  * this functions returns -1 and errno is explicitly set.
  */
 EXPORT_SYMBOL(mnl_attr_validate2);
-int
-mnl_attr_validate2(const struct nlattr *attr, enum mnl_attr_data_type type,
-		   size_t exp_len)
+int mnl_attr_validate2(const struct nlattr *attr, enum mnl_attr_data_type type,
+		       size_t exp_len)
 {
 	if (type >= MNL_TYPE_MAX) {
 		errno = EINVAL;
@@ -262,9 +261,8 @@ mnl_attr_validate2(const struct nlattr *attr, enum mnl_attr_data_type type,
  * MNL_CB_ERROR, MNL_CB_OK or MNL_CB_STOP.
  */
 EXPORT_SYMBOL(mnl_attr_parse);
-int
-mnl_attr_parse(const struct nlmsghdr *nlh, unsigned int offset,
-	       mnl_attr_cb_t cb, void *data)
+int mnl_attr_parse(const struct nlmsghdr *nlh, unsigned int offset,
+		   mnl_attr_cb_t cb, void *data)
 {
 	int ret = MNL_CB_OK;
 	const struct nlattr *attr;
@@ -290,9 +288,8 @@ mnl_attr_parse(const struct nlmsghdr *nlh, unsigned int offset,
  * MNL_CB_ERROR, MNL_CB_OK or MNL_CB_STOP.
  */
 EXPORT_SYMBOL(mnl_attr_parse_nested);
-int
-mnl_attr_parse_nested(const struct nlattr *nested, mnl_attr_cb_t cb,
-		      void *data)
+int mnl_attr_parse_nested(const struct nlattr *nested, mnl_attr_cb_t cb,
+			  void *data)
 {
 	int ret = MNL_CB_OK;
 	const struct nlattr *attr;
@@ -323,9 +320,8 @@ mnl_attr_parse_nested(const struct nlattr *nested, mnl_attr_cb_t cb,
  * MNL_CB_ERROR, MNL_CB_OK or MNL_CB_STOP.
  */
 EXPORT_SYMBOL(mnl_attr_parse_payload);
-int
-mnl_attr_parse_payload(const void *payload, size_t payload_len,
-		       mnl_attr_cb_t cb, void *data)
+int mnl_attr_parse_payload(const void *payload, size_t payload_len,
+			   mnl_attr_cb_t cb, void *data)
 {
 	int ret = MNL_CB_OK;
 	const struct nlattr *attr;
@@ -411,8 +407,8 @@ const char *mnl_attr_get_str(const struct nlattr *attr)
  * by adding the size (header + payload) of the new attribute.
  */
 EXPORT_SYMBOL(mnl_attr_put);
-void
-mnl_attr_put(struct nlmsghdr *nlh, uint16_t type, size_t len, const void *data)
+void mnl_attr_put(struct nlmsghdr *nlh, uint16_t type, size_t len,
+		  const void *data)
 {
 	struct nlattr *attr = mnl_nlmsg_get_payload_tail(nlh);
 	uint16_t payload_len = MNL_ALIGN(sizeof(struct nlattr)) + len;
@@ -552,9 +548,8 @@ struct nlattr *mnl_attr_nest_start(struct nlmsghdr *nlh, uint16_t type)
  * to the message, otherwise false is returned.
  */
 EXPORT_SYMBOL(mnl_attr_put_check);
-bool
-mnl_attr_put_check(struct nlmsghdr *nlh, size_t buflen,
-		   uint16_t type, size_t len, const void *data)
+bool mnl_attr_put_check(struct nlmsghdr *nlh, size_t buflen,
+			uint16_t type, size_t len, const void *data)
 {
 	if (nlh->nlmsg_len + MNL_ATTR_HDRLEN + MNL_ALIGN(len) > buflen)
 		return false;
@@ -576,9 +571,8 @@ mnl_attr_put_check(struct nlmsghdr *nlh, size_t buflen,
  * to the message, otherwise false is returned.
  */
 EXPORT_SYMBOL(mnl_attr_put_u8_check);
-bool
-mnl_attr_put_u8_check(struct nlmsghdr *nlh, size_t buflen,
-		      uint16_t type, uint8_t data)
+bool mnl_attr_put_u8_check(struct nlmsghdr *nlh, size_t buflen,
+			   uint16_t type, uint8_t data)
 {
 	return mnl_attr_put_check(nlh, buflen, type, sizeof(uint8_t), &data);
 }
@@ -599,9 +593,8 @@ mnl_attr_put_u8_check(struct nlmsghdr *nlh, size_t buflen,
  * by adding the size (header + payload) of the new attribute.
  */
 EXPORT_SYMBOL(mnl_attr_put_u16_check);
-bool
-mnl_attr_put_u16_check(struct nlmsghdr *nlh, size_t buflen,
-		       uint16_t type, uint16_t data)
+bool mnl_attr_put_u16_check(struct nlmsghdr *nlh, size_t buflen,
+			    uint16_t type, uint16_t data)
 {
 	return mnl_attr_put_check(nlh, buflen, type, sizeof(uint16_t), &data);
 }
@@ -622,9 +615,8 @@ mnl_attr_put_u16_check(struct nlmsghdr *nlh, size_t buflen,
  * by adding the size (header + payload) of the new attribute.
  */
 EXPORT_SYMBOL(mnl_attr_put_u32_check);
-bool
-mnl_attr_put_u32_check(struct nlmsghdr *nlh, size_t buflen,
-		       uint16_t type, uint32_t data)
+bool mnl_attr_put_u32_check(struct nlmsghdr *nlh, size_t buflen,
+			    uint16_t type, uint32_t data)
 {
 	return mnl_attr_put_check(nlh, buflen, type, sizeof(uint32_t), &data);
 }
@@ -645,9 +637,8 @@ mnl_attr_put_u32_check(struct nlmsghdr *nlh, size_t buflen,
  * by adding the size (header + payload) of the new attribute.
  */
 EXPORT_SYMBOL(mnl_attr_put_u64_check);
-bool
-mnl_attr_put_u64_check(struct nlmsghdr *nlh, size_t buflen,
-		       uint16_t type, uint64_t data)
+bool mnl_attr_put_u64_check(struct nlmsghdr *nlh, size_t buflen,
+			    uint16_t type, uint64_t data)
 {
 	return mnl_attr_put_check(nlh, buflen, type, sizeof(uint64_t), &data);
 }
@@ -668,9 +659,8 @@ mnl_attr_put_u64_check(struct nlmsghdr *nlh, size_t buflen,
  * by adding the size (header + payload) of the new attribute.
  */
 EXPORT_SYMBOL(mnl_attr_put_str_check);
-bool
-mnl_attr_put_str_check(struct nlmsghdr *nlh, size_t buflen,
-		       uint16_t type, const char *data)
+bool mnl_attr_put_str_check(struct nlmsghdr *nlh, size_t buflen,
+			    uint16_t type, const char *data)
 {
 	return mnl_attr_put_check(nlh, buflen, type, strlen(data), data);
 }
@@ -692,9 +682,8 @@ mnl_attr_put_str_check(struct nlmsghdr *nlh, size_t buflen,
  * to the message, otherwise false is returned.
  */
 EXPORT_SYMBOL(mnl_attr_put_strz_check);
-bool
-mnl_attr_put_strz_check(struct nlmsghdr *nlh, size_t buflen,
-			uint16_t type, const char *data)
+bool mnl_attr_put_strz_check(struct nlmsghdr *nlh, size_t buflen,
+			     uint16_t type, const char *data)
 {
 	return mnl_attr_put_check(nlh, buflen, type, strlen(data)+1, data);
 }
@@ -710,8 +699,8 @@ mnl_attr_put_strz_check(struct nlmsghdr *nlh, size_t buflen,
  * otherwise valid pointer to the beginning of the nest is returned.
  */
 EXPORT_SYMBOL(mnl_attr_nest_start_check);
-struct nlattr *
-mnl_attr_nest_start_check(struct nlmsghdr *nlh, size_t buflen, uint16_t type)
+struct nlattr *mnl_attr_nest_start_check(struct nlmsghdr *nlh, size_t buflen,
+					 uint16_t type)
 {
 	if (nlh->nlmsg_len + MNL_ATTR_HDRLEN > buflen)
 		return NULL;
@@ -726,8 +715,7 @@ mnl_attr_nest_start_check(struct nlmsghdr *nlh, size_t buflen, uint16_t type)
  * This function updates the attribute header that identifies the nest.
  */
 EXPORT_SYMBOL(mnl_attr_nest_end);
-void
-mnl_attr_nest_end(struct nlmsghdr *nlh, struct nlattr *start)
+void mnl_attr_nest_end(struct nlmsghdr *nlh, struct nlattr *start)
 {
 	start->nla_len = mnl_nlmsg_get_payload_tail(nlh) - (void *)start;
 }
@@ -740,8 +728,7 @@ mnl_attr_nest_end(struct nlmsghdr *nlh, struct nlattr *start)
  * This function updates the attribute header that identifies the nest.
  */
 EXPORT_SYMBOL(mnl_attr_nest_cancel);
-void
-mnl_attr_nest_cancel(struct nlmsghdr *nlh, struct nlattr *start)
+void mnl_attr_nest_cancel(struct nlmsghdr *nlh, struct nlattr *start)
 {
 	nlh->nlmsg_len -= mnl_nlmsg_get_payload_tail(nlh) - (void *)start;
 }
diff --git a/src/callback.c b/src/callback.c
index beaeb59..00ffcf4 100644
--- a/src/callback.c
+++ b/src/callback.c
@@ -45,10 +45,11 @@ static const mnl_cb_t default_cb_array[NLMSG_MIN_TYPE] = {
 	[NLMSG_OVERRUN]	= mnl_cb_noop,
 };
 
-static inline int
-__mnl_cb_run(const void *buf, size_t numbytes, unsigned int seq,
-	     unsigned int portid, mnl_cb_t cb_data, void *data,
-	     mnl_cb_t *cb_ctl_array, unsigned int cb_ctl_array_len)
+static inline int __mnl_cb_run(const void *buf, size_t numbytes,
+			       unsigned int seq, unsigned int portid,
+			       mnl_cb_t cb_data, void *data,
+			       mnl_cb_t *cb_ctl_array,
+			       unsigned int cb_ctl_array_len)
 {
 	int ret = MNL_CB_OK, len = numbytes;
 	const struct nlmsghdr *nlh = buf;
@@ -127,10 +128,9 @@ out:
  * request a new fresh dump again.
  */
 EXPORT_SYMBOL(mnl_cb_run2);
-int
-mnl_cb_run2(const void *buf, size_t numbytes, unsigned int seq,
-	    unsigned int portid, mnl_cb_t cb_data, void *data,
-	    mnl_cb_t *cb_ctl_array, unsigned int cb_ctl_array_len)
+int mnl_cb_run2(const void *buf, size_t numbytes, unsigned int seq,
+		unsigned int portid, mnl_cb_t cb_data, void *data,
+		mnl_cb_t *cb_ctl_array, unsigned int cb_ctl_array_len)
 {
 	return __mnl_cb_run(buf, numbytes, seq, portid, cb_data, data,
 			    cb_ctl_array, cb_ctl_array_len);
@@ -156,9 +156,8 @@ mnl_cb_run2(const void *buf, size_t numbytes, unsigned int seq,
  * This function propagates the callback return value.
  */
 EXPORT_SYMBOL(mnl_cb_run);
-int
-mnl_cb_run(const void *buf, size_t numbytes, unsigned int seq,
-	   unsigned int portid, mnl_cb_t cb_data, void *data)
+int mnl_cb_run(const void *buf, size_t numbytes, unsigned int seq,
+	       unsigned int portid, mnl_cb_t cb_data, void *data)
 {
 	return __mnl_cb_run(buf, numbytes, seq, portid, cb_data, data, NULL, 0);
 }
diff --git a/src/nlmsg.c b/src/nlmsg.c
index 43189b9..f9448a5 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -102,8 +102,7 @@ struct nlmsghdr *mnl_nlmsg_put_header(void *buf)
  * header.
  */
 EXPORT_SYMBOL(mnl_nlmsg_put_extra_header);
-void *
-mnl_nlmsg_put_extra_header(struct nlmsghdr *nlh, size_t size)
+void *mnl_nlmsg_put_extra_header(struct nlmsghdr *nlh, size_t size)
 {
 	char *ptr = (char *)nlh + nlh->nlmsg_len;
 	size_t len = MNL_ALIGN(size);
@@ -133,8 +132,7 @@ void *mnl_nlmsg_get_payload(const struct nlmsghdr *nlh)
  * a given offset.
  */
 EXPORT_SYMBOL(mnl_nlmsg_get_payload_offset);
-void *
-mnl_nlmsg_get_payload_offset(const struct nlmsghdr *nlh, size_t offset)
+void *mnl_nlmsg_get_payload_offset(const struct nlmsghdr *nlh, size_t offset)
 {
 	return (void *)nlh + MNL_NLMSG_HDRLEN + MNL_ALIGN(offset);
 }
@@ -177,8 +175,7 @@ bool mnl_nlmsg_ok(const struct nlmsghdr *nlh, int len)
  * valid.
  */
 EXPORT_SYMBOL(mnl_nlmsg_next);
-struct nlmsghdr *
-mnl_nlmsg_next(const struct nlmsghdr *nlh, int *len)
+struct nlmsghdr *mnl_nlmsg_next(const struct nlmsghdr *nlh, int *len)
 {
 	*len -= MNL_ALIGN(nlh->nlmsg_len);
 	return (struct nlmsghdr *)((void *)nlh + MNL_ALIGN(nlh->nlmsg_len));
@@ -213,8 +210,7 @@ void *mnl_nlmsg_get_payload_tail(const struct nlmsghdr *nlh)
  * listen to events (that we do not track).
  */
 EXPORT_SYMBOL(mnl_nlmsg_seq_ok);
-bool
-mnl_nlmsg_seq_ok(const struct nlmsghdr *nlh, unsigned int seq)
+bool mnl_nlmsg_seq_ok(const struct nlmsghdr *nlh, unsigned int seq)
 {
 	return nlh->nlmsg_seq && seq ? nlh->nlmsg_seq == seq : true;
 }
@@ -234,8 +230,7 @@ mnl_nlmsg_seq_ok(const struct nlmsghdr *nlh, unsigned int seq)
  * do not track).
  */
 EXPORT_SYMBOL(mnl_nlmsg_portid_ok);
-bool
-mnl_nlmsg_portid_ok(const struct nlmsghdr *nlh, unsigned int portid)
+bool mnl_nlmsg_portid_ok(const struct nlmsghdr *nlh, unsigned int portid)
 {
 	return nlh->nlmsg_pid && portid ? nlh->nlmsg_pid == portid : true;
 }
@@ -255,9 +250,8 @@ static void mnl_nlmsg_fprintf_header(FILE *fd, const struct nlmsghdr *nlh)
 	fprintf(fd, "----------------\t------------------\n");
 }
 
-static void
-mnl_nlmsg_fprintf_payload(FILE *fd, const struct nlmsghdr *nlh,
-			  size_t extra_header_size)
+static void mnl_nlmsg_fprintf_payload(FILE *fd, const struct nlmsghdr *nlh,
+				      size_t extra_header_size)
 {
 	int rem = 0;
 	unsigned int i;
@@ -370,9 +364,8 @@ mnl_nlmsg_fprintf_payload(FILE *fd, const struct nlmsghdr *nlh,
  * - B, that indicates that NLA_F_NET_BYTEORDER is set.
  */
 EXPORT_SYMBOL(mnl_nlmsg_fprintf);
-void
-mnl_nlmsg_fprintf(FILE *fd, const void *data, size_t datalen,
-		  size_t extra_header_size)
+void mnl_nlmsg_fprintf(FILE *fd, const void *data, size_t datalen,
+		       size_t extra_header_size)
 {
 	const struct nlmsghdr *nlh = data;
 	int len = datalen;
diff --git a/src/socket.c b/src/socket.c
index cc22f5b..31d6fbe 100644
--- a/src/socket.c
+++ b/src/socket.c
@@ -235,8 +235,8 @@ int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups, pid_t pid)
  * returns the number of bytes sent.
  */
 EXPORT_SYMBOL(mnl_socket_sendto);
-ssize_t
-mnl_socket_sendto(const struct mnl_socket *nl, const void *buf, size_t len)
+ssize_t mnl_socket_sendto(const struct mnl_socket *nl, const void *buf,
+			  size_t len)
 {
 	static const struct sockaddr_nl snl = {
 		.nl_family = AF_NETLINK
@@ -260,8 +260,8 @@ mnl_socket_sendto(const struct mnl_socket *nl, const void *buf, size_t len)
  * message without truncating it.
  */
 EXPORT_SYMBOL(mnl_socket_recvfrom);
-ssize_t
-mnl_socket_recvfrom(const struct mnl_socket *nl, void *buf, size_t bufsiz)
+ssize_t mnl_socket_recvfrom(const struct mnl_socket *nl, void *buf,
+			    size_t bufsiz)
 {
 	ssize_t ret;
 	struct sockaddr_nl addr;
-- 
2.1.4

