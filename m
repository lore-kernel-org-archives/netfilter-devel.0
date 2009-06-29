From: Nishit Shah <nsshah.82@gmail.com>
Subject: Re: arptables ruleset not working when compiling on
	fedora6,7,8/centos 5/redhat 5
Date: Mon, 29 Jun 2009 20:21:48 +0530
Message-ID: <b2d58cb80906290751j7fb3976bx9d04fed852c8b451@mail.gmail.com>
References: <b2d58cb80906290712k33c1ebbvfc8e661cb34c502c@mail.gmail.com>
	 <56378e320906290721i63f969edm90aed19619decf71@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Richard Horton <arimus.uk@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:23942 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbZF2Ovq convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Jun 2009 10:51:46 -0400
In-Reply-To: <56378e320906290721i63f969edm90aed19619decf71@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 29, 2009 at 7:51 PM, Richard Horton<arimus.uk@googlemail.co=
m> wrote:
> 2009/6/29 Nishit Shah <nsshah.82@gmail.com>:
>> Hi,
>> =A0 =A0 =A0 =A0 I am compiling arptables-v0.0.3-3/arptables-v0.0.3-2=
 on
>> fedora6,7,8/centos 5/redhat 5. Module is compiled successfully.
>> Following are the simple steps.
>>
>> =A0 =A0 =A0 =A0make
>> =A0 =A0 =A0 =A0make install
>>
>> =A0 =A0 =A0 =A0Now, I am applying following rules,
>>
>> =A0 =A0 =A0 =A0arptables -N user1
>> =A0 =A0 =A0 =A0arptables -N user2
>> =A0 =A0 =A0 =A0arptables -N user3
>>
>> =A0 =A0 =A0 =A0arptables -A INPUT -j user1
>> =A0 =A0 =A0 =A0arptables -A INPUT -j user2
>> =A0 =A0 =A0 =A0arptables -A INPUT -j user3
>>
>> =A0 =A0 =A0 when I am doing arptables -nvx -L, I am getting packet c=
ounts
>> on only "arptables -A INPUT -j user1", no packet counts on user2 and
>> user3 chains. If I remove the user1 chain, I am getting packet count=
s
>> on user2 chain, not on user3 chain. It means only the first user
>> defined chain is traversing.
>>
>> =A0 =A0 =A0 all above machine contains gcc >=3D 4.1.2 and glibc >=3D=
 2.5
>>
>> =A0 =A0 =A0 If i compile the same source with machine having gcc 2.9=
6 and
>> glibc 2.2.4 things are working properly on the above machines.
>> =A0 =A0 =A0 Is it something related to gcc and/or glibc ? as I am no=
t
>> seeing any issues with kernel space arptables code.
>>
>> Rgds,
>> Nishit Shah.
>
>
> I might be missing something obvious but all three rules are identica=
l
> so traffic is going to hit the first rule and go down to user1 chain.
>
>
> Your user chains don't have any actions associated so looks to me lik=
e
> it enter the chain, nothing will happen - including not returning to
> the input chain so the other rules aren't being hit.
> --
> Richard Horton
> Users are like a virus: Each causing a thousand tiny crises until the
> host finally dies.
> http://www.solstans.co.uk - Solstans Japanese Bobtails and Norwegian =
=46orest Cats
> http://www.pbase.com/arimus - My online photogallery
>

If user chain doesn't have any actions associated, action is
ARPT_CONTINUE. So, the packet will traverse the next rule in INPUT
(that is arptables -A -j user2) and so on. (That is the behavior I am
getting when compiled with gcc 2.96 and glibc 2.2.4)

Rgds,
Nishit Shah.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
