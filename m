From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/2 nft] doc: nft: document log, reject, counter, meta, limit, nat and queue statements
Date: Thu,  8 Sep 2016 23:12:22 +0200
Message-ID: <1473369142-21765-2-git-send-email-pablo@netfilter.org>
References: <1473369142-21765-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44038 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754251AbcIHVMd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Sep 2016 17:12:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 681DF1E11B4
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Sep 2016 23:12:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4F0A9114D62
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Sep 2016 23:12:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CEBF0100A5F
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Sep 2016 23:12:26 +0200 (CEST)
In-Reply-To: <1473369142-21765-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the missing documentation for the aforementioned
statements.

This is based on original work from Shivani Bhardwaj.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/nft.xml | 457 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 454 insertions(+), 3 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index e6e8583..dbb36e0 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -2203,36 +2203,487 @@ filter input iif eth0 drop
 		<refsect2>
 			<title>Log statement</title>
 			<para>
+				<cmdsynopsis>
+					<command>log</command>
+					<arg choice="opt">prefix
+					<replaceable>string</replaceable></arg>
+					<arg choice="opt">level
+					<replaceable>syslog-level</replaceable></arg>
+				</cmdsynopsis>
+				<cmdsynopsis>
+					<command>log</command>
+					<arg choice="none">group
+					<replaceable>nflog_group</replaceable></arg>
+					<arg choice="opt">prefix
+					<replaceable>string</replaceable></arg>
+					<arg choice="opt">queue-threshold
+					<replaceable>value</replaceable></arg>
+					<arg choice="opt">snaplen
+					<replaceable>size</replaceable></arg>
+				</cmdsynopsis>
 			</para>
-		</refsect2>
+			<para>
+				The log statement enables logging of matching packets. When this statement is used from a rule, the Linux kernel will print some information on all matching packets, such as header fields, via the kernel log (where it can be read with dmesg(1) or read in the syslog). If the group number is specified, the Linux kernel will pass the packet to nfnetlink_log which will multicast the packet through a netlink socket to the specified multicast group. One or more userspace processes may subscribe to the group to receive the packets. This is a non-terminating statement, so the rule evaluation continues after the packet is logged.
+			</para>
+			<para>
+				<table frame="all">
+					<title>log statement options</title>
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
+								<entry>prefix</entry>
+								<entry>Prefix log messages</entry>
+								<entry>string</entry>
+							</row>
+							<row>
+								<entry>syslog-level</entry>
+								<entry>Syslog level of logging</entry>
+								<entry>string: emerg, alert, crit, err, warn [default], notice, info, debug</entry>
+							</row>
+							<row>
+                                                                <entry>group</entry>
+                                                                <entry>NFLOG group to send messages to</entry>
+                                                                <entry>unsigned integer (16 bit)</entry>
+                                                        </row>
+                                                         <row>
+                                                                <entry>snaplen</entry>
+                                                                <entry>Length of packet payload to include in netlink message</entry>
+                                                                <entry>unsigned integer (32 bit)</entry>
+                                                        </row>
+                                                         <row>
+                                                                <entry>queue-threshold</entry>
+                                                                <entry>Number of packets to queue inside the kernel before sending them to userspace</entry>
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
+				<cmdsynopsis>
+					<command>reject</command>
+					<arg choice="none">with</arg>
+					<group choice="req">
+						<arg>icmp</arg>
+						<arg>icmp6</arg>
+						<arg>icmpx</arg>
+					</group>
+					<arg choice="none">type</arg>
+					<group choice="req">
+						<arg>icmp_type</arg>
+						<arg>icmp6_type</arg>
+						<arg>icmpx_type</arg>
+					</group>
+				</cmdsynopsis>
+				<cmdsynopsis>
+					<command>reject</command>
+					<arg choice="none">with</arg>
+					<arg choice="req">tcp</arg>
+					<arg choice="req">reset</arg>
+				</cmdsynopsis>
+			</para>
+			<para>
+				A reject statement is used to send back an error packet in response to the matched packet otherwise it is equivalent to drop so it is a terminating statement, ending rule traversal. This statement is only valid in the input, forward and output chains, and user-defined chains which are only called from those chains.
+				<table frame="all">
+					<title>reject statement (ip)</title>
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
+								<entry>icmp_type</entry>
+								<entry>ICMP response to be sent to the host</entry>
+								<entry>unsigned integer (8 bit), net-unreachable, host-unreachable, prot-unreachable, port-unreachable [default], net-prohibited, host-prohibited, admin-prohibited</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
+				<table frame="all">
+					<title>reject statement (ip6)</title>
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
+								<entry>icmp6_type</entry>
+								<entry>ICMP6 response to be sent to the host</entry>
+								<entry>unsigned integer (8 bit), no-route, admin-prohibited, addr-unreachable, port-unreachable [default], policy-fail, reject-route</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
+				<table frame="all">
+					<title>reject statement (inet)</title>
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
+								<entry>icmpx_type</entry>
+								<entry>ICMP response to be sent to the host</entry>
+								<entry>unsigned integer (8 bit), port-unreachable [default], admin-prohibited, no-route, host-unreachable</entry>
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
+			<para>
+				<cmdsynopsis>
+					<command>counter</command>
+					<arg choice="req">packets
+					<replaceable>number</replaceable>
+					</arg>
+					<arg choice="req">bytes
+					<replaceable>number</replaceable>
+					</arg>
+				</cmdsynopsis>
+			</para>
+
 		</refsect2>
 		<refsect2>
 			<title>Meta statement</title>
 			<para>
