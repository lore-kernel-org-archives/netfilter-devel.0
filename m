From: Ed W <lists@wildgooses.com>
Subject: How to access conntrack connection expiration in a netfilter module?
Date: Mon, 01 Oct 2012 22:17:02 +0100
Message-ID: <506A084E.5060505@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.nippynetworks.com ([91.220.24.129]:46510 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757467Ab2JAVRD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Oct 2012 17:17:03 -0400
Received: from localhost (mail1.nippynetworks.com [127.0.0.1])
	by mail1.nippynetworks.com (Postfix) with ESMTP id 105CD340338
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Oct 2012 22:17:02 +0100 (BST)
Received: from mail1.nippynetworks.com ([127.0.0.1])
	by localhost (mail1.nippynetworks.com [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id UdFM31f28M5i for <netfilter-devel@vger.kernel.org>;
	Mon,  1 Oct 2012 22:17:01 +0100 (BST)
Received: from eds-macbook-pro.nippynetworks.local (unknown [212.69.38.73])
	(Authenticated sender: edward@wildgooses.com)
	by mail1.nippynetworks.com (Postfix) with ESMTPSA id C7BB2340305
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Oct 2012 22:17:01 +0100 (BST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi, I'm trying to update the opendpi-netfilter module to work with more 
recent kernels and the ntop ndpi fork of the code (now that opendpi 
seems to have gone away)

The netfilter module registers a conntrack notifier in order to release 
resources once a conntrack is destroyed
https://github.com/ewildgoose/ndpi-netfilter/blob/master/src/main.c
This is not possible though, if you also want to have conntrack events 
through netlink... ( NF_CT_NETLINK grabs the conntrack notifier first)

Now I have read the history on why this is the case, but what are the 
obvious workarounds to this situation?  Can we extend the conntrack 
connection with custom properties? Anything better than simply scanning 
my flows occasionally and comparing with the conntrack list to see if 
they have gone away?

Thanks for any thoughts

Ed W

