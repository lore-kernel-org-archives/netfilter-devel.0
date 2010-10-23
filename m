From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 06/13] doc: documentation updates
Date: Sat, 23 Oct 2010 07:44:43 +0200
Message-ID: <1287812691-14470-7-git-send-email-jengelh@medozas.de>
References: <1287812691-14470-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55113 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580Ab0JWFpG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Oct 2010 01:45:06 -0400
In-Reply-To: <1287812691-14470-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Spelling, grammer, and synchronization of the readme.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 README       |   10 +++++-----
 src/attr.c   |   17 +++++++++--------
 src/nlmsg.c  |    8 ++++----
 src/socket.c |   18 +++++++++---------
 4 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/README b/README
index ca7a820..fbac9d2 100644
--- a/README
+++ b/README
@@ -6,21 +6,21 @@ both the Netlink header and TLVs that are repetitive and easy to get wrong.
 This library aims to provide simple helpers that allows you to re-use code
 and to avoid re-inventing the wheel. The main features of this library are:
 
-* Small: the shared library requires around 30KB in a x86-based computer.
+* Small: the shared library requires around 30KB for an x86-based computer.
 * Simple: this library avoids complexity and elaborated abstractions that
 tend to hide Netlink details.
 * Easy to use: the library simplifies the work for Netlink-wise developers.
 It provides functions to make socket handling, message building, validating,
-parsing, and sequence tracking, easier.
+parsing and sequence tracking, easier.
 * Easy to re-use: you can use the library to build your own abstraction layer
 on top of this library.
 * Decoupling: the interdependency of the main bricks that compose the library
-is reduced, eg. the library provides many helpers but the programmer is not
+is reduced, i.e. the library provides many helpers, but the programmer is not
 forced to use them.
 
-= Examples files =
+= Example files =
 
