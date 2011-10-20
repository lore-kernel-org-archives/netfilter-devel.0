From: =?ISO-8859-1?Q?Jorge_D=E1vila?= <jorgedavilalopez@gmail.com>
Subject: Re: add new tcp option
Date: Thu, 20 Oct 2011 09:42:09 -0600
Message-ID: <CAG61UF-P+k3NsHLteLXp-QK32Fr8RHrzyD5rbWApr=7cgR2F6w@mail.gmail.com>
References: <4EA03EB9.70204@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43908 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab1JTPmK convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Oct 2011 11:42:10 -0400
Received: by ywf7 with SMTP id 7so2932695ywf.19
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Oct 2011 08:42:10 -0700 (PDT)
In-Reply-To: <4EA03EB9.70204@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Which is the main reason to add 4 bytes to tcp header via netfilter?

Jorge D=E1vila.

2011/10/20 hoangtam <tamnghoang@gmail.com>:
> Hi all,
> I have done with netfilter to add 4 bytes to tcp header option. I use
> wireshark to check its working, and the result is : for the packets w=
ithout
> data payload I can see 4 bytes in packet correctly; but for the packe=
ts with
> data payload 4 bytes changing. I'm sure that other fields of packet (=
tcp
> header, ip header) is ok. Any suggestion is appreciated.?
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Jorge Isaac D=E1vila L=F3pez
+505 8430 5462
jorgedavilalopez@gmail.com
---
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
