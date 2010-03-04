From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: how to use regex inside new netfilter extension modules?
Date: Thu, 4 Mar 2010 09:33:04 +0800
Message-ID: <412e6f7f1003031733n68bfa158v1b590a41c2ffa3d2@mail.gmail.com>
References: <63409.152.14.240.190.1267641716.squirrel@webmail.ncsu.edu>
	<alpine.LSU.2.01.1003031954001.25372@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Balaji Venkatamohan <bvenkat@ncsu.edu>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43928 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993Ab0CDBdZ convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Mar 2010 20:33:25 -0500
Received: by gyd8 with SMTP id 8so107358gyd.19
        for <netfilter-devel@vger.kernel.org>; Wed, 03 Mar 2010 17:33:24 -0800 (PST)
In-Reply-To: <alpine.LSU.2.01.1003031954001.25372@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 4, 2010 at 2:56 AM, Jan Engelhardt <jengelh@medozas.de> wro=
te:
> On Wednesday 2010-03-03 19:41, Balaji Venkatamohan wrote:
>>
>>I need to use regular expressions inside the point of decision match
>>function. I could not use 'regex.h ' or any other standard C library
>>inside any of xt_*.c or xt_c*.h files. I could also see that none of =
the
>>netfilter match extensions have them. I would also like to know why i=
s it
>>so?

Please refer to the source code of l7filter. http://l7-filter.sourcefor=
ge.net/

>
> Regular expressions are not the cheapest, both time and memory-wise:
> you have to keep in mind NF runs in irq context. Furthermore, since
> you only see single packets rather than the connection stream, regexe=
s
> prove to be far less useful.

REs are useful and cheapest in some conditions.

--=20
Regards=EF=BC=8C
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
