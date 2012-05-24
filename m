From: Krishna Kumar <krkumar2@in.ibm.com>
Subject: [v5 PATCH 0/1] netfilter: "fail-open" feature support for NFQUEUE
Date: Thu, 24 May 2012 19:26:31 +0530
Message-ID: <20120524135631.24345.60254.sendpatchset@localhost.localdomain>
Cc: vivk@us.ibm.com, svajipay@in.ibm.com, fw@strlen.de,
	netfilter-devel@vger.kernel.org,
	Krishna Kumar <krkumar2@in.ibm.com>, sri@us.ibm.com
To: kaber@trash.net, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:43799 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445Ab2EXN4m (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 May 2012 09:56:42 -0400
Received: from /spool/local
	by e23smtp09.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <netfilter-devel@vger.kernel.org> from <krkumar2@in.ibm.com>;
	Thu, 24 May 2012 14:44:44 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay05.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q4ODnVor23789642
	for <netfilter-devel@vger.kernel.org>; Thu, 24 May 2012 23:49:32 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q4ODuYmo020170
	for <netfilter-devel@vger.kernel.org>; Thu, 24 May 2012 23:56:36 +1000
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Many users of an IBM security product, which uses netfilter's NFQUEUE
target to process packets in userspace, face a problem of dropped
connections during heavy load. Incoming packets are queued and
processed by the security module, which does deep packet analysis to
decide whether to accept or reject them. However during heavy load,
the queue fills up and connections fail when large number of packets
get dropped.

This patch implements a "failopen" support for NFQUEUE to help keep
connections open during such failures. This is achieved by allowing
acceptance of packets temporarily when the queue is full, which
enables existing connections to be kept open.

Failopen is enabled/disabled using a new call - nfq_set_flags(qh,
mask, flags), which makes use of two new netlink attributes:
	NFQA_CFG_MASK -  Specifies which flags are being modified.
	NFQA_CFG_FLAGS - Set/reset the bits for each of those flags.


		Tests done:
		------------
- netperf TCP_STREAM.
- 64 netperf stress testing to ensure there are no memory leaks.
- icmp ping.
- enabling/disabling failopen in the middle of existing connections.
- checksum verification of transferred files using scp.
- different flag/mask values to check that code handling NFQA_CFG_MASK
  works as expected.


		Test results:
		-------------
Server:
-------
# iptables -A INPUT -p tcp -m mac --mac-source 00:00:C9:C6:4F:22 \
	-j NFQUEUE --queue-num 0
# Run interceptor program with 50ms delay between packet processing,
  and also sets qlen to 16. After every read system call, this program
  tests and read's a config file's contents and calls
  nfq_set_flags(qh, mask, flags).

Client:
-------
	---> failopen is disabled on server at this time
# netperf -v0 -H 10.0.4.1
TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 10.0.4.1 (10.0.4.1) port 0 AF_INET
0.16   
	---> failopen is enabled on server at this time
# netperf -v0 -H 10.0.4.1
TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 10.0.4.1 (10.0.4.1) port 0 AF_INET
2292.82 

	---> failopen is disabled on server at this time
# scp FILE 10.0.4.1:/tmp
FILE                             0% 2960KB  88.4KB/s 12:19:37 ETA
	---> Enable failopen on server at this time
FILE                             21%  809MB  44.2MB/s   01:08 ETA
	---> Disable failopen on server at this time
FILE                             23%  903MB 157.4KB/s 5:18:01 ETA
	---> Enable failopen on server at this time
FILE                             100% 3835MB  24.1MB/s   02:39    

Changes from rev4:
------------------

1. Localize all changes to net/netfilter/nfnetlink_queue.c, which
	helps remove GSO handling and other code in core.


Changes from rev3:
------------------

1. Changed flags/mask to big-endian.
2. Use nla_get_be32 instead of nla_data to access flags/masks.
3. Cleaned up some comments.


Changes from rev2:
------------------

1. Changed NFQA_CFG_FAIL_OPEN to generic NFQA_CFG_FLAGS and NFQA_CFG_MASK to
	support new flags/options in future.
2. Enqueue handler changed to return -ENOSPC on queue-full condition.
3. Do not invoke okfn on -ENOSPC, but process all hooks first. nf_hook_slow
   has code to handle failopen.

Please review.

Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
Signed-off-by: Vivek Kashyap <vivk@us.ibm.com>
Signed-off-by: Sridhar Samudrala <samudrala@us.ibm.com>
---

