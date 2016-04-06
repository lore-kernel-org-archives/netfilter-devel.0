From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] doc: Complete the documentation of statements
Date: Wed, 6 Apr 2016 11:39:19 +0530
Message-ID: <20160406060919.GA2432@shivani>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36833 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbcDFGKG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Apr 2016 02:10:06 -0400
Received: by mail-pf0-f193.google.com with SMTP id q129so3306690pfb.3
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Apr 2016 23:10:06 -0700 (PDT)
Received: from shivani ([116.202.38.137])
        by smtp.gmail.com with ESMTPSA id wh9sm1789574pab.8.2016.04.05.23.09.59
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 05 Apr 2016 23:10:04 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add documentation corresponding to LOG STATEMENT, REJECT STATEMENT,
COUNTER STATEMENT, META STATEMENT, LIMIT STATEMENT, NAT STATEMENT,
QUEUE STATEMENT.

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 doc/nft.xml | 188 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 187 insertions(+), 1 deletion(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index e4d227c..cec4dbf 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -2186,36 +2186,222 @@ filter input iif eth0 drop
 		<refsect2>
 			<title>Log statement</title>
 			<para>
+				A log statement is used to set logging attributes of a packet. Default log level is warn.
+				<table frame="all">
+					<title>LOG statement</title>
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
+								<entry>unsigned integer (32 bit), emerg, alert, crit, err, warn, notice, info, debug</entry>
+							</row>
+							<row>
+								<entry>prefix</entry>
+								<entry>Prefix log messages</entry>
+								<entry>string</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
 			</para>
 		</refsect2>
 		<refsect2>
 			<title>Reject statement</title>
 			<para>
+				A reject statement is used to set an error packet response. The default error packet is port-unreachable.
+				<table frame="all">
+					<title>REJECT statement (ipv4)</title>
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
+								<entry>unsigned integer (8 bit), net-unreachable, host-unreachable, prot-unreachable, port-unreachable, net-prohibited, host-prohibited, admin-prohibited</entry>
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
+					<title>REJECT statement (ipv6)</title>
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
+								<entry>unsigned integer (8 bit), no-route, admin-prohibited, addr-unreachable, port-unreachable, policy-fail, reject-route</entry>
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
 			</para>
 		</refsect2>
 		<refsect2>
 			<title>Limit statement</title>
 			<para>
+				A limit statement is used to set a specified limit attribute.
+				<table frame="all">
+					<title>Limit statement</title>
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
+					<group choice="req">
+						<arg>snat</arg>
+						<arg>dnat</arg>
+					</group>
+					<arg choice="req"><replaceable>flags</replaceable></arg>
+				</cmdsynopsis>
+			</para>
+			<para>
+				<table frame="all">
+				<title>NAT statement</title>
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
+					<title>Queue statement</title>
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

