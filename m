From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 3/4] Sync ulogd doc with code evolution.
Date: Wed,  3 Sep 2008 22:19:02 +0200
Message-ID: <1220473143-17957-4-git-send-email-eric@inl.fr>
References: <>
 <1220473143-17957-1-git-send-email-eric@inl.fr>
 <1220473143-17957-2-git-send-email-eric@inl.fr>
 <1220473143-17957-3-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:46786 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753417AbYICUsr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Sep 2008 16:48:47 -0400
In-Reply-To: <1220473143-17957-3-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch updates the SGML documentation to be in sync with the latest
version of the code.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 doc/ulogd.sgml |  222 +++++++++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 181 insertions(+), 41 deletions(-)

diff --git a/doc/ulogd.sgml b/doc/ulogd.sgml
index 772cc8d..af327a2 100644
--- a/doc/ulogd.sgml
+++ b/doc/ulogd.sgml
@@ -6,12 +6,12 @@
 
 <title>ULOGD 2.x - the Netfilter Userspace Logging Daemon</title>
 <author>Harald Welte &lt;laforge@netfilter.org&gt</author>
-<date>Revision $Revision$, $Date$</date>
+<date>Revision 2008/09/03</date>
 
 <abstract>
 This is the documentation for <tt>ulogd-2.x</tt>, the second generation
 Netfilter Userspace logging daemon.  ulogd makes use of the Linux &gt;= 2.6.14
-nfnetlink_log subsystem, but also provides backwards compatibility for Linux
+nfnetlink_log and nfnetlink_conntrack subsystems, but also provides backwards compatibility for Linux
 &gt;= 2.4.0 ipt_ULOG.
 </abstract>
 
@@ -46,7 +46,7 @@ conforming to the IETF IPFIX language.
 </descrip>
 <p>
 By means of the configuration file, the administrator can build any number
-of Plugin Stacks.  A plugin stack is a seris of plugins, starting with an Input
+of Plugin Stacks.  A plugin stack is a series of plugins, starting with an Input
 plugin, none, one or multiple filter plugins, and one output plugin on top.
 </p>
 
@@ -60,7 +60,7 @@ dynamic allocations at runtime.  Yes, obviously, at startup time the config
 file is parsed, and allocations are made.  But after that, everything is
 pre-allocated.  As an additional improvement over ulogd-1.x, there are also no
 hashtable lookups for key resolval.  All input/output keys of plugins within
-every stakc are resolved at config file parsing time, and directly
+every stack are resolved at config file parsing time, and directly
 interconnected  by pointers.
 
 <sect>INSTALLATION
@@ -70,6 +70,14 @@ interconnected  by pointers.
 To use the NFCT or NFLOG input plugin, you will need a 2.6.14 or later kernel.
 For old-style ULOG logging, you need a kernel &gt;= 2.4.18.
 
+<sect1>Userspace libraries
+<p>
+If you plan to use NFCT and NFLOG input plugin, you will need to compile
+libnfnetlink, libnetfilter_conntrack and libnetfilter_log libraries which
+can be downloaded from <URL URL="http://ftp.netfilter.org/pub/">.
+A simple './configure; make; make install' will be enough to have library
+installed on your system.
+
 
 <sect1>ulogd
 <sect2>Recompiling the source
@@ -81,13 +89,51 @@ If you want to build ulogd with MySQL support, type './configure --with-mysql'.
 <p>
 To compile and install the program, call 'make install'.
 
-<sect2>Using a precompiled package
+<sect>Configuration
+<sect1>iptables NFLOG target
+<sect2>Quick Setup
+<p>
+Just add rules using the NFLOG target to your firewalling chain. A very basic
+example:
+<tscreen><verb>
+iptables -A FORWARD -j NFLOG --nflog-group 32 --nflog-prefix foo 
+</verb></tscreen>
+<p>
+To increase logging performance, try to use the
+<tscreen><verb>
+--nflog-qthreshold N
+</verb></tscreen>
+option (where 1 &lt; N &lt;= 50). The number you specify is the amount of packets
+batched together in one multipart netlink message. If you set this to 20, the
+kernel schedules ulogd only once every 20 packets. All 20 packets are then 
+processed by ulogd. This reduces the number of context switches between kernel
+and userspace.
 <p>
