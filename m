From: Krishna Kumar <krkumar2@in.ibm.com>
Subject: [RFC] [PATCH 0/4] netfilter: "fail-open" feature support for NFQUEUE
Date: Mon, 07 May 2012 11:33:38 +0530
Message-ID: <20120507060338.19528.29403.sendpatchset@localhost.localdomain>
Cc: svajipay@in.ibm.com, vivk@us.ibm.com,
	Krishna Kumar <krkumar2@in.ibm.com>, sri@us.ibm.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:54866 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab2EGGDp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 May 2012 02:03:45 -0400
Received: from /spool/local
	by e28smtp01.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <netfilter-devel@vger.kernel.org> from <krkumar2@in.ibm.com>;
	Mon, 7 May 2012 11:33:42 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay03.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q4763d074718900
	for <netfilter-devel@vger.kernel.org>; Mon, 7 May 2012 11:33:40 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q47BY917013917
	for <netfilter-devel@vger.kernel.org>; Mon, 7 May 2012 21:34:09 +1000
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Many users of an IBM security product, which uses netfilter's NFQUEUE
target to process packets in userspace, face a problem of dropped
connections during heavy load. Incoming packets are queued and
processed by the security module, which does deep packet analysis to
decide whether to accept or reject them. However during heavy load,
NFQUEUE queue (default 1024 entries) fills up and connections fail
after large number of packets drop during enqueue. Increasing the
queue size delays the problem and also worsens latency.

This patch set implements a "failopen" support to help keep connections
open during such failures. This is achieved by allowing acceptance of
packets temporarily when the queue is full, which enables existing
connections to be kept alive. Customers prefer this option as similar
feature is available on other systems.

This patch set implements failopen for NFQUEUE (though a similar patch
for IPQUEUE is also implemented but not submitted at this time). I will
submit the iptables changes which controls turning failopen mode on/off
later. The original requirement for sysctl option is not implemented -
please let me know whether that is acceptable/preferable.

-------------------------- Results -----------------------------
		Server:
# iptables -A INPUT -p tcp -m mac --mac-source 00:00:C9:C6:4F:22 -j NFQUEUE --queue-num 0
# Run interceptor program with 50ms delay between packet processing, and
	also sets qlen to 8

		Client:
# netperf -v0 -H 10.0.4.1 -l 10
TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 10.0.4.1 (10.0.4.1) port 0 AF_INET
0.22 

# scp /tmp/LARGE_FILE_1 10.0.4.1:/tmp
/tmp/LARGE_FILE_1                          8% 8848KB  24.0KB/s 1:09:41 ETA
---------------------------------------------------------
		Server:
# iptables -A INPUT -p tcp -m mac --mac-source 00:00:C9:C6:4F:22 -j NFQUEUE --queue-num 0 --fail-open
# Run interceptor program with 50ms delay between packet processing, and
	also sets qlen to 8

		Client:
# netperf -v0 -H 10.0.4.1 -l 10
TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 10.0.4.1 (10.0.4.1) port 0 AF_INET
4184.48 

# scp /tmp/LARGE_FILE_2 10.0.4.1:/tmp
/tmp/LARGE_FILE_2                          100%  107MB 106.5MB/s   00:01    
---------------------------------------------------------

Please review and provide feedback/comments.

Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
---