+				A meta statement sets the value of a meta expression.
+				The existing meta fields are: priority, mark, pkttype, nftrace.
 			</para>
+			<para>
+				<cmdsynopsis>
+					<command>meta</command>
+					<group choice="req">
+						<arg>mark</arg>
+						<arg>priority</arg>
+						<arg>pkttype</arg>
+						<arg>nftrace</arg>
+					</group>
+					<arg choice="none">set</arg>
+					<replaceable>value</replaceable>
+				</cmdsynopsis>
+			</para>
+			<para>
+				A meta statement sets meta data associated with a packet.
+			</para>
+			<para>
+				<table frame="all">
+					<title>Meta statement types</title>
+					<tgroup cols='3' align='left' colsep='1' rowsep='1'>
+						<colspec colname='c1'/>
+						<colspec colname='c2'/>
+						<colspec colname='c3'/>
+						<thead>
+							<row>
+								<entry>Keyword</entry>
+								<entry>Description</entry>
+								<entry>Value</entry>
+							</row>
+						</thead>
+						<tbody>
+							<row>
+								<entry>priority</entry>
+								<entry>TC packet priority</entry>
+								<entry>tc_handle</entry>
+							</row>
+							<row>
+								<entry>mark</entry>
+								<entry>Packet mark</entry>
+								<entry>mark</entry>
+							</row>
+							<row>
+								<entry>pkttype</entry>
+								<entry>packet type</entry>
+								<entry>pkt_type</entry>
+							</row>
+							<row>
+								<entry>nftrace</entry>
+								<entry>ruleset packet tracing on/off. Use <command>monitor trace</command> command to watch traces</entry>
+								<entry>0, 1</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
+			</para>
+
+
 		</refsect2>
 		<refsect2>
 			<title>Limit statement</title>
 			<para>
+				<cmdsynopsis>
+					<command>limit</command>
+					<arg choice="none">rate</arg>
+					<arg choice="opt">over</arg>
+					<replaceable>packet_number</replaceable>
+					<arg choice="none">/</arg>
+					<group choice="req">
+						<arg>second</arg>
+						<arg>minute</arg>
+						<arg>hour</arg>
+						<arg>day</arg>
+					</group>
+					<arg>burst <replaceable>packet_number</replaceable> packets</arg>
+				</cmdsynopsis>
+				<cmdsynopsis>
+					<command>limit</command>
+					<arg choice="none">rate</arg>
+					<arg choice="opt">over</arg>
+					<replaceable>byte_number</replaceable>
+					<group choice="req">
+						<arg>bytes</arg>
+						<arg>kbytes</arg>
+						<arg>mbytes</arg>
+					</group>
+					<arg choice="none">/</arg>
+					<group choice="req">
+						<arg>second</arg>
+						<arg>minute</arg>
+						<arg>hour</arg>
+						<arg>day</arg>
+						<arg>week</arg>
+					</group>
+					<arg>burst <replaceable>byte_number</replaceable> bytes</arg>
+				</cmdsynopsis>
 			</para>
+			<para>
+				A limit statement matches at a limited rate using a token bucket filter. A rule using this statement will match until this limit is reached. It can be used in combination with the log statement to give limited logging. The <command>over</command> keyword, that is optional, makes it match over the specified rate.
+			</para>
+				<table frame="all">
+					<title>limit statement values</title>
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
+								<entry>packet_number</entry>
+								<entry>Number of packets</entry>
+								<entry>unsigned integer (32 bit)</entry>
+							</row>
+							<row>
+								<entry>byte_number</entry>
+								<entry>Number of  bytes</entry>
+								<entry>unsigned integer (32 bit)</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
 		</refsect2>
-			<refsect2>
-			<title>NAT statement</title>
+		<refsect2>
+			<title>NAT statements</title>
+			<para>
+				<cmdsynopsis>
+					        <command>snat</command>
+						<arg choice="none">to</arg>
+						<group choice="opt">
+							<arg>address</arg>
+							<arg>mapping</arg>
+						</group>
+						<arg choice="opt">:port</arg>
+						<arg choice="opt">persistent, random, fully-random</arg>
+				</cmdsynopsis>
+				<cmdsynopsis>
+						<command>dnat</command>
+						<arg choice="none">to</arg>
+						<group choice="opt">
+							<arg>address</arg>
+							<arg>mapping</arg>
+						</group>
+						<arg choice="opt">:port</arg>
+						<arg choice="opt">persistent, random, fully-random</arg>
+				</cmdsynopsis>
+			</para>
+			<para>
+				The nat statements are only valid from nat chain types.
+			</para>
 			<para>
