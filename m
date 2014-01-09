From: Vytas Dauksa <vytas.dauksa@smoothwall.net>
Subject: Re: [PATCH 1/1] add markmask for hash:ip,mark data type
Date: Thu, 9 Jan 2014 11:09:13 +0000
Message-ID: <CACUMwTnn3HyOT5S431viY0s=qoLasFsuv=i7HMQPPC9is745Kw@mail.gmail.com>
References: <1387288904-26456-1-git-send-email-vytas.dauksa@smoothwall.net>
	<1387288904-26456-2-git-send-email-vytas.dauksa@smoothwall.net>
	<alpine.DEB.2.10.1401082213110.27937@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from exprod7og107.obsmtp.com ([64.18.2.167]:42884 "HELO
	exprod7og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753281AbaAILJQ convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:09:16 -0500
Received: by mail-ee0-f45.google.com with SMTP id d49so1243754eek.32
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Jan 2014 03:09:13 -0800 (PST)
In-Reply-To: <alpine.DEB.2.10.1401082213110.27937@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Why it's important that the kernel should mask the mark value, when t=
he
> user could add the intended value directly? The only case where it's
> required when entries added/deleted by the SET target. It's more natu=
ral
> for me if the markmask value has a meaning and effect for kernel side
> add/del operations only, and ignored for user add/del/test and kernel
> tests. What's your opinion?

The kernel must apply the mask at test time - that's the whole reason
for it. In our use case the desired mask is 0xff000000, because those
bits identify the protocol, and the other bits are for an unrelated pur=
pose.
Because the other bits could be set to anything, without a mask there
might have to be 2^24 entries for the other possible values.

If the kernel applies a mask on test, but values added by the user aren=
't
masked, those entries would never match. It seems clearer to mask them
at add time, so that the user gets sensible errors; for instance, addin=
g two
different values which mask to the same thing will give the same error =
as
adding the same value twice.

Another option we discounted was that each entry could have its own
mask. This didn't make sense because they're not strictly ordered like
netmasks, so multiple entries could be equally applicable, and no hashi=
ng
is possible. If 12000000/ff000000 and 00340000/00ff0000 are in the set,
but one is nomatch, and a packet has mark 12345678, which entry should
take effect?

> A small thing, but I'd prefer if the mark value were printed/saved in=
 hex
> instead of decimal, similarly to iptables. Better introduce a new pri=
nt
> function for it.

Sure, will implement this on Friday

> Best regards,
> Jozsef
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> Address : Wigner Research Centre for Physics, Hungarian Academy of Sc=
iences
>           H-1525 Budapest 114, POB. 49, Hungary



--=20
Vytas Dauksa
Junior Developer
vytas.dauksa@smoothwall.net

Smoothwall Ltd
Phone: +44 (0=AD) 8701 999500
www.smoothwall.net
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
