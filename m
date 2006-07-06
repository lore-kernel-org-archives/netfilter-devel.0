From: Krzysztof Oledzki <olenf@ans.pl>
Subject: RE: 2.6.17.1 compile error with a netfilter module
Date: Thu, 6 Jul 2006 23:33:41 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0607062323410.31114@bizon.gios.gov.pl>
References: <925A849792280C4E80C5461017A4B8A206F784@mail733.InfraSupportEtc.com>
	<1151700888.2709.4.camel@murdegern.hindenburgdamm.example>
	<44A9615C.2050405@trash.net>
	<Pine.LNX.4.64.0607032135220.9324@bizon.gios.gov.pl>
	<925A849792280C4E80C5461017A4B8A208D0A6@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-103490456-1152221621=:31114"
Cc: Torsten Luettgert <t.luettgert@pressestimmen.de>,
	netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Greg Scott <GregScott@InfraSupportEtc.com>
In-Reply-To: <925A849792280C4E80C5461017A4B8A208D0A6@mail733.InfraSupportEtc.com>
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

---187430788-103490456-1152221621=:31114
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 3 Jul 2006, Greg Scott wrote:

> Thanks guys.  Meanwhile, I went ahead and built up a box with just the=20
> kernel.org 2.6.17.2 kernel and no POM patches for now.

OK, I prepared external repository with correct (I hope!) time and ipp2p=20
extensions, TARPIT and connlimit are going to be fixed soon. Before I=20
submit this to Patrick I need to be sure that it works. If you would like=
=20
to test it, please:

  - remove "time" and "ipp2p" directories from extracted pom-ng

  - add this to the sources.list:

# ipp2p and time maintained by Krzysztof Oledzki <ole@ans.pl>
http://people.netfilter.org/ole/pom/

  - run "./runme --download"

  - patch & recompile kernel as always

  - tell me if it works (or not).

Both extensions should work with both 2.6.16 and 2.6.17 kernels if I done=
=20
everything properly.

Thanks.

> On Mon, 3 Jul 2006, Patrick McHardy wrote:
>
>> Torsten Luettgert wrote:
>>> On Fri, 2006-06-30 at 12:36 -0500, Greg Scott wrote:
>>>
>>>> Hmmm -
>>>
>>>
>>>> I'll try another build, this time with 2.6.17.2 and POM 20060629 using
>>>> these POM
>>>> modules:
>>>>  time
>>>>  ipp2p
>>>>  ROUTE
>>>>  sip-conntrack-nat
>>>
>>>
>>> time, ipp2p and ROUTE won't work with 2.6.17 without API patches -
>>> I posted those last saturday, but they didn't get committed yet.
>>> You can grab them from the archives. Don't know about sip-conntrack-nat=
,
>>> but I suspect it'll have the same problem.
>>
>> Just applied ROUTE and u32. I think Jozsef already fixed u32, the
>> remaining patchlets are not part of official pomng anymore, although
>> I still haven't received the URL of the new external repository.
>
> Need a day or two, sorry. :( I have been very busy for the last two weeks
> but now I'm going to finish this ASAP.



Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-103490456-1152221621=:31114--
