From: Anton <anton.vazir@gmail.com>
Subject: Re: iptables performance and alternatives
Date: Thu, 15 May 2008 16:29:22 +0500
Message-ID: <200805151629.22785.anton.vazir@gmail.com>
References: <200805151421.23862.anton.vazir@gmail.com> <200805151557.28368.anton.vazir@gmail.com> <alpine.LNX.1.10.0805151318020.16151@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.eastera.tj ([82.198.21.18]:48542 "EHLO mail.eastera.tj"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbYEOL3T (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 May 2008 07:29:19 -0400
In-Reply-To: <alpine.LNX.1.10.0805151318020.16151@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 15 May 2008 16:18, Jan Engelhardt wrote:
> On Thursday 2008-05-15 12:57, Anton wrote:
> >Definitelly what my test shows - while rule-inserts - if
> > you try to insert 10000 rules - after a several
> > hundreds - it will be inserting like a 1 rule in 1
> > second and slowness will progress :)
>
> Your insertion slowness is probably due to incorrect use
> of iptables.

Possible too. 

But aside of use of IPMARK from xtables, if I have to match 
80  (prio traffic)  22(realtime) port for every customer IP 
and customer's ip too (bulk traffic) for another mark set 
and all with different htb queues - IPMARK will not help 
and in case of, say, 1000 matching IP's, it comes to 4 
queues per , with 3 to use with lending/borrowing (main, 
80, and 22) and 3000 queuses in total, plus POSTROUTING 
mangle rule per park (3000 rules) + 3000 return rules 
(6000) rules and so on. If this PC also do NAT for 
matches - it will come with extra 1000 rules (or single 
IPSET :)

If there is a better approach to this in relation to 
IPTABLES - this would be just great...
