From: Ignacy Gawedzki <i@lri.fr>
Subject: Re: Netfilter API and libiptc
Date: Mon, 9 Feb 2009 19:39:41 +0100
Message-ID: <20090209183941.GA1050@zenon.in.qult.net>
References: <20090205141722.GB21417@qubit> <4990636B.9080900@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from qult.net ([82.238.217.46]:39102 "EHLO slartibartfast.qult.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbZBITLo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 14:11:44 -0500
Content-Disposition: inline
In-Reply-To: <4990636B.9080900@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 09, 2009 at 06:10:03PM +0100, thus spake Patrick McHardy:
> Ignacy Gawedzki wrote:
>> Hi everybody,
>>
>> I'm currently working on a project that relies on manipulation of iptables in
>> order to perform fine data packet accounting.  This manipulation is performed
>> dynamically, so the code initially used libiptc.
>>
>> Since iptables 1.4.0, libiptc is not distributed anymore, so I resolved to
>> incorporate the code into our own source distribution, just as people from
>> collectd seemingly did.  All seemed to work well until yesterday, when we
>> eventually pinpointed our calls to the (internal) libiptc as a cause of a
>> kernel freeze.  It only happened on a generic Ubuntu Hardy kernel
>> (2.6.24-22-generic) on one particular laptop (I didn't succeed in reproducing
>> the freeze on another hardware with the same distribution).  I suppose it has
>> something to do with the change of the format of data flowing to kernelspace
>> (iptables 1.3.8 came distributed on that freezing machine), could anyone here
>> confirm that this is possible indeed?
>
> It should never crash the kernel, and the ABI is supposed to be
> compatible.

Good to know, thanks.

>
>>
>> Now my question is: how are we supposed to proceed from now on in order to
>> manipulate iptables?  I read about libxtables and the corresponding libxtc.h
>> (though these are not yet packaged in the current Ubuntu Intrepid), but it's
>> not clear to me how the communication with the kernel is actually to be done.
>>
>> Thanks for any information that could help me making this work properly.
>
> Hard to tell without seeing the exact crash you're getting.

As far as I know, the crash is a complete freeze.  I don't know whether there
are any console messages to recover (using netconsole for instance).

My question was not about how to prevent the machine from crashing, but rather
how are we supposed to manipulate iptables, now that libiptc is not available.

As for the kernel crash itself, it is right now pretty difficult for me to
analyze, since I don't have the machine at hand and the person using it is too
busy at the moment.  So maybe I'll be able to take a look at some later time.

Thanks for your reply.

-- 
:wq!
