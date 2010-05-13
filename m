From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Problem compiling libipq example
Date: Thu, 13 May 2010 09:58:02 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1005130957260.6609@obet.zrqbmnf.qr>
References: <79f8595aaa42b469ae2e273b8a1a27f2@mail.insa-lyon.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Mailing list <netfilter-devel@vger.kernel.org>
To: Zerouali Mehdi <mehdi.zerouali@insa-lyon.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:53085 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758324Ab0EMH6E (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 May 2010 03:58:04 -0400
In-Reply-To: <79f8595aaa42b469ae2e273b8a1a27f2@mail.insa-lyon.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2010-05-12 23:16, Zerouali Mehdi wrote:
>
>I am using this mailing list as the last chance to get a solution to m=
y
>problem. I hope my simple question is not going to bother you too much=
=2E
>
>I am trying to compile and run the simpliest program that uses libipq,=
 the
>man example program.
>
>When I try to compile it, I get the following error code:
>
>In file included from example.c:2:
>/usr/include/linux/netfilter.h:55: error: field =E2=80=98in=E2=80=99 h=
as incomplete type
>/usr/include/linux/netfilter.h:56: error: field =E2=80=98in6=E2=80=99h=
as incomplete type
>
>It looks like there is a problem with the netfilter header, that is no=
t
>able to load the in.h and in6.h librairies.

in and in6 are not libraries, they are struct members, and you
need #include <netinet/in.h> to get at their definition beforehand.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
