From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH v4] doc: Complete documentation of statements
Date: Fri, 29 Jul 2016 16:12:17 +0530
Message-ID: <1469788937-4432-1-git-send-email-shivanib134@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35601 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbcG2Kma (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Jul 2016 06:42:30 -0400
Received: by mail-pf0-f193.google.com with SMTP id h186so5267434pfg.2
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Jul 2016 03:42:30 -0700 (PDT)
Received: from localhost.localdomain ([116.202.38.105])
        by smtp.gmail.com with ESMTPSA id s12sm23813002pfj.73.2016.07.29.03.42.27
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 29 Jul 2016 03:42:29 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add documentation corresponding to LOG STATEMENT, REJECT STATEMENT,
COUNTER STATEMENT, META STATEMENT, LIMIT STATEMENT, NAT STATEMENT,
QUEUE STATEMENT.

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
Changes in v4:
	Fix the syntax as per parser_bison

Changes in v3:
        Correct meta fields, use lowercase statement names, merge nflog
        with log.

Changes in v2:
        Add more content to the description.

 doc/nft.xml | 239 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 237 insertions(+), 2 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index ea47e2b..d2f106b 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -2191,36 +2191,271 @@ filter input iif eth0 drop
 		<refsect2>
 			<title>Log statement</title>
 			<para>
+				<cmdsynopsis>
+					        <command>log</command>
+					<group choice="req">
+						        <arg>prefix</arg>
+							<arg>level</arg>
+							<arg>group</arg>
+							<arg>snaplen</arg>
+							<arg>queue-threshold</arg>
+	                                </group>
+				</cmdsynopsis>
 			</para>
-		</refsect2>
+			<para>
+				The log statement enables logging of matching packets. When this statement is used from a rule, the Linux kernel will print some information on all matching packets, such as header fields, via the kernel log (where it can be read with dmesg(1) or read in the syslog). This is a non-terminating statement, so the rule evaluation continues after the packet is logged. It is necessary to mention the group [default 0] to consider logging with nflog.
+				<table frame="all">
+					<title>log statement</title>
+					<tgroup cols='3' align='left' colsep='1' rowsep='1'>
+						<colspec colname='c1'/>
+						<colspec colname='c2'/>
+						<colspec colname='c3'/>
+						<thead>
+							<row>
+								<entry>Keyword</entry>
+								<entry>Description</entry>
+								<entry>Type</entry>
+							</row>
+						</thead>
+						<tbody>
+							<row>
+								<entry>level</entry>
+								<entry>Level of logging</entry>
+								<entry>unsigned integer (32 bit), emerg, alert, crit, err, warn [default], notice, info, debug</entry>
+							</row>
+							<row>
+								<entry>prefix</entry>
+								<entry>Prefix log messages</entry>
+								<entry>string</entry>
+							</row>
+							<row>
+                                                                <entry>group</entry>
+                                                                <entry>Netlink group to send messages to</entry>
+                                                                <entry>unsigned integer (32 bit)</entry>
+                                                        </row>
+                                                         <row>
+                                                                <entry>snaplen</entry>
+                                                                <entry>Length of payload to include in netlink message</entry>
+                                                                <entry>unsigned integer (32 bit)</entry>
+                                                        </row>
+                                                         <row>
+                                                                <entry>queue-threshold</entry>
+                                                                <entry>Queue threshold value</entry>
+                                                                <entry>unsigned integer (32 bit)</entry>
+                                                        </row>
+						</tbody>
+					</tgroup>
+				</table>
+			</para>
+                </refsect2>
 		<refsect2>
 			<title>Reject statement</title>
 			<para>
+				A reject statement is used to send back an error packet in response to the matched packet otherwise it is equivalent to drop so it is a terminating statement, ending rule traversal. This statement is only valid in the input, forward and output chains, and user-defined chains which are only called from those chains.
+				<table frame="all">
+					<title>reject statement (ipv4)</title>
+					<tgroup cols='3' align='left' colsep='1' rowsep='1'>
+						<colspec colname='c1'/>
+						<colspec colname='c2'/>
+						<colspec colname='c3'/>
+						<thead>
+							<row>
+								<entry>Keyword</entry>
+								<entry>Description</entry>
+								<entry>Type</entry>
+							</row>
+						</thead>
+						<tbody>
+							<row>
+								<entry>with icmp type</entry>
+								<entry>ICMP response to be sent to the host</entry>
+								<entry>unsigned integer (8 bit), net-unreachable, host-unreachable, prot-unreachable, port-unreachable [default], net-prohibited, host-prohibited, admin-prohibited</entry>
+							</row>
+							<row>
+								<entry>with</entry>
+								<entry>Used on rules which only match the TCP</entry>
+								<entry>tcp reset</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
+				<table frame="all">
+					<title>reject statement (ipv6)</title>
+					<tgroup cols='3' align='left' colsep='1' rowsep='1'>
+						<colspec colname='c1'/>
+						<colspec colname='c2'/>
+						<colspec colname='c3'/>
+						<thead>
+							<row>
+								<entry>Keyword</entry>
+								<entry>Description</entry>
+								<entry>Type</entry>
+							</row>
+						</thead>
+						<tbody>
+							<row>
+								<entry>with icmpv6 type</entry>
+								<entry>ICMP6 response to be sent to the host</entry>
+								<entry>unsigned integer (8 bit), no-route, admin-prohibited, addr-unreachable, port-unreachable [default], policy-fail, reject-route</entry>
+							</row>
+							<row>
+								<entry>with</entry>
+								<entry>Used on rules which only match the TCP</entry>
+								<entry>tcp reset</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
 			</para>
 		</refsect2>
 		<refsect2>
 			<title>Counter statement</title>
 			<para>
+				A counter statement sets the hit count of packets along with the number of bytes.
 			</para>
 		</refsect2>
 		<refsect2>
 			<title>Meta statement</title>
 			<para>
+				A meta statement sets the value of a meta expression.
+				The existing meta fields are: priority, mark, pkttype, nftrace.
 			</para>
 		</refsect2>
 		<refsect2>
 			<title>Limit statement</title>
 			<para>
+				<cmdsynopsis>
+					<command>limit</command>
+					<arg choice="none">rate</arg>
+					<replaceable>rate</replaceable>
+					<arg choice="opt">SLASH</arg>
+					<replaceable>time_unit</replaceable>
+					<arg>burst <replaceable>limit_burst</replaceable> <arg>BURST_TYPE</arg></arg>
+				</cmdsynopsis>
+			</para>
+			<para>
+				A limit statement is used to set a specified limit attribute.
+				<table frame="all">
+					<title>limit statement</title>
+					<tgroup cols='3' align='left' colsep='1' rowsep='1'>
+						<colspec colname='c1'/>
+						<colspec colname='c2'/>
+						<colspec colname='c3'/>
+						<thead>
+							<row>
+								<entry>Keyword</entry>
+								<entry>Description</entry>
+								<entry>Type</entry>
+							</row>
+						</thead>
+						<tbody>
+							<row>
+								<entry>rate</entry>
+								<entry>Maximum average matching rate</entry>
+								<entry>size (bytes, kbytes, mbytes)/time (second, minute, hour, day, week)</entry>
+							</row>
+							<row>
+								<entry>burst</entry>
+								<entry>Maximum initial number of packets</entry>
+								<entry>packets, size (bytes, kbytes, mbytes)</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
 			</para>
 		</refsect2>
-			<refsect2>
+		<refsect2>
 			<title>NAT statement</title>
 			<para>
+				<cmdsynopsis>
+					        <group choice="none">
+						        <command>snat</command>
+							<command>dnat</command>
+	                                        </group>
+		                                <arg choice="req"><replaceable>flags</replaceable></arg>
+				</cmdsynopsis>
+			</para>
+			<para>
+				The nat statement is only valid from nat chain types. It specifies that the source/destination address of the packet should be modified (and all future packets in this connection will also be mangled), and rules should cease being examined.
+			</para>
+			<para>
+				<table frame="all">
+				<title>nat statement</title>
+					<tgroup cols='3' align='left' colsep='1' rowsep='1'>
+						<colspec colname='c1'/>
+						<colspec colname='c2'/>
+						<colspec colname='c3'/>
+						<thead>
+							<row>
+								<entry>Keyword</entry>
+								<entry>Description</entry>
+								<entry>Type</entry>
+							</row>
+						</thead>
+						<tbody>
+							<row>
+								<entry>snat</entry>
+								<entry>Specifies that the source address of the packet should be modified</entry>
+								<entry>ipv4 address/ipv6 address</entry>
+							</row>
+							<row>
+								<entry>dnat</entry>
+								<entry>Specifies that the destination address of the packet should be modified</entry>
+								<entry>ipv4 address/ipv6 address</entry>
+							</row>
+							<row>
+								<entry>flags</entry>
+								<entry>Flags</entry>
+								<entry>random, fully-random, persistent</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
 			</para>
 		</refsect2>
 		<refsect2>
 			<title>Queue statement</title>
 			<para>
+                                <cmdsynopsis>
+                                        <command>queue</command>
+                                        <arg choice="none">num</arg>
+                                        <replaceable>queue_num</replaceable>
+					<arg choice="req"><replaceable>flags</replaceable></arg>
+                                </cmdsynopsis>
+                        </para>
+			<para>
+				<table frame="all">
+					<title>queue statement</title>
+					<tgroup cols='3' align='left' colsep='1' rowsep='1'>
+						<colspec colname='c1'/>
+						<colspec colname='c2'/>
+						<colspec colname='c3'/>
+						<thead>
+							<row>
+								<entry>Keyword</entry>
+								<entry>Description</entry>
+								<entry>Type</entry>
+							</row>
+						</thead>
+						<tbody>
+							<row>
+								<entry>num</entry>
+								<entry>Sets queue number</entry>
+								<entry>unsigned integer (16 bit)</entry>
+							</row>
+							<row>
+								<entry>flags</entry>
+								<entry>Flags</entry>
+								<entry>bypass, fanout</entry>
+							</row>
+							<row>
+								<entry>total</entry>
+								<entry>Sets total load-balanced queues</entry>
+								<entry>unsigned integer (16 bit)</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
 			</para>
 		</refsect2>
 	</refsect1>
-- 
2.7.4