-I also provide a SRPM, which should compile on almost any rpm-based distribution. It is available at <URL URL="http://ftp.netfilter.org/pub/ulogd/">
+Of course you can combine the NFLOG target with the different netfilter match
+modules.  For a more detailed description, have a look at the netfilter
+HOWTO's, available on the netfilter homepage.
+<sect2>NFLOG target reference
 <p>
-Just download the package and do the usual 'rpm --rebuild &lt;file&gt;'.
+<descrip>
+<tag>--nflog-group N</tag>
+The number of the netlink multicast group to which NFLOG'ed packets are sent.
+You will have to use the same group number in the NFLOG target and ulogd in
+order to make logging work.
+<tag>--nflog-range N</tag>
+Copyrange.  This works like the 'snaplen' parameter of tcpdump.  You can specify
+a number of bytes up to which the packet is copied.  If you say '40', you will
+receive the first fourty bytes of every packet. Leave it to <tt>0</tt> to dump
+the whole packet.
+<tag>--nflog-threshold N</tag>
+Queue threshold.  If a packet is matched by the iptables rule, and already N
+packets are in the queue, the queue is flushed to userspace.  You can use this
+to implement a policy like: Use a big queue in order to gain high performance,
+but still have certain packets logged immediately to userspace.
+<tag>--nflog-prefix STRING</tag>
+A string that is associated with every packet logged by this rule.  You can use
+this option to later tell from which rule the packet was logged.
+</descrip>
 
-<sect>Configuration
 <sect1>iptables ULOG target
 <sect2>Quick Setup
 <p>
@@ -167,9 +213,6 @@ at '/etc/ulogd.conf'.
 <p>
 The following configuration parameters are available:
 <descrip>
-<tag>nlgroup</tag>
-The netlink multicast group, which ulgogd should bind to. This is the same as
-given with the '--ulog-nlgroup' option to iptables.
 <tag>logfile</tag>
 The main logfile, where ulogd reports any errors, warnings and other unexpected conditions. Apart from a regular filename, the following special values can be used; ``syslog'' to log via the unix syslog(3) mechanism.  ``stdout'' to log to stdout.
 <tag>loglevel</tag>
@@ -177,16 +220,11 @@ This specifies, how verbose the logging to logfile is. Currently defined
 loglevels are: 1=debug information, 3=informational messages, 5=noticable
 exceptional conditions, 7=error conditions, 8=fatal errors, program abort.
 <tag>plugin</tag>
-This option is followed by a filename of a ulogd plugin, which ulogd shold load
+This option is followed by a filename of a ulogd plugin, which ulogd should load
 upon initialization. This option may appear more than once.
-<tag>rmem</tag>
-Size of the netlink socket receive memory.  You should set this to at least the
-size of the kernel buffer (nlbufsiz parameter of the ipt_ULOG module).  Please
-note that there is a maximum limit in /proc/sys/net/core/rmem_max which you
-cannot exceed by increasing the ``rmem'' parameter.  You may need to raise the
-system-wide maximum limit before.
-<tag>bufsize</tag>
-Size of the receive buffer. You should set this to at least the socket receive buffer (rmem).
+<tag>stack</tag>
+This option is followed by a list of plugin instances which will start with an input plugin, contains optionnal
+filtering plugin and finish by an output plugin. This option may appear more than once.
 </descrip>
 <sect2>ulogd commandline option reference
 <p>
@@ -202,6 +240,8 @@ most of the time.
 <tag>-c --configfile</tag>
 Using this commandline option, an alternate config file can be used.  This is
 important if multiple instances of ulogd are to be run on a single machine.
+<tag>-i --info</tag>
+Display informations about the plugin whom filename is given as argument.
 </descrip>
 
 <sect>Signals / Logrotate
@@ -222,26 +262,78 @@ It is important to understand that ulogd without plugins does nothing.  It will
 There are two kinds of plugins, interpreter and output plugins.  Interpreter
 plugins parse the packet, output plugins write the interpreted information to
 some logfile/database/...
+<p>
+You can get information about plugins by running
+<code>
+ulogd -i path/to/plugin/file.so
+</code>
 
 <sect1>Input plugins
 <p>
 ulogd comes with the following input plugins:
 
-<sect2>ulogd_inppkt_ULOG.so
-<p>
-The good old ipt_ULOG input plugin.  This basically emulates ulogd-1.x which
-didn't have input plugins.
-
 <sect2>ulogd_inppkt_NFLOG.so
 <p>
 This interfaces the new nfnetlink_log interface.  To compile, you need
 libnetfilter_log installed in your system.