-You can find several examples files under examples/ that you can compile by
+You can find several example files under examples/ that you can compile by
 invoking `make check'.
 
 --
diff --git a/src/attr.c b/src/attr.c
index fcb5e4a..f77f239 100644
--- a/src/attr.c
+++ b/src/attr.c
@@ -65,8 +65,9 @@ uint16_t mnl_attr_get_payload_len(const struct nlattr *attr)
 
 /**
  * mnl_attr_get_payload - get pointer to the attribute payload
+ * \param attr pointer to netlink attribute
  *
- * This function return a pointer to the attribute payload
+ * This function return a pointer to the attribute payload.
  */
 void *mnl_attr_get_payload(const struct nlattr *attr)
 {
@@ -75,11 +76,11 @@ void *mnl_attr_get_payload(const struct nlattr *attr)
 
 /**
  * mnl_attr_ok - check if there is room for an attribute in a buffer
- * \param nattr attribute that we want to check if there is room for
+ * \param attr attribute that we want to check if there is room for
  * \param len remaining bytes in a buffer that contains the attribute
  *
  * This function is used to check that a buffer, which is supposed to contain
- * an attribute, has enough room for the attribute that it stores, ie. this
+ * an attribute, has enough room for the attribute that it stores, i.e. this
  * function can be used to verify that an attribute is neither malformed nor
  * truncated.
  *
@@ -202,7 +203,7 @@ static const size_t mnl_attr_data_type_len[MNL_TYPE_MAX] = {
  *
  * The validation is based on the data type. Specifically, it checks that
  * integers (u8, u16, u32 and u64) have enough room for them. This function
- * returns -1 in case of error and errno is explicitly set.
+ * returns -1 in case of error, and errno is explicitly set.
  */
 int mnl_attr_validate(const struct nlattr *attr, enum mnl_attr_data_type type)
 {
@@ -248,7 +249,7 @@ int mnl_attr_validate2(const struct nlattr *attr,
  * usually happens at this stage or you can use any other data structure (such
  * as lists or trees).
  *
- * This function propagates the return value of the callback that can be
+ * This function propagates the return value of the callback, which can be
  * MNL_CB_ERROR, MNL_CB_OK or MNL_CB_STOP.
  */
 int mnl_attr_parse(const struct nlmsghdr *nlh, unsigned int offset,
@@ -277,7 +278,7 @@ int mnl_attr_parse(const struct nlmsghdr *nlh, unsigned int offset,
  * usually happens at this stage or you can use any other data structure (such
  * as lists or trees).
  *
- * This function propagates the return value of the callback that can be
+ * This function propagates the return value of the callback, which can be
  * MNL_CB_ERROR, MNL_CB_OK or MNL_CB_STOP.
  */
 int mnl_attr_parse_nested(const struct nlattr *nested,
@@ -333,7 +334,7 @@ uint32_t mnl_attr_get_u32(const struct nlattr *attr)
  * \param attr pointer to netlink attribute
  *
  * This function returns the 64-bit value of the attribute payload. This
- * function is align-safe since accessing 64-bit Netlink attributes is a
+ * function is align-safe, since accessing 64-bit Netlink attributes is a
  * common source of alignment issues.
  */
 uint64_t mnl_attr_get_u64(const struct nlattr *attr)
@@ -453,7 +454,7 @@ void mnl_attr_put_str(struct nlmsghdr *nlh, uint16_t type, const void *data)
  * \param type netlink attribute type
  * \param data pointer to string data that is stored by the new attribute
  *
- * This function is similar to mnl_attr_put_str but it includes the NULL
+ * This function is similar to mnl_attr_put_str, but it includes the NUL
  * terminator at the end of the string.
  *
  * This function updates the length field of the Netlink message (nlmsg_len)
diff --git a/src/nlmsg.c b/src/nlmsg.c
index 3cec2a2..535f4b5 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -219,10 +219,10 @@ int mnl_nlmsg_seq_ok(const struct nlmsghdr *nlh, unsigned int seq)
  * \param nlh current netlink message that we are handling
  * \param seq netlink portid that we want to check
  *
- * This functions return 1 if the origin is fulfilled, otherwise
+ * This functions returns 1 if the origin is fulfilled, otherwise
  * 0 is returned.  We skip the tracking for netlink message whose portID 
  * is zero since it is reserved for event-based kernel notifications. On the
- * other hand, if portid is set but the message PortID is not set (i.e. this
+ * other hand, if portid is set but the message PortID is not (i.e. this
  * is an event message coming from kernel-space), then we also skip the
  * tracking. This approach is good if we use the same socket to send commands
  * to kernel-space (that we want to track) and to listen to events (that we
@@ -237,8 +237,8 @@ int mnl_nlmsg_portid_ok(const struct nlmsghdr *nlh, unsigned int portid)
  * mnl_nlmsg_fprintf - print netlink message to file
  * \param nlh pointer to netlink message that we want to print
  *
- * This function prints the netlink header to a file. This function may be
- * useful for debugging purposes.
+ * This function prints the netlink header to a file handle.
+ * It may be useful for debugging purposes.
  */
 void mnl_nlmsg_fprintf(FILE *fd, const struct nlmsghdr *nlh)
 {
diff --git a/src/socket.c b/src/socket.c
index 9250c27..6ca3d3e 100644
--- a/src/socket.c
+++ b/src/socket.c
@@ -28,24 +28,24 @@
 "Simplify, simplify" -- Henry David Thoureau. Walden (1854)
 \endverbatim
  *
- * The acronim libmnl stands for LIBrary Minimalistic NetLink.
+ * The acronym libmnl stands for LIBrary Minimalistic NetLink.
  *
  * (temporary) libmnl homepage is:
  *      http://1984.lsi.us.es/projects/libmnl/
  *
  * \section features Main Features
- * - Small: the shared library requires around 30KB in a x86-based computer.
+ * - Small: the shared library requires around 30KB for an x86-based computer.
  * - Simple: this library avoids complex abstractions that tend to hide Netlink
  *   details. It avoids elaborated object-oriented infrastructure and complex
  *   callback-based workflow.
  * - Easy to use: the library simplifies the work for Netlink-wise developers.
  *   It provides functions to make socket handling, message building,
- *   validating, parsing, and sequence tracking, easier.
+ *   validating, parsing and sequence tracking, easier.
  * - Easy to re-use: you can use this library to build your own abstraction
  *   layer upon this library, if you want to provide another library that
  *   hides Netlink details to your users.
  * - Decoupling: the interdependency of the main bricks that compose this
- *   library is reduced, ie. the library provides many helpers but the
+ *   library is reduced, i.e. the library provides many helpers, but the
  *   programmer is not forced to use them.
  *
  * \section Dependencies
@@ -58,7 +58,7 @@
  * http://git.netfilter.org/cgi-bin/gitweb.cgi?p=libmnl.git;a=summary
  *
  * \section using Using libmnl
- * You can access several examples files under examples/ in the libmnl source
+ * You can access several example files under examples/ in the libmnl source
  * code tree.
  */
 
@@ -99,7 +99,7 @@ unsigned int mnl_socket_get_portid(const struct mnl_socket *nl)
 
 /**
  * mnl_socket_open - open a netlink socket
- * \param unit the netlink socket bus ID (see NETLINK_* constants)
+ * \param bus the netlink socket bus ID (see NETLINK_* constants)
  *
  * On error, it returns -1 and errno is appropriately set. Otherwise, it
  * returns a valid pointer to the mnl_socket structure.
@@ -164,7 +164,7 @@ int mnl_socket_bind(struct mnl_socket *nl, int groups, int pid)
  * mnl_socket_sendto - send a netlink message of a certain size
  * \param nl netlink socket obtained via mnl_socket_open()
  * \param buf buffer containing the netlink message to be sent
- * \param bufsiz number of bytes in the buffer that you want to send
+ * \param len number of bytes in the buffer that you want to send
  *
  * On error, it returns -1 and errno is appropriately set. Otherwise, it 
  * returns the number of bytes sent.
@@ -186,8 +186,8 @@ int mnl_socket_sendto(const struct mnl_socket *nl, const void *buf, size_t len)
  *
  * On error, it returns -1 and errno is appropriately set. If errno is set
  * to ENOSPC, it means that the buffer that you have passed to store the
- * netlink message is too small so you have received a truncated message.
- * To avoid this you have to allocate a buffer of MNL_SOCKET_BUFFER_SIZE
+ * netlink message is too small, so you have received a truncated message.
+ * To avoid this, you have to allocate a buffer of MNL_SOCKET_BUFFER_SIZE
  * (which is 8KB, see linux/netlink.h for more information). Using this
  * buffer size ensures that your buffer is big enough to store the netlink
  * message without truncating it.
-- 
1.7.1

