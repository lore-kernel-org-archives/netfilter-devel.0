From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 7/9] netfilter: xtables: slightly better error reporting
 (2/2)
Date: Tue, 23 Mar 2010 16:00:09 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003231545390.21464@obet.zrqbmnf.qr>
References: <1269285486-22653-1-git-send-email-jengelh@medozas.de> <1269285486-22653-8-git-send-email-jengelh@medozas.de> <4BA8D3D1.7000409@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49506 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754352Ab0CWPAK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Mar 2010 11:00:10 -0400
In-Reply-To: <4BA8D3D1.7000409@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2010-03-23 15:44, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_L=
OG.c
>> index c9ee5c4..33213d6 100644
>> --- a/net/ipv4/netfilter/ipt_LOG.c
>> +++ b/net/ipv4/netfilter/ipt_LOG.c
>> @@ -445,7 +445,7 @@ static int log_tg_check(const struct xt_tgchk_pa=
ram *par)
>> =20
>>  	if (loginfo->level >=3D 8) {
>>  		pr_debug("level %u >=3D 8\n", loginfo->level);
>> -		return false;
>> +		return -EDOM;
>>  =20
>
>Mhh is that really a "Math argument out of domain of func"? ERANGE see=
ms
>slightly
>better fitting to me.

I had to look up the difference too, but it's pretty obvious
(to me at least).

EDOM is for when a function is not defined at a point, such as log(0)
or divide(1.0, 0.0). Of course you could say "that's =C2=B1Inf", but th=
at
infinity argument I'll leave to academia.

However, "2^63 * 4" for example is well-defined in maths, but
computers are the limiting factor, hence ERANGE is appropriate in
this case.


>>  {
>> +	int ret;
>> +
>>  	if (XT_ALIGN(par->match->matchsize) !=3D size &&
>>  	    par->match->matchsize !=3D -1) {
>>  		/*
>> @@ -399,8 +401,13 @@ int xt_check_match(struct xt_mtchk_param *par,
>>  		       par->match->proto);
>>  		return -EINVAL;
>>  	}
>> -	if (par->match->checkentry !=3D NULL && !par->match->checkentry(pa=
r))
>> -		return -EINVAL;
>> +	if (par->match->checkentry !=3D NULL) {
>> +		ret =3D par->match->checkentry(par);
>> +		if (ret < 0)
>> +			return ret;
>> +		else if (ret =3D=3D 0)
>> +			return -EINVAL;
>
>I'd suggest to do the true/false conversion before this patch. Current=
ly I
>don't understand the split of these patches, this one keeps lots of bo=
olean
>return values and initializations, but changes some.

I did this so that the two main changes,

 A1. replacing 'return false' by "detailed" code
 (EDOM, etc.)

 A2. replacing all remaining bools that did not get a detailed_code
 by EINVAL.

It is also possible to change the order, as in

 B1. change everything to EINVAL first

 B2. then change EINVAL -> detailed_code.

Should I switch?

>>  	case SECMARK_MODE_SEL:
>> -		if (!checkentry_selinux(info))
>> -			return false;
>> +		err =3D checkentry_selinux(info);
>> +		if (err <=3D 0)
>>  =20
><=3D ?

This is all cleared up by the A2 commit.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
