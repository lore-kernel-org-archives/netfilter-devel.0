From: Nicolas Bareil <nico@chdir.org>
Subject: Re: scrubbing support in Netfilter
Date: Wed, 28 May 2008 09:20:39 +0200
Message-ID: <87hccinbco.fsf@chdir.org>
References: <87hccjdbm4.fsf@chdir.org>
	<alpine.LNX.1.10.0805271729350.12937@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moog.chdir.org ([88.191.42.160]:38288 "EHLO moog.chdir.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbYE1HUo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 May 2008 03:20:44 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello Jan,

Thanks for your review!

Jan Engelhardt <jengelh@medozas.de> writes:
> I seem to remember that Linux's TCP or nf_conntrack already does
> some scrubbing.

That's right, that's the reason why it's not that hard to compete with
the OpenBSD features. The hard work is already done : fragmentation, tcp
sequence management, packet in the tcp window, sanity checks for invalid
constructed packets.

>>  - Random IP ID
>>  - Zeroify ToS
>
> Zeroify? Clearing the TOS is probably not a good idea because
> it defeats packet scheduling (if it uses TOS).

Correct me if I'm wrong, but on Internet (I mean, just after the first
ISP's router), the ToS is not used or even looked up.

I tried to make the scrubbing modular : you can choose to scrub a field
or not. I'm open to discuss the default flags for --scrub-everything 

>>  - TTL normalization
>>
>>* TCP
>> - Random TCP Sequence
>
> I wonder if Linux already has this.

Don't think so, AFAIK, Linux only randomizes the TCP sequence for its own
packet (in OUTPUT), not for the packet in transit.

>> - TCP Options
>>   - Random Timestamp
>
> Is this even RFC compatible?

Yes I guess : I'm doing like for the TCP sequence stuff, when a
conntrack is created, I randomize the timestamp, compute the difference
(a substraction) between the original timestamp and mine that I store in
the conntrack.

Then, when I receive a packet, I apply the offset to reflect the change :
the meaning is intact because we are not putting a random value at each
packet. 

> I suggest you have a look at "Writing your own Netfilter modules"
> (abbreviated NFM in this reply) document from
> http://jengelh.medozas.de/ , since I have seen a few outdated
> constructs in your code.

Ok, I noted your remarks and will submit tomorrow a new patch based on
the feedbacks!

-- 
Nicolas Bareil                                  http://chdir.org/~nico/
OpenPGP=0xAE4F7057 Fingerprint=34DB22091049FB2F33E6B71580F314DAAE4F7057
