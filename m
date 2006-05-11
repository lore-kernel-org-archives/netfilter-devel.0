From: Gregor Maier <gregor@net.in.tum.de>
Subject: [PATCH] libnetfilter_log documentation
Date: Fri, 12 May 2006 00:19:05 +1200
Message-ID: <44632BB9.5020906@net.in.tum.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030706040501020502050409"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------030706040501020502050409
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I've written a small API Doc for the libnetfilter_log library. And since 
I don't like to write manpages from hand, I just added doxygen-style 
comments to the header file and used doxygen to generate the manpages 
from it.

The converted docs (manpage, html, pdf) can be found at 
http://www.net.informatik.tu-muenchen.de/~gregor/projects/

cu
Gregor


--------------030706040501020502050409
Content-Type: text/plain;
 name="doc.libnetfilter_log-r6596.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="doc.libnetfilter_log-r6596.patch"

Index: include/libnetfilter_log/libnetfilter_log.h
===================================================================
--- include/libnetfilter_log/libnetfilter_log.h	(revision 6596)
+++ include/libnetfilter_log/libnetfilter_log.h	(working copy)
@@ -11,54 +11,404 @@
 
 #include <libnetfilter_log/linux_nfnetlink_log.h>
 
+/**
+ * @file libnetfilter_log
+ *
+ * libnetfilter_log is a userspace library providing interface to
+ * packets that have been logged by the kernel packet filter. It is part
+ * of the netfilter project and can be found at http://www.netfilter.org/
+ *
+ * @author libnetfilter_log (C) 2005 by Harald Welte <laforge@gnumonks.org>
+ *
+ * @author This software may be used and distributed according to the terms
+ *   of the GNU General Public License, incorporated herein by reference.
+ *
+ * @author Documentation by Gregor Maier <gregor@majordomus.org>, with a lot 
+ * of stuff taken from Brad Fisher's <brad@info-link.net> libnetfilter_queue
+ * documentation.
+ */
+
 struct nflog_handle;
 struct nflog_g_handle;
 struct nflog_data;
 
 extern int nflog_errno;
 
+/**
+ * @brief Returns the netfilter netlink handle used by h
+ *
+ * @param h A netfilter log handle. See nflog_open()
+ * @return The netfilter netlink handle of h, that is used by
+ * libnfnetlink to talk to the kernel.
+ */
 extern struct nfnl_handle *nflog_nfnlh(struct nflog_handle *h);
-extern int nflog_fd(struct nflog_handle *h);
 
+
+/**
+ * @brief Callback prototype.
+ *
+ * nflog_callback function pointeres are registered with libnetfilter_log
+ * to handle received packets. The callback function is called for each 
+ * received packet. 
+ *
+ * @param gh A netfilter log group handle (see nflog_bind_group())
+ * @param nfmsg Pointer to a netfilter netlink message ??? 
+ * @param nfd Data structure containing the netfilter netlink attributes
+ * 	received from kernel.  This pointer is passed to many of the informational
+ * 	functions, such as nflog_get_nfmark(), nflog_get_payload(), etc. Should
+ * 	not be manipulated directly
+ * @param data The value passed as data parameter of nflog_callback_register()
+ * @return You must return zero on success. nflog_handle_packet() will
+ * 	return this value.
+ */
 typedef int nflog_callback(struct nflog_g_handle *gh, struct nfgenmsg *nfmsg,
-			    struct nflog_data *nfd, void *data);
+			    struct nflog_data *nfad, void *data);
 
 
+/**
+ * @brief Obtains netfilter log connection handle.
+ *
+ * Obtains netfilter log connection handle. When you are finished with the
+ * handle, you should destroy it by calling nflog_close(). A new netlink 
+ * connection is obtained internally and associated with the queue 
+ * connection handle returned.
+ * 
+ * @return Pointer to a new log handle or NULL on failure
+ * 
+ */
 extern struct nflog_handle *nflog_open(void);
+
+/**
+ * @brief Obtains netfilter log connection handle.
+ *
+ * Obtains netfilter log connection handle using an existing 
+ * netlink connection. This function is used internally to 
+ * implement nflog_open(), and should typically not be called directly.
+ * 
+ * @param nfnlh Pointer to netfilter netlink handler
+ * @return Pointer to a new log handle or NULL on failure
+ * 
+ */
 extern struct nflog_handle *nflog_open_nfnl(struct nfnl_handle *nfnlh);
+
+
+/**
+ * @brief Close netfilter log connection
+ *
+ * Close a netfilter log connection associated with the connection
+ * handle and free resources.
+ * 
+ * @param h Pointer to netfilter log connection handle as obtained from
+ * nflog_open()
+ * @return 0 on successs, non-zero on error and errno is set accordingly
+ * 
+ */
 extern int nflog_close(struct nflog_handle *h);
 
+
+/**
+ * @brief Binds the netfilter_log kernel logging backend to PF. 
+ *
+ * Binds the netfilter_log kernel logging bind to the specified 
+ * protocol family (like PF_INET).
+ * 
+ * @param h Pointer to netfilter log connection handle.
+ * @param pf Protocal Family (see socket(2))
+ * @return 0 on successs, non-zero on error and errno is set accordingly\n
+ * EEXIST  libnetfilter_log handler is already registered for this protocol
+ *     family. This error can be igrnored safely.\n
+ * EBUSY   Another libnetfilter_log handler is registered XXX:\n
+ * EINVAL  Invalid Protocol Family has been specified.\n
+ *
+ * NOTE: libnfnetlink currently catches the error and issues
+ * a perror() call, which will clear errno. To get the behaviour described
+ * above, comment out the perror() call in libnfnetlink/src/libnfnetlink.c
+ */
 extern int nflog_bind_pf(struct nflog_handle *h, u_int16_t pf);
+
+
+/**
+ * @brief Unbinds the netfilter_log kernel logging backend from PF. (Dangerous)
+ *
+ * Unbinds the netfilter_log kernel logging backend from PF. (Dangerous). 
+ * Calling this function may break other programs using libnetfilter_log. You 
+ * should not use it! Not to unbind the logger is safe!
+ * 
+ * @param h Pointer to netfilter log connection handle.
+ * @param pf Protocal Family (see socket(2))
+ * @return 0 on successs, non-zero on error and errno is set accordingly\n
+ * EINVAL  Invalid Protocol Family has been specified.
+ */
 extern int nflog_unbind_pf(struct nflog_handle *h, u_int16_t pf);
 
+/** 
+ * @brief Bind the connection handle to a loggroup. 
+ * 
+ * Bind  the connection handle to a loggroup. This call returns a 
+ * group handle, which is usesd for later calls and for identifying
+ * the loggroup. 
+ * 
+ * @param h Pointer to netfilter log connection handle.
+ * @param num The number of loggroup. 
+ * @return gh A netfilter log group handle.
+ */
 extern struct nflog_g_handle *nflog_bind_group(struct nflog_handle *h,
 						 u_int16_t num);
+
+/** 
+ * @brief Unbind and free a group handle. 
+ *
+ * Unbinds the specified group handle from its loggroup. The gh
+ * is freed by this call. 
+ * 
+ * @param gh A netfilter log group handle (see nflog_bind_group())
+ * @return 0 on successs, non-zero on error and errno is set accordingly?
+ */
 extern int nflog_unbind_group(struct nflog_g_handle *gh);
 
+/**
+ * @brief Sets the amount of data copied to userspace for each packet
+ *
+ * Sets the amount of data copied to userspace for each packet. 
+ *
+ * @param gh A netfilter log group handle (see nflog_bind_group())
+ * @param mode How much data to copy:\n
+ *		\b NFULNL_COPY_NONE Do not copy data to userspace\n
+ *		\b NFULNL_COPY_META Copy only packet queuing metadata (The actual 
+ *		packet data itself is not copied)\n
+ *		\b NFULNL_COPY_PACKET Copy metadata and up to range bytes of packet data
+ *	@param len The amount of packet data to copy when mode is NFULNL_COPY_PACKET. 
+ *		Use 0 or 0xffff to copy the whole packet. 
+ *	@return 0 on success, non-zero on error. errno is set accordingly.
+ */
 extern int nflog_set_mode(struct nflog_g_handle *gh,
 			  u_int8_t mode, unsigned int len);
+
+/** 
+ * @brief Set flush timeout.
+ *
+ * Time before flushing queued packets from kernel to userspace. 
+ * This prevents packets from never being flushed to userspace if 
+ * qthreshhold is not request. Packets are either flushed to
+ * userspace when the timeout expires or when qthreshold packets
+ * are queued. (See nflog_set_qthresh()).  
+ *
+ * @param gh A netfilter log group handle (see nflog_bind_group())
+ * @param timeout The timeout to set in 1/100 s. (i.e. multiples of 10ms)??
+ * @return 0 on success, non-zero on error. errno is set accordingly
+ * XXX: is this true??
+ */
 extern int nflog_set_timeout(struct nflog_g_handle *gh, u_int32_t timeout);
