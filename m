From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: [PATCH v2] extensions: libxt_mark: Add translation to nft
Date: Sat, 19 Dec 2015 19:56:56 +0530
Message-ID: <CAKHNQQGcET7S+RJENLs+p5zwCe4Xd8FdmJTCT5E-16zjD_PNqw@mail.gmail.com>
References: <20151206033214.GA5939@gmail.com> <20151209132600.GA29450@salvia>
 <CAKHNQQF3XFhMJaoi8gBLOeGTLJjxncPQ-s9Tke3nC0FNoGVJjg@mail.gmail.com>
 <CAKHNQQEtTZ0Hg57VcgrOTaFZww-3T8nc8+P1WFq5Ms4Ap2qmbg@mail.gmail.com>
 <CAKHNQQGSbN8QQru8PB9GntbGGBKLT7v3VRYnjhEObshs7qKPcg@mail.gmail.com> <20151218214013.GA26438@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:35206 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbbLSO1R convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Dec 2015 09:27:17 -0500
Received: by mail-wm0-f43.google.com with SMTP id l126so18719046wml.0
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Dec 2015 06:27:16 -0800 (PST)
In-Reply-To: <20151218214013.GA26438@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Dec 19, 2015 at 3:10 AM, Pablo Neira Ayuso <pablo@netfilter.org=
> wrote:
> On Fri, Dec 18, 2015 at 09:39:49AM +0530, Shivani Bhardwaj wrote:
>> Hi,
>>
>> So far, I've been able to figure out that the problem is arising
>> because of wrong return value by the function xlate of
>> xtables-translate. This return value is further dependent on a
>> function cb() which I am not able to understand. Could you please he=
lp
>> me with this?
>
> I'm getting this here:
>
> libxt_mark.c:116:1: warning: =E2=80=98mark_mt_xlate_print=E2=80=99 de=
fined but not
> used [-Wunused-function]
>  mark_mt_xlate_print(const struct xt_entry_match *match,
>  ^
> libxt_mark.c:140:1: warning: =E2=80=98mark_xlate_print=E2=80=99 defin=
ed but not used
> [-Wunused-function]
>  mark_xlate_print(const struct xt_entry_match *match,
>  ^
>
> These two functions are unused, so there is some problem there.
>
> But, anyway after applying you patch I can see:
>
> # iptables-translate -I INPUT -m mark --mark 10
> nft insert rule ip filter INPUT ct mark  & xa counter
>
> So this kind of work already.
>

Hi,

I just tried adding this rule to nft. It does not work. It only works
for integer values of mark. nft shows syntax error for ampersand and
hex values.
Isn't there something wrong? Please let me know.

Thank you

> Be careful about shared libraries for extensions (here I have them at
> /usr/lib/xtables/*.so or maybe you have it at /usr/local/lib/xtables)
>
> The thing is that probably you have an older iptables installation, s=
o
> you iptables-translate binary refers to the old .so file which has no
> translation.
>
> So make sure you don't have several .so in your setup, probably that'=
s
> the problem.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
