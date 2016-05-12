From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH v3] doc: Complete the documentation of statements
Date: Thu, 12 May 2016 16:57:14 +0530
Message-ID: <20160512112714.GA10290@shivani>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34215 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbcELL13 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 May 2016 07:27:29 -0400
Received: by mail-pf0-f194.google.com with SMTP id 145so6198242pfz.1
        for <netfilter-devel@vger.kernel.org>; Thu, 12 May 2016 04:27:29 -0700 (PDT)
Received: from shivani ([124.124.47.116])
        by smtp.gmail.com with ESMTPSA id fn3sm19198719pab.20.2016.05.12.04.27.27
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Thu, 12 May 2016 04:27:28 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add documentation corresponding to LOG STATEMENT, REJECT STATEMENT,
COUNTER STATEMENT, META STATEMENT, LIMIT STATEMENT, NAT STATEMENT,
QUEUE STATEMENT.

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
Changes in v3:
	Correct meta fields, use lowercase statement names, merge nflog
	with log.

Changes in v2:
	Add more content to the description.

 doc/nft.xml | 227 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 225 insertions(+), 2 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index e4d227c..e3cd2d3 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -2186,36 +2186,259 @@ filter input iif eth0 drop
 		<refsect2>
 			<title>Log statement</title>
 			<para>
+				<cmdsynopsis>
+					        <command>log</command>
+					<group choice="req">
+						        <arg>prefix</arg>
+							<arg>level</arg>
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
+						<group choice="req">
+							<arg>rate</arg>
+							<arg>burst</arg>
+						</group>
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
+					        <group choice="req">
+						        <arg>snat</arg>
+							<arg>dnat</arg>
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
1.9.1

