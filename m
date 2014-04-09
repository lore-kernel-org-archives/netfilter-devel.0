From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftnl PATCH 1/3] ruleset: Add an end of line in the exit of ruleset.
Date: Wed, 9 Apr 2014 12:11:42 +0200
Message-ID: <CAOkSjBjOTWW2cS012J73-UcqYbUyAJ31aXA==K4BsTYkTXffmA@mail.gmail.com>
References: <cover.1397032579.git.anarey@gmail.com> <15bbda6958ec01d0088c386537288dcfe1ad8731.1397032579.git.anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:50002 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758178AbaDIKME convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2014 06:12:04 -0400
Received: by mail-la0-f43.google.com with SMTP id e16so955789lan.2
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Apr 2014 03:12:02 -0700 (PDT)
In-Reply-To: <15bbda6958ec01d0088c386537288dcfe1ad8731.1397032579.git.anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 9 April 2014 10:53, Ana Rey <anarey@gmail.com> wrote:
> Add an end of line in the exit of ruleset.
>
> Signed-off-by: Ana Rey <anarey@gmail.com>

Hi Ana,

Why do you need this here?

The policy was to don't add any format stuff (tabs, newlines..) to
XML|JSON formats and let the caller add the trailing \n if needed..

However, I see several inconsistencies already in the code:
src/rule.c: ret =3D snprintf(buf+offset, len, "\n");
src/rule.c: ret =3D snprintf(buf+offset, len, "]\n");
src/rule.c: ret =3D snprintf(buf+offset, len, " }\n");
src/set.c: ret =3D snprintf(buf+offset, len, "\n");

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
