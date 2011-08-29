From: ZOU YOUTAO <Youtao.Zou@alcatel-sbell.com.cn>
Subject: can we use nfq_set_verdict to accept packets more than once with one packet_id?
Date: Mon, 29 Aug 2011 22:03:41 +0800
Message-ID: <D39C71B66797974C8687C6F5AC74A781069358FF@CNSHGSMBS01.ad4.ad.alcatel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cnshjsmin03.alcatel-sbell.com.cn ([211.144.215.47]:56742 "EHLO
	cnshjsmin03.alcatel-sbell.com.cn" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751766Ab1H2OEU convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:04:20 -0400
Content-Class: urn:content-classes:message
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


I need to develop an user space routing applcation.

My question is that I need to split an incoming udp packet to several
small ones and forward them to different servers.
Can I implement the requirement by  using libnetfilter_queue?

another requirement is that the incoming packet is not forwarded
immediately. A timer is set instead. The packet forwarding is performed
in the timeout handler. So we cannot invoke nfq_set_verdict in the end
of libnetfilter_queue callback function. We have to hold the packet_id
for the timeout handler for forwarding.
Does this introduce performance issue?
