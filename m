From: Patrick McHardy <kaber@trash.net>
Subject: Re: Netfilter API and libiptc
Date: Mon, 09 Feb 2009 18:10:03 +0100
Message-ID: <4990636B.9080900@trash.net>
References: <20090205141722.GB21417@qubit>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Ignacy Gawedzki <i@lri.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59620 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbZBIRKG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:10:06 -0500
In-Reply-To: <20090205141722.GB21417@qubit>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ignacy Gawedzki wrote:
> Hi everybody,
> 
> I'm currently working on a project that relies on manipulation of iptables in
> order to perform fine data packet accounting.  This manipulation is performed
> dynamically, so the code initially used libiptc.
> 
> Since iptables 1.4.0, libiptc is not distributed anymore, so I resolved to
> incorporate the code into our own source distribution, just as people from
> collectd seemingly did.  All seemed to work well until yesterday, when we
> eventually pinpointed our calls to the (internal) libiptc as a cause of a
> kernel freeze.  It only happened on a generic Ubuntu Hardy kernel
> (2.6.24-22-generic) on one particular laptop (I didn't succeed in reproducing
> the freeze on another hardware with the same distribution).  I suppose it has
> something to do with the change of the format of data flowing to kernelspace
> (iptables 1.3.8 came distributed on that freezing machine), could anyone here
> confirm that this is possible indeed?

It should never crash the kernel, and the ABI is supposed to be
compatible.

> 
> Now my question is: how are we supposed to proceed from now on in order to
> manipulate iptables?  I read about libxtables and the corresponding libxtc.h
> (though these are not yet packaged in the current Ubuntu Intrepid), but it's
> not clear to me how the communication with the kernel is actually to be done.
> 
> Thanks for any information that could help me making this work properly.

Hard to tell without seeing the exact crash you're getting.
