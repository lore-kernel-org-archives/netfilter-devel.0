From: "Yigal Reiss (yreiss)" <yreiss@cisco.com>
Subject: batch netlink messages - performance improvement
Date: Thu, 25 Feb 2016 19:43:04 +0000
Message-ID: <dab4ca588cd243b0b36b7b0283bd50dd@XCH-RCD-014.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rcdn-iport-4.cisco.com ([173.37.86.75]:47471 "EHLO
	rcdn-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933646AbcBYTw6 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Feb 2016 14:52:58 -0500
Received: from XCH-RCD-012.cisco.com (xch-rcd-012.cisco.com [173.37.102.22])
	by alln-core-9.cisco.com (8.14.5/8.14.5) with ESMTP id u1PJh4Cw019940
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL)
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Feb 2016 19:43:05 GMT
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I would like to check an idea.

I am using nfqueue for DPI in user space. I use the already existing batch verdict from user space. The problem with that is that reducing the number of user <--> kernel context switches is bound to 1/2, since kernel --> user space still reports every single packet. So if I have batch verdict for every 25 or 50 packets, then still I only reduced the number of switches by an order of 2. 

So I tried batching the unicast netlink messages (carrying the packets) from kernel to user space. I do that by calling sk->sk_data_ready(sk); (in __netlink_sendskb() in af_netlink.c) only every [N] packets. This seems to contribute similar performance improvements as the batch verdict.

However I have no experience in kernel programming and currently I only implemented a quick and dirty hack (no timeout, assuming a single socket...) just to demonstrate the improvement. My question is therefore whether such an improvement could be interesting for the main kernel. Does it bear any problems etc.

If this suggestion makes sense, how would you suggest proceed with this idea? I could continue and start working on a patch, but since as I wrote I have no experience in kernel programming I would like to have some thumbs up for the directions I'm taking, what makes sense and what's not etc so I don't waste my and other people time.

B.t.w., I saw that there is another potential improvement which is mmaping the packets to user space. I couldn't figure out whether this feature is complete in any kernel version and is it ready to use. 

Thanks,
Yigal

