From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: ipt_time fixes (resend, sorry)
Date: Thu, 20 Jan 2005 18:18:15 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0501201759360.1703@bizon.gios.gov.pl>
References: <Pine.LNX.4.61.0501141503220.9908@bizon.gios.gov.pl>
	<20050114143722.GA10088@ti64.telemetry-investments.com>
	<Pine.LNX.4.61.0501141542230.3572@bizon.gios.gov.pl>
	<57991.142.169.215.10.1105716756.squirrel@142.169.215.10>
	<Pine.LNX.4.61.0501141622190.4865@bizon.gios.gov.pl>
	<41E7F2DA.608@info-link.net> <41E7F4B9.4080103@info-link.net>
	<Pine.LNX.4.61.0501201424140.5089@bizon.gios.gov.pl>
	<41EFDDE2.8030901@info-link.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1351239175-1106241495=:1703"
Cc: netfilter-devel@lists.netfilter.org,
	Samuel Jean <sj-netfilter@cookinglinux.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Brad Fisher <brad@info-link.net>
In-Reply-To: <41EFDDE2.8030901@info-link.net>
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

---187430788-1351239175-1106241495=:1703
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 20 Jan 2005, Brad Fisher wrote:

> Krzysztof Oledzki wrote:
>
>>>=20
>>> Sorry for the additional spam :(
>>>=20
>>> The check should be changed to something like the following:
>>>=20
>>> +      if (info->date_start <=3D info->date_stop) {
>>> +              /* normal order: start <=3D stop */
>>> +              if ((skb->stamp.tv_sec < info->date_start) ||=20
>>> (skb->stamp.tv_sec > info->date_stop))
>>> +                        return 0;
>>> +        } else {
>>> +              /* reversed order: stop < start */
>>> +                if ((skb->stamp.tv_sec < info->date_start) &&=20
>>> (skb->stamp.tv_sec > info->date_stop))
>>> +                        return 0;
>>> +        }
>>>=20
>>> Sorry about the previous crap :)  Anyway, this only adds one more if te=
st=20
>>> per packet, which in my opintion is acceptable when the alternative is =
an=20
>>> additional rule.
>>=20
>>=20
>>=20
>> OK.. You need to match 20:00-4:00, right? So why you just cannot reverse=
=20
>> the match of 4:00-20:00?
>>=20
>> Best regards,
>>=20
>>                 Krzysztof Ol=EAdzki
>>=20
> 20:00 - 4:00 is very different from 4:00 - 20:00, one is a range of 8 hou=
rs=20
> (20,21,22,23,0,1,2,3), the other is a range of 16
True...

> (4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19)...  They are complementary to=
=20
> each other in terms of a 24 hour clock.
True..

> To match 20:00 - 4:00 you currently need 2 rules:
> 1) match 20:00 - 23:59
> 2) match 0:00 - 4:00
> What I'm proposing is to allow this to be reduced to one rule.

So, again.. You need something like invert flag in -m like in the -p:

iptables -A something ! -m time --timestart 4:01 --timestop 19:59 -j DoSome=
thing

This one should match 20:00-20:59 and 0:00-4:00, true?

Right now you can use:

iptables -N Match20_4
iptables -A Match20_4 -m time --timestart 4:01 --timestop 19:59 -j RETURN
iptables -A Match20_4 -j DoSomething

This one should match 20:00-20:59 and 0:00-4:00, true?

Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-1351239175-1106241495=:1703--
