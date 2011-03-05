From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/3] build: support compilation on non-Linuxes
Date: Sat,  5 Mar 2011 13:31:31 +0100
Message-ID: <1299328292-4469-4-git-send-email-jengelh@medozas.de>
References: <1299328292-4469-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58545 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753455Ab1CEMbh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Mar 2011 07:31:37 -0500
In-Reply-To: <1299328292-4469-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Netlink is a usable TLV protocol for IPC (e.g. over AF_LOCAL sockets)
in itself even if other operating systems do not have kernel support
for it.
This tested on FreeBSD 8.2.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac                    |   13 ++--
 include/generic/linux/netlink.h |  152 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 160 insertions(+), 5 deletions(-)
 create mode 100644 include/generic/linux/netlink.h

diff --git a/configure.ac b/configure.ac
index a9fde6c..6b351a0 100644
--- a/configure.ac
+++ b/configure.ac
@@ -12,15 +12,18 @@ AC_EXEEXT
 AC_DISABLE_STATIC
 LT_INIT
 CHECK_GCC_FVISIBILITY
-case "$host" in
-*-*-linux*) ;;
-*) AC_MSG_ERROR([Linux only, dude!]);;
-esac
-
 regular_CPPFLAGS="-D_FILE_OFFSET_BITS=64 -D_REENTRANT"
 regular_CFLAGS="-Wall -Waggregate-return -Wmissing-declarations \
 	-Wmissing-prototypes -Wshadow -Wstrict-prototypes \
 	-Wformat=2 -pipe"
+
+case "$host" in
+*-*-linux*)
+	;;
+*)
+	regular_CPPFLAGS="$regular_CPPFLAGS "'-I${top_srcdir}/include/generic';;
+esac;
+
 AC_SUBST([regular_CPPFLAGS])
 AC_SUBST([regular_CFLAGS])
 AC_CONFIG_FILES([Makefile src/Makefile include/Makefile include/libmnl/Makefile include/linux/Makefile examples/Makefile examples/genl/Makefile examples/netfilter/Makefile examples/rtnl/Makefile libmnl.pc doxygen.cfg])
