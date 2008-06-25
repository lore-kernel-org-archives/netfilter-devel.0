From: Jan Engelhardt <jengelh@medozas.de>
Subject: Remove libipq from source tree
Date: Wed, 25 Jun 2008 10:34:19 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0806251032540.31898@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38830 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbYFYIeV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Jun 2008 04:34:21 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Suggestive patch.

====
commit cf230b83b5df3e9c74e434b6feecbb13ea641d7f
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Jun 25 10:29:50 2008 +0200

Remove libipq
    
libipq has been obsoleted by libnetfilter_queue, which also
provides a compat layer, should the need arise.
    
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am                 |    3 -
 configure.ac                |    5 +-
 libipq/Makefile.am          |   11 -
 libipq/ipq_create_handle.3  |   84 --------
 libipq/ipq_destroy_handle.3 |    1 -
 libipq/ipq_errstr.3         |   66 ------
 libipq/ipq_get_msgerr.3     |    1 -
 libipq/ipq_get_packet.3     |    1 -
 libipq/ipq_message_type.3   |  136 -------------
 libipq/ipq_perror.3         |    1 -
 libipq/ipq_read.3           |  106 ----------
 libipq/ipq_set_mode.3       |  107 ----------
 libipq/ipq_set_verdict.3    |   95 ---------
 libipq/libipq.3             |  279 --------------------------
 libipq/libipq.c             |  378 -----------------------------------
 15 files changed, 1 insertions(+), 1273 deletions(-)
 delete mode 100644 libipq/Makefile.am
 delete mode 100644 libipq/ipq_create_handle.3
 delete mode 100644 libipq/ipq_destroy_handle.3
 delete mode 100644 libipq/ipq_errstr.3
 delete mode 100644 libipq/ipq_get_msgerr.3
 delete mode 100644 libipq/ipq_get_packet.3
 delete mode 100644 libipq/ipq_message_type.3
 delete mode 100644 libipq/ipq_perror.3
 delete mode 100644 libipq/ipq_read.3
 delete mode 100644 libipq/ipq_set_mode.3
 delete mode 100644 libipq/ipq_set_verdict.3
 delete mode 100644 libipq/libipq.3
 delete mode 100644 libipq/libipq.c

diff --git a/Makefile.am b/Makefile.am
index 49edbf8..8f55e14 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -4,9 +4,6 @@ AUTOMAKE_OPTIONS = foreign subdir-objects
 
 AM_CFLAGS        = ${regular_CFLAGS} -I${top_builddir}/include -I${top_srcdir}/include ${kinclude_CFLAGS}
 SUBDIRS         := extensions
-if ENABLE_LIBIPQ
-SUBDIRS         += libipq
-endif
 
 # libiptc
 libiptc_libiptc_a_SOURCES = libiptc/libip4tc.c libiptc/libip6tc.c
diff --git a/configure.ac b/configure.ac
index f4cfcc1..b6deab8 100644
--- a/configure.ac
+++ b/configure.ac
@@ -35,8 +35,6 @@ AC_ARG_ENABLE([devel],
 	AS_HELP_STRING([--enable-devel],
 	[Install Xtables development headers]),
 	[enable_devel="$enableval"], [enable_devel="yes"])
-AC_ARG_ENABLE([libipq],
-	AS_HELP_STRING([--enable-libipq], [Build and install libipq]))
 
 AC_CHECK_HEADER([linux/dccp.h])
 
@@ -49,7 +47,6 @@ AC_SUBST([blacklist_modules])
 AM_CONDITIONAL([ENABLE_STATIC], [test "$enable_static" = "yes"])
 AM_CONDITIONAL([ENABLE_SHARED], [test "$enable_shared" = "yes"])
 AM_CONDITIONAL([ENABLE_DEVEL], [test "$enable_devel" = "yes"])
-AM_CONDITIONAL([ENABLE_LIBIPQ], [test "$enable_libipq" = "yes"])
 
 regular_CFLAGS="-D_LARGEFILE_SOURCE=1 -D_LARGE_FILES -D_FILE_OFFSET_BITS=64 \
 	-D_REENTRANT -Wall -Waggregate-return -Wmissing-declarations \
@@ -79,4 +76,4 @@ AC_SUBST([XTABLES_VERSION_MINOR])
 AC_SUBST([XTABLES_VERSION_PATCH])
 AC_SUBST([XTABLES_VERSION_EXTRA])
 
