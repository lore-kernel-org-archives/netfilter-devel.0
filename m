From: Ed W <lists@wildgooses.com>
Subject: How to make netfilter modules communicate?
Date: Mon, 01 Oct 2012 19:17:40 +0100
Message-ID: <5069DE44.6090306@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.nippynetworks.com ([91.220.24.129]:47223 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375Ab2JAS1J (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Oct 2012 14:27:09 -0400
Received: from localhost (mail1.nippynetworks.com [127.0.0.1])
	by mail1.nippynetworks.com (Postfix) with ESMTP id 7670F34033E
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Oct 2012 19:17:40 +0100 (BST)
Received: from mail1.nippynetworks.com ([127.0.0.1])
	by localhost (mail1.nippynetworks.com [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id hQ_GyhdIJLAQ for <netfilter-devel@vger.kernel.org>;
	Mon,  1 Oct 2012 19:17:40 +0100 (BST)
Received: from eds-macbook-pro.nippynetworks.local (unknown [212.69.38.73])
	(Authenticated sender: edward@wildgooses.com)
	by mail1.nippynetworks.com (Postfix) with ESMTPSA id 31E14340338
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Oct 2012 19:17:40 +0100 (BST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi, I'm plotting a custom accounting module which would give me some per 
device (MAC), per interface and per protocol bandwidth statistics, but I 
would quite like to decompose the module into several re-usable pieces 
and have them communicate.  I hope this isn't too dim a question, but 
how to make the modules communicate...?

For example some of my interfaces are attached to upstream connections 
which calculate bandwidth in a peculiar way (eg think ATM encapsulation, 
but even more wierd...).  I could create a new module which might match 
on interface and create a new per packet bandwidth computation based on 
the parameters for that upstream interface.  How then to make that 
computation available to other modules?

Also I'm trying to fixup the opendpi-netfilter module to work with nDPI 
and I would quite like to use that to classify all traffic such that the 
accounting module can then log per interface, per user and per 
protocol.  Again how to communicate between the accounting module and 
the ndpi module and tag that a certain connection is a particular protocol?

I already use connection marks quite extensively in this setup, so I 
would like to avoid crystalising this stuff into a conmark in some way, 
but is there a better way to say extend conntrack data to include things 
like custom protocol information, or are there other sensible ways to 
communicate between iptables modules?

Thanks for any thoughts

Ed W
