From: Thomas Mader <thezema@gmail.com>
Subject: register callback for special packet types like udp and icmp?
Date: Fri, 11 Apr 2008 14:36:50 +0200
Message-ID: <47FF5B62.1040600@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:36624 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757295AbYDKMgy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Apr 2008 08:36:54 -0400
Received: by fg-out-1718.google.com with SMTP id l27so391137fgb.17
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Apr 2008 05:36:53 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

is there a way to define callback (match) functions for special packet 
types like udp and icmp? I would like to have a match function which 
only reacts on udp and icmp packets. Is this possible in a kernelspace 
module and/or in a libnetfilter_queue daemon and how?

thanks in advance,
Thomas
