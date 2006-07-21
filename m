From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: Connlimit and linux-2.6.17
Date: Fri, 21 Jul 2006 22:06:48 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0607212050390.17358@bizon.gios.gov.pl>
References: <44BEA42B.3000304@andybev.com>
	<Pine.LNX.4.64.0607200026310.4015@bizon.gios.gov.pl>
	<44BEB607.3000408@andybev.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-973269532-1153512408=:17358"
Cc: martin.bene@icomedias.com, netfilter-devel@lists.netfilter.org,
	netfilter@lists.netfilter.org, adlan.elm@gmail.com, kraxel@bytesex.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Andrew Beverley <andy@andybev.com>
In-Reply-To: <44BEB607.3000408@andybev.com>
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

---187430788-973269532-1153512408=:17358
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 19 Jul 2006, Andrew Beverley wrote:

>>> I (and others, see netfilter list) are having trouble compiling kernel=
=20
>>> 2.6.17.4 and iptables-1.3.5-20060508 to use connlimit. Once compiled in=
=20
>>> and I run:
>
> <snip>
>
>> Yes, the API was changed in 2.6.17, so small fixes are required to allow=
=20
>> extensions to work. I'm currently traveling a lot so connlimit & TARPIT =
is=20
>> still on my TODO list. I'm going to finish it ASAP but with limited=20
>> GPRS/EDGE access it is not so simple.
>
> Many thanks.

OK, I fixed the connlimit extension. Please:

  - download recent version of patch-o-matic-ng

  - remove "patchlets/connlimit" directory from extracted pom-ng

  - run "./runme --download"

  - patch & recompile your kernel, as always

  - tell me if it works (or not).

> I do not envy you working through GPRS - very tedious!

GPRS/EDGE is not so bad, especially if you don't have anything better. ;)

> Will it still be a patch or is it possible to get it in the stable kernel=
?

Connlimit goes to my external pom-ng repository.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-973269532-1153512408=:17358--
