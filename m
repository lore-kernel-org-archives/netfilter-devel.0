From: Thomas Jacob <jacob@internet24.de>
Subject: Re: iptables performance and alternatives
Date: Thu, 15 May 2008 15:19:16 +0200
Message-ID: <1210857556.24732.10.camel@enterprise.ims-firmen.de>
References: <200805151421.23862.anton.vazir@gmail.com>
	 <200805151535.31933.anton.vazir@gmail.com>
	 <alpine.LNX.1.10.0805151242110.16151@fbirervta.pbzchgretzou.qr>
	 <200805151557.28368.anton.vazir@gmail.com>
	 <alpine.LNX.1.10.0805151318020.16151@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout02.ims-firmen.de ([213.174.32.97]:38157 "EHLO
	mailout02.ims-firmen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759089AbYEONmd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 May 2008 09:42:33 -0400
Received: from mailin03.ims-firmen.de ([192.168.1.112])
	by mailout02.ims-firmen.de with esmtp (Exim 4.67)
	(envelope-from <jacob@internet24.de>)
	id 1JwdMb-0007xe-CT
	for netfilter-devel@vger.kernel.org; Thu, 15 May 2008 15:19:17 +0200
Received: from [213.174.32.254] (helo=[192.168.0.170])
	by mailin03.ims-firmen.de with esmtpsa (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <jacob@internet24.de>)
	id 1JwdMb-0002tR-B3
	for netfilter-devel@vger.kernel.org; Thu, 15 May 2008 15:19:17 +0200
In-Reply-To: <alpine.LNX.1.10.0805151318020.16151@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 2008-05-15 at 13:18 +0200, Jan Engelhardt wrote:
> On Thursday 2008-05-15 12:57, Anton wrote:
> 
> >Definitelly what my test shows - while rule-inserts - if you 
> >try to insert 10000 rules - after a several hundreds - it 
> >will be inserting like a 1 rule in 1 second and slowness 
> >will progress :)
> 
> Your insertion slowness is probably due to incorrect use of iptables.

What do you mean by that? Isn't it a fact, that the iptables command
utility and to a  lesser extent also iptables-restore  is pretty slow in
updating the ruleset when you have a large number of rules, simply
because it copies the entire ruleset to userspace, modifies it there,
and then copies the resulting rule set back to the kernel? 

Curious...
    
    Thomas

