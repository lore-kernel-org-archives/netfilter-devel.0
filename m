From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: ipt_time fixes (resend, sorry)
Date: Tue, 15 Feb 2005 16:58:39 +0100 (CET)
Message-ID: <Pine.LNX.4.62.0502151647350.16076@bizon.gios.gov.pl>
References: <Pine.LNX.4.61.0501141503220.9908@bizon.gios.gov.pl>
	<200502030010.47260.fabrice.marie@fma-rms.com>
	<Pine.LNX.4.62.0502150219100.17929@bizon.gios.gov.pl>
	<200502152323.11942.fabrice@netfilter.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-77928170-1108483119=:16076"
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
To: Fabrice MARIE <fabrice@netfilter.org>
In-Reply-To: <200502152323.11942.fabrice@netfilter.org>
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

---187430788-77928170-1108483119=:16076
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 15 Feb 2005, Fabrice MARIE wrote:

>
> Hello,
>
> On Tuesday 15 February 2005 09:20, Krzysztof Oledzki wrote:
>> Any progress? ;-)
>
> Yep. Sorry for the delay. The patch looks alright although I didn't test =
it.
;-)

> As for the rest of the thread, right now like Brad mentioned, you need
> 2 rules to match the time period:
>> To match 20:00 - 4:00 you currently need 2 rules:
>>  1) match 20:00 - 23:59
>>  2) match 0:00 - 4:00
>> What I'm proposing is to allow this to be reduced to one rule.
>
> The cleanest way to solve that in my opinion is to implement
> the negative form of time match, in other words, to allow the usage
> of the negative option (!) in the time match which is right now not allow=
ed.
True. Talking about negation of -m (match). Excuse me for my question,=20
maybe this is obvious, but.. why we don't have a negation for -m=20
(match) like for -p (protocol)?

> It shouldn't be very straight forward. On the other hand, this will requi=
re an additional
> variable in the time structure passed from userspace to kernelspace,
> and this would break binary compatibility with previously built iptables =
userpace
> programs.
Oh. With my patch we have free "u_int8_t  kerneltime" ;-) So no problem,=20
we can easy store additional flag(s).

> But if you ask me, patches on extensions like ipt_time shouldn't bother
> too much about backward compatibility headaches, since they are not shipp=
ed
> in the kernel by default (and I guess never will). Backward compatibility=
 for
> standard-kernel-modules is important though.
True, true ;)

Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-77928170-1108483119=:16076--
