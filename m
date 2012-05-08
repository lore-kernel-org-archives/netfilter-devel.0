From: Krishna Kumar <krkumar2@in.ibm.com>
Subject: [v2 PATCH 0/6] netfilter: "fail-open" feature support for NFQUEUE
Date: Tue, 08 May 2012 15:13:42 +0530
Message-ID: <20120508094342.19531.51351.sendpatchset@localhost.localdomain>
Cc: vivk@us.ibm.com, svajipay@in.ibm.com, fw@strlen.de,
	netfilter-devel@vger.kernel.org,
	Krishna Kumar <krkumar2@in.ibm.com>, sri@us.ibm.com
To: kaber@trash.net, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:58831 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab2EHJsU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 May 2012 05:48:20 -0400
Received: from /spool/local
	by e28smtp04.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <netfilter-devel@vger.kernel.org> from <krkumar2@in.ibm.com>;
	Tue, 8 May 2012 15:14:31 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay01.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q489hjYD327998
	for <netfilter-devel@vger.kernel.org>; Tue, 8 May 2012 15:13:45 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q48FDWH1021753
	for <netfilter-devel@vger.kernel.org>; Wed, 9 May 2012 01:13:33 +1000
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

This patch set implements a "failopen" support for NFQUEUE to help
keep connections open during such failures. This is achieved by
allowing acceptance of packets temporarily when the queue is full,
which enables existing connections to be kept alive. Customers have
expressed preference for this option as similar feature is available
on other systems.

Failopen is enabled/disabled using nfq_set_failopen() call, which
uses netlink's NFQA_CFG_FAIL_OPEN attribute (will submit the library
code to turn fail-open on/off later). During a stalled scp session,
application can call this new API with fail-open set to continue the
session, as can be seen below:

		Server:
# iptables -A INPUT -p tcp -m mac --mac-source 00:00:C9:C6:4F:22 \
	-j NFQUEUE --queue-num 0
# Run interceptor program with 50ms delay between packet processing, and
	also sets qlen to 16. After every read system call, this program
	tests and read's a config file's contents (0 or 1) and dynamically
	calls nfq_set_failopen(qh, val).

		Client:
# scp LARGE_FILE 10.0.4.1:/tmp
LARGE_FILE                           2% 2832KB 183.7KB/s   09:38 ETA
LARGE_FILE                           2% 3088KB  67.3KB/s   26:14 ETA
	<Set failopen=1 on server at this time>
LARGE_FILE                           11%   12MB   1.0MB/s   01:35 ETA
LARGE_FILE                           70%   75MB   7.2MB/s   00:04 ETA
LARGE_FILE                           100%  107MB   2.5MB/s  00:42


Please review.

Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
Signed-off-by: Vivek Kashyap <vivk@us.ibm.com>
Signed-off-by: Sridhar Samudrala <samudrala@us.ibm.com>
---

