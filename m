From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH] pgsql: add SSL connection implementation to PGSQL plugin
Date: Sat, 10 Nov 2012 23:17:31 +0000
Message-ID: <509EE08B.80805@googlemail.com>
References: <1346503911-3781-1-git-send-email-mr.dash.four@googlemail.com>		 <20120902233228.GA22069@1984> <50440A1B.7060908@googlemail.com>	 <1346653997.5194.37.camel@tiger.regit.org> <50449BF1.40005@googlemail.com> <1352277668.3652.43.camel@tourtet>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Netfilter Core Team <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35394 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab2KJXRg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 10 Nov 2012 18:17:36 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr13so3358350wgb.1
        for <netfilter-devel@vger.kernel.org>; Sat, 10 Nov 2012 15:17:35 -0800 (PST)
In-Reply-To: <1352277668.3652.43.camel@tourtet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Hello,
>=20
> Le lundi 03 septembre 2012 =C3=A0 13:00 +0100, Mr Dash Four a =C3=A9c=
rit :
>>>> Sure. Are there any (other) objections to the patch I submitted?
>>>>    =20
>>> I've applied the current patch to give it a run. And it shows a lot=
 of
>>> whitespace errors. You'll need to fix it too.
>>>  =20
>> What do you mean by that?
>=20
> There's a lot of spaces at end of lines or empty lines containing onl=
y
> spaces. Basically, s/ +$// to fix it.
I see. The patch I submitted over 2 months ago was based on the (then) =
newest git tree. From that tree, the 2 files I modified were output/pgs=
ql/ulogd_output_PGSQL.c and ulogd.conf.in.

By looking at my patch, it is quite evident that the white space "error=
s", as you call them, originate mostly from the existing source in that=
 git tree. In cases where I have introduced new "errors", these were ca=
used by cut-and-paste from the original source after applying the modif=
ications I needed done for the patch to fulfil its purpose.

Even today, the present version of ulogd_output_PGSQL.c and ulogd.conf.=
in in the current ulogd2 git tree has "a lot of whitespace errors" in t=
hem, even without my patch being applied.=20

A simple search for such "errors" in output/pgsql/ulogd_output_PGSQL.c =
alone produces 15 matches.=20

I suspect if I run similar searches on the entire ulogd2 tree (or any o=
ther tree within netfilter.org for that matter), the results won't be a=
ny different. Since you and Pablo are the maintainers of that tree, I a=
m assuming that these "errors" were good enough for you when you patche=
d these files in the past.=20

Why is that? What's changed?=20

Am I supposed to run a clean sweep of the entire existing git tree befo=
re submitting any patches, so that they meet with your and Pablo's appr=
oval then? I won't even go into the 2 months it took for the above resp=
onse to finally arrive.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
