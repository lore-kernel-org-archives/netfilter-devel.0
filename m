From: Anton <anton.vazir@gmail.com>
Subject: Re: NFLOG - missing packets?
Date: Mon, 12 May 2008 14:19:32 +0500
Message-ID: <200805121419.33303.anton.vazir@gmail.com>
References: <200805101657.45111.anton.vazir@gmail.com> <200805101750.38472.anton.vazir@gmail.com> <20080511161837.GJ11778@ice-age>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.eastera.tj ([82.198.21.18]:53931 "EHLO mail.eastera.tj"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349AbYELJTa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2008 05:19:30 -0400
In-Reply-To: <20080511161837.GJ11778@ice-age>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I did some extra test, which show diffrenece on P4 2.8G with 
the transfer rate 100Mbit/s between iptables chains couters 
and ulogd logemu records - 2% - seems it's ulogd misses, 
not netlink subsystem, and it's directly depends on the 
ulogd processing load - db inserts are slow...

Do you think it's fixable in viewable future atleast on the 
ulog level, that we know what amount of data we have 
missed?

On Sunday 11 May 2008 21:18, Eric Leblond wrote:
> Hello,
>
> On Saturday, 2008 May 10 at 17:50:37 +0500, Anton wrote:
> > Something wrong quite definitelly,
> > in 700Mb of the data it logs only 43Mb
>
> I've done some test on my system and I've got similar
> results. Sole difference is the ratio between logged
> packets and unlogged packets.
>
> I've downloaded a 48Mo at a rate of 348.28K/s and I have
> the following result :
> Iptables : 33625 packets, 50383786 bits
> Ulogd2 : 33272 packets 49856076 bits
>
> As usual, size does not matter. The problem is due to
> some packets not being loggued. It recall me results of
> Pablo's conntrackd benchmark. After a given rate, the
> netlink subsystem is not able to transmit messages.
>
> IMHO, the main issue is that the lost (or the overrun)
> does not seem to be logged somewhere.
>
> BR,
