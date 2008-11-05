From: Jesper Dangaard Brouer <hawk@diku.dk>
Subject: Re: [Fwd: Re: Shortcuts to counting rules?]
Date: Wed, 5 Nov 2008 19:25:13 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0811051922050.6949@ask.diku.dk>
References: <490B46F0.4010100@hp.com> <alpine.LNX.1.10.0810311906120.29079@fbirervta.pbzchgretzou.qr>
 <490B544B.50903@hp.com> <alpine.LNX.1.10.0811010209040.23833@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Rick Jones <rick.jones2@hp.com>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:49454 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbYKESZV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Nov 2008 13:25:21 -0500
In-Reply-To: <alpine.LNX.1.10.0811010209040.23833@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 1 Nov 2008, Jan Engelhardt wrote:

> On Friday 2008-10-31 19:54, Rick Jones wrote:
>>>
>>> iptables-save | grep ^- | wc -l
>>
>> Here is where I cop to being a luddite who prefers straight C to calling
>> system() :)
>
> But there is no C library. And libiptc is so strongly internal that
> it does not fall under libraries-to-use.

I don't see why not to use libiptc.  Its been one of the most stable / 
less-changed through the years...

I'm using libiptc quite extensivly in IPTables::libiptc Perl CPAN module.

Hilsen
   Jesper Brouer

--
-------------------------------------------------------------------
MSc. Master of Computer Science
Dept. of Computer Science, University of Copenhagen
Author of http://www.adsl-optimizer.dk
-------------------------------------------------------------------
