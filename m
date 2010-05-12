From: Zerouali Mehdi <mehdi.zerouali@insa-lyon.fr>
Subject: Problem compiling libipq example
Date: Wed, 12 May 2010 23:16:30 +0200
Message-ID: <79f8595aaa42b469ae2e273b8a1a27f2@mail.insa-lyon.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Netfilter Mailing list <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from criges14.insa-lyon.fr ([134.214.76.242]:49838 "EHLO
	smtp.insa-lyon.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757927Ab0ELVcw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 May 2010 17:32:52 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp.insa-lyon.fr (Postfix) with ESMTP id CBF61F1358
	for <netfilter-devel@vger.kernel.org>; Wed, 12 May 2010 23:16:30 +0200 (CEST)
Received: from smtp.insa-lyon.fr ([127.0.0.1])
	by localhost (criges14.insa-lyon.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wWQmOobGItZ8 for <netfilter-devel@vger.kernel.org>;
	Wed, 12 May 2010 23:16:30 +0200 (CEST)
Received: from webmail3.insa-lyon.fr (webmail3.insa-lyon.fr [134.214.77.245])
	by smtp.insa-lyon.fr (Postfix) with ESMTP id 7554DF1337
	for <netfilter-devel@vger.kernel.org>; Wed, 12 May 2010 23:16:30 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello all,

I am using this mailing list as the last chance to get a solution to my
problem. I hope my simple question is not going to bother you too much.

I am trying to compile and run the simpliest program that uses libipq, =
the
man example program.

When I try to compile it, I get the following error code:

In file included from example.c:2:
/usr/include/linux/netfilter.h:55: error: field =E2=80=98in=E2=80=99 ha=
s incomplete type
/usr/include/linux/netfilter.h:56: error: field =E2=80=98in6=E2=80=99ha=
s incomplete type

It looks like there is a problem with the netfilter header, that is not
able to load the in.h and in6.h librairies.

I installed all the necessary tools:
iptables 1.4.7
libnetfilter_queue 0.0.17 (the actual successor of ip_queue)
libnfnetlink 1.0.0

I am using Ubuntu 9.10, with the 2.6.31-14 kernel.

I of course searched for any solutions, and found that this problem has
been encountered in the past. However, I didn't get any relevant
information. Thanks in advance for your precious advices.

Cheers,

--=20
Mehdi Zerouali
INSA Lyon Student
KTH Stockholm Student
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
