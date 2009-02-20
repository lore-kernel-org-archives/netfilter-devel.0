From: Ralf <rm@amitrader.com>
Subject: Syntax errors in man and help regarding rulenum placement
Date: Fri, 20 Feb 2009 16:12:49 +0100
Message-ID: <gnmh9h$vt7$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:45651 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456AbZBTPNA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Feb 2009 10:13:00 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1LaX3i-0004H9-Hi
	for netfilter-devel@vger.kernel.org; Fri, 20 Feb 2009 15:12:58 +0000
Received: from p57a2fbdf.dip.t-dialin.net ([87.162.251.223])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Feb 2009 15:12:58 +0000
Received: from rm by p57a2fbdf.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Feb 2009 15:12:58 +0000
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

man iptables of v1.4.2 gives these 2 different syntaxes
for example for the -I option: 

  iptables [-t table] -I [rulenum] rule-specification [options...]
 
  iptables [-t table] -I chain [rulenum] rule-specification


And iptables --help gives these:

  iptables -[RI] chain rulenum rule-specification [options]

  --insert  -I chain [rulenum]

  
This is all irritating, don't you think so?
Which of them is the officially correct one
regarding the placement (location) of the rulenum?

