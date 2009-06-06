From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: ulogd2/NFLOG: nfnetlink_log: error creating log nlmsg
Date: Sat, 06 Jun 2009 08:57:04 +0200
Message-ID: <4A2A1340.2090301@netfilter.org>
References: <1242842730.8076.60.camel@enterprise.ims-firmen.de>	 <4A158E6A.8090705@netfilter.org>  <20090522121241.GA28340@internet24.de> <1244210460.9510.4.camel@enterprise.ims-firmen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jacob <jacob@internet24.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35411 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbZFFG5v (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Jun 2009 02:57:51 -0400
In-Reply-To: <1244210460.9510.4.camel@enterprise.ims-firmen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thomas Jacob wrote:
> On Fri, 2009-05-22 at 14:12 +0200, Thomas Jacob wrote:
>> On Thu, May 21, 2009 at 07:24:58PM +0200, Pablo Neira Ayuso wrote:
>>> Thomas Jacob wrote:
>>>> Bug? Feature? If it's the latter, how can I prevent this from
>>>> happening?
>>> Does this patch helps? It seems that we're missing to add the size of
>>> the hardware address since 2.6.27.
>> Thanks for the quick reply and the patch. Unfortunately I haven't found a way
>> to reproduce this problem in a lab environment yet, so I can't confirm
>> whether or not it does anything. Originally the issue
>> occurred when hot-replacing an older system with one that
>> runs NFLOG/ulogd2 and the versions listed, thereby generating lots
>> of invalid packets probably (which should have been logged) as well
>> as some intentional drops (Packet rate at the time maybe was 30kpps).
> 
> Just to let you know, I still haven't been able to reproduce the
> problem in the lab, but the errors went away in the production
> environment after applying your patch, so presumably it did the trick.
> Also, the lines in question are clearly missing anyway.

Thanks for the info. I think that it should be related with the patch.
I'll try make some tests by hot-replacing the daemon in my testbed to
see if I catch anything.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