diff --git a/include/generic/linux/netlink.h b/include/generic/linux/netlink.h
new file mode 100644
index 0000000..0988284
--- /dev/null
+++ b/include/generic/linux/netlink.h
@@ -0,0 +1,152 @@
+#ifndef __LINUX_NETLINK_H
+#define __LINUX_NETLINK_H
+
+#include <stdint.h>
+#include <sys/socket.h> /* for sa_family_t */
+
+#ifndef AF_NETLINK
+#	define AF_NETLINK 0
+#endif
+
+#define NETLINK_ROUTE		0	/* Routing/device hook				*/
+#define NETLINK_UNUSED		1	/* Unused number				*/
+#define NETLINK_USERSOCK	2	/* Reserved for user mode socket protocols 	*/
+#define NETLINK_FIREWALL	3	/* Firewalling hook				*/
+#define NETLINK_INET_DIAG	4	/* INET socket monitoring			*/
+#define NETLINK_NFLOG		5	/* netfilter/iptables ULOG */
+#define NETLINK_XFRM		6	/* ipsec */
+#define NETLINK_SELINUX		7	/* SELinux event notifications */
+#define NETLINK_ISCSI		8	/* Open-iSCSI */
+#define NETLINK_AUDIT		9	/* auditing */
+#define NETLINK_FIB_LOOKUP	10	
+#define NETLINK_CONNECTOR	11
+#define NETLINK_NETFILTER	12	/* netfilter subsystem */
+#define NETLINK_IP6_FW		13
+#define NETLINK_DNRTMSG		14	/* DECnet routing messages */
+#define NETLINK_KOBJECT_UEVENT	15	/* Kernel messages to userspace */
+#define NETLINK_GENERIC		16
+/* leave room for NETLINK_DM (DM Events) */
+#define NETLINK_SCSITRANSPORT	18	/* SCSI Transports */
+#define NETLINK_ECRYPTFS	19
+
+#define MAX_LINKS 32		
+
+struct sockaddr_nl {
+	sa_family_t	nl_family;	/* AF_NETLINK	*/
+	unsigned short	nl_pad;		/* zero		*/
+	uint32_t		nl_pid;		/* port ID	*/
+       	uint32_t		nl_groups;	/* multicast groups mask */
+};
+
+struct nlmsghdr {
+	uint32_t		nlmsg_len;	/* Length of message including header */
+	uint16_t		nlmsg_type;	/* Message content */
+	uint16_t		nlmsg_flags;	/* Additional flags */
+	uint32_t		nlmsg_seq;	/* Sequence number */
+	uint32_t		nlmsg_pid;	/* Sending process port ID */
+};
+
+/* Flags values */
+
+#define NLM_F_REQUEST		1	/* It is request message. 	*/
+#define NLM_F_MULTI		2	/* Multipart message, terminated by NLMSG_DONE */
+#define NLM_F_ACK		4	/* Reply with ack, with zero or error code */
+#define NLM_F_ECHO		8	/* Echo this request 		*/
+
+/* Modifiers to GET request */
+#define NLM_F_ROOT	0x100	/* specify tree	root	*/
+#define NLM_F_MATCH	0x200	/* return all matching	*/
+#define NLM_F_ATOMIC	0x400	/* atomic GET		*/
+#define NLM_F_DUMP	(NLM_F_ROOT|NLM_F_MATCH)
+
+/* Modifiers to NEW request */
+#define NLM_F_REPLACE	0x100	/* Override existing		*/
+#define NLM_F_EXCL	0x200	/* Do not touch, if it exists	*/
+#define NLM_F_CREATE	0x400	/* Create, if it does not exist	*/
+#define NLM_F_APPEND	0x800	/* Add to end of list		*/
+
+/*
+   4.4BSD ADD		NLM_F_CREATE|NLM_F_EXCL
+   4.4BSD CHANGE	NLM_F_REPLACE
+
+   True CHANGE		NLM_F_CREATE|NLM_F_REPLACE
+   Append		NLM_F_CREATE
+   Check		NLM_F_EXCL
+ */
+
+#define NLMSG_ALIGNTO	4U
+#define NLMSG_ALIGN(len) ( ((len)+NLMSG_ALIGNTO-1) & ~(NLMSG_ALIGNTO-1) )
+#define NLMSG_HDRLEN	 ((int) NLMSG_ALIGN(sizeof(struct nlmsghdr)))
+#define NLMSG_LENGTH(len) ((len)+NLMSG_ALIGN(NLMSG_HDRLEN))
+#define NLMSG_SPACE(len) NLMSG_ALIGN(NLMSG_LENGTH(len))
+#define NLMSG_DATA(nlh)  ((void*)(((char*)nlh) + NLMSG_LENGTH(0)))
+#define NLMSG_NEXT(nlh,len)	 ((len) -= NLMSG_ALIGN((nlh)->nlmsg_len), \
+				  (struct nlmsghdr*)(((char*)(nlh)) + NLMSG_ALIGN((nlh)->nlmsg_len)))
+#define NLMSG_OK(nlh,len) ((len) >= (int)sizeof(struct nlmsghdr) && \
+			   (nlh)->nlmsg_len >= sizeof(struct nlmsghdr) && \
+			   (nlh)->nlmsg_len <= (len))
+#define NLMSG_PAYLOAD(nlh,len) ((nlh)->nlmsg_len - NLMSG_SPACE((len)))
+
+#define NLMSG_NOOP		0x1	/* Nothing.		*/
+#define NLMSG_ERROR		0x2	/* Error		*/
+#define NLMSG_DONE		0x3	/* End of a dump	*/
+#define NLMSG_OVERRUN		0x4	/* Data lost		*/
+
+#define NLMSG_MIN_TYPE		0x10	/* < 0x10: reserved control messages */
+
+struct nlmsgerr {
+	int		error;
+	struct nlmsghdr msg;
+};
+
+#define NETLINK_ADD_MEMBERSHIP	1
+#define NETLINK_DROP_MEMBERSHIP	2
+#define NETLINK_PKTINFO		3
+#define NETLINK_BROADCAST_ERROR	4
+#define NETLINK_NO_ENOBUFS	5
+
+struct nl_pktinfo {
+	uint32_t	group;
+};
+
+#define NET_MAJOR 36		/* Major 36 is reserved for networking 						*/
+
+enum {
+	NETLINK_UNCONNECTED = 0,
+	NETLINK_CONNECTED,
+};
+
+/*
+ *  <------- NLA_HDRLEN ------> <-- NLA_ALIGN(payload)-->
+ * +---------------------+- - -+- - - - - - - - - -+- - -+
+ * |        Header       | Pad |     Payload       | Pad |
+ * |   (struct nlattr)   | ing |                   | ing |
+ * +---------------------+- - -+- - - - - - - - - -+- - -+
+ *  <-------------- nlattr->nla_len -------------->
+ */
+
+struct nlattr {
+	uint16_t           nla_len;
+	uint16_t           nla_type;
+};
+
+/*
+ * nla_type (16 bits)
+ * +---+---+-------------------------------+
+ * | N | O | Attribute Type                |
+ * +---+---+-------------------------------+
+ * N := Carries nested attributes
+ * O := Payload stored in network byte order
+ *
+ * Note: The N and O flag are mutually exclusive.
+ */
+#define NLA_F_NESTED		(1 << 15)
+#define NLA_F_NET_BYTEORDER	(1 << 14)
+#define NLA_TYPE_MASK		~(NLA_F_NESTED | NLA_F_NET_BYTEORDER)
+
+#define NLA_ALIGNTO		4
+#define NLA_ALIGN(len)		(((len) + NLA_ALIGNTO - 1) & ~(NLA_ALIGNTO - 1))
+#define NLA_HDRLEN		((int) NLA_ALIGN(sizeof(struct nlattr)))
+
+
+#endif	/* __LINUX_NETLINK_H */
-- 
1.7.1

