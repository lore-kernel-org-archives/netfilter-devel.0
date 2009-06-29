From: Richard Horton <arimus.uk@googlemail.com>
Subject: Re: arptables ruleset not working when compiling on
	fedora6,7,8/centos 5/redhat 5
Date: Mon, 29 Jun 2009 15:21:52 +0100
Message-ID: <56378e320906290721i63f969edm90aed19619decf71@mail.gmail.com>
References: <b2d58cb80906290712k33c1ebbvfc8e661cb34c502c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Nishit Shah <nsshah.82@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:60997 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759933AbZF2OVv convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Jun 2009 10:21:51 -0400
In-Reply-To: <b2d58cb80906290712k33c1ebbvfc8e661cb34c502c@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2009/6/29 Nishit Shah <nsshah.82@gmail.com>:
> Hi,
> =A0 =A0 =A0 =A0 I am compiling arptables-v0.0.3-3/arptables-v0.0.3-2 =
on
> fedora6,7,8/centos 5/redhat 5. Module is compiled successfully.
> Following are the simple steps.
>
> =A0 =A0 =A0 =A0make
> =A0 =A0 =A0 =A0make install
>
> =A0 =A0 =A0 =A0Now, I am applying following rules,
>
> =A0 =A0 =A0 =A0arptables -N user1
> =A0 =A0 =A0 =A0arptables -N user2
> =A0 =A0 =A0 =A0arptables -N user3
>
> =A0 =A0 =A0 =A0arptables -A INPUT -j user1
> =A0 =A0 =A0 =A0arptables -A INPUT -j user2
> =A0 =A0 =A0 =A0arptables -A INPUT -j user3
>
> =A0 =A0 =A0 when I am doing arptables -nvx -L, I am getting packet co=
unts
> on only "arptables -A INPUT -j user1", no packet counts on user2 and
> user3 chains. If I remove the user1 chain, I am getting packet counts
> on user2 chain, not on user3 chain. It means only the first user
> defined chain is traversing.
>
> =A0 =A0 =A0 all above machine contains gcc >=3D 4.1.2 and glibc >=3D =
2.5
>
> =A0 =A0 =A0 If i compile the same source with machine having gcc 2.96=
 and
> glibc 2.2.4 things are working properly on the above machines.
> =A0 =A0 =A0 Is it something related to gcc and/or glibc ? as I am not
> seeing any issues with kernel space arptables code.
>
> Rgds,
> Nishit Shah.


I might be missing something obvious but all three rules are identical
so traffic is going to hit the first rule and go down to user1 chain.


Your user chains don't have any actions associated so looks to me like
it enter the chain, nothing will happen - including not returning to
the input chain so the other rules aren't being hit.
--=20
Richard Horton
Users are like a virus: Each causing a thousand tiny crises until the
host finally dies.
http://www.solstans.co.uk - Solstans Japanese Bobtails and Norwegian Fo=
rest Cats
http://www.pbase.com/arimus - My online photogallery
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
