From: Eric Leblond <eric@regit.org>
Subject: Re: How to modify conntrack accounting?
Date: Wed, 03 Apr 2013 11:05:15 +0200
Message-ID: <1364979915.9791.6.camel@tiger2>
References: <515B2D5B.8010807@wildgooses.com>
	 <1364935594.30922.3.camel@ice-age.regit.org>
	 <515B5FA7.3090902@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:52853 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758716Ab3DCJFX convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Apr 2013 05:05:23 -0400
In-Reply-To: <515B5FA7.3090902@wildgooses.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Tue, 2013-04-02 at 23:45 +0100, Ed W wrote:
> On 02/04/2013 21:46, Eric Leblond wrote:
> > Hello,
> >
> > Le mardi 02 avril 2013 =C3=A0 20:11 +0100, Ed W a =C3=A9crit :
> >> Hi, I have a requirement to account for "bytes I pay for" over som=
e
> >> link, and conntrack very nearly gives me the right answer...  This=
 link
> >> uses accounting somewhat like ATM, where the IP data is sliced int=
o
> >> fixed size cells and you have to pay for the overhead per cell, pl=
us the
> >> wasted space in the extra cell.
> > I'm not sure I really understood your ATM comparison but why not us=
e the
> > new accounting system like described here:
> >
> > https://home.regit.org/2012/07/flow-accounting-with-netfilter-and-u=
logd2/
> >
>=20
> Thanks - I really need the raw conntrack detail so that I can do my o=
wn=20
> aggregations (its quite a complex requirement for accounting)
>=20
> Apologies for the ATM assumptions.  OK, ATM works by encapsulating th=
e=20
> data into small fixed sized packets of 48 bytes with a 5 byte header.=
 =20
> So for example if you send a 1000 byte IP packet then it will consume=
 21=20
> ATM cells, which means a total bandwidth you pay for of 21 x (48+5) =3D=
=20
> 1,113 bytes.   Annoyingly even the last (part filled) packet still ha=
s=20
> to be 48 bytes, plus you have that 5 byte header on each packet.
>=20
> The above is how ADSL connections work, and why using standard QOS fa=
ils=20
> to work as expected when you have a bunch of small packets (ATM=20
> bandwidth becomes large compared with IP bandwidth).

OK that is what I was fearing. You want to do ATM accounting at the IP
level ;)

> I believe newer kernels have some options to correctly compute the=20
> overheads for ATM encapsulation, effectively I need to implement=20
> something similar for conntrack
>=20
> Thanks for further thoughts

You said you want a per-interface accounting but conntrack is not
interface aware. So a better solution may be to update nfacct modue to
increment counter with ATM-rounded value at each packet. Given the type
of patch this will require, it should be easy to maintain other time.
This will provide a more performant and easy to use framework.

By the way, if you want consulting time, I've got some available ;)

BR,
>=20
> Ed W
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