+<descrip>
+<tag>group</tag>
+The number of the netlink multicast group to which NFLOG'ed packets are sent.
+You will have to use the same group number in the NFLOG target (--nflog-group) and in the input plugin.
+<tag>addressfamily</tag>
+You will need to specify the value of the protocol if you are not loging IPv4 packet.
+addressfamily is 7 to bridged packet and 10 for IPv6 packet.
+<tag>numeric_label</tag>
+You can use this label to store information relative to the logging. The administrator can define a convention which can be used later to differenciate packet. For example, it can store the severity of the logged event.
+<tag>netlink_socket_buffer_size</tag>
+Specify the base socket buffer size. This start value will be increased if needed up to netlink_socket_buffer_maxsize. 
+<tag>netlink_socket_buffer_maxsize</tag>
+Specify the base socket buffer maximum size.
+</descrip>
 
 <sect2>ulogd_inpflow_NFCT.so
 <p>
 This interfaces the nfnetlink_conntrack kernel subsystem, and provides
 flow-based logging.  To compile, you need libnetfilter_conntrack installed on
 your system.
+<descrip>
+<tag>pollinterval</tag>
+Change connection tracking dump interval.
+<tag>hash_enable</tag>
+If set to 1 (default) a internal hash will be stored and only destroy event will reach the output plugin.
+It set to 0, all events are reveived by the output plugin.
+<tag>hash_buckets</tag>
+Size of the internal hash bucket.
+<tag>hash_max_entries</tag>
+Maximum number of entries in the internal connection hash.
+<tag>event_mask</tag>
+Select event received from kernel based on a mask. Event types are defined as follows:
+<itemize>
+<item>Creation event: 0x00000001</item>
+<item>Update event: 0x00000002</item>
+<item>Destroy event: 0x00000004</item>
+</itemize>
+<tag>netlink_socket_buffer_size</tag>
+Specify the base socket buffer size. This start value will be increased if needed up to netlink_socket_buffer_maxsize. 
+<tag>netlink_socket_buffer_maxsize</tag>
+Specify the base socket buffer maximum size.
+</descrip>
+
+
+
+<sect2>ulogd_inppkt_ULOG.so
+<p>
+The good old ipt_ULOG input plugin.  This basically emulates ulogd-1.x which
+didn't have input plugins.
+<descrip>
+<tag>nlgroup</tag>
+The number of the netlink multicast group to which ULOG'ed packets are sent.
+You will have to use the same group number in the ULOG target and nin the input plugin.
+<tag>numeric_label</tag>
+You can use this label to store information relative to the logging. The administrator can define a convention which can be used later to differenciate packet. For example, it can store the severity of the logged event.
+</descrip>
+
+
 
 
 <sect1>Interpreter plugins
@@ -272,6 +364,38 @@ This is a 'virtual interpreter'.  It doesn't really return any information on
 the packet itself, rather the local system time and hostname.  Please note that
 the time is the time at the time of logging, not the packets receive time.
 
+<sect2>ulogd_filter_HWHDR.so
+<p>
+This plugin convert hardware header to string. In the case of ethernet packet,
+it basically convert mac address to a string represetation.
+
+<sect2>ulogd_filter_IP2BIN.so
+<p>
+This plugin convert IP addresses to a binary form usable by databases like MySQL.
+
+<sect2>ulogd_filter_IP2STR.so
+<p>
+This plugin convert IP addresses to string.
+
+<sect2>ulogd_filter_PRINTFLOW.so
+<p>
+Convert the keys relative to a flow in a string readable by human.
+
+<sect2>ulogd_filter_PRINTPKT.so
+<p>
+Convert the keys relative to a packet in a string readable by human. This plugin has
+to be used to print packet in the format similar to the LOG target format.
+
+<sect2>ulogd_filter_MARK.so
+<p>
+When this plugin is put in a stack, only messages were the mark (packet mark or connection
+mark) matches the given mark/mask will be logged.
+<descrip>
+<tag>mark</tag>
+Define the mark which will be used to check packet or flow.
+<tag>mask</tag>
+Define the mask which will be used to check packet or flow.
+</descrip>
 
 <sect1>Output plugins
 <p>
@@ -317,7 +441,8 @@ you have the mysql libraries installed, and the configure script was able to
 detect them. (that is: --with-mysql was specified for ./configure)
 
 <p>
