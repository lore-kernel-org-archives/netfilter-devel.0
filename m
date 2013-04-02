From: Ed W <lists@wildgooses.com>
Subject: Re: How to modify conntrack accounting?
Date: Tue, 02 Apr 2013 23:45:59 +0100
Message-ID: <515B5FA7.3090902@wildgooses.com>
References: <515B2D5B.8010807@wildgooses.com> <1364935594.30922.3.camel@ice-age.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.nippynetworks.com ([91.220.24.129]:52081 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab3DBWqB convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:46:01 -0400
In-Reply-To: <1364935594.30922.3.camel@ice-age.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02/04/2013 21:46, Eric Leblond wrote:
> Hello,
>
> Le mardi 02 avril 2013 =E0 20:11 +0100, Ed W a =E9crit :
>> Hi, I have a requirement to account for "bytes I pay for" over some
>> link, and conntrack very nearly gives me the right answer...  This l=
ink
>> uses accounting somewhat like ATM, where the IP data is sliced into
>> fixed size cells and you have to pay for the overhead per cell, plus=
 the
>> wasted space in the extra cell.
> I'm not sure I really understood your ATM comparison but why not use =
the
> new accounting system like described here:
>
> https://home.regit.org/2012/07/flow-accounting-with-netfilter-and-ulo=
gd2/
>

Thanks - I really need the raw conntrack detail so that I can do my own=
=20
aggregations (its quite a complex requirement for accounting)

Apologies for the ATM assumptions.  OK, ATM works by encapsulating the=20
data into small fixed sized packets of 48 bytes with a 5 byte header. =20
So for example if you send a 1000 byte IP packet then it will consume 2=
1=20
ATM cells, which means a total bandwidth you pay for of 21 x (48+5) =3D=
=20
1,113 bytes.   Annoyingly even the last (part filled) packet still has=20
to be 48 bytes, plus you have that 5 byte header on each packet.

The above is how ADSL connections work, and why using standard QOS fail=
s=20
to work as expected when you have a bunch of small packets (ATM=20
bandwidth becomes large compared with IP bandwidth).

I believe newer kernels have some options to correctly compute the=20
overheads for ATM encapsulation, effectively I need to implement=20
something similar for conntrack

Thanks for further thoughts

Ed W

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
