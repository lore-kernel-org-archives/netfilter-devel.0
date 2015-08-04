From: Aju L Francis <aju@iraw.net>
Subject: IPv6 support for GRE helper(nf_conntrack_proto_gre)
Date: Tue, 04 Aug 2015 13:14:40 -0400
Message-ID: <1438708480.1197054.347597513.3BF1F74D@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50350 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753397AbbHDROn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2015 13:14:43 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailout.nyi.internal (Postfix) with ESMTP id 6BF5B20478
	for <netfilter-devel@vger.kernel.org>; Tue,  4 Aug 2015 13:14:40 -0400 (EDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

    We are trying to implement GRE over IPv6 on Linux running kernel
    3.13.0-53. But found that IPv6 traffic is being marked as INVALID by
    netfilter. Wanted to know if there is any effort on having IPv6
    support for the GRE helper nf_conntrack_proto_gre. 

Thanks in advance.

-- 
Aju  Francis
