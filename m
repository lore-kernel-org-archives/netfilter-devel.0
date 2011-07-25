From: Ed W <lists@wildgooses.com>
Subject: ipset "contains" question
Date: Mon, 25 Jul 2011 23:25:29 +0100
Message-ID: <4E2DED59.1030902@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.nippynetworks.com ([91.220.24.129]:47169 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab1GYWZa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jul 2011 18:25:30 -0400
Received: from localhost (mail1.nippynetworks.com [127.0.0.1])
	by mail1.nippynetworks.com (Postfix) with ESMTP id 0D4183402DC
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Jul 2011 23:25:30 +0100 (BST)
Received: from mail1.nippynetworks.com ([127.0.0.1])
	by localhost (mail1.nippynetworks.com [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id R4BLChtDnKES for <netfilter-devel@vger.kernel.org>;
	Mon, 25 Jul 2011 23:25:29 +0100 (BST)
Received: from Ed-Wildgooses-MacBook-Pro.local (office.nippynetworks.com [212.69.49.94])
	(Authenticated sender: edward@wildgooses.com)
	by mail1.nippynetworks.com (Postfix) with ESMTPSA id C222F3402D5
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Jul 2011 23:25:29 +0100 (BST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

Many thanks for ipset.  Quick question please: I'm implementing a
captive portal and I have an ipset (CP) containing bitmap:ip,mac.  How
should I best implement rules to:

- Drop packets from same IP, different MAC

I might be missing the obvious, but how do I query to match on IP, then
drop IP with a mismatching MAC (in the bitmap ipset)? Can this be done
without a second ipset tracking only IP?

Thanks for any tips?

Ed W
