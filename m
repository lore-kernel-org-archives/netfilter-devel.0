From: "Samuel Jean" <sj-netfilter@cookinglinux.org>
Subject: Re: ipt_time fixes (resend, sorry)
Date: Thu, 20 Jan 2005 13:33:58 -0500 (EST)
Message-ID: <13851.142.169.215.10.1106246038.squirrel@142.169.215.10>
References: <Pine.LNX.4.61.0501141503220.9908@bizon.gios.gov.pl>
	<20050114143722.GA10088@ti64.telemetry-investments.com>
	<Pine.LNX.4.61.0501141542230.3572@bizon.gios.gov.pl>
	<57991.142.169.215.10.1105716756.squirrel@142.169.215.10>
	<Pine.LNX.4.61.0501141622190.4865@bizon.gios.gov.pl>
	<41E7F2DA.608@info-link.net> <41E7F4B9.4080103@info-link.net>
	<Pine.LNX.4.61.0501201424140.5089@bizon.gios.gov.pl>
	<41EFDDE2.8030901@info-link.net>
	<Pine.LNX.4.61.0501201759360.1703@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Brad Fisher <brad@info-link.net>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0501201759360.1703@bizon.gios.gov.pl>
To: "Krzysztof Oledzki" <olenf@ans.pl>
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

Hi!

On Thu, January 20, 2005 12:18 pm, Krzysztof Oledzki said:

..snip..

> On Thu, 20 Jan 2005, Brad Fisher wrote:
>> To match 20:00 - 4:00 you currently need 2 rules:
>> 1) match 20:00 - 23:59
>> 2) match 0:00 - 4:00
>> What I'm proposing is to allow this to be reduced to one rule.

What Brad proposes makes so much sense, IMHO. I haven't looked at this
code yet (ipt_time) but I thought it already behaves that way. Apperently
not, since you both complain about it.

>
> So, again.. You need something like invert flag in -m like in the -p:
>
> iptables -A something ! -m time --timestart 4:01 --timestop 19:59 -j
> DoSomething
>
> This one should match 20:00-20:59 and 0:00-4:00, true?

I wasn't aware you can negate --match options. Are you sure we can do thi=
s ?

>
> Right now you can use:
>
> iptables -N Match20_4
> iptables -A Match20_4 -m time --timestart 4:01 --timestop 19:59 -j RETU=
RN
> iptables -A Match20_4 -j DoSomething
>
> This one should match 20:00-20:59 and 0:00-4:00, true?

Yes, but rather ugly :) I strongly suggest adding support to it. As Brad
did mention, another 'if' condition produces less latency than superfluou=
s
packet iteration.

>
> Best regards,
>
>  			Krzysztof Ol=EAdzki

Cheers!

Samuel
