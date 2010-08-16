From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [RFC] setting up throughput threshold indications to userspace
Date: Mon, 16 Aug 2010 22:13:13 +0800
Message-ID: <AANLkTikd75p0UU-SVp2yXPHR4KJeZJxzbD4QYmNAUUMA@mail.gmail.com>
References: <1279268431.1603.44.camel@powerslave> <4C40583F.40200@trash.net>
 <1279285829.1603.77.camel@powerslave> <alpine.LSU.2.01.1007162127090.22666@obet.zrqbmnf.qr>
 <1279517423.7097.2.camel@powerslave> <1281966043.27200.30.camel@chilepepper>
 <AANLkTinrnA0H9RH533jQQman2NLFAywx8eA=80n1vv2e@mail.gmail.com> <1281967287.27200.37.camel@chilepepper>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Jan Engelhardt <jengelh@medozas.de>
To: Luciano Coelho <luciano.coelho@nokia.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33914 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab0HPONe convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Aug 2010 10:13:34 -0400
Received: by wwj40 with SMTP id 40so6573313wwj.1
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Aug 2010 07:13:33 -0700 (PDT)
In-Reply-To: <1281967287.27200.37.camel@chilepepper>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 16, 2010 at 10:01 PM, Luciano Coelho
<luciano.coelho@nokia.com> wrote:
> On Mon, 2010-08-16 at 15:51 +0200, ext Changli Gao wrote:
>>
>> You can implement a daemon: which samples the statistics data of NIC
>> periodically, calculates the average bandwidth in a period, and chan=
ge
>> the condition variables accordingly.
>
> We don't want to use polling from userspace. =A0That's the reason why=
 we
> decided to use iptables instead. =A0The idea is that we will only not=
ify
> the userspace when the throughput crosses the threshold line. =A0And =
the
> rules I defined above are working rather well, except for this "detai=
l"
> that the BELOW signal is not sent when there's no data flowing.
>

There is a daemon watching the ABOVE signal in any way. How about
staring a timer, which is used to check if there is no packet
transfered in a period, in this daemon when receiving the ABOVE
signal, and stopping this timer when receiving the BELOW signal? It is
like the implementation of IDLETIMER in user space.

--=20
Regards,
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
