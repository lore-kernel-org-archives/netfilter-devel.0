From: "Yigal Reiss (yreiss)" <yreiss@cisco.com>
Subject: NFQUEUE "fail-open" only open to queue limit and not receive buffer
 limit
Date: Wed, 9 Mar 2016 20:37:13 +0000
Message-ID: <7966959fae8e4dd5b13ba4d607ac2db4@XCH-RTP-014.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rcdn-iport-7.cisco.com ([173.37.86.78]:64410 "EHLO
	rcdn-iport-7.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbcCIUhP convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Mar 2016 15:37:15 -0500
Received: from XCH-RTP-014.cisco.com (xch-rtp-014.cisco.com [64.101.220.154])
	by rcdn-core-9.cisco.com (8.14.5/8.14.5) with ESMTP id u29KbEdq007098
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL)
	for <netfilter-devel@vger.kernel.org>; Wed, 9 Mar 2016 20:37:14 GMT
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently the "fail-open" feature in NFQUEUE passes packets only in the case where the limit comes from the queue size (queue->queue_total >= queue->queue_maxlen).

In case where the qlen is high and the load is high, packets will be dropped as result of crossing the socket's receive buffer size. This will eventually be reported through the proc file as 'user dropped' (don't know why). 

>From user perspective IMO the user doesn't care if the packet cannot be passed as a result of a queue size or socket receive buffer size. This is quite arbitrary and depends on average packet size. Actually the result may be opposite to what the user desired if he raises the qlen wishing to increase availability but in fact causing more packets be dropped due to receive buffer limitations.
I suggest implementing the same behavior (fail open) also for the case where nfnetlink_unicast() fails (which usually would be due to receive buffer limit).

Does this make sense?

If so, what would be the recommended way of achieving that? The problem is that skb is being freed at netlink level (netlink_attachskb). So it's either copying the skb each time before calling nfnetlink_unicast() (wasteful) or passing a flag all the way to indicate that freeing is not desired (lots of changes and involves also core netlink). Any other suggestions?
