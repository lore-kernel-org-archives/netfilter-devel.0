From: Ed W <lists@wildgooses.com>
Subject: Re: How to modify conntrack accounting?
Date: Wed, 03 Apr 2013 10:58:14 +0100
Message-ID: <515BFD36.5020408@wildgooses.com>
References: <515B2D5B.8010807@wildgooses.com>  <1364935594.30922.3.camel@ice-age.regit.org>  <515B5FA7.3090902@wildgooses.com> <1364979915.9791.6.camel@tiger2>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.nippynetworks.com ([91.220.24.129]:37306 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763385Ab3DCJ6P (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Apr 2013 05:58:15 -0400
In-Reply-To: <1364979915.9791.6.camel@tiger2>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 03/04/2013 10:05, Eric Leblond wrote:

>> Thanks - I really need the raw conntrack detail so that I can do my own
>> aggregations (its quite a complex requirement for accounting)
>>
>> Apologies for the ATM assumptions.  OK, ATM works by encapsulating the
>> data into small fixed sized packets of 48 bytes with a 5 byte header.
>> So for example if you send a 1000 byte IP packet then it will consume 21
>> ATM cells, which means a total bandwidth you pay for of 21 x (48+5) =
>> 1,113 bytes.   Annoyingly even the last (part filled) packet still has
>> to be 48 bytes, plus you have that 5 byte header on each packet.
>>
>> The above is how ADSL connections work, and why using standard QOS fails
>> to work as expected when you have a bunch of small packets (ATM
>> bandwidth becomes large compared with IP bandwidth).
> OK that is what I was fearing. You want to do ATM accounting at the IP
> level ;)

Actually, although others probably want this, my requirements are very 
slightly different.  I have to account for charged bandwidth over an 
(expensive) satellite network, the specification is a bit peculiar, but 
I suspect that it's a type of MLPPP (same basic scenario though, cells 
of xx bytes with a y byte overhead)


> You said you want a per-interface accounting but conntrack is not
> interface aware.

Yes, so I need to tag my flows in some way that conntrack can see.


> So a better solution may be to update nfacct modue to
> increment counter with ATM-rounded value at each packet. Given the type
> of patch this will require, it should be easy to maintain other time.
> This will provide a more performant and easy to use framework.

OK, can I run the larger requirements past you because I like the idea 
of nfacct, but unsure that it will do what I desire

- I have a router with multiple internet connections. Could be anything, 
but lets assume we have 1) wifi to the internet, 2) 3G datacard 
(cellular) and 3) a relatively expensive satellite link.
- Customer is mobile so any of the above may work and roughly they will 
want to choose the cheapest wherever they are
- We provide a web interface which allows the customer to indicate a 
route preference and after that we use forced routing to put all the 
customers data out of the correct internet connection (interestingly 
this means two clients can use different internet connections at the 
same time, there is not a single primary internet connection at any moment)

- For now I need to log bandwidth consumed during a session (start/end 
time) using the tuple (customer, inet), IP/MAC+Time will be good enough 
to identify the customer for this scenario. This will be dumped into 
some radius accounting server.
- We will need interim updates on bandwidth consumed during a session in 
order to implement access control such that if the user exceeds xxMB or 
so much time online, etc.
- In the future we require more detailed bandwidth breakdown, eg we can 
plot some pretty graphs of usage by customer / protocol / inet choice / 
time.  Essentially we want to be able to show that "bob" was surfing 
facebook during his lunchbreak, over the expensive satellite connection.

Conntrack accounting gives me fairly close to the flows I want (seems to 
drop a few ICMP packets, but ...).  What I need is to be able to adjust 
for the services where we have some funny accounting due to being 
rounded into "cells".  It's not quite close enough to just guess.

I updated the nDPI module a month or so back to give some L7 
capabilities to the kernel. However, its a bit icky and I'm still not 
sure how to approach proper integration there though:
- I think I can see how to extend conntrack so that nDPI netfilter can 
store it's tracking info in the conntrack. This means we can tag all 
connections with L7 info. However, I haven't figured out how to extend 
this to userspace so that it's emitted as part of the connection 
accounting info?
- Also nDPI is moving in the direction of being extremely flexible and 
emitting full info about a flow, eg "this is an HTTPS connection with a 
cert for somewhere.com". So now I'm thinking that the netfilter 
integration should instead match the connection but emit the details of 
that match through nflog?  After all the design of nDPI is to categorise 
a connection and once categorised that's the end of it, no point 
dragging around that info in kernel space
- Alternatively we could leave all connection marking to userspace, ie 
the netfilter module could match packets and based on that I tag the 
flow with some connmark or assign it to pfacct category?

So, in theory how well would pfacct handle the situation of:

Separate accounting bin for:
- Source IP (either class C or possibly class B)
- Output inet interface (up to 32 of them) - this changes the byte 
counting forumula
- L7 protocol used (up to 255)


I have a captive portal which notices users arriving and so some of the 
above can be build dynamically, however, I'm trying to build everything 
such that it's setup once at boot and stays static thereafter


Could I trouble you for your thoughts please?


> By the way, if you want consulting time, I've got some available ;)

Sure - I'm interested

Cheers

Ed W