+
+/** 
+ * @brief UNUSED
+ */
 extern int nflog_set_flags(struct nflog_g_handle *gh, u_int16_t flags);
+
+/** 
+ * @brief Set transmit threshold
+ *
+ * Number of packet to queue inside kernel.  Setting this value to,
+ * e.g.  10 accumulates ten packets inside the kernel and transmits
+ * them as one netlink multipart message to userspace.  Default  is
+ * 1 (for backwards compatibility). See also nflog_set_timeout().
+ *
+ * @param gh A netfilter log group handle (see nflog_bind_group())
+ * @param qthresh The value of the threshold
+ * @return 0 on success, non-zero on error. errno is set accordingly
+ * XXX: is this true??
+ */
 extern int nflog_set_qthresh(struct nflog_g_handle *gh, u_int32_t qthresh);
+
+/** 
+ * @brief Set the kernel buffer size. 
+ * 
+ * Set the size of the kernel buffer that are used to packets before they
+ * are trasnmitted to userspace. Please note that the netlink message 
+ * headers are also included, so you have to add this margin to
+ * the payload size you want to queue. ???
+ *
+ * @param gh A netfilter log group handle (see nflog_bind_group())
+ * @param nlbufsiz The size of the kernel buffer in bytes. 
+ * @return 0 on success, non-zero on error. errno is set accordingly
+ * XXX: is this true? 
+ */
 extern int nflog_set_nlbufsiz(struct nflog_g_handle *gh, u_int32_t nlbufsiz);
 
+/** 
+ * @brief Register callback function that receives packets
+ *
+ * Register a callback function that receives packets for the given 
+ * group. This callback will be called for each packet logged to
+ * userspace. 
+ *
+ * @param gh A netfilter log group handle (see nflog_bind_group())
+ * @param cb Callback function pointer
+ * @param data Custom data that is passed to the callback function
+ * @return 0 on success, Won't fail.
+ */
 extern int nflog_callback_register(struct nflog_g_handle *gh, 
 				    nflog_callback *cb, void *data);
+
+/**
+ * @brief Return fd associated with netfilter log handle 
+ *
+ * Returns the filedescriptor associated with the netfilter log
+ * handle. This fd is used to received logged packets from the
+ * kernel using recv(2). The data received from recv is then
+ * passed ti nflog_handle_packet()
+ *
+ * @param h Netfilter log handle. See nflog_open()
+ * @return Returns a file descriptor that can be used with the recv(2)
+ *     system call.
+ */
+extern int nflog_fd(struct nflog_handle *h);
+
+/**
+ * @brief Handle packet(s) received from kernel. 
+ *
+ * Packets that have been received from the kernel with recv(2) are 
+ * handed to nflog_handle_packet(), which will trigger the associated
+ * callback functions (see nflog_callback_register()).
+ *
+ * @param h Netfilter log handle. See nflog_open()
+ * @param buf The buffer containing the received data. This is the same
+ *     buffer that recv(2) has filled.
+ * @param len Size of the buffer. This is the length returned from the
+ *     recv(2) call.
+ * @return 0 on success, non-zero on error. Negative values are returned
+ * 	when internal errors occured. Otherwise the return value of the 
+ * 	callback is returned (which must return zero on success). 
+ */
 extern int nflog_handle_packet(struct nflog_handle *h, char *buf, int len);
 
+/**
+ * @brief Returns netfilter log packet header 
+ * 
+ * Returns netfilter log packet header for the given nflog_data argument. 
+ * This function is intended to be called from the callback. 
+ *
+ * @param nfad  Netlink packet attribute data passed to callback function.
+ * @return Netlink packet header for the given packet data. The struct contains
+ * 	the following fields:\n
+ * 	\e "u_int16_t hw_protocol" The ethertype of the packet in network byte order\n
+ * 	\e "u_int8_t hook" The netfilter hook where this packet was intercepted
+ */
+extern struct nfulnl_msg_packet_hdr *nflog_get_msg_packet_hdr(struct nflog_data *nfad);
 
-extern struct nfulnl_msg_packet_hdr *nflog_get_msg_packet_hdr(struct nflog_data *nfad);
+
+/**
+ * @brief Returns netfilter mark currently assigned to the packet.
+ * 
+ * @param nfad  Netlink packet attribute data passed to callback function.
+ * @return The netfilter mark currently assigned to the packet.
+ */
 extern u_int32_t nflog_get_nfmark(struct nflog_data *nfad);
+
+/**
+ * @brief Returns the timestamp of the packet.
+ * 
+ * @param nfad  Netlink packet attribute data passed to callback function.
+ * @param tv Structure to fill with timestamp info
+ * @return  0 on success, -1 on failure (tv is unmodified on failure).
+ */
 extern int nflog_get_timestamp(struct nflog_data *nfad, struct timeval *tv);
+
+/**
+ * @brief Return ingresss interface index 
+ *
+ * @param nfad  Netlink packet attribute data passed to callback function.
+ * @return The index of the physical device the queued packet was received via.
+ *     If the returned index is 0, the packet was locally generated or the
+ *     physical input interface is no longer known. If the packet arrived
+ *     on a bridged port, indev is the bridge group??
+ */ 
 extern u_int32_t nflog_get_indev(struct nflog_data *nfad);
+
+/**
+ * @brief Return physical ingresss interface index 
+ *
+ * @param nfad  Netlink packet attribute data passed to callback function.
+ * @return The index of the physical device the queued packet was received via.
+ *     If the returned index is 0, the packet was locally generated or the
+ *     physical input interface is no longer known. If the packet arrived
+ *     on a bridged port physindev returns the number of the interface where
+ *     the packet entered the system. 
+ */ 
 extern u_int32_t nflog_get_physindev(struct nflog_data *nfad);
+
+/**
+ * @brief Return egress interface index
+ *
+ * @param nfad  Netlink packet attribute data passed to callback function.
+ * @see nflog_get_indev()
+ */
 extern u_int32_t nflog_get_outdev(struct nflog_data *nfad);
+
+/**
+ * @brief Return physical egress interface index
+ *
+ * @param nfad  Netlink packet attribute data passed to callback function.
+ * @see nflog_get_indev()
+ */
 extern u_int32_t nflog_get_physoutdev(struct nflog_data *nfad);
+
+/** 
+ * @brief Returns hardware addresss of the packet. 
+ *
+ * Retrieves the hardware address associated with the given queued packet.
+ * For ethernet packets, the hardware address returned (if any) will be the
+ * MAC address of the packet source host. Empty for packets generated on the
+ * local machine
+ *
+ * @param nfad  Netlink packet attribute data passed to callback function.
+ * @return The source hardware address associated with the queued packet, or NULL if
+ *     unknown. The struct contains the following fields:\n
+ *     \e "u_int16_t hw_addrlen" Length of the hardware address\n
+ *     \e "u_int8_t hw_addr[8]" The hardware address.
+ */
 extern struct nfulnl_msg_packet_hw *nflog_get_packet_hw(struct nflog_data *nfad);
+
+/**
+ * @brief Retrieve packet payload
+ *
+ * Retrieve the packet data of logged packet, starting with the Layer 3 header
+ * (e.g. IP or IPv6). The actual amount of data available depends on the
+ * copy mode specified by nflog_set_mode().
+ *
+ * @param nfad  Netlink packet attribute data passed to callback function.
+ * @param data  A pointer to the packet data is returned in data. 
+ * @returns Length of the packet data pointed to by *data on success, -1
+ *     on failure.
+ */
 extern int nflog_get_payload(struct nflog_data *nfad, char **data);
+
+/**
+ * @brief Return log prefix
+ *
+ * @param nfad  Netlink packet attribute data passed to callback function.
+ * @returns The Log Prefix of this packet. 
+ */
 extern char *nflog_get_prefix(struct nflog_data *nfad);
+
+/** 
+ * @brief Return uid of packet "owner"
+ *
+ * @param nfad  Netlink packet attribute data passed to callback function
+ * @param uid The uid of the packet owner is placed here.
+ * @returns 0 on success, -1 on error
+ */
 extern int nflog_get_uid(struct nflog_data *nfad, u_int32_t *uid);
+
+/**
+ * @brief UNUSED
+ */
 extern int nflog_get_seq(struct nflog_data *nfad, u_int32_t *seq);
+
+/**
+ * @brief UNUSED
+ */
 extern int nflog_get_seq_global(struct nflog_data *nfad, u_int32_t *seq);
 
+
 #endif	/* __LIBNETFILTER_LOG_H */
