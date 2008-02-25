From: Anton <anton.vazir@gmail.com>
Subject: TC interface
Date: Mon, 25 Feb 2008 13:58:12 +0500
Message-ID: <200802251358.12898.anton.vazir@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from postman.tajik.net ([82.198.21.5]:54299 "HELO postman.tajik.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751456AbYBYJFG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Feb 2008 04:05:06 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello!

I'm trying to figure out how to interface with the kernel's 
qos structires. I've found libiptc HOWTO - but it's very 
outdated and provides only IPTABLES manipulation, not 
traffic scheduler. Could anyone please advice, if there is 
a C library, which provides an abstraction for easier 
manipulation with kernel internals to not use "tc" 
and "iptables"?

Best regards to everyone,
Anton.