-The plugin automagically inserts the data into the configured table; It
+The plugin automagically runs a procedure with arguments taken from a  the configurable
+ table; It
 connects to mysql during the startup phase of ulogd and obtains a list of the
 columns in the table. Then it tries to resolve the column names against keys of
 interpreter plugins. This way you can easily select which information you want
@@ -326,19 +451,20 @@ to log - just by the layout of the table.
 <p>
 If, for example, your table contains a field called 'ip_saddr', ulogd will
 resolve this against the key 'ip.saddr' and put the ip address as 32bit
-unsigned integer into the table.
+unsigned integer into the corresponding argument of table.
 
 <p>
-You may want to have a look at the file '<tt>doc/mysql.table</tt>' as an
-example table including fields to log all keys from ulogd_BASE.so. Just delete
-the fields you are not interested in, and create the table.
+The file '<tt>doc/mysql-ulogd2.sql</tt>' contains a schema for both packet and flow logging.
 
 <p>
 The module defines the following configuration directives:
 <descrip>
 <tag>table</tag>
-Name of the table to which ulogd should log.
-<tag>ldb</tag>
+Name of the table which ulogd will use to build arguments list.
+<tag>procedure</tag> 
+Stored procedure that will be run with the argument specified in the
+table variable.
+<tag>db</tag>
 Name of the mysql database.
 <tag>host</tag>
 Name of the mysql database host.
@@ -348,20 +474,26 @@ TCP port number of mysql database server.
 Name of the mysql user.
 <tag>pass</tag>
 Password for mysql.
+<tag>reconnect</tag>
+Number of reconnection attempt before declaring the output plugin as
+dead.
+<tag>connect_timeout</tag>
+Database connection timeout.
 </descrip>
 
 <sect2>ulogd_output_PGSQL.so
 <p>
 An output plugin for logging into a postgresql database. This is only compiled
-if you have the mysql libraries installed, and the configure script was able to
+if you have the pgsql libraries installed, and the configure script was able to
 detect them. (that is: --with-pgsql was specified for ./configure)
 
 <p>
-The plugin automagically inserts the data into the configured table; It
+The plugin automagically runs a procedure with arguments taken from a  the configurable
+ table; It
 connects to pgsql during the startup phase of ulogd and obtains a list of the
 columns in the table. Then it tries to resolve the column names against keys of
-interpreter plugins. This way you can easily select which information you want
-to log - just by the layout of the table.
+interpreter plugins. This way you can easily build your own procedure and select it
+arguments just by modifying the layout of the table.
 
 <p>
 If, for example, your table contains a field called 'ip_saddr', ulogd will
@@ -369,15 +501,18 @@ resolve this against the key 'ip.saddr' and put the ip address as 32bit
 unsigned integer into the table.
 
 <p>
-You may want to have a look at the file '<tt>doc/mysql.table</tt>' as an
-example table including fields to log all keys from ulogd_BASE.so. Just delete
-the fields you are not interested in, and create the table.
+The file '<tt>doc/pgsql-ulogd2.sql</tt>' contains a schema for both packet and flow logging.
 
 <p>
 The module defines the following configuration directives:
 <descrip>
 <tag>table</tag>
-Name of the table to which ulogd should log.
+Name of the table which ulogd will use to build arguments list.
+<tag>procedure</tag> 
+Stored procedure that will be run with the argument specified in the
+table variable.
+<tag>schema</tag>
+PGSQL schema to use.
 <tag>db</tag>
 Name of the database.
 <tag>host</tag>
@@ -388,6 +523,11 @@ TCP port number of database server.
 Name of the sql user.
 <tag>pass</tag>
 Password for sql user.
+<tag>reconnect</tag>
+Number of reconnection attempt before declaring the output plugin as
+dead.
+<tag>connect_timeout</tag>
+Database connection timeout.
 </descrip>
 
 <sect2>ulogd_output_PCAP.so
@@ -460,7 +600,7 @@ The syslog level (LOG_EMERG, LOG_ALERT, LOG_CRIT, LOG_ERR, LOG_WARNING, LOG_NOTI
 <p>
 All comments / questions / ... are appreciated.
 <p>
-Just drop me a note to laforge@gnumonks.org
+Just drop a note to netfilter-devel@vger.kernel.org.
 <p>
 Please note also that there is now a mailinglist, ulogd@lists.gnumonks.org. 
 You can subscribe at
-- 
1.5.4.3

