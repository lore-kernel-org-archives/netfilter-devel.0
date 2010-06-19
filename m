From: Andrew Beverley <andy@andybev.com>
Subject: Accessing packet marking functions
Date: Sat, 19 Jun 2010 17:42:19 +0100
Message-ID: <1276965739.1476.35.camel@andybev>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from earth.simplelists.com ([89.16.184.171]:60570 "EHLO
	earth.simplelists.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab0FSRGW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Jun 2010 13:06:22 -0400
Received: from [10.95.168.244] (unknown [82.132.248.168])
	by earth.simplelists.com (Postfix) with ESMTP id 7DB181B3002D
	for <netfilter-devel@vger.kernel.org>; Sat, 19 Jun 2010 17:42:28 +0100 (BST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I am considering patching Squid proxy so that it retains a packet's mark
value if it could not be fetched from the cache. Squid already has
similar functionality for the TOS field, but I would like to extend this
to netfilter's mark feature.

Can somebody point me in the right direction for the correct way of
setting and accessing the mark value of a packet? The TOS feature in
Squid uses setsockopt(). Is there an equivalent for mark? Should I be
using libnetfilter_queue?

Thanks in advance,

Andy


