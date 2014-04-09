From: Ana Rey <anarey@gmail.com>
Subject: Re: [libnftnl PATCH 1/3] ruleset: Add an end of line in the exit of ruleset.
Date: Wed, 9 Apr 2014 16:56:27 +0200
Message-ID: <CAD7o0sikoYmw0G=Jkr7vaJS73bjB0kYqiRLZ+SSTLD6Kw26fnA@mail.gmail.com>
References: <cover.1397032579.git.anarey@gmail.com> <15bbda6958ec01d0088c386537288dcfe1ad8731.1397032579.git.anarey@gmail.com>
 <CAOkSjBjOTWW2cS012J73-UcqYbUyAJ31aXA==K4BsTYkTXffmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ve0-f170.google.com ([209.85.128.170]:57509 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932826AbaDIO4s convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2014 10:56:48 -0400
Received: by mail-ve0-f170.google.com with SMTP id pa12so2206018veb.15
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Apr 2014 07:56:47 -0700 (PDT)
In-Reply-To: <CAOkSjBjOTWW2cS012J73-UcqYbUyAJ31aXA==K4BsTYkTXffmA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2014-04-09 12:11 GMT+02:00 Arturo Borrero Gonzalez
<arturo.borrero.glez@gmail.com>:
> On 9 April 2014 10:53, Ana Rey <anarey@gmail.com> wrote:
>> Add an end of line in the exit of ruleset.
>>
>> Signed-off-by: Ana Rey <anarey@gmail.com>
>
> Hi Ana,
>
> Why do you need this here?
>
> The policy was to don't add any format stuff (tabs, newlines..) to
> XML|JSON formats and let the caller add the trailing \n if needed..

Thank you for this advise. I'll remember it the next time.

I solved this problem in the tests/nft-parsing-test.c

(I'll send a new version of "[libnftnl PATCH 2/3] tests: New tools to
uptade xml and json testfiles." patch and I deleted it of tihs
patchset)

Thank you!

>
> However, I see several inconsistencies already in the code:
> src/rule.c: ret =3D snprintf(buf+offset, len, "\n");
> src/rule.c: ret =3D snprintf(buf+offset, len, "]\n");
> src/rule.c: ret =3D snprintf(buf+offset, len, " }\n");
> src/set.c: ret =3D snprintf(buf+offset, len, "\n");
>
> --
> Arturo Borrero Gonz=E1lez



--=20
Ana Rey (@anaRB)
http://about.me/anarey
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
