From: Anton <anton.vazir@gmail.com>
Subject: iptables performance and alternatives
Date: Thu, 15 May 2008 14:21:23 +0500
Message-ID: <200805151421.23862.anton.vazir@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "netfilter-devel" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.eastera.tj ([82.198.21.18]:60325 "EHLO mail.eastera.tj"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277AbYEOJWR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 May 2008 05:22:17 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Regarding the performance of the lookup of the iptables 
rules for match inside the kernel, is there any plans to 
improve the behaviour or no plans in this area yet?

For example on the transit gateway I have ~500 rules which 
mark the packet, according to the client source IP - with 
unique mark per client IP - so I have 500 unique marks 
there, and so cannot use IPSET, and only IPTABLES - but 
it's known that iptables insert/lookup is very slow on huge 
rulesets (atleat with iptables 1.3.x) and slowness 
progresses approximatelly exponentially on growth of rules 
number.

Do I miss anything?