-AC_OUTPUT([Makefile extensions/GNUmakefile libipq/Makefile include/xtables.h])
+AC_OUTPUT([Makefile extensions/GNUmakefile include/xtables.h])
diff --git a/libipq/Makefile.am b/libipq/Makefile.am
deleted file mode 100644
index d4245e7..0000000
--- a/libipq/Makefile.am
+++ /dev/null
@@ -1,11 +0,0 @@
-# -*- Makefile -*-
-
-AM_CFLAGS = ${regular_CFLAGS} -I${top_builddir}/include -I${top_srcdir}/include
-
-libipq_a_SOURCES = libipq.c
-lib_LIBRARIES    = libipq.a
-include_HEADERS  = ${top_srcdir}/include/libipq/libipq.h
-man_MANS         = ipq_create_handle.3 ipq_destroy_handle.3 ipq_errstr.3 \
-                   ipq_get_msgerr.3 ipq_get_packet.3 ipq_message_type.3 \
-                   ipq_perror.3 ipq_read.3 ipq_set_mode.3 ipq_set_verdict.3 \
-                   libipq.3
diff --git a/libipq/ipq_create_handle.3 b/libipq/ipq_create_handle.3
deleted file mode 100644
index c833e88..0000000
--- a/libipq/ipq_create_handle.3
+++ /dev/null
@@ -1,84 +0,0 @@
-.TH IPQ_CREATE_HANDLE 3 "16 October 2001" "Linux iptables 1.2" "Linux Programmer's Manual" 
-.\"
-\" $Id: ipq_create_handle.3,v 1.2 2001/10/16 14:41:02 jamesm Exp $
-.\"
-.\"     Copyright (c) 2000-2001 Netfilter Core Team
-.\"
-.\"     This program is free software; you can redistribute it and/or modify
-.\"     it under the terms of the GNU General Public License as published by
-.\"     the Free Software Foundation; either version 2 of the License, or
-.\"     (at your option) any later version.
-.\"
-.\"     This program is distributed in the hope that it will be useful,
-.\"     but WITHOUT ANY WARRANTY; without even the implied warranty of
-.\"     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-.\"     GNU General Public License for more details.
-.\"
-.\"     You should have received a copy of the GNU General Public License
-.\"     along with this program; if not, write to the Free Software
-.\"     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-.\"
-.\"
-.SH NAME
-ipq_create_handle, ipq_destroy_handle - create and destroy libipq handles.
-.SH SYNOPSIS
-.B #include <linux/netfilter.h>
-.br
-.B #include <libipq.h>
-.sp
-.BI "struct ipq_handle *ipq_create_handle(u_int32_t " flags ", u_int32_t " protocol ");"
-.br
-.BI "int ipq_destroy_handle(struct ipq_handle *" h );
-.SH DESCRIPTION
-The
-.B ipq_create_handle
-function initialises libipq for an application, attempts to bind to the
-Netlink socket used by ip_queue, and returns an opaque context handle.  It
-should be the first libipq function to be called by an application.  The
-handle returned should be used in all subsequent library calls which 
-require a handle parameter.
-.PP
-The
-.I flags
-parameter is not currently used and should be set to zero by the application
-for forward compatibility.
-.PP
-The
-.I protocol
-parameter is used to specify the protocol of the packets to be queued.
-Valid values are PF_INET for IPv4 and PF_INET6 for IPv6.  Currently, 
-only one protocol may be queued at a time for a handle.
-.PP
-The
-.B ipq_destroy_handle
-function frees up resources allocated by
-.BR ipq_create_handle ,
-and should be used when the handle is no longer required by the application.
-.SH RETURN VALUES
-On success,
-.B ipq_create_handle
-returns a pointer to a context handle.
-.br
-On failure, NULL is returned.
-.PP
-On success,
-.B ipq_destroy_handle
-returns zero.
-.br
-On failure, -1 is returned.
-.SH ERRORS
-On failure, a descriptive error message will be available
-via the
-.B ipq_errstr
-function.
-.SH BUGS
-None known.
-.SH AUTHOR
-James Morris <jmorris@intercode.com.au>
-.SH COPYRIGHT
-Copyright (c) 2000-2001 Netfilter Core Team.
-.PP
-Distributed under the GNU General Public License.
-.SH SEE ALSO
-.BR iptables (8),
-.BR libipq (3).
diff --git a/libipq/ipq_destroy_handle.3 b/libipq/ipq_destroy_handle.3
deleted file mode 100644
index 29dcd98..0000000
--- a/libipq/ipq_destroy_handle.3
+++ /dev/null
@@ -1 +0,0 @@
-.so man3/ipq_create_handle.3
diff --git a/libipq/ipq_errstr.3 b/libipq/ipq_errstr.3
deleted file mode 100644
index 9661469..0000000
--- a/libipq/ipq_errstr.3
+++ /dev/null
@@ -1,66 +0,0 @@
-.TH IPQ_ERRSTR 3 "16 October 2001" "Linux iptables 1.2" "Linux Programmer's Manual" 
-.\"
-.\" $Id: ipq_errstr.3,v 1.1 2000/11/20 14:13:32 jamesm Exp $
-.\"
-.\"     Copyright (c) 2000 Netfilter Core Team
-.\"
-.\"     This program is free software; you can redistribute it and/or modify
-.\"     it under the terms of the GNU General Public License as published by
-.\"     the Free Software Foundation; either version 2 of the License, or
-.\"     (at your option) any later version.
-.\"
-.\"     This program is distributed in the hope that it will be useful,
-.\"     but WITHOUT ANY WARRANTY; without even the implied warranty of
-.\"     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-.\"     GNU General Public License for more details.
-.\"
-.\"     You should have received a copy of the GNU General Public License
-.\"     along with this program; if not, write to the Free Software
-.\"     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-.\"
-.\"
-.SH NAME
-ipq_errstr, ipq_perror - libipq error handling routines
-.SH SYNOPSIS
-.B #include <linux/netfilter.h>
-.br
-.B #include <libipq.h>
-.sp
-.BI "char *ipq_errstr(" void );
-.br
-.BI "void ipq_perror(const char *" s );
-.SH DESCRIPTION
-The
-.B ipq_errstr
-function returns a descriptive error message based on the current
-value of the internal
-.B ipq_errno
-variable.  All libipq API functions set this internal variable
-upon failure.
-.PP
-The
-.B ipq_perror
-function prints an error message to stderr corresponding to the
-current value of the internal
-.B ipq_error
-variable, and the global
-.B errno
-variable (if set).  The error message is prefixed with the string
-.I s
-as supplied by the application. If
-.I s
-is NULL, the error message is prefixed with the string "ERROR".
-.SH RETURN VALUE
-.B ipq_errstr
-returns an error message as outlined above.
-.SH BUGS
-None known.
-.SH AUTHOR
-James Morris <jmorris@intercode.com.au>
-.SH COPYRIGHT
-Copyright (c) 2000-2001 Netfilter Core Team.
-.PP
-Distributed under the GNU General Public License.
-.SH SEE ALSO
-.BR iptables (8),
-.BR libipq (3).
diff --git a/libipq/ipq_get_msgerr.3 b/libipq/ipq_get_msgerr.3
deleted file mode 100644
index 8a28be3..0000000
--- a/libipq/ipq_get_msgerr.3
+++ /dev/null
@@ -1 +0,0 @@
-.so man3/ipq_message_type.3
diff --git a/libipq/ipq_get_packet.3 b/libipq/ipq_get_packet.3
deleted file mode 100644
index 8a28be3..0000000
--- a/libipq/ipq_get_packet.3
+++ /dev/null
@@ -1 +0,0 @@
-.so man3/ipq_message_type.3
diff --git a/libipq/ipq_message_type.3 b/libipq/ipq_message_type.3
deleted file mode 100644
index 0594518..0000000
--- a/libipq/ipq_message_type.3
+++ /dev/null
@@ -1,136 +0,0 @@
-.TH IPQ_MESSAGE_TYPE 3 "16 October 2001" "Linux iptables 1.2" "Linux Programmer's Manual" 
-.\"
-.\" $Id: ipq_message_type.3,v 1.1 2000/11/20 14:13:32 jamesm Exp $
-.\"
-.\"     Copyright (c) 2000-2001 Netfilter Core Team
-.\"
-.\"     This program is free software; you can redistribute it and/or modify
-.\"     it under the terms of the GNU General Public License as published by
-.\"     the Free Software Foundation; either version 2 of the License, or
-.\"     (at your option) any later version.
-.\"
-.\"     This program is distributed in the hope that it will be useful,
-.\"     but WITHOUT ANY WARRANTY; without even the implied warranty of
-.\"     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-.\"     GNU General Public License for more details.
-.\"
-.\"     You should have received a copy of the GNU General Public License
-.\"     along with this program; if not, write to the Free Software
-.\"     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-.\"
-.\"
-.SH NAME
-ipq_message_type, ipq_get_packet, ipq_getmsgerr - query queue messages
-.SH SYNOPSIS
-.B #include <linux/netfilter.h>
-.br
-.B #include <libipq.h>
-.sp
-.BI "int ipq_message_type(const unsigned char *" buf ");"
-.br
-.BI "ipq_packet_msg_t *ipq_get_packet(const unsigned char *" buf ");"
-.br
-.BI "int ipq_get_msgerr(const unsigned char *" buf ");"
-.SH DESCRIPTION
-The
-.B ipq_message_type
-function returns the type of queue message returned to userspace
-via
-.BR ipq_read .
-.PP
-.B ipq_message_type
-should always be called following a successful call to
-.B ipq_read
-to determine whether the message is a packet message or an
-error message. The
-.I buf
-parameter should be the same data obtained from
-the previous call to
-.BR ipq_read .
-.PP
-.B ipq_message_type
-will return one of the following values:
-.TP
-.B NLMSG_ERROR
-An error message generated by the Netlink transport.
-.PP
-.TP
-.B IPQM_PACKET
-A packet message containing packet metadata and optional packet payload data.
-.PP
-The
-.B ipq_get_packet
-function should be called if
-.B ipq_message_type
-returns
-.BR IPQM_PACKET .
-The
-.I buf
-parameter should point to the same data used for the call to
-.BR ipq_message_type .
-The pointer returned by
-.B ipq_get_packet
-points to a packet message, which is declared as follows:
-.PP
-.RS
-.nf
-typedef struct ipq_packet_msg {
-	unsigned long packet_id;        /* ID of queued packet */
-	unsigned long mark;             /* Netfilter mark value */
-	long timestamp_sec;             /* Packet arrival time (seconds) */
-	long timestamp_usec;            /* Packet arrvial time (+useconds) */
-	unsigned int hook;              /* Netfilter hook we rode in on */
-	char indev_name[IFNAMSIZ];      /* Name of incoming interface */
-	char outdev_name[IFNAMSIZ];     /* Name of outgoing interface */
-	unsigned short hw_protocol;     /* Hardware protocol (network order) */
-	unsigned short hw_type;         /* Hardware type */
-	unsigned char hw_addrlen;       /* Hardware address length */
-	unsigned char hw_addr[8];       /* Hardware address */
-	size_t data_len;                /* Length of packet data */
-	unsigned char payload[0];       /* Optional packet data */
-} ipq_packet_msg_t;
-.fi
-.RE
-.PP
-Each of these fields may be read by the application.  If the queue mode
-is
-.B IPQ_COPY_PACKET
-and the
-.I data_len
-value is greater than zero, the packet payload contents may be accessed
-in the memory following the
-.B ipq_packet_msg_t
-structure to a range of
-.I data_len.
-.PP
-The
-.I packet_id
-field contains a packet identifier to be used when calling
-.BR ipq_set_verdict .
-.PP
-The
-.B ipq_get_msgerr
-function should be called if
-.B ipq_message_type
-returns
-.BR NLMSG_ERROR.
-The
-.I buf
-parameter should point to the same data used for the call to
-.BR ipq_message_type .
-The value returned by
-.B ipq_get_msgerr
-is set by higher level kernel code and corresponds to standard
-.B errno
-values.
-.SH BUGS
-None known.
-.SH AUTHOR
-James Morris <jmorris@intercode.com.au>
-.SH COPYRIGHT
-Copyright (c) 2000-2001 Netfilter Core Team.
-.PP
-Distributed under the GNU General Public License.
-.SH SEE ALSO
-.BR iptables (8),
-.BR libipq (3).
diff --git a/libipq/ipq_perror.3 b/libipq/ipq_perror.3
deleted file mode 100644
index 6efd53d..0000000
--- a/libipq/ipq_perror.3
+++ /dev/null
@@ -1 +0,0 @@
-.so man3/ipq_errstr.3
diff --git a/libipq/ipq_read.3 b/libipq/ipq_read.3
deleted file mode 100644
index 5d96737..0000000
--- a/libipq/ipq_read.3
+++ /dev/null
@@ -1,106 +0,0 @@
-.TH IPQ_READ 3 "16 October 2001" "Linux iptables 1.2" "Linux Programmer's Manual" 
-.\"
-.\" $Id: ipq_read.3,v 1.2 2001/10/16 14:41:02 jamesm Exp $
-.\"
-.\"     Copyright (c) 2000-2001 Netfilter Core Team
-.\"
-.\"     This program is free software; you can redistribute it and/or modify
-.\"     it under the terms of the GNU General Public License as published by
-.\"     the Free Software Foundation; either version 2 of the License, or
-.\"     (at your option) any later version.
-.\"
-.\"     This program is distributed in the hope that it will be useful,
-.\"     but WITHOUT ANY WARRANTY; without even the implied warranty of
-.\"     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-.\"     GNU General Public License for more details.
-.\"
-.\"     You should have received a copy of the GNU General Public License
-.\"     along with this program; if not, write to the Free Software
-.\"     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-.\"
-.\"
-.SH NAME
-ipq_read - read queue messages from ip_queue and read into supplied buffer
-.SH SYNOPSIS
-.B #include <linux/netfilter.h>
-.br
-.B #include <libipq.h>
-.sp
-.BI "ssize_t ipq_read(const struct ipq_handle *" h ", unsigned char *" buf ", size_t " len ", int " timeout ");"
-.SH DESCRIPTION
-The
-.B ipq_read
-function reads a queue message from the kernel and copies it to
-the memory pointed to by 
-.I buf
-to a maximum length of
-. IR len .
-.PP
-The
-.I h
-parameter is a context handle which must previously have been returned 
-successfully from a call to
-.BR ipq_create_handle .
-.PP
-The caller is responsible for ensuring that the memory pointed to by
-.I buf
-is large enough to contain
-.I len
-bytes.
-.PP
-The
-.I timeout
-parameter may be used to set a timeout for the operation, specified in microseconds.
-This is implemented internally by the library via the
-.BR select
-system call.  A value of zero provides normal, backwards-compatible blocking behaviour
-with no timeout.  A negative value causes the function to return immediately.
-.PP
-Data returned via
-.I buf
-should not be accessed directly.  Use the 
-.BR ipq_message_type ,
-.BR ipq_get_packet ", and"
-.BR ipq_get_msgerr
-functions to access the queue message in the buffer.
-.SH RETURN VALUE
-On failure, -1 is returned.
-.br
-On success, a non-zero positive value is returned when no timeout
-value is specified.
-.br
-On success with a timeout value specified, zero is returned if no data
-was available to read, or if a non-blocked signal was caught.  In the
-latter case, the global
-.B errno
-value will be set to 
-.BR EINTR .
-.SH ERRORS
-On error, a descriptive error message will be available
-via the
-.B ipq_errstr
-function.
-.SH DIAGNOSTICS
-While the
-.B ipq_read
-function may return successfully, the queue message copied to the buffer
-may itself be an error message from a higher level kernel component.  Use
-.B ipq_message_type
-to determine if it is an error message, and
-.B ipq_get_msgerr
-to access the value of the message.
-.SH BUGS
-None known.
-.SH AUTHOR
-James Morris <jmorris@intercode.com.au>
-.SH COPYRIGHT
-Copyright (c) 2000-2001 Netfilter Core Team.
-.PP
-Distributed under the GNU General Public License.
-.SH CREDITS
-Joost Remijn implemented the timeout feature, which appeared in the 1.2.4 release of iptables.
-.SH SEE ALSO
-.BR iptables (8),
-.BR libipq (3),
-.BR select (2).
-
diff --git a/libipq/ipq_set_mode.3 b/libipq/ipq_set_mode.3
deleted file mode 100644
index 241581e..0000000
--- a/libipq/ipq_set_mode.3
+++ /dev/null
@@ -1,107 +0,0 @@
-.TH IPQ_SET_MODE 3 "16 October 2001" "Linux iptables 1.2" "Linux Programmer's Manual" 
-.\"
-.\" $Id: ipq_set_mode.3,v 1.1 2000/11/20 14:13:32 jamesm Exp $
-.\"
-.\"     Copyright (c) 2000-2001 Netfilter Core Team
-.\"
-.\"     This program is free software; you can redistribute it and/or modify
-.\"     it under the terms of the GNU General Public License as published by
-.\"     the Free Software Foundation; either version 2 of the License, or
-.\"     (at your option) any later version.
-.\"
-.\"     This program is distributed in the hope that it will be useful,
-.\"     but WITHOUT ANY WARRANTY; without even the implied warranty of
-.\"     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-.\"     GNU General Public License for more details.
-.\"
-.\"     You should have received a copy of the GNU General Public License
-.\"     along with this program; if not, write to the Free Software
-.\"     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-.\"
-.\"
-.SH NAME
-ipq_set_mode - set the ip_queue queuing mode
-.SH SYNOPSIS
-.B #include <linux/netfilter.h>
-.br
-.B #include <libipq.h>
-.sp
-.BI "int ipq_set_mode(const struct ipq_handle *" h ", u_int8_t " mode ", size_t " range );
-.SH DESCRIPTION
-The
-.B ipq_set_mode
-function sends a message to the kernel ip_queue module, specifying whether
-packet metadata only, or packet payloads as well as metadata should be copied to
-userspace.
-.PP
-The
-.I h
-parameter is a context handle which must previously have been returned 
-successfully from a call to
-.BR ipq_create_handle .
-.PP
-The
-.I mode
-parameter must be one of:
-.TP
-.B IPQ_COPY_META
-Copy only packet metadata to userspace.
-.TP
-.B IPQ_COPY_PACKET
-Copy packet metadata and packet payloads to userspace.
-.PP
-The
-.I range
-parameter is used to specify how many bytes of the payload to copy
-to userspace.  It is only valid for
-.B IPQ_COPY_PACKET
-mode and is otherwise ignored.  The maximum useful value for
-.I range
-is 65535 (greater values will be clamped to this by ip_queue).
-.PP
-.B ipq_set_mode
-is usually used immediately following
-.B ipq_create_handle
-to enable the flow of packets to userspace.
-.PP
-Note that as the underlying Netlink messaging transport is connectionless,
-the ip_queue module does not know that a userspace application is ready to
-communicate until it receives a message such as this.
-.SH RETURN VALUE
-On failure, -1 is returned.
-.br
-On success, a non-zero positive value is returned.
-.SH ERRORS
-On failure, a descriptive error message will be available
-via the
-.B ipq_errstr
-function.
-.SH DIAGNOSTICS
-A relatively common failure may occur if the ip_queue module is not loaded.
-In this case, the following code excerpt:
-.PP
-.RS
-.nf
-status = ipq_set_mode(h, IPQ_COPY_META, 0);
-if (status < 0) {
-	ipq_perror("myapp");
-	ipq_destroy_handle(h);
-	exit(1);
-}
-.RE
-.fi
-.PP
-would generate the following output:
-.PP
-.I myapp: Failed to send netlink message: Connection refused
-.SH BUGS
-None known.
-.SH AUTHOR
-James Morris <jmorris@intercode.com.au>
-.SH COPYRIGHT
-Copyright (c) 2000-2001 Netfilter Core Team.
-.PP
-Distributed under the GNU General Public License.
-.SH SEE ALSO
-.BR libipq (3),
-.BR iptables (8).
diff --git a/libipq/ipq_set_verdict.3 b/libipq/ipq_set_verdict.3
deleted file mode 100644
index 84a9411..0000000
--- a/libipq/ipq_set_verdict.3
+++ /dev/null
@@ -1,95 +0,0 @@
-.TH IPQ_SET_VERDICT 3 "16 October 2001" "Linux iptables 1.2" "Linux Programmer's Manual" 
-.\"
-.\" $Id: ipq_set_verdict.3,v 1.1 2000/11/20 14:13:32 jamesm Exp $
-.\"
-.\"     Copyright (c) 2000-2001 Netfilter Core Team
-.\"
-.\"     This program is free software; you can redistribute it and/or modify
-.\"     it under the terms of the GNU General Public License as published by
-.\"     the Free Software Foundation; either version 2 of the License, or
-.\"     (at your option) any later version.
-.\"
-.\"     This program is distributed in the hope that it will be useful,
-.\"     but WITHOUT ANY WARRANTY; without even the implied warranty of
-.\"     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-.\"     GNU General Public License for more details.
-.\"
-.\"     You should have received a copy of the GNU General Public License
-.\"     along with this program; if not, write to the Free Software
-.\"     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-.\"
-.\"
-.SH NAME
-ipq_set_verdict - issue verdict and optionally modified packet to kernel
-.SH SYNOPSIS
-.B #include <linux/netfilter.h>
-.br
-.B #include <libipq.h>
-.sp
-.BI "int ipq_set_verdict(const struct ipq_handle *" h ", ipq_id_t " id ", unsigned int " verdict ", size_t " data_len ", unsigned char *" buf ");"
-.SH DESCRIPTION
-The
-.B ipq_set_verdict
-function issues a verdict on a packet previously obtained with
-.BR ipq_read ,
-specifing the intended disposition of the packet, and optionally
-supplying a modified version of the payload data.
-.PP
-The
-.I h
-parameter is a context handle which must previously have been returned 
-successfully from a call to
-.BR ipq_create_handle .
-.PP
-The
-.I id
-parameter is the packet identifier obtained via
-.BR ipq_get_packet .
-.PP
-The
-.I verdict
-parameter must be one of:
-.TP
-.B NF_ACCEPT
-Accept the packet and continue traversal within the kernel.
-.br
-.TP
-.B NF_DROP
-Drop the packet.
-.PP
-The
-.I data_len
-parameter is the length of the data pointed to
-by
-.IR buf ,
-the optional replacement payload data.
-.PP
-If simply setting a verdict without modifying the payload data, use zero
-for
-.I data_len
-and NULL for
-.IR buf .
-.PP
-The application is responsible for recalculating any packet checksums
-when modifying packets.
-.SH RETURN VALUE
-On failure, -1 is returned.
-.br
-On success, a non-zero positive value is returned.
-.SH ERRORS
-On error, a descriptive error message will be available
-via the
-.B ipq_errstr
-function.
-.SH BUGS
-None known.
-.SH AUTHOR
-James Morris <jmorris@intercode.com.au>
-.SH COPYRIGHT
-Copyright (c) 2000-2001 Netfilter Core Team.
-.PP
-Distributed under the GNU General Public License.
-.SH SEE ALSO
-.BR iptables (8),
-.BR libipq (3).
-
diff --git a/libipq/libipq.3 b/libipq/libipq.3
deleted file mode 100644
index c2295c1..0000000
--- a/libipq/libipq.3
+++ /dev/null
@@ -1,279 +0,0 @@
-.TH LIBIPQ 3 "16 October 2001" "Linux iptables 1.2" "Linux Programmer's Manual" 
-.\"
-.\" $Id: libipq.3,v 1.4 2001/10/16 16:58:25 jamesm Exp $
-.\"
-.\"     Copyright (c) 2000-2001 Netfilter Core Team
-.\"
-.\"     This program is free software; you can redistribute it and/or modify
-.\"     it under the terms of the GNU General Public License as published by
-.\"     the Free Software Foundation; either version 2 of the License, or
-.\"     (at your option) any later version.
-.\"
-.\"     This program is distributed in the hope that it will be useful,
-.\"     but WITHOUT ANY WARRANTY; without even the implied warranty of
-.\"     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-.\"     GNU General Public License for more details.
-.\"
-.\"     You should have received a copy of the GNU General Public License
-.\"     along with this program; if not, write to the Free Software
-.\"     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-.\"
-.\"
-.SH NAME
-libipq \- iptables userspace packet queuing library.
-.SH SYNOPSIS
-.B #include <linux/netfilter.h>
-.br
-.B #include <libipq.h>
-.SH DESCRIPTION
-libipq is a development library for iptables userspace packet queuing.
-.SS Userspace Packet Queuing
-Netfilter provides a mechanism for passing packets out of the stack for
-queueing to userspace, then receiving these packets back into the kernel
-with a verdict specifying what to do with the packets (such as ACCEPT
-or DROP).  These packets may also be modified in userspace prior to
-reinjection back into the kernel.
-.PP
-For each supported protocol, a kernel module called a
-.I queue handler
-may register with Netfilter to perform the mechanics of passing
-packets to and from userspace.
-.PP
-The standard queue handler for IPv4 is ip_queue.  It is provided as an
-experimental module with 2.4 kernels, and uses a Netlink socket for
-kernel/userspace communication.
-.PP
-Once ip_queue is loaded, IP packets may be selected with iptables
-and queued for userspace processing via the QUEUE target.  For example,
-running the following commands:
-.PP
-	# modprobe iptable_filter
-.br	
-	# modprobe ip_queue
-.br	
-	# iptables -A OUTPUT -p icmp -j QUEUE
-.PP
-will cause any locally generated ICMP packets (e.g. ping output) to
-be sent to the ip_queue module, which will then attempt to deliver the
-packets to a userspace application.  If no userspace application is waiting,
-the packets will be dropped
-.PP
-An application may receive and process these packets via libipq.
-.PP
-.PP
-.SS Libipq Overview
-Libipq provides an API for communicating with ip_queue.  The following is
-an overview of API usage, refer to individual man pages for more details
-on each function.
-.PP
-.B Initialisation
-.br
-To initialise the library, call
-.BR ipq_create_handle (3).
-This will attempt to bind to the Netlink socket used by ip_queue and
-return an opaque context handle for subsequent library calls.
-.PP
-.B Setting the Queue Mode
-.br
-.BR ipq_set_mode (3)
-allows the application to specify whether packet metadata, or packet
-payloads as well as metadata are copied to userspace.  It is also used to
-initially notify ip_queue that an application is ready to receive queue
-messages.
-.PP
-.B Receiving Packets from the Queue
-.br
-.BR ipq_read (3)
-waits for queue messages to arrive from ip_queue and copies
-them into a supplied buffer.
-Queue messages may be
-.I packet messages
-or
-.I error messages.
-.PP
-The type of packet may be determined with
-.BR ipq_message_type (3).
-.PP
-If it's a packet message, the metadata and optional payload may be retrieved with
-.BR ipq_get_packet (3).
-.PP
-To retrieve the value of an error message, use
-.BR ipq_get_msgerr (3).
-.PP
-.B Issuing Verdicts on Packets
-.br
-To issue a verdict on a packet, and optionally return a modified version
-of the packet to the kernel, call
-.BR ipq_set_verdict (3).
-.PP
-.B Error Handling
-.br
-An error string corresponding to the current value of the internal error
-variable
-.B ipq_errno
-may be obtained with
-.BR ipq_errstr (3).
-.PP
-For simple applications, calling
-.BR ipq_perror (3)
-will print the same message as
-.BR ipq_errstr (3),
-as well as the string corresponding to the global
-.B errno
-value (if set) to stderr.
-.PP
-.B Cleaning Up
-.br
-To free up the Netlink socket and destroy resources associated with
-the context handle, call
-.BR ipq_destroy_handle (3).
-.SH SUMMARY
-.TP 4
-.BR ipq_create_handle (3)
-Initialise library, return context handle.
-.TP
-.BR ipq_set_mode (3)
-Set the queue mode, to copy either packet metadata, or payloads
-as well as metadata to userspace.
-.TP
-.BR ipq_read (3)
-Wait for a queue message to arrive from ip_queue and read it into
-a buffer.
-.TP
-.BR ipq_message_type (3)
-Determine message type in the buffer.
-.TP
-.BR ipq_get_packet (3)
-Retrieve a packet message from the buffer.
-.TP
-.BR ipq_get_msgerr (3)
-Retrieve an error message from the buffer.
-.TP
-.BR ipq_set_verdict (3)
-Set a verdict on a packet, optionally replacing its contents.
-.TP
-.BR ipq_errstr (3)
-Return an error message corresponding to the internal ipq_errno variable.
-.TP
-.BR ipq_perror (3)
-Helper function to print error messages to stderr.
-.TP
-.BR ipq_destroy_handle (3)
-Destroy context handle and associated resources.
-.SH EXAMPLE
-The following is an example of a simple application which receives
-packets and issues NF_ACCEPT verdicts on each packet.
-.RS
-.nf
-/*
- * This code is GPL.
- */
-#include <linux/netfilter.h>
-#include <libipq.h>
-#include <stdio.h>
-
-#define BUFSIZE 2048 
-
-static void die(struct ipq_handle *h)
-{
-	ipq_perror("passer");
-	ipq_destroy_handle(h);
-	exit(1);
-}
-
-int main(int argc, char **argv)
-{
-	int status;
-	unsigned char buf[BUFSIZE];
-	struct ipq_handle *h;
-	
-	h = ipq_create_handle(0, PF_INET);
-	if (!h)
-		die(h);
-		
-	status = ipq_set_mode(h, IPQ_COPY_PACKET, BUFSIZE);
-	if (status < 0)
-		die(h);
-		
-	do{
-		status = ipq_read(h, buf, BUFSIZE, 0);
-		if (status < 0)
-			die(h);
-			
-		switch (ipq_message_type(buf)) {
-			case NLMSG_ERROR:
-				fprintf(stderr, "Received error message %d\\n",
-				        ipq_get_msgerr(buf));
-				break;
-				
-			case IPQM_PACKET: {
-				ipq_packet_msg_t *m = ipq_get_packet(buf);
-				
-				status = ipq_set_verdict(h, m->packet_id,
-				                         NF_ACCEPT, 0, NULL);
-				if (status < 0)
-					die(h);
-				break;
-			}
-			
-			default:
-				fprintf(stderr, "Unknown message type!\\n");
-				break;
-		}
-	} while (1);
-	
-	ipq_destroy_handle(h);
-	return 0;
-}
-.RE
-.fi
-.PP
-Pointers to more libipq application examples may be found in The
-Netfilter FAQ.
-.SH DIAGNOSTICS
-For information about monitoring and tuning ip_queue, refer to the
-Linux 2.4 Packet Filtering HOWTO.
-.PP
-If an application modifies a packet, it needs to also update any
-checksums for the packet.  Typically, the kernel will silently discard
-modified packets with invalid checksums. 
-.SH SECURITY
-Processes require CAP_NET_ADMIN capabilty to access the kernel ip_queue
-module.  Such processes can potentially access and modify any IP packets
-received, generated or forwarded by the kernel.
-.SH TODO
-Per-handle
-.B ipq_errno
-values.
-.SH BUGS
-Probably.
-.SH AUTHOR
-James Morris <jmorris@intercode.com.au>
-.SH COPYRIGHT
-Copyright (c) 2000-2001 Netfilter Core Team.
-.PP
-Distributed under the GNU General Public License.
-.SH CREDITS
-Joost Remijn implemented the
-.B ipq_read
-timeout feature, which appeared in the 1.2.4 release of iptables.
-.PP
-Fernando Anton added support for IPv6.
-.SH SEE ALSO
-.BR iptables (8),
-.BR ipq_create_handle (3),
-.BR ipq_destroy_handle (3),
-.BR ipq_errstr (3),
-.BR ipq_get_msgerr (3),
-.BR ipq_get_packet (3),
-.BR ipq_message_type (3),
-.BR ipq_perror (3),
-.BR ipq_read (3),
-.BR ipq_set_mode (3),
-.BR ipq_set_verdict (3).
-.PP
-The Netfilter home page at http://netfilter.samba.org/
-which has links to The Networking Concepts HOWTO, The Linux 2.4 Packet
-Filtering HOWTO, The Linux 2.4 NAT HOWTO, The Netfilter Hacking HOWTO,
-The Netfilter FAQ and many other useful resources.
-
diff --git a/libipq/libipq.c b/libipq/libipq.c
deleted file mode 100644
index 658af97..0000000
--- a/libipq/libipq.c
+++ /dev/null
@@ -1,378 +0,0 @@
-/*
- * libipq.c
- *
- * IPQ userspace library.
- *
- * Please note that this library is still developmental, and there may
- * be some API changes.
- *
- * Author: James Morris <jmorris@intercode.com.au>
- *
- * 07-11-2001 Modified by Fernando Anton to add support for IPv6.
- *
- * Copyright (c) 2000-2001 Netfilter Core Team
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#include <stdlib.h>
-#include <stdio.h>
-#include <string.h>
-#include <unistd.h>
-#include <sys/time.h>
-#include <sys/types.h>
-
-#include <libipq/libipq.h>
-
-/****************************************************************************
- *
- * Private interface
- *
- ****************************************************************************/
-
-enum {
-	IPQ_ERR_NONE = 0,
-	IPQ_ERR_IMPL,
-	IPQ_ERR_HANDLE,
-	IPQ_ERR_SOCKET,
-	IPQ_ERR_BIND,
-	IPQ_ERR_BUFFER,
-	IPQ_ERR_RECV,
-	IPQ_ERR_NLEOF,
-	IPQ_ERR_ADDRLEN,
-	IPQ_ERR_STRUNC,
-	IPQ_ERR_RTRUNC,
-	IPQ_ERR_NLRECV,
-	IPQ_ERR_SEND,
-	IPQ_ERR_SUPP,
-	IPQ_ERR_RECVBUF,
-	IPQ_ERR_TIMEOUT,
-        IPQ_ERR_PROTOCOL
-};
-#define IPQ_MAXERR IPQ_ERR_PROTOCOL
-
-struct ipq_errmap_t {
-	int errcode;
-	char *message;
-} ipq_errmap[] = {
-	{ IPQ_ERR_NONE, "Unknown error" },
-	{ IPQ_ERR_IMPL, "Implementation error" },
-	{ IPQ_ERR_HANDLE, "Unable to create netlink handle" },
-	{ IPQ_ERR_SOCKET, "Unable to create netlink socket" },
-	{ IPQ_ERR_BIND, "Unable to bind netlink socket" },
-	{ IPQ_ERR_BUFFER, "Unable to allocate buffer" },
-	{ IPQ_ERR_RECV, "Failed to receive netlink message" },
-	{ IPQ_ERR_NLEOF, "Received EOF on netlink socket" },
-	{ IPQ_ERR_ADDRLEN, "Invalid peer address length" },
-	{ IPQ_ERR_STRUNC, "Sent message truncated" },
-	{ IPQ_ERR_RTRUNC, "Received message truncated" },
-	{ IPQ_ERR_NLRECV, "Received error from netlink" },
-	{ IPQ_ERR_SEND, "Failed to send netlink message" },
-	{ IPQ_ERR_SUPP, "Operation not supported" },
-	{ IPQ_ERR_RECVBUF, "Receive buffer size invalid" },
-	{ IPQ_ERR_TIMEOUT, "Timeout"},
-	{ IPQ_ERR_PROTOCOL, "Invalid protocol specified" }
-};
-
-static int ipq_errno = IPQ_ERR_NONE;
-
-static ssize_t ipq_netlink_sendto(const struct ipq_handle *h,
-                                  const void *msg, size_t len);
-
-static ssize_t ipq_netlink_recvfrom(const struct ipq_handle *h,
-                                    unsigned char *buf, size_t len,
-                                    int timeout);
-
-static ssize_t ipq_netlink_sendmsg(const struct ipq_handle *h,
-                                   const struct msghdr *msg,
-                                   unsigned int flags);
-
-static char *ipq_strerror(int errcode);
-
-static ssize_t ipq_netlink_sendto(const struct ipq_handle *h,
-                                  const void *msg, size_t len)
-{
-	int status = sendto(h->fd, msg, len, 0,
-	                    (struct sockaddr *)&h->peer, sizeof(h->peer));
-	if (status < 0)
-		ipq_errno = IPQ_ERR_SEND;
-	return status;
-}
-
-static ssize_t ipq_netlink_sendmsg(const struct ipq_handle *h,
-                                   const struct msghdr *msg,
-                                   unsigned int flags)
-{
-	int status = sendmsg(h->fd, msg, flags);
-	if (status < 0)
-		ipq_errno = IPQ_ERR_SEND;
-	return status;
-}
-
-static ssize_t ipq_netlink_recvfrom(const struct ipq_handle *h,
-                                    unsigned char *buf, size_t len,
-                                    int timeout)
-{
-	unsigned int addrlen;
-	int status;
-	struct nlmsghdr *nlh;
-
-	if (len < sizeof(struct nlmsgerr)) {
-		ipq_errno = IPQ_ERR_RECVBUF;
-		return -1;
-	}
-	addrlen = sizeof(h->peer);
-
-	if (timeout != 0) {
-		int ret;
-		struct timeval tv;
-		fd_set read_fds;
-		
-		if (timeout < 0) {
-			/* non-block non-timeout */
-			tv.tv_sec = 0;
-			tv.tv_usec = 0;
-		} else {
-			tv.tv_sec = timeout / 1000000;
-			tv.tv_usec = timeout % 1000000;
-		}
-
-		FD_ZERO(&read_fds);
-		FD_SET(h->fd, &read_fds);
-		ret = select(h->fd+1, &read_fds, NULL, NULL, &tv);
-		if (ret < 0) {
-			if (errno == EINTR) {
-				return 0;
-			} else {
-				ipq_errno = IPQ_ERR_RECV;
-				return -1;
-			}
-		}
-		if (!FD_ISSET(h->fd, &read_fds)) {
-			ipq_errno = IPQ_ERR_TIMEOUT;
-			return 0;
-		}
-	}
-	status = recvfrom(h->fd, buf, len, 0,
-	                      (struct sockaddr *)&h->peer, &addrlen);
-	if (status < 0) {
-		ipq_errno = IPQ_ERR_RECV;
-		return status;
-	}
-	if (addrlen != sizeof(h->peer)) {
-		ipq_errno = IPQ_ERR_RECV;
-		return -1;
-	}
-	if (h->peer.nl_pid != 0) {
-		ipq_errno = IPQ_ERR_RECV;
-		return -1;
-	}
-	if (status == 0) {
-		ipq_errno = IPQ_ERR_NLEOF;
-		return -1;
-	}
-	nlh = (struct nlmsghdr *)buf;
-	if (nlh->nlmsg_flags & MSG_TRUNC || nlh->nlmsg_len > status) {
-		ipq_errno = IPQ_ERR_RTRUNC;
-		return -1;
-	}
-	return status;
-}
-
-static char *ipq_strerror(int errcode)
-{
-	if (errcode < 0 || errcode > IPQ_MAXERR)
-		errcode = IPQ_ERR_IMPL;
-	return ipq_errmap[errcode].message;
-}
-
-/****************************************************************************
- *
- * Public interface
- *
- ****************************************************************************/
-
-/*
- * Create and initialise an ipq handle.
- */
-struct ipq_handle *ipq_create_handle(u_int32_t flags, u_int32_t protocol)
-{
-	int status;
-	struct ipq_handle *h;
-
-	h = (struct ipq_handle *)malloc(sizeof(struct ipq_handle));
-	if (h == NULL) {
-		ipq_errno = IPQ_ERR_HANDLE;
-		return NULL;
-	}
-	
-	memset(h, 0, sizeof(struct ipq_handle));
-	
-        if (protocol == PF_INET)
-                h->fd = socket(PF_NETLINK, SOCK_RAW, NETLINK_FIREWALL);
-        else if (protocol == PF_INET6)
-                h->fd = socket(PF_NETLINK, SOCK_RAW, NETLINK_IP6_FW);
-        else {
-		ipq_errno = IPQ_ERR_PROTOCOL;
-		free(h);
-		return NULL;
-        }
-        
-	if (h->fd == -1) {
-		ipq_errno = IPQ_ERR_SOCKET;
-		close(h->fd);
-		free(h);
-		return NULL;
-	}
-	memset(&h->local, 0, sizeof(struct sockaddr_nl));
-	h->local.nl_family = AF_NETLINK;
-	h->local.nl_pid = getpid();
-	h->local.nl_groups = 0;
-	status = bind(h->fd, (struct sockaddr *)&h->local, sizeof(h->local));
-	if (status == -1) {
-		ipq_errno = IPQ_ERR_BIND;
-		close(h->fd);
-		free(h);
-		return NULL;
-	}
-	memset(&h->peer, 0, sizeof(struct sockaddr_nl));
-	h->peer.nl_family = AF_NETLINK;
-	h->peer.nl_pid = 0;
-	h->peer.nl_groups = 0;
-	return h;
-}
-
-/*
- * No error condition is checked here at this stage, but it may happen
- * if/when reliable messaging is implemented.
- */
-int ipq_destroy_handle(struct ipq_handle *h)
-{
-	if (h) {
-		close(h->fd);
-		free(h);
-	}
-	return 0;
-}
-
-int ipq_set_mode(const struct ipq_handle *h,
-                 u_int8_t mode, size_t range)
-{
-	struct {
-		struct nlmsghdr nlh;
-		ipq_peer_msg_t pm;
-	} req;
-
-	memset(&req, 0, sizeof(req));
-	req.nlh.nlmsg_len = NLMSG_LENGTH(sizeof(req));
-	req.nlh.nlmsg_flags = NLM_F_REQUEST;
-	req.nlh.nlmsg_type = IPQM_MODE;
-	req.nlh.nlmsg_pid = h->local.nl_pid;
-	req.pm.msg.mode.value = mode;
-	req.pm.msg.mode.range = range;
-	return ipq_netlink_sendto(h, (void *)&req, req.nlh.nlmsg_len);
-}
-
-/*
- * timeout is in microseconds (1 second is 1000000 (1 million) microseconds)
- *
- */
-ssize_t ipq_read(const struct ipq_handle *h,
-                 unsigned char *buf, size_t len, int timeout)
-{
-	return ipq_netlink_recvfrom(h, buf, len, timeout);
-}
-
-int ipq_message_type(const unsigned char *buf)
-{
-	return ((struct nlmsghdr*)buf)->nlmsg_type;
-}
-
-int ipq_get_msgerr(const unsigned char *buf)
-{
-	struct nlmsghdr *h = (struct nlmsghdr *)buf;
-	struct nlmsgerr *err = (struct nlmsgerr*)NLMSG_DATA(h);
-	return -err->error;
-}
-
-ipq_packet_msg_t *ipq_get_packet(const unsigned char *buf)
-{
-	return NLMSG_DATA((struct nlmsghdr *)(buf));
-}
-
-int ipq_set_verdict(const struct ipq_handle *h,
-                    ipq_id_t id,
-                    unsigned int verdict,
-                    size_t data_len,
-                    unsigned char *buf)
-{
-	unsigned char nvecs;
-	size_t tlen;
-	struct nlmsghdr nlh;
-	ipq_peer_msg_t pm;
-	struct iovec iov[3];
-	struct msghdr msg;
-
-	memset(&nlh, 0, sizeof(nlh));
-	nlh.nlmsg_flags = NLM_F_REQUEST;
-	nlh.nlmsg_type = IPQM_VERDICT;
-	nlh.nlmsg_pid = h->local.nl_pid;
-	memset(&pm, 0, sizeof(pm));
-	pm.msg.verdict.value = verdict;
-	pm.msg.verdict.id = id;
-	pm.msg.verdict.data_len = data_len;
-	iov[0].iov_base = &nlh;
-	iov[0].iov_len = sizeof(nlh);
-	iov[1].iov_base = &pm;
-	iov[1].iov_len = sizeof(pm);
-	tlen = sizeof(nlh) + sizeof(pm);
-	nvecs = 2;
-	if (data_len && buf) {
-		iov[2].iov_base = buf;
-		iov[2].iov_len = data_len;
-		tlen += data_len;
-		nvecs++;
-	}
-	msg.msg_name = (void *)&h->peer;
-	msg.msg_namelen = sizeof(h->peer);
-	msg.msg_iov = iov;
-	msg.msg_iovlen = nvecs;
-	msg.msg_control = NULL;
-	msg.msg_controllen = 0;
-	msg.msg_flags = 0;
-	nlh.nlmsg_len = tlen;
-	return ipq_netlink_sendmsg(h, &msg, 0);
-}
-
-/* Not implemented yet */
-int ipq_ctl(const struct ipq_handle *h, int request, ...)
-{
-	return 1;
-}
-
-char *ipq_errstr(void)
-{
-	return ipq_strerror(ipq_errno);
-}
-
-void ipq_perror(const char *s)
-{
-	if (s)
-		fputs(s, stderr);
-	else
-		fputs("ERROR", stderr);
-	if (ipq_errno)
-		fprintf(stderr, ": %s", ipq_errstr());
-	if (errno)
-		fprintf(stderr, ": %s", strerror(errno));
-	fputc('\n', stderr);
-}

