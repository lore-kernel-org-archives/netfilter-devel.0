From: Hugo Miguel Mendes <hugo-m-mendes@ptinovacao.pt>
Subject: NTP Full cone NAT
Date: Wed, 29 Jul 2009 17:34:04 +0100
Message-ID: <47A7F67C62706041BC49DB7822B1C9DB34D79A873D@INOAVREX11.ptin.corpPT.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from owa.ptinovacao.pt ([194.65.138.99]:18915 "EHLO
	owa.ptinovacao.pt" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177AbZG2Qen convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Jul 2009 12:34:43 -0400
Content-Language: pt-PT
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dear all,

I'm operating netfilter on a router and I have a client on the LAN side which is making requests to an NTP server on the WAN side. The NTP server responds from a different IP from that where the client sends the request, but the response from the NTP server goes to the same port on the client from where it sent the request. 
I developed a conntrack helper module and a nat helper module so that an expectation is created for the response from the server. These modules are identical to the modules used for TFTP.

When the modules are operating the expectations are created when the request from the client is sent, but it immediatly disappears and in the conntrack table the connection coming from the server which is related to the one made by the request from the client never appears.

udp      17 17 src=188.80.107.154 dst=188.80.102.162 sport=1110 dport=33147 packets=1 bytes=544 [UNREPLIED] src=172.16.0.184 dst=188.80.107.154 sport=33147 dport=1110 packets=0 bytes=0 mark=0 use=1
udp      17 37 src=172.16.0.184 dst=188.80.107.154 sport=33147 dport=69 packets=5 bytes=255 [UNREPLIED] src=188.80.107.154 dst=188.80.102.162 sport=69 dport=33147 packets=0 bytes=0 mark=0 use=2

These are two entries in the conntrack table for TFTP, where 172.16.0.184 requested a file from 188.80.102.162 in the second entry. In the first entry comes the requested file, which is the expected connection.

Using my module I have the following entries in the conntrack

udp      17 55 src=172.16.0.184 dst=194.65.47.55 sport=37705 dport=123 packets=1 bytes=76 [UNREPLIED] src=194.65.47.55 dst=10.194.30.172 sport=123 dport=37705 packets=0 bytes=0 mark=0 use=1

Here the client is 172.16.0.184 and is making the request to 194.65.47.55, the NTP server. The IP which answers from the server is 213.13.16.227 and goes to 10.194.30.172. The expectation which appears in the expectations table is:

600 proto=17 src=0.0.0.0 dst=10.194.30.172 sport=0 dport=37705

The problem is that the connection coming from 213.13.16.227 never appears on the conntrack table.

I have logged the packets coming from the NTP server in the FORWARD chain of the filter table and I have the this:

IN=eth0.12 OUT=br-lan SRC=213.13.16.227 DST=172.16.0.184 LEN=76 TOS=0x08 PREC=0x20 TTL=124 ID=31524 PROTO=UDP SPT=123 DPT=39843 LEN=56

This means that the packets have been successfully NATed but they never arrive ate 172.16.0.184. I don't know why this is happening.

Best Regards

Hugo Mendes