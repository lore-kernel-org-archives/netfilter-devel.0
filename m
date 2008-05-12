From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: NFLOG - missing packets?
Date: Mon, 12 May 2008 13:53:56 +0200
Message-ID: <48282FD4.4070806@netfilter.org>
References: <200805101657.45111.anton.vazir@gmail.com> <200805101750.38472.anton.vazir@gmail.com> <20080511161837.GJ11778@ice-age>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Eric Leblond <eric@inl.fr>, Anton <anton.vazir@gmail.com>,
	netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58913 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753127AbYELLqJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2008 07:46:09 -0400
In-Reply-To: <20080511161837.GJ11778@ice-age>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Hello,
> 
> On Saturday, 2008 May 10 at 17:50:37 +0500, Anton wrote:
>> Something wrong quite definitelly,
>> in 700Mb of the data it logs only 43Mb 
> 
> I've done some test on my system and I've got similar results. Sole
> difference is the ratio between logged packets and unlogged packets. 
> 
> I've downloaded a 48Mo at a rate of 348.28K/s and I have the following
> result :
> Iptables : 33625 packets, 50383786 bits
> Ulogd2 : 33272 packets 49856076 bits
> 
> As usual, size does not matter. The problem is due to some packets not
> being loggued. It recall me results of Pablo's conntrackd benchmark.
> After a given rate, the netlink subsystem is not able to transmit
> messages.
> 
> IMHO, the main issue is that the lost (or the overrun) does not seem to be logged
> somewhere.

I'm finishing a patchset to improve this and other aspects of ulogd. 
I'll post them to the ML soon.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
