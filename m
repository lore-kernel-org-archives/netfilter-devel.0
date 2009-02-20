From: Ralf <rm@amitrader.com>
Subject: Re: iptables return code 256
Date: Fri, 20 Feb 2009 22:58:37 +0100
Message-ID: <gnn92e$ln9$1@ger.gmane.org>
References: <gnn43d$647$1@ger.gmane.org> <alpine.LSU.2.00.0902202134350.11155@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:48830 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959AbZBTV6u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Feb 2009 16:58:50 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1LadOS-0005L2-HC
	for netfilter-devel@vger.kernel.org; Fri, 20 Feb 2009 21:58:48 +0000
Received: from p57a2d807.dip.t-dialin.net ([87.162.216.7])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Feb 2009 21:58:48 +0000
Received: from rm by p57a2d807.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Feb 2009 21:58:48 +0000
In-Reply-To: <alpine.LSU.2.00.0902202134350.11155@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Friday 2009-02-20 21:33, Ralf wrote:
> 
>> Sometimes an insert operation (-I) fails and iptables returns 256.
>> Under which circumstances can iptables give a return code 256 ?
> 
> Never should this happen, because the lower 8 bits of 256 that
> make up the exist status are 0 actually.
> Or where do you see 256?

int rc = system(sz);    // sz="iptables ..."

rc is sometimes definitely 256 !

What does it mean?

