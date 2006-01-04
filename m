From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: Patch for ipt_time (to enable start > stop / crossing midnight)
Date: Wed, 4 Jan 2006 17:58:41 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0601041750390.22709@bizon.gios.gov.pl>
References: <20060104142750.GF15217@schlittermann.de>
	<Pine.LNX.4.64.0601041639400.19966@bizon.gios.gov.pl>
	<20060104164455.GH15217@schlittermann.de>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-739171346-1136393921=:22709"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Heiko Schlittermann <hs@schlittermann.de>
In-Reply-To: <20060104164455.GH15217@schlittermann.de>
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

---187430788-739171346-1136393921=:22709
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 4 Jan 2006, Heiko Schlittermann wrote:

> Hello Krzysztof & *,
>
> Krzysztof Oledzki <olenf@ans.pl> (Mi 04 Jan 2006 16:47:43 CET):
>>
>> How about this (also attached) one? Untested, but should work.
>> [NETFILTER] Support for timestart > timestop in ipt_time (eg. 21:00 - 15=
:00)
>>
>> Based on a patch from Heiko Schlittermann <hs@schlittermann.de>
>
> My "compound return" looked shorter :) but I admit, that your's is
> better readable.

It would also allow to extend ipt_time checks in the future.

>  I don't know, which one is faster or if good gcc
> optimimzes both the same way ...  (I learned to save every bit ;-)

Hm, there is also another version, totally unreadable but highly=20
optimized:

         if ((info->time_start < info->time_stop) + (packet_time < info->ti=
me_start) + (packet_time > info->time_stop) >=3D 2 )
                         return 0;

;)


>> -=09if ((packet_time < info->time_start) || (packet_time > info->time_st=
op))
>> -=09=09return 0;
>> +=09if (info->time_start < info->time_stop) {
>> +=09=09if ((packet_time < info->time_start) || (packet_time > info->time=
_stop))
>> +=09=09=09return 0;
>> +=09} else {
>> +=09=09if ((packet_time < info->time_start) && (packet_time > info->time=
_stop))
>> +=09=09=09return 0;
>> +=09}
>
>
> But I'd like to see:
>
> =09if (info->time_start < info->time_stop) {
> =09=09if ((packet_time < info->time_start) || (packet_time >=3D info->tim=
e_stop))
> =09=09=09return 0;
> =09} else {
> =09=09if ((packet_time < info->time_start) && (packet_time >=3D info->tim=
e_stop))
> =09=09=09return 0;
> =09}
>
>
> To match --timestart 12:07 --timestop 13:10 really from 12:07:00 to 13:09=
:59.

So please use --timestart 12:07 --timestop 13:09. We need ">" not ">=3D" to=
=20
match a single minute, eg. --timestart 12:07 --timestop 12:07.

Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-739171346-1136393921=:22709--
