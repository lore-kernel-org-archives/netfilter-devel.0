From: Brad Fisher <brad@info-link.net>
Subject: Re: ipt_time fixes (resend, sorry)
Date: Thu, 20 Jan 2005 12:45:51 -0600
Message-ID: <41EFFC5F.1050207@info-link.net>
References: <Pine.LNX.4.61.0501141503220.9908@bizon.gios.gov.pl>
	<20050114143722.GA10088@ti64.telemetry-investments.com>
	<Pine.LNX.4.61.0501141542230.3572@bizon.gios.gov.pl>
	<57991.142.169.215.10.1105716756.squirrel@142.169.215.10>
	<Pine.LNX.4.61.0501141622190.4865@bizon.gios.gov.pl>
	<41E7F2DA.608@info-link.net> <41E7F4B9.4080103@info-link.net>
	<Pine.LNX.4.61.0501201424140.5089@bizon.gios.gov.pl>
	<41EFDDE2.8030901@info-link.net>
	<Pine.LNX.4.61.0501201759360.1703@bizon.gios.gov.pl>
	<13851.142.169.215.10.1106246038.squirrel@142.169.215.10>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Samuel Jean <sj-netfilter@cookinglinux.org>
In-Reply-To: <13851.142.169.215.10.1106246038.squirrel@142.169.215.10>
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

Samuel Jean wrote:

>Hi!
>
>On Thu, January 20, 2005 12:18 pm, Krzysztof Oledzki said:
>
>..snip..
>
> =20
>
>>On Thu, 20 Jan 2005, Brad Fisher wrote:
>>   =20
>>
>>>To match 20:00 - 4:00 you currently need 2 rules:
>>>1) match 20:00 - 23:59
>>>2) match 0:00 - 4:00
>>>What I'm proposing is to allow this to be reduced to one rule.
>>>     =20
>>>
>
>What Brad proposes makes so much sense, IMHO. I haven't looked at this
>code yet (ipt_time) but I thought it already behaves that way. Apperentl=
y
>not, since you both complain about it.
>
> =20
>
>>So, again.. You need something like invert flag in -m like in the -p:
>>
>>iptables -A something ! -m time --timestart 4:01 --timestop 19:59 -j
>>DoSomething
>>
>>This one should match 20:00-20:59 and 0:00-4:00, true?
>>   =20
>>
>
>I wasn't aware you can negate --match options. Are you sure we can do th=
is ?
>
> =20
>

I haven't found any generic capability to negate matches.  I could see=20
this being possibly useful, and could reduce the need for every=20
individual match to implement some sort of negation internally.  Of=20
course, it may not make sense to be able to negate some types of matches=20
(no examples come to mind though).

>>Right now you can use:
>>
>>iptables -N Match20_4
>>iptables -A Match20_4 -m time --timestart 4:01 --timestop 19:59 -j RETU=
RN
>>iptables -A Match20_4 -j DoSomething
>>
>>This one should match 20:00-20:59 and 0:00-4:00, true?
>>   =20
>>
>
>Yes, but rather ugly :) I strongly suggest adding support to it. As Brad
>did mention, another 'if' condition produces less latency than superfluo=
us
>packet iteration.
> =20
>
It also makes the ruleset more complex by adding a custom chain and two=20
rules where I'd like to only have one rule.  Your example may work fine=20
and not add much complexity when multiple rules may jump to the new=20
chain, but if you need to match multiple time ranges this way, it could=20
really bulk up your ruleset for no real reason.  It'd just be nice if=20
the time match handled this in a way that doesn't require such=20
workarounds in the first place.

>>Best regards,
>>
>> 			Krzysztof Ol=EAdzki
>>   =20
>>
>
>Cheers!
>
>Samuel
> =20
>
-Brad
