From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: First userspace, then module
Date: Thu, 16 Apr 2009 09:02:16 +0200
Message-ID: <49E6D7F8.6030507@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:26768 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbZDPG5e (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Apr 2009 02:57:34 -0400
Received: by ey-out-2122.google.com with SMTP id 4so59237eyf.37
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2009 23:57:32 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I am playing around with an idea for a module that will manipulate the 
packets in userspace before passing them on to the xtables module. In 
other words, there will be two rules in iptables (in the samle table) 
and after userspace is done with the packet, it will be passed onto the 
next rule.

However, when creating a small prototype to see if this is possible, I 
did not find an equivalant to "XT_CONTINUE" that can be passed to 
nfq_set_verdict and I therefore did not get the prortype working.So my 
question is, is it possible to first send a packet to userspace, make a 
verdict and then have it processed by a rule in the same iptables-table?

Thanks,
Kristian