Index: libnetfilter_log.doxygen.conf
===================================================================
--- libnetfilter_log.doxygen.conf	(revision 0)
+++ libnetfilter_log.doxygen.conf	(revision 0)
@@ -0,0 +1,1237 @@
+# Doxyfile 1.4.6
+
+# This file describes the settings to be used by the documentation system
+# doxygen (www.doxygen.org) for a project
+#
+# All text after a hash (#) is considered a comment and will be ignored
+# The format is:
+#       TAG = value [value, ...]
+# For lists items can also be appended using:
+#       TAG += value [value, ...]
+# Values that contain spaces should be placed between quotes (" ")
+
+#---------------------------------------------------------------------------
+# Project related configuration options
+#---------------------------------------------------------------------------
+
+# The PROJECT_NAME tag is a single word (or a sequence of words surrounded 
+# by quotes) that should identify the project.
+
+PROJECT_NAME           = libnetfilter_log
+
+# The PROJECT_NUMBER tag can be used to enter a project or revision number. 
+# This could be handy for archiving the generated documentation or 
+# if some version control system is used.
+
+PROJECT_NUMBER         = x.y
+
+# The OUTPUT_DIRECTORY tag is used to specify the (relative or absolute) 
+# base path where the generated documentation will be put. 
+# If a relative path is entered, it will be relative to the location 
+# where doxygen was started. If left blank the current directory will be used.
+
+OUTPUT_DIRECTORY       = doc
+
+# If the CREATE_SUBDIRS tag is set to YES, then doxygen will create 
+# 4096 sub-directories (in 2 levels) under the output directory of each output 
+# format and will distribute the generated files over these directories. 
+# Enabling this option can be useful when feeding doxygen a huge amount of 
+# source files, where putting all generated files in the same directory would 
+# otherwise cause performance problems for the file system.
+
+CREATE_SUBDIRS         = NO
+
+# The OUTPUT_LANGUAGE tag is used to specify the language in which all 
+# documentation generated by doxygen is written. Doxygen will use this 
+# information to generate all constant output in the proper language. 
+# The default language is English, other supported languages are: 
+# Brazilian, Catalan, Chinese, Chinese-Traditional, Croatian, Czech, Danish, 
+# Dutch, Finnish, French, German, Greek, Hungarian, Italian, Japanese, 
+# Japanese-en (Japanese with English messages), Korean, Korean-en, Norwegian, 
+# Polish, Portuguese, Romanian, Russian, Serbian, Slovak, Slovene, Spanish, 
+# Swedish, and Ukrainian.
+
+OUTPUT_LANGUAGE        = English
+
+# This tag can be used to specify the encoding used in the generated output. 
+# The encoding is not always determined by the language that is chosen, 
+# but also whether or not the output is meant for Windows or non-Windows users. 
+# In case there is a difference, setting the USE_WINDOWS_ENCODING tag to YES 
+# forces the Windows encoding (this is the default for the Windows binary), 
+# whereas setting the tag to NO uses a Unix-style encoding (the default for 
+# all platforms other than Windows).
+
+USE_WINDOWS_ENCODING   = NO
+
+# If the BRIEF_MEMBER_DESC tag is set to YES (the default) Doxygen will 
+# include brief member descriptions after the members that are listed in 
+# the file and class documentation (similar to JavaDoc). 
+# Set to NO to disable this.
+
+BRIEF_MEMBER_DESC      = YES
+
+# If the REPEAT_BRIEF tag is set to YES (the default) Doxygen will prepend 
+# the brief description of a member or function before the detailed description. 
+# Note: if both HIDE_UNDOC_MEMBERS and BRIEF_MEMBER_DESC are set to NO, the 
+# brief descriptions will be completely suppressed.
+
+REPEAT_BRIEF           = YES
+
+# This tag implements a quasi-intelligent brief description abbreviator 
+# that is used to form the text in various listings. Each string 
+# in this list, if found as the leading text of the brief description, will be 
+# stripped from the text and the result after processing the whole list, is 
+# used as the annotated text. Otherwise, the brief description is used as-is. 
+# If left blank, the following values are used ("$name" is automatically 
+# replaced with the name of the entity): "The $name class" "The $name widget" 
+# "The $name file" "is" "provides" "specifies" "contains" 
+# "represents" "a" "an" "the"
+
+ABBREVIATE_BRIEF       = 
+
+# If the ALWAYS_DETAILED_SEC and REPEAT_BRIEF tags are both set to YES then 
+# Doxygen will generate a detailed section even if there is only a brief 
+# description.
+
+ALWAYS_DETAILED_SEC    = NO
+
+# If the INLINE_INHERITED_MEMB tag is set to YES, doxygen will show all 
+# inherited members of a class in the documentation of that class as if those 
+# members were ordinary class members. Constructors, destructors and assignment 
+# operators of the base classes will not be shown.
+
+INLINE_INHERITED_MEMB  = NO
+
+# If the FULL_PATH_NAMES tag is set to YES then Doxygen will prepend the full 
+# path before files name in the file list and in the header files. If set 
+# to NO the shortest path that makes the file name unique will be used.
+
+FULL_PATH_NAMES        = NO
+
+# If the FULL_PATH_NAMES tag is set to YES then the STRIP_FROM_PATH tag 
+# can be used to strip a user-defined part of the path. Stripping is 
+# only done if one of the specified strings matches the left-hand part of 
+# the path. The tag can be used to show relative paths in the file list. 
+# If left blank the directory from which doxygen is run is used as the 
+# path to strip.
+
+STRIP_FROM_PATH        = 
+
+# The STRIP_FROM_INC_PATH tag can be used to strip a user-defined part of 
+# the path mentioned in the documentation of a class, which tells 
+# the reader which header file to include in order to use a class. 
+# If left blank only the name of the header file containing the class 
+# definition is used. Otherwise one should specify the include paths that 
+# are normally passed to the compiler using the -I flag.
+
+STRIP_FROM_INC_PATH    = 
+
+# If the SHORT_NAMES tag is set to YES, doxygen will generate much shorter 
+# (but less readable) file names. This can be useful is your file systems 
+# doesn't support long names like on DOS, Mac, or CD-ROM.
+
+SHORT_NAMES            = NO
+
+# If the JAVADOC_AUTOBRIEF tag is set to YES then Doxygen 
+# will interpret the first line (until the first dot) of a JavaDoc-style 
+# comment as the brief description. If set to NO, the JavaDoc 
+# comments will behave just like the Qt-style comments (thus requiring an 
+# explicit @brief command for a brief description.
+
+JAVADOC_AUTOBRIEF      = NO
+
+# The MULTILINE_CPP_IS_BRIEF tag can be set to YES to make Doxygen 
+# treat a multi-line C++ special comment block (i.e. a block of //! or /// 
+# comments) as a brief description. This used to be the default behaviour. 
+# The new default is to treat a multi-line C++ comment block as a detailed 
+# description. Set this tag to YES if you prefer the old behaviour instead.
+
+MULTILINE_CPP_IS_BRIEF = NO
+
+# If the DETAILS_AT_TOP tag is set to YES then Doxygen 
+# will output the detailed description near the top, like JavaDoc.
+# If set to NO, the detailed description appears after the member 
+# documentation.
+
+DETAILS_AT_TOP         = YES
+
+# If the INHERIT_DOCS tag is set to YES (the default) then an undocumented 
+# member inherits the documentation from any documented member that it 
+# re-implements.
+
+INHERIT_DOCS           = YES
+
+# If the SEPARATE_MEMBER_PAGES tag is set to YES, then doxygen will produce 
+# a new page for each member. If set to NO, the documentation of a member will 
+# be part of the file/class/namespace that contains it.
+
+SEPARATE_MEMBER_PAGES  = NO
+
+# The TAB_SIZE tag can be used to set the number of spaces in a tab. 
+# Doxygen uses this value to replace tabs by spaces in code fragments.
+
+TAB_SIZE               = 8
+
+# This tag can be used to specify a number of aliases that acts 
+# as commands in the documentation. An alias has the form "name=value". 
+# For example adding "sideeffect=\par Side Effects:\n" will allow you to 
+# put the command \sideeffect (or @sideeffect) in the documentation, which 
+# will result in a user-defined paragraph with heading "Side Effects:". 
+# You can put \n's in the value part of an alias to insert newlines.
+
+ALIASES                = 
+
+# Set the OPTIMIZE_OUTPUT_FOR_C tag to YES if your project consists of C 
+# sources only. Doxygen will then generate output that is more tailored for C. 
+# For instance, some of the names that are used will be different. The list 
+# of all members will be omitted, etc.
+
+OPTIMIZE_OUTPUT_FOR_C  = YES
+
+# Set the OPTIMIZE_OUTPUT_JAVA tag to YES if your project consists of Java 
+# sources only. Doxygen will then generate output that is more tailored for Java. 
+# For instance, namespaces will be presented as packages, qualified scopes 
+# will look different, etc.
+
+OPTIMIZE_OUTPUT_JAVA   = NO
+
+# If you use STL classes (i.e. std::string, std::vector, etc.) but do not want to 
+# include (a tag file for) the STL sources as input, then you should 
+# set this tag to YES in order to let doxygen match functions declarations and 
+# definitions whose arguments contain STL classes (e.g. func(std::string); v.s. 
+# func(std::string) {}). This also make the inheritance and collaboration 
+# diagrams that involve STL classes more complete and accurate.
+
+BUILTIN_STL_SUPPORT    = NO
+
+# If member grouping is used in the documentation and the DISTRIBUTE_GROUP_DOC 
+# tag is set to YES, then doxygen will reuse the documentation of the first 
+# member in the group (if any) for the other members of the group. By default 
+# all members of a group must be documented explicitly.
+
+DISTRIBUTE_GROUP_DOC   = NO
+
+# Set the SUBGROUPING tag to YES (the default) to allow class member groups of 
+# the same type (for instance a group of public functions) to be put as a 
+# subgroup of that type (e.g. under the Public Functions section). Set it to 
+# NO to prevent subgrouping. Alternatively, this can be done per class using 
+# the \nosubgrouping command.
+
+SUBGROUPING            = YES
+
+#---------------------------------------------------------------------------
+# Build related configuration options
+#---------------------------------------------------------------------------
+
+# If the EXTRACT_ALL tag is set to YES doxygen will assume all entities in 
+# documentation are documented, even if no documentation was available. 
+# Private class members and static file members will be hidden unless 
+# the EXTRACT_PRIVATE and EXTRACT_STATIC tags are set to YES
+
+EXTRACT_ALL            = NO
+
+# If the EXTRACT_PRIVATE tag is set to YES all private members of a class 
+# will be included in the documentation.
+
+EXTRACT_PRIVATE        = NO
+
+# If the EXTRACT_STATIC tag is set to YES all static members of a file 
+# will be included in the documentation.
+
+EXTRACT_STATIC         = NO
+
+# If the EXTRACT_LOCAL_CLASSES tag is set to YES classes (and structs) 
+# defined locally in source files will be included in the documentation. 
+# If set to NO only classes defined in header files are included.
+
+EXTRACT_LOCAL_CLASSES  = YES
+
+# This flag is only useful for Objective-C code. When set to YES local 
+# methods, which are defined in the implementation section but not in 
+# the interface are included in the documentation. 
+# If set to NO (the default) only methods in the interface are included.
+
+EXTRACT_LOCAL_METHODS  = NO
+
+# If the HIDE_UNDOC_MEMBERS tag is set to YES, Doxygen will hide all 
+# undocumented members of documented classes, files or namespaces. 
+# If set to NO (the default) these members will be included in the 
+# various overviews, but no documentation section is generated. 
+# This option has no effect if EXTRACT_ALL is enabled.
+
+HIDE_UNDOC_MEMBERS     = NO
+
+# If the HIDE_UNDOC_CLASSES tag is set to YES, Doxygen will hide all 
+# undocumented classes that are normally visible in the class hierarchy. 
+# If set to NO (the default) these classes will be included in the various 
+# overviews. This option has no effect if EXTRACT_ALL is enabled.
+
+HIDE_UNDOC_CLASSES     = NO
+
+# If the HIDE_FRIEND_COMPOUNDS tag is set to YES, Doxygen will hide all 
+# friend (class|struct|union) declarations. 
+# If set to NO (the default) these declarations will be included in the 
+# documentation.
+
+HIDE_FRIEND_COMPOUNDS  = NO
+
+# If the HIDE_IN_BODY_DOCS tag is set to YES, Doxygen will hide any 
+# documentation blocks found inside the body of a function. 
+# If set to NO (the default) these blocks will be appended to the 
+# function's detailed documentation block.
+
+HIDE_IN_BODY_DOCS      = NO
+
+# The INTERNAL_DOCS tag determines if documentation 
+# that is typed after a \internal command is included. If the tag is set 
+# to NO (the default) then the documentation will be excluded. 
+# Set it to YES to include the internal documentation.
+
+INTERNAL_DOCS          = NO
+
+# If the CASE_SENSE_NAMES tag is set to NO then Doxygen will only generate 
+# file names in lower-case letters. If set to YES upper-case letters are also 
+# allowed. This is useful if you have classes or files whose names only differ 
+# in case and if your file system supports case sensitive file names. Windows 
+# and Mac users are advised to set this option to NO.
+
+CASE_SENSE_NAMES       = YES
+
+# If the HIDE_SCOPE_NAMES tag is set to NO (the default) then Doxygen 
+# will show members with their full class and namespace scopes in the 
+# documentation. If set to YES the scope will be hidden.
+
+HIDE_SCOPE_NAMES       = NO
+
+# If the SHOW_INCLUDE_FILES tag is set to YES (the default) then Doxygen 
+# will put a list of the files that are included by a file in the documentation 
+# of that file.
+
+SHOW_INCLUDE_FILES     = YES
+
+# If the INLINE_INFO tag is set to YES (the default) then a tag [inline] 
+# is inserted in the documentation for inline members.
+
+INLINE_INFO            = YES
+
+# If the SORT_MEMBER_DOCS tag is set to YES (the default) then doxygen 
+# will sort the (detailed) documentation of file and class members 
+# alphabetically by member name. If set to NO the members will appear in 
+# declaration order.
+
+SORT_MEMBER_DOCS       = NO
+
+# If the SORT_BRIEF_DOCS tag is set to YES then doxygen will sort the 
+# brief documentation of file, namespace and class members alphabetically 
+# by member name. If set to NO (the default) the members will appear in 
+# declaration order.
+
+SORT_BRIEF_DOCS        = NO
+
+# If the SORT_BY_SCOPE_NAME tag is set to YES, the class list will be 
+# sorted by fully-qualified names, including namespaces. If set to 
+# NO (the default), the class list will be sorted only by class name, 
+# not including the namespace part. 
+# Note: This option is not very useful if HIDE_SCOPE_NAMES is set to YES.
+# Note: This option applies only to the class list, not to the 
+# alphabetical list.
+
+SORT_BY_SCOPE_NAME     = NO
+
+# The GENERATE_TODOLIST tag can be used to enable (YES) or 
+# disable (NO) the todo list. This list is created by putting \todo 
+# commands in the documentation.
+
+GENERATE_TODOLIST      = YES
+
+# The GENERATE_TESTLIST tag can be used to enable (YES) or 
+# disable (NO) the test list. This list is created by putting \test 
+# commands in the documentation.
+
+GENERATE_TESTLIST      = YES
+
+# The GENERATE_BUGLIST tag can be used to enable (YES) or 
+# disable (NO) the bug list. This list is created by putting \bug 
+# commands in the documentation.
+
+GENERATE_BUGLIST       = YES
+
+# The GENERATE_DEPRECATEDLIST tag can be used to enable (YES) or 
+# disable (NO) the deprecated list. This list is created by putting 
+# \deprecated commands in the documentation.
+
+GENERATE_DEPRECATEDLIST= YES
+
+# The ENABLED_SECTIONS tag can be used to enable conditional 
+# documentation sections, marked by \if sectionname ... \endif.
+
+ENABLED_SECTIONS       = 
+
+# The MAX_INITIALIZER_LINES tag determines the maximum number of lines 
+# the initial value of a variable or define consists of for it to appear in 
+# the documentation. If the initializer consists of more lines than specified 
+# here it will be hidden. Use a value of 0 to hide initializers completely. 
+# The appearance of the initializer of individual variables and defines in the 
+# documentation can be controlled using \showinitializer or \hideinitializer 
+# command in the documentation regardless of this setting.
+
+MAX_INITIALIZER_LINES  = 30
+
+# Set the SHOW_USED_FILES tag to NO to disable the list of files generated 
+# at the bottom of the documentation of classes and structs. If set to YES the 
+# list will mention the files that were used to generate the documentation.
+
+SHOW_USED_FILES        = NO
+
+# If the sources in your project are distributed over multiple directories 
+# then setting the SHOW_DIRECTORIES tag to YES will show the directory hierarchy 
+# in the documentation. The default is NO.
+
+SHOW_DIRECTORIES       = NO
+
+# The FILE_VERSION_FILTER tag can be used to specify a program or script that 
+# doxygen should invoke to get the current version for each file (typically from the 
+# version control system). Doxygen will invoke the program by executing (via 
+# popen()) the command <command> <input-file>, where <command> is the value of 
+# the FILE_VERSION_FILTER tag, and <input-file> is the name of an input file 
+# provided by doxygen. Whatever the program writes to standard output 
+# is used as the file version. See the manual for examples.
+
+FILE_VERSION_FILTER    = 
+
+#---------------------------------------------------------------------------
+# configuration options related to warning and progress messages
+#---------------------------------------------------------------------------
+
+# The QUIET tag can be used to turn on/off the messages that are generated 
+# by doxygen. Possible values are YES and NO. If left blank NO is used.
+
+QUIET                  = NO
+
+# The WARNINGS tag can be used to turn on/off the warning messages that are 
+# generated by doxygen. Possible values are YES and NO. If left blank 
+# NO is used.
+
+WARNINGS               = YES
+
+# If WARN_IF_UNDOCUMENTED is set to YES, then doxygen will generate warnings 
+# for undocumented members. If EXTRACT_ALL is set to YES then this flag will 
+# automatically be disabled.
+
+WARN_IF_UNDOCUMENTED   = YES
+
+# If WARN_IF_DOC_ERROR is set to YES, doxygen will generate warnings for 
+# potential errors in the documentation, such as not documenting some 
+# parameters in a documented function, or documenting parameters that 
+# don't exist or using markup commands wrongly.
+
+WARN_IF_DOC_ERROR      = YES
+
+# This WARN_NO_PARAMDOC option can be abled to get warnings for 
+# functions that are documented, but have no documentation for their parameters 
+# or return value. If set to NO (the default) doxygen will only warn about 
+# wrong or incomplete parameter documentation, but not about the absence of 
+# documentation.
+
+WARN_NO_PARAMDOC       = NO
+
+# The WARN_FORMAT tag determines the format of the warning messages that 
+# doxygen can produce. The string should contain the $file, $line, and $text 
+# tags, which will be replaced by the file and line number from which the 
+# warning originated and the warning text. Optionally the format may contain 
+# $version, which will be replaced by the version of the file (if it could 
+# be obtained via FILE_VERSION_FILTER)
+
+WARN_FORMAT            = "$file:$line: $text"
+
+# The WARN_LOGFILE tag can be used to specify a file to which warning 
+# and error messages should be written. If left blank the output is written 
+# to stderr.
+
+WARN_LOGFILE           = 
+
+#---------------------------------------------------------------------------
+# configuration options related to the input files
+#---------------------------------------------------------------------------
+
+# The INPUT tag can be used to specify the files and/or directories that contain 
+# documented source files. You may enter file names like "myfile.cpp" or 
+# directories like "/usr/src/myproject". Separate the files or directories 
+# with spaces.
+
+INPUT                  = doc/libnetfilter_log 
+
+# If the value of the INPUT tag contains directories, you can use the 
+# FILE_PATTERNS tag to specify one or more wildcard pattern (like *.cpp 
+# and *.h) to filter out the source-files in the directories. If left 
+# blank the following patterns are tested: 
+# *.c *.cc *.cxx *.cpp *.c++ *.java *.ii *.ixx *.ipp *.i++ *.inl *.h *.hh *.hxx 
+# *.hpp *.h++ *.idl *.odl *.cs *.php *.php3 *.inc *.m *.mm *.py
+
+FILE_PATTERNS          = 
+
+# The RECURSIVE tag can be used to turn specify whether or not subdirectories 
+# should be searched for input files as well. Possible values are YES and NO. 
+# If left blank NO is used.
+
+RECURSIVE              = NO
+
+# The EXCLUDE tag can be used to specify files and/or directories that should 
+# excluded from the INPUT source files. This way you can easily exclude a 
+# subdirectory from a directory tree whose root is specified with the INPUT tag.
+
+EXCLUDE                = 
+
+# The EXCLUDE_SYMLINKS tag can be used select whether or not files or 
+# directories that are symbolic links (a Unix filesystem feature) are excluded 
+# from the input.
+
+EXCLUDE_SYMLINKS       = NO
+
+# If the value of the INPUT tag contains directories, you can use the 
+# EXCLUDE_PATTERNS tag to specify one or more wildcard patterns to exclude 
+# certain files from those directories. Note that the wildcards are matched 
+# against the file with absolute path, so to exclude all test directories 
+# for example use the pattern */test/*
+
+EXCLUDE_PATTERNS       = 
+
+# The EXAMPLE_PATH tag can be used to specify one or more files or 
+# directories that contain example code fragments that are included (see 
+# the \include command).
+
+EXAMPLE_PATH           = 
+
+# If the value of the EXAMPLE_PATH tag contains directories, you can use the 
+# EXAMPLE_PATTERNS tag to specify one or more wildcard pattern (like *.cpp 
+# and *.h) to filter out the source-files in the directories. If left 
+# blank all files are included.
+
+EXAMPLE_PATTERNS       = 
+
+# If the EXAMPLE_RECURSIVE tag is set to YES then subdirectories will be 
+# searched for input files to be used with the \include or \dontinclude 
+# commands irrespective of the value of the RECURSIVE tag. 
+# Possible values are YES and NO. If left blank NO is used.
+
+EXAMPLE_RECURSIVE      = NO
+
+# The IMAGE_PATH tag can be used to specify one or more files or 
+# directories that contain image that are included in the documentation (see 
+# the \image command).
+
+IMAGE_PATH             = 
+
+# The INPUT_FILTER tag can be used to specify a program that doxygen should 
+# invoke to filter for each input file. Doxygen will invoke the filter program 
+# by executing (via popen()) the command <filter> <input-file>, where <filter> 
+# is the value of the INPUT_FILTER tag, and <input-file> is the name of an 
+# input file. Doxygen will then use the output that the filter program writes 
+# to standard output.  If FILTER_PATTERNS is specified, this tag will be 
+# ignored.
+
+INPUT_FILTER           = 
+
+# The FILTER_PATTERNS tag can be used to specify filters on a per file pattern 
+# basis.  Doxygen will compare the file name with each pattern and apply the 
+# filter if there is a match.  The filters are a list of the form: 
+# pattern=filter (like *.cpp=my_cpp_filter). See INPUT_FILTER for further 
+# info on how filters are used. If FILTER_PATTERNS is empty, INPUT_FILTER 
+# is applied to all files.
+
+FILTER_PATTERNS        = 
+
+# If the FILTER_SOURCE_FILES tag is set to YES, the input filter (if set using 
+# INPUT_FILTER) will be used to filter the input files when producing source 
+# files to browse (i.e. when SOURCE_BROWSER is set to YES).
+
+FILTER_SOURCE_FILES    = NO
+
+#---------------------------------------------------------------------------
+# configuration options related to source browsing
+#---------------------------------------------------------------------------
+
+# If the SOURCE_BROWSER tag is set to YES then a list of source files will 
+# be generated. Documented entities will be cross-referenced with these sources. 
+# Note: To get rid of all source code in the generated output, make sure also 
+# VERBATIM_HEADERS is set to NO.
+
+SOURCE_BROWSER         = NO
+
+# Setting the INLINE_SOURCES tag to YES will include the body 
+# of functions and classes directly in the documentation.
+
+INLINE_SOURCES         = NO
+
+# Setting the STRIP_CODE_COMMENTS tag to YES (the default) will instruct 
+# doxygen to hide any special comment blocks from generated source code 
+# fragments. Normal C and C++ comments will always remain visible.
+
+STRIP_CODE_COMMENTS    = YES
+
+# If the REFERENCED_BY_RELATION tag is set to YES (the default) 
+# then for each documented function all documented 
+# functions referencing it will be listed.
+
+REFERENCED_BY_RELATION = YES
+
+# If the REFERENCES_RELATION tag is set to YES (the default) 
+# then for each documented function all documented entities 
+# called/used by that function will be listed.
+
+REFERENCES_RELATION    = YES
+
+# If the USE_HTAGS tag is set to YES then the references to source code 
+# will point to the HTML generated by the htags(1) tool instead of doxygen 
+# built-in source browser. The htags tool is part of GNU's global source 
+# tagging system (see http://www.gnu.org/software/global/global.html). You 
+# will need version 4.8.6 or higher.
+
+USE_HTAGS              = NO
+
+# If the VERBATIM_HEADERS tag is set to YES (the default) then Doxygen 
+# will generate a verbatim copy of the header file for each class for 
+# which an include is specified. Set to NO to disable this.
+
+VERBATIM_HEADERS       = YES
+
+#---------------------------------------------------------------------------
+# configuration options related to the alphabetical class index
+#---------------------------------------------------------------------------
+
+# If the ALPHABETICAL_INDEX tag is set to YES, an alphabetical index 
+# of all compounds will be generated. Enable this if the project 
+# contains a lot of classes, structs, unions or interfaces.
+
+ALPHABETICAL_INDEX     = NO
+
+# If the alphabetical index is enabled (see ALPHABETICAL_INDEX) then 
+# the COLS_IN_ALPHA_INDEX tag can be used to specify the number of columns 
+# in which this list will be split (can be a number in the range [1..20])
+
+COLS_IN_ALPHA_INDEX    = 5
+
+# In case all classes in a project start with a common prefix, all 
+# classes will be put under the same header in the alphabetical index. 
+# The IGNORE_PREFIX tag can be used to specify one or more prefixes that 
+# should be ignored while generating the index headers.
+
+IGNORE_PREFIX          = 
+
+#---------------------------------------------------------------------------
+# configuration options related to the HTML output
+#---------------------------------------------------------------------------
+
+# If the GENERATE_HTML tag is set to YES (the default) Doxygen will 
+# generate HTML output.
+
+GENERATE_HTML          = YES
+
+# The HTML_OUTPUT tag is used to specify where the HTML docs will be put. 
+# If a relative path is entered the value of OUTPUT_DIRECTORY will be 
+# put in front of it. If left blank `html' will be used as the default path.
+
+HTML_OUTPUT            = html
+
+# The HTML_FILE_EXTENSION tag can be used to specify the file extension for 
+# each generated HTML page (for example: .htm,.php,.asp). If it is left blank 
+# doxygen will generate files with .html extension.
+
+HTML_FILE_EXTENSION    = .html
+
+# The HTML_HEADER tag can be used to specify a personal HTML header for 
+# each generated HTML page. If it is left blank doxygen will generate a 
+# standard header.
+
+HTML_HEADER            = 
+
+# The HTML_FOOTER tag can be used to specify a personal HTML footer for 
+# each generated HTML page. If it is left blank doxygen will generate a 
+# standard footer.
+
+HTML_FOOTER            = 
+
+# The HTML_STYLESHEET tag can be used to specify a user-defined cascading 
+# style sheet that is used by each HTML page. It can be used to 
+# fine-tune the look of the HTML output. If the tag is left blank doxygen 
+# will generate a default style sheet. Note that doxygen will try to copy 
+# the style sheet file to the HTML output directory, so don't put your own 
+# stylesheet in the HTML output directory as well, or it will be erased!
+
+HTML_STYLESHEET        = 
+
+# If the HTML_ALIGN_MEMBERS tag is set to YES, the members of classes, 
+# files or namespaces will be aligned in HTML using tables. If set to 
+# NO a bullet list will be used.
+
+HTML_ALIGN_MEMBERS     = YES
+
+# If the GENERATE_HTMLHELP tag is set to YES, additional index files 
+# will be generated that can be used as input for tools like the 
+# Microsoft HTML help workshop to generate a compressed HTML help file (.chm) 
+# of the generated HTML documentation.
+
+GENERATE_HTMLHELP      = NO
+
+# If the GENERATE_HTMLHELP tag is set to YES, the CHM_FILE tag can 
+# be used to specify the file name of the resulting .chm file. You 
+# can add a path in front of the file if the result should not be 
+# written to the html output directory.
+
+CHM_FILE               = 
+
+# If the GENERATE_HTMLHELP tag is set to YES, the HHC_LOCATION tag can 
+# be used to specify the location (absolute path including file name) of 
+# the HTML help compiler (hhc.exe). If non-empty doxygen will try to run 
+# the HTML help compiler on the generated index.hhp.
+
+HHC_LOCATION           = 
+
+# If the GENERATE_HTMLHELP tag is set to YES, the GENERATE_CHI flag 
+# controls if a separate .chi index file is generated (YES) or that 
+# it should be included in the master .chm file (NO).
+
+GENERATE_CHI           = NO
+
+# If the GENERATE_HTMLHELP tag is set to YES, the BINARY_TOC flag 
+# controls whether a binary table of contents is generated (YES) or a 
+# normal table of contents (NO) in the .chm file.
+
+BINARY_TOC             = NO
+
+# The TOC_EXPAND flag can be set to YES to add extra items for group members 
+# to the contents of the HTML help documentation and to the tree view.
+
+TOC_EXPAND             = NO
+
+# The DISABLE_INDEX tag can be used to turn on/off the condensed index at 
+# top of each HTML page. The value NO (the default) enables the index and 
+# the value YES disables it.
+
+DISABLE_INDEX          = NO
+
+# This tag can be used to set the number of enum values (range [1..20]) 
+# that doxygen will group on one line in the generated HTML documentation.
+
+ENUM_VALUES_PER_LINE   = 4
+
+# If the GENERATE_TREEVIEW tag is set to YES, a side panel will be
+# generated containing a tree-like index structure (just like the one that 
+# is generated for HTML Help). For this to work a browser that supports 
+# JavaScript, DHTML, CSS and frames is required (for instance Mozilla 1.0+, 
+# Netscape 6.0+, Internet explorer 5.0+, or Konqueror). Windows users are 
+# probably better off using the HTML help feature.
+
+GENERATE_TREEVIEW      = NO
+
+# If the treeview is enabled (see GENERATE_TREEVIEW) then this tag can be 
+# used to set the initial width (in pixels) of the frame in which the tree 
+# is shown.
+
+TREEVIEW_WIDTH         = 250
+
+#---------------------------------------------------------------------------
+# configuration options related to the LaTeX output
+#---------------------------------------------------------------------------
+
+# If the GENERATE_LATEX tag is set to YES (the default) Doxygen will 
+# generate Latex output.
+
+GENERATE_LATEX         = YES
+
+# The LATEX_OUTPUT tag is used to specify where the LaTeX docs will be put. 
+# If a relative path is entered the value of OUTPUT_DIRECTORY will be 
+# put in front of it. If left blank `latex' will be used as the default path.
+
+LATEX_OUTPUT           = latex
+
+# The LATEX_CMD_NAME tag can be used to specify the LaTeX command name to be 
+# invoked. If left blank `latex' will be used as the default command name.
+
+LATEX_CMD_NAME         = latex
+
+# The MAKEINDEX_CMD_NAME tag can be used to specify the command name to 
+# generate index for LaTeX. If left blank `makeindex' will be used as the 
+# default command name.
+
+MAKEINDEX_CMD_NAME     = makeindex
+
+# If the COMPACT_LATEX tag is set to YES Doxygen generates more compact 
+# LaTeX documents. This may be useful for small projects and may help to 
+# save some trees in general.
+
+COMPACT_LATEX          = YES
+
+# The PAPER_TYPE tag can be used to set the paper type that is used 
+# by the printer. Possible values are: a4, a4wide, letter, legal and 
+# executive. If left blank a4wide will be used.
+
+PAPER_TYPE             = a4wide
+
+# The EXTRA_PACKAGES tag can be to specify one or more names of LaTeX 
+# packages that should be included in the LaTeX output.
+
+EXTRA_PACKAGES         = 
+
+# The LATEX_HEADER tag can be used to specify a personal LaTeX header for 
+# the generated latex document. The header should contain everything until 
+# the first chapter. If it is left blank doxygen will generate a 
+# standard header. Notice: only use this tag if you know what you are doing!
+
+LATEX_HEADER           = 
+
+# If the PDF_HYPERLINKS tag is set to YES, the LaTeX that is generated 
+# is prepared for conversion to pdf (using ps2pdf). The pdf file will 
+# contain links (just like the HTML output) instead of page references 
+# This makes the output suitable for online browsing using a pdf viewer.
+
+PDF_HYPERLINKS         = YES
+
+# If the USE_PDFLATEX tag is set to YES, pdflatex will be used instead of 
+# plain latex in the generated Makefile. Set this option to YES to get a 
+# higher quality PDF documentation.
+
+USE_PDFLATEX           = YES
+
+# If the LATEX_BATCHMODE tag is set to YES, doxygen will add the \\batchmode. 
+# command to the generated LaTeX files. This will instruct LaTeX to keep 
+# running if errors occur, instead of asking the user for help. 
+# This option is also used when generating formulas in HTML.
+
+LATEX_BATCHMODE        = NO
+
+# If LATEX_HIDE_INDICES is set to YES then doxygen will not 
+# include the index chapters (such as File Index, Compound Index, etc.) 
+# in the output.
+
+LATEX_HIDE_INDICES     = NO
+
+#---------------------------------------------------------------------------
+# configuration options related to the RTF output
+#---------------------------------------------------------------------------
+
+# If the GENERATE_RTF tag is set to YES Doxygen will generate RTF output 
+# The RTF output is optimized for Word 97 and may not look very pretty with 
+# other RTF readers or editors.
+
+GENERATE_RTF           = NO
+
+# The RTF_OUTPUT tag is used to specify where the RTF docs will be put. 
+# If a relative path is entered the value of OUTPUT_DIRECTORY will be 
+# put in front of it. If left blank `rtf' will be used as the default path.
+
+RTF_OUTPUT             = rtf
+
+# If the COMPACT_RTF tag is set to YES Doxygen generates more compact 
+# RTF documents. This may be useful for small projects and may help to 
+# save some trees in general.
+
+COMPACT_RTF            = NO
+
+# If the RTF_HYPERLINKS tag is set to YES, the RTF that is generated 
+# will contain hyperlink fields. The RTF file will 
+# contain links (just like the HTML output) instead of page references. 
+# This makes the output suitable for online browsing using WORD or other 
+# programs which support those fields. 
+# Note: wordpad (write) and others do not support links.
+
+RTF_HYPERLINKS         = NO
+
+# Load stylesheet definitions from file. Syntax is similar to doxygen's 
+# config file, i.e. a series of assignments. You only have to provide 
+# replacements, missing definitions are set to their default value.
+
+RTF_STYLESHEET_FILE    = 
+
+# Set optional variables used in the generation of an rtf document. 
+# Syntax is similar to doxygen's config file.
+
+RTF_EXTENSIONS_FILE    = 
+
+#---------------------------------------------------------------------------
+# configuration options related to the man page output
+#---------------------------------------------------------------------------
+
+# If the GENERATE_MAN tag is set to YES (the default) Doxygen will 
+# generate man pages
+
+GENERATE_MAN           = YES
+
+# The MAN_OUTPUT tag is used to specify where the man pages will be put. 
+# If a relative path is entered the value of OUTPUT_DIRECTORY will be 
+# put in front of it. If left blank `man' will be used as the default path.
+
+MAN_OUTPUT             = man
+
+# The MAN_EXTENSION tag determines the extension that is added to 
+# the generated man pages (default is the subroutine's section .3)
+
+MAN_EXTENSION          = .3
+
+# If the MAN_LINKS tag is set to YES and Doxygen generates man output, 
+# then it will generate one additional man file for each entity 
+# documented in the real man page(s). These additional files 
+# only source the real man page, but without them the man command 
+# would be unable to find the correct page. The default is NO.
+
+MAN_LINKS              = NO
+
+#---------------------------------------------------------------------------
+# configuration options related to the XML output
+#---------------------------------------------------------------------------
+
+# If the GENERATE_XML tag is set to YES Doxygen will 
+# generate an XML file that captures the structure of 
+# the code including all documentation.
+
+GENERATE_XML           = NO
+
+# The XML_OUTPUT tag is used to specify where the XML pages will be put. 
+# If a relative path is entered the value of OUTPUT_DIRECTORY will be 
+# put in front of it. If left blank `xml' will be used as the default path.
+
+XML_OUTPUT             = xml
+
+# The XML_SCHEMA tag can be used to specify an XML schema, 
+# which can be used by a validating XML parser to check the 
+# syntax of the XML files.
+
+XML_SCHEMA             = 
+
+# The XML_DTD tag can be used to specify an XML DTD, 
+# which can be used by a validating XML parser to check the 
+# syntax of the XML files.
+
+XML_DTD                = 
+
+# If the XML_PROGRAMLISTING tag is set to YES Doxygen will 
+# dump the program listings (including syntax highlighting 
+# and cross-referencing information) to the XML output. Note that 
+# enabling this will significantly increase the size of the XML output.
+
+XML_PROGRAMLISTING     = YES
+
+#---------------------------------------------------------------------------
+# configuration options for the AutoGen Definitions output
+#---------------------------------------------------------------------------
+
+# If the GENERATE_AUTOGEN_DEF tag is set to YES Doxygen will 
+# generate an AutoGen Definitions (see autogen.sf.net) file 
+# that captures the structure of the code including all 
+# documentation. Note that this feature is still experimental 
+# and incomplete at the moment.
+
+GENERATE_AUTOGEN_DEF   = NO
+
+#---------------------------------------------------------------------------
+# configuration options related to the Perl module output
+#---------------------------------------------------------------------------
+
+# If the GENERATE_PERLMOD tag is set to YES Doxygen will 
+# generate a Perl module file that captures the structure of 
+# the code including all documentation. Note that this 
+# feature is still experimental and incomplete at the 
+# moment.
+
+GENERATE_PERLMOD       = NO
+
+# If the PERLMOD_LATEX tag is set to YES Doxygen will generate 
+# the necessary Makefile rules, Perl scripts and LaTeX code to be able 
+# to generate PDF and DVI output from the Perl module output.
+
+PERLMOD_LATEX          = NO
+
+# If the PERLMOD_PRETTY tag is set to YES the Perl module output will be 
+# nicely formatted so it can be parsed by a human reader.  This is useful 
+# if you want to understand what is going on.  On the other hand, if this 
+# tag is set to NO the size of the Perl module output will be much smaller 
+# and Perl will parse it just the same.
+
+PERLMOD_PRETTY         = YES
+
+# The names of the make variables in the generated doxyrules.make file 
+# are prefixed with the string contained in PERLMOD_MAKEVAR_PREFIX. 
+# This is useful so different doxyrules.make files included by the same 
+# Makefile don't overwrite each other's variables.
+
+PERLMOD_MAKEVAR_PREFIX = 
+
+#---------------------------------------------------------------------------
+# Configuration options related to the preprocessor   
+#---------------------------------------------------------------------------
+
+# If the ENABLE_PREPROCESSING tag is set to YES (the default) Doxygen will 
+# evaluate all C-preprocessor directives found in the sources and include 
+# files.
+
+ENABLE_PREPROCESSING   = NO
+
+# If the MACRO_EXPANSION tag is set to YES Doxygen will expand all macro 
+# names in the source code. If set to NO (the default) only conditional 
+# compilation will be performed. Macro expansion can be done in a controlled 
+# way by setting EXPAND_ONLY_PREDEF to YES.
+
+MACRO_EXPANSION        = NO
+
+# If the EXPAND_ONLY_PREDEF and MACRO_EXPANSION tags are both set to YES 
+# then the macro expansion is limited to the macros specified with the 
+# PREDEFINED and EXPAND_AS_DEFINED tags.
+
+EXPAND_ONLY_PREDEF     = NO
+
+# If the SEARCH_INCLUDES tag is set to YES (the default) the includes files 
+# in the INCLUDE_PATH (see below) will be search if a #include is found.
+
+SEARCH_INCLUDES        = YES
+
+# The INCLUDE_PATH tag can be used to specify one or more directories that 
+# contain include files that are not input files but should be processed by 
+# the preprocessor.
+
+INCLUDE_PATH           = 
+
+# You can use the INCLUDE_FILE_PATTERNS tag to specify one or more wildcard 
+# patterns (like *.h and *.hpp) to filter out the header-files in the 
+# directories. If left blank, the patterns specified with FILE_PATTERNS will 
+# be used.
+
+INCLUDE_FILE_PATTERNS  = 
+
+# The PREDEFINED tag can be used to specify one or more macro names that 
+# are defined before the preprocessor is started (similar to the -D option of 
+# gcc). The argument of the tag is a list of macros of the form: name 
+# or name=definition (no spaces). If the definition and the = are 
+# omitted =1 is assumed. To prevent a macro definition from being 
+# undefined via #undef or recursively expanded use the := operator 
+# instead of the = operator.
+
+PREDEFINED             = 
+
+# If the MACRO_EXPANSION and EXPAND_ONLY_PREDEF tags are set to YES then 
+# this tag can be used to specify a list of macro names that should be expanded. 
+# The macro definition that is found in the sources will be used. 
+# Use the PREDEFINED tag if you want to use a different macro definition.
+
+EXPAND_AS_DEFINED      = 
+
+# If the SKIP_FUNCTION_MACROS tag is set to YES (the default) then 
+# doxygen's preprocessor will remove all function-like macros that are alone 
+# on a line, have an all uppercase name, and do not end with a semicolon. Such 
+# function macros are typically used for boiler-plate code, and will confuse 
+# the parser if not removed.
+
+SKIP_FUNCTION_MACROS   = YES
+
+#---------------------------------------------------------------------------
+# Configuration::additions related to external references   
+#---------------------------------------------------------------------------
+
+# The TAGFILES option can be used to specify one or more tagfiles. 
+# Optionally an initial location of the external documentation 
+# can be added for each tagfile. The format of a tag file without 
+# this location is as follows: 
+#   TAGFILES = file1 file2 ... 
+# Adding location for the tag files is done as follows: 
+#   TAGFILES = file1=loc1 "file2 = loc2" ... 
+# where "loc1" and "loc2" can be relative or absolute paths or 
+# URLs. If a location is present for each tag, the installdox tool 
+# does not have to be run to correct the links.
+# Note that each tag file must have a unique name
+# (where the name does NOT include the path)
+# If a tag file is not located in the directory in which doxygen 
+# is run, you must also specify the path to the tagfile here.
+
+TAGFILES               = 
+
+# When a file name is specified after GENERATE_TAGFILE, doxygen will create 
+# a tag file that is based on the input files it reads.
+
+GENERATE_TAGFILE       = 
+
+# If the ALLEXTERNALS tag is set to YES all external classes will be listed 
+# in the class index. If set to NO only the inherited external classes 
+# will be listed.
+
+ALLEXTERNALS           = NO
+
+# If the EXTERNAL_GROUPS tag is set to YES all external groups will be listed 
+# in the modules index. If set to NO, only the current project's groups will 
+# be listed.
+
+EXTERNAL_GROUPS        = YES
+
+# The PERL_PATH should be the absolute path and name of the perl script 
+# interpreter (i.e. the result of `which perl').
+
+PERL_PATH              = /usr/bin/perl
+
+#---------------------------------------------------------------------------
+# Configuration options related to the dot tool   
+#---------------------------------------------------------------------------
+
+# If the CLASS_DIAGRAMS tag is set to YES (the default) Doxygen will 
+# generate a inheritance diagram (in HTML, RTF and LaTeX) for classes with base 
+# or super classes. Setting the tag to NO turns the diagrams off. Note that 
+# this option is superseded by the HAVE_DOT option below. This is only a 
+# fallback. It is recommended to install and use dot, since it yields more 
+# powerful graphs.
+
+CLASS_DIAGRAMS         = NO
+
+# If set to YES, the inheritance and collaboration graphs will hide 
+# inheritance and usage relations if the target is undocumented 
+# or is not a class.
+
+HIDE_UNDOC_RELATIONS   = YES
+
+# If you set the HAVE_DOT tag to YES then doxygen will assume the dot tool is 
+# available from the path. This tool is part of Graphviz, a graph visualization 
+# toolkit from AT&T and Lucent Bell Labs. The other options in this section 
+# have no effect if this option is set to NO (the default)
+
+HAVE_DOT               = NO
+
+# If the CLASS_GRAPH and HAVE_DOT tags are set to YES then doxygen 
+# will generate a graph for each documented class showing the direct and 
+# indirect inheritance relations. Setting this tag to YES will force the 
+# the CLASS_DIAGRAMS tag to NO.
+
+CLASS_GRAPH            = YES
+
+# If the COLLABORATION_GRAPH and HAVE_DOT tags are set to YES then doxygen 
+# will generate a graph for each documented class showing the direct and 
+# indirect implementation dependencies (inheritance, containment, and 
+# class references variables) of the class with other documented classes.
+
+COLLABORATION_GRAPH    = YES
+
+# If the GROUP_GRAPHS and HAVE_DOT tags are set to YES then doxygen 
+# will generate a graph for groups, showing the direct groups dependencies
+
+GROUP_GRAPHS           = YES
+
+# If the UML_LOOK tag is set to YES doxygen will generate inheritance and 
+# collaboration diagrams in a style similar to the OMG's Unified Modeling 
+# Language.
+
+UML_LOOK               = NO
+
+# If set to YES, the inheritance and collaboration graphs will show the 
+# relations between templates and their instances.
+
+TEMPLATE_RELATIONS     = NO
+
+# If the ENABLE_PREPROCESSING, SEARCH_INCLUDES, INCLUDE_GRAPH, and HAVE_DOT 
+# tags are set to YES then doxygen will generate a graph for each documented 
+# file showing the direct and indirect include dependencies of the file with 
+# other documented files.
+
+INCLUDE_GRAPH          = NO
+
+# If the ENABLE_PREPROCESSING, SEARCH_INCLUDES, INCLUDED_BY_GRAPH, and 
+# HAVE_DOT tags are set to YES then doxygen will generate a graph for each 
+# documented header file showing the documented files that directly or 
+# indirectly include this file.
+
+INCLUDED_BY_GRAPH      = NO
+
+# If the CALL_GRAPH and HAVE_DOT tags are set to YES then doxygen will 
+# generate a call dependency graph for every global function or class method. 
+# Note that enabling this option will significantly increase the time of a run. 
+# So in most cases it will be better to enable call graphs for selected 
+# functions only using the \callgraph command.
+
+CALL_GRAPH             = NO
+
+# If the GRAPHICAL_HIERARCHY and HAVE_DOT tags are set to YES then doxygen 
+# will graphical hierarchy of all classes instead of a textual one.
+
+GRAPHICAL_HIERARCHY    = NO
+
+# If the DIRECTORY_GRAPH, SHOW_DIRECTORIES and HAVE_DOT tags are set to YES 
+# then doxygen will show the dependencies a directory has on other directories 
+# in a graphical way. The dependency relations are determined by the #include
+# relations between the files in the directories.
+
+DIRECTORY_GRAPH        = NO
+
+# The DOT_IMAGE_FORMAT tag can be used to set the image format of the images 
+# generated by dot. Possible values are png, jpg, or gif
+# If left blank png will be used.
+
+DOT_IMAGE_FORMAT       = png
+
+# The tag DOT_PATH can be used to specify the path where the dot tool can be 
+# found. If left blank, it is assumed the dot tool can be found in the path.
+
+DOT_PATH               = 
+
+# The DOTFILE_DIRS tag can be used to specify one or more directories that 
+# contain dot files that are included in the documentation (see the 
+# \dotfile command).
+
+DOTFILE_DIRS           = 
+
+# The MAX_DOT_GRAPH_WIDTH tag can be used to set the maximum allowed width 
+# (in pixels) of the graphs generated by dot. If a graph becomes larger than 
+# this value, doxygen will try to truncate the graph, so that it fits within 
+# the specified constraint. Beware that most browsers cannot cope with very 
+# large images.
+
+MAX_DOT_GRAPH_WIDTH    = 1024
+
+# The MAX_DOT_GRAPH_HEIGHT tag can be used to set the maximum allows height 
+# (in pixels) of the graphs generated by dot. If a graph becomes larger than 
+# this value, doxygen will try to truncate the graph, so that it fits within 
+# the specified constraint. Beware that most browsers cannot cope with very 
+# large images.
+
+MAX_DOT_GRAPH_HEIGHT   = 1024
+
+# The MAX_DOT_GRAPH_DEPTH tag can be used to set the maximum depth of the 
+# graphs generated by dot. A depth value of 3 means that only nodes reachable 
+# from the root by following a path via at most 3 edges will be shown. Nodes 
+# that lay further from the root node will be omitted. Note that setting this 
+# option to 1 or 2 may greatly reduce the computation time needed for large 
+# code bases. Also note that a graph may be further truncated if the graph's 
+# image dimensions are not sufficient to fit the graph (see MAX_DOT_GRAPH_WIDTH 
+# and MAX_DOT_GRAPH_HEIGHT). If 0 is used for the depth value (the default), 
+# the graph is not depth-constrained.
+
+MAX_DOT_GRAPH_DEPTH    = 0
+
+# Set the DOT_TRANSPARENT tag to YES to generate images with a transparent 
+# background. This is disabled by default, which results in a white background. 
+# Warning: Depending on the platform used, enabling this option may lead to 
+# badly anti-aliased labels on the edges of a graph (i.e. they become hard to 
+# read).
+
+DOT_TRANSPARENT        = NO
+
+# Set the DOT_MULTI_TARGETS tag to YES allow dot to generate multiple output 
+# files in one run (i.e. multiple -o and -T options on the command line). This 
+# makes dot run faster, but since only newer versions of dot (>1.8.10) 
+# support this, this feature is disabled by default.
+
+DOT_MULTI_TARGETS      = NO
+
+# If the GENERATE_LEGEND tag is set to YES (the default) Doxygen will 
+# generate a legend page explaining the meaning of the various boxes and 
+# arrows in the dot generated graphs.
+
+GENERATE_LEGEND        = YES
+
+# If the DOT_CLEANUP tag is set to YES (the default) Doxygen will 
+# remove the intermediate dot files that are used to generate 
+# the various graphs.
+
+DOT_CLEANUP            = YES
+
+#---------------------------------------------------------------------------
+# Configuration::additions related to the search engine   
+#---------------------------------------------------------------------------
+
+# The SEARCHENGINE tag specifies whether or not a search engine should be 
+# used. If set to NO the values of all tags below this one will be ignored.
+
+SEARCHENGINE           = NO
Index: makedoc.sh
===================================================================
--- makedoc.sh	(revision 0)
+++ makedoc.sh	(revision 0)
@@ -0,0 +1,32 @@
+#!/bin/sh
+
+# Ugly script a wrapper around doxygen, to generate the docs for
+# libnetfilter_log. Run it from the top-level-src dir of 
+# libnetfilter_log
+#
+# Complain to Gregor Maier <gregor@majordomus.org> if you don't like
+# this script
+
+if [ ! -d doc ]
+then 
+	mkdir doc
+fi
+
+# We misuse doxygen to generate just on manpage for the whole lib.
+# Normally doxygen would use the filename of the source file as 
+# heading (and as manpage filename), but I just want the
+# heading and filename to be libnetfilter_log (i.e. the manpage
+# should be libnetfilter_log.3 and not libnetfilter_log.h.3)
+if [ ! -e doc/libnetfilter_log ]
+then
+	ln -s ../include/libnetfilter_log/libnetfilter_log.h doc/libnetfilter_log
+fi 
+
+if [ ! -h doc/libnetfilter_log ]
+then
+	echo "ERROR: doc/libnetfilter_log exists but is not a symlink. Exiting"
+fi
+
+doxygen libnetfilter_log.doxygen.conf 
+
+make -C doc/latex

Property changes on: makedoc.sh
___________________________________________________________________
Name: svn:executable
   + *


--------------030706040501020502050409--
