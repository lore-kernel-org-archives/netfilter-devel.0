From: Ralf <rm@amitrader.com>
Subject: iptables return code 256
Date: Fri, 20 Feb 2009 21:33:48 +0100
Message-ID: <gnn43d$647$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:45725 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716AbZBTUeA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Feb 2009 15:34:00 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Lac4M-0001th-Fz
	for netfilter-devel@vger.kernel.org; Fri, 20 Feb 2009 20:33:58 +0000
Received: from p57a2d807.dip.t-dialin.net ([87.162.216.7])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Feb 2009 20:33:58 +0000
Received: from rm by p57a2d807.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Feb 2009 20:33:58 +0000
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sometimes an insert operation (-I) fails and iptables returns 256.
Under which circumstances can iptables give a return code 256 ?

(I guess it happens when an internal resource is in locked state
when user issues the iptables command, right?)  

