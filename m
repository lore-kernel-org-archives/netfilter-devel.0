From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: Connlimit and linux-2.6.17
Date: Sat, 22 Jul 2006 02:37:34 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0607220227500.2260@bizon.gios.gov.pl>
References: <44BEA42B.3000304@andybev.com>
	<Pine.LNX.4.64.0607200026310.4015@bizon.gios.gov.pl>
	<44BEB607.3000408@andybev.com>
	<Pine.LNX.4.64.0607212050390.17358@bizon.gios.gov.pl>
	<44C16CE4.3030302@andybev.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1071996556-1153528654=:2260"
Cc: kraxel@bytesex.org, martin.bene@icomedias.com,
	netfilter-devel@lists.netfilter.org,
	netfilter@lists.netfilter.org, adlan.elm@gmail.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Andrew Beverley <andy@andybev.com>
In-Reply-To: <44C16CE4.3030302@andybev.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1071996556-1153528654=:2260
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sat, 22 Jul 2006, Andrew Beverley wrote:

>>>>> I (and others, see netfilter list) are having trouble compiling kerne=
l=20
>>>>> 2.6.17.4 and iptables-1.3.5-20060508 to use connlimit. Once compiled =
in=20
>>>>> and I run:
>>>=20
>>> <snip>
>>>=20
>>>> Yes, the API was changed in 2.6.17, so small fixes are required to all=
ow=20
>>>> extensions to work. I'm currently traveling a lot so connlimit & TARPI=
T=20
>>>> is still on my TODO list. I'm going to finish it ASAP but with limited=
=20
>>>> GPRS/EDGE access it is not so simple.
>>=20
>> OK, I fixed the connlimit extension. Please:
>>
>>  - tell me if it works (or not).
>>=20
>
> I forgot to mention - I get a lot of 'ipt_connlimit: Oops: invalid ct sta=
te'=20
> error messages scrolling up the screen.

But when did it start? In 2.6.17?

> Is it safe for me to edit=20
> ipt_connlimit.c to not print them? Or are they telling me there is someth=
ing=20
> wrong with my setup?

Plase try adding "-m conntrack --ctstate INVALID -j DROP" before "-m=20
connlimit (...)". Did it help?


Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1071996556-1153528654=:2260--
