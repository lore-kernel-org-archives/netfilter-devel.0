From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: ipt_time fixes (resend, sorry)
Date: Thu, 20 Jan 2005 14:40:25 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0501201424140.5089@bizon.gios.gov.pl>
References: <Pine.LNX.4.61.0501141503220.9908@bizon.gios.gov.pl>
	<20050114143722.GA10088@ti64.telemetry-investments.com>
	<Pine.LNX.4.61.0501141542230.3572@bizon.gios.gov.pl>
	<57991.142.169.215.10.1105716756.squirrel@142.169.215.10>
	<Pine.LNX.4.61.0501141622190.4865@bizon.gios.gov.pl>
	<41E7F2DA.608@info-link.net> <41E7F4B9.4080103@info-link.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1172203057-1106228425=:5089"
Cc: netfilter-devel@lists.netfilter.org,
	Samuel Jean <sj-netfilter@cookinglinux.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Brad Fisher <brad@info-link.net>
In-Reply-To: <41E7F4B9.4080103@info-link.net>
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

---187430788-1172203057-1106228425=:5089
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 14 Jan 2005, Brad Fisher wrote:

> Brad Fisher wrote:
>
>> Krzysztof Oledzki wrote:
>>=20
>>>=20
>>> -        packet_local_time =3D skb->stamp.tv_sec;
>>> +    /* We might not have a timestamp, get one */
>>> +    if (skb->stamp.tv_sec =3D=3D 0)
>>> +        do_gettimeofday((struct timeval *)&skb->stamp);
>>>=20
>>>      /* First we make sure we are in the date start-stop boundaries */
>>> -    if ((packet_local_time < info->date_start) || (packet_local_time >=
=20
>>> info->date_stop))
>>> +    if ((skb->stamp.tv_sec < info->date_start) || (skb->stamp.tv_sec >=
=20
>>> info->date_stop))
>>>          return 0; /* We are outside the date boundaries */
>>>=20
>> I'd like to see the above like become:
>>=20
>> +    if ((skb->stamp.tv_sec >=3D info->date_start) && (skb->stamp.tv_sec=
 <=3D=20
>> info->date_stop))
>>         return 0; /* We are outside the date boundaries */
>>=20
>> This will have the same logic in most situations, and fix a problem with=
=20
>> the time match where you need 2 rules to match something like all times=
=20
>> between 20:00-04:00 (ie. the start time is "greater" than the end time).=
=20
>> I've used something similar for years and enjoy not needing multiple rul=
es=20
>> for this.  I also have a patch (and I believe I've submitted it in the=
=20
>> past) for grabbing the kernel time if no time is known (and with that=20
>> patch, or what's being discussed here, I believe the time match should w=
ork=20
>> in any chain).
>>=20
>> -Brad Fisher
>>=20
>>=20
>> !DSPAM:41e7f37a167171105578672!
>>=20
>
> Sorry for the additional spam :(
>
> The check should be changed to something like the following:
>
> +      if (info->date_start <=3D info->date_stop) {
> +              /* normal order: start <=3D stop */
> +              if ((skb->stamp.tv_sec < info->date_start) ||=20
> (skb->stamp.tv_sec > info->date_stop))
> +                        return 0;
> +        } else {
> +              /* reversed order: stop < start */
> +                if ((skb->stamp.tv_sec < info->date_start) &&=20
> (skb->stamp.tv_sec > info->date_stop))
> +                        return 0;
> +        }
>
> Sorry about the previous crap :)  Anyway, this only adds one more if test=
 per=20
> packet, which in my opintion is acceptable when the alternative is an=20
> additional rule.


OK.. You need to match 20:00-4:00, right? So why you just cannot reverse=20
the match of 4:00-20:00?

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1172203057-1106228425=:5089--