+				The <command>snat</command> statement is only valid in the postrouting and input hooks, and non-base chains which are only called from those chains. It specifies that the source address of the packet should be modified. The <command>dnat</command> statement is only valid in the prerouting and output chains, and non-base chains which are only called from those chains. It specifies that the destination address of the packet should be modified. All future packets in this connection will also be mangled, and rules should cease being examined.
+			</para>
+			<para>
+				<table frame="all">
+				<title>NAT statement values</title>
+					<tgroup cols='3' align='left' colsep='1' rowsep='1'>
+						<colspec colname='c1'/>
+						<colspec colname='c2'/>
+						<colspec colname='c3'/>
+						<thead>
+							<row>
+								<entry>Expression</entry>
+								<entry>Description</entry>
+								<entry>Type</entry>
+							</row>
+						</thead>
+						<tbody>
+							<row>
+								<entry>address</entry>
+								<entry>Specifies that the source/destination address of the packet should be modified</entry>
+								<entry>ipv4_addr, ipv6_addr, eg. abcd::1234</entry>
+							</row>
+							<row>
+								<entry>port</entry>
+								<entry>Specifies that the source/destination address of the packet should be modified</entry>
+								<entry>port number (16 bits)</entry>
+							</row>
+							<row>
+								<entry>mapping</entry>
+								<entry>Specifies a list of tuples that relates any arbitrary expression key with address value</entry>
+								<entry>mapping expression, eg. meta mark map { 10 : 192.168.1.2, 20 : 192.168.1.3 }</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
+				<table frame="all">
+				<title>NAT statement flags</title>
+					<tgroup cols='2' align='left' colsep='1' rowsep='1'>
+						<colspec colname='c1'/>
+						<colspec colname='c2'/>
+						<thead>
+							<row>
+								<entry>Flag</entry>
+								<entry>Description</entry>
+							</row>
+						</thead>
+						<tbody>
+							<row>
+								<entry>persistent</entry>
+								<entry>Gives a client the same source-/destination-address for each connection.</entry>
+							</row>
+							<row>
+								<entry>random</entry>
+								<entry>If used then port mapping will be randomized using a random seeded MD5 hash mix using source and destination address and destination port.</entry>
+							</row>
+							<row>
+								<entry>fully-random</entry>
+								<entry>If used then port mapping is generated based on a 32-bit pseudo-random algorithm suitable for simulation.</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
+
 			</para>
 		</refsect2>
 		<refsect2>
 			<title>Queue statement</title>
 			<para>
+				This statement passes the packet to userspace using the nfnetlink_queue handler. The packet is put into the queue identified by its 16-bit queue number. Userspace can inspect and modify the packet if desired. Userspace must then drop or reinject the packet into the kernel. Please see libnetfilter_queue documentation for details.
+			</para>
+			<para>
+                                <cmdsynopsis>
+                                        <command>queue</command>
+                                        <arg choice="opt">num
+                                        <replaceable>queue_number</replaceable></arg>
+					<arg choice="opt">bypass</arg>
+                                </cmdsynopsis>
+                                <cmdsynopsis>
+                                        <command>queue</command>
+                                        <arg choice="opt">num
+                                        <replaceable>queue_number_from</replaceable> - <replaceable>queue_number_to</replaceable></arg>
+					<arg choice="opt">bypass,fanout</arg>
+                                </cmdsynopsis>
+                        </para>
+			<para>
+				<table frame="all">
+					<title>queue statement values</title>
+					<tgroup cols='3' align='left' colsep='1' rowsep='1'>
+						<colspec colname='c1'/>
+						<colspec colname='c2'/>
+						<colspec colname='c3'/>
+						<thead>
+							<row>
+								<entry>Value</entry>
+								<entry>Description</entry>
+								<entry>Type</entry>
+							</row>
+						</thead>
+						<tbody>
+							<row>
+								<entry>queue_number</entry>
+								<entry>Sets queue number, default is 0.</entry>
+								<entry>unsigned integer (16 bit)</entry>
+							</row>
+							<row>
+								<entry>queue_number_from</entry>
+								<entry>Sets initial queue in the range if fanout is used.</entry>
+								<entry>unsigned integer (16 bit)</entry>
+							</row>
+							<row>
+								<entry>queue_number_to</entry>
+								<entry>Sets closing queue in the range if fanout is used.</entry>
+								<entry>unsigned integer (16 bit)</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
+				<table frame="all">
+					<title>queue statement flags</title>
+					<tgroup cols='2' align='left' colsep='1' rowsep='1'>
+						<colspec colname='c1'/>
+						<colspec colname='c2'/>
+						<thead>
+							<row>
+								<entry>Flag</entry>
+								<entry>Description</entry>
+							</row>
+						</thead>
+						<tbody>
+							<row>
+								<entry>bypass</entry>
+								<entry>Let packets go through is userspace application cannot back off. Before using this flag, read libnetfilter_queue documentation for performance tuning recomendations.</entry>
+							</row>
+							<row>
+								<entry>fanout</entry>
+								<entry>Distribute packets between several queues.</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
 			</para>
 		</refsect2>
 	</refsect1>
-- 
2.1.4

