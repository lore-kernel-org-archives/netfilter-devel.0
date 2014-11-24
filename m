From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: nft compilation issues
Date: Mon, 24 Nov 2014 10:23:06 +0100
Message-ID: <CAOkSjBgxVbCnw7t_6+19v5MLSSPidZ9dRsXhQomb5LAtK9=GAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:38896 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaKXJX2 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Nov 2014 04:23:28 -0500
Received: by mail-la0-f53.google.com with SMTP id gm9so4142644lab.40
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Nov 2014 01:23:27 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I have some compilation issues in nft.

[...]
  CC       proto.o
  CC       payload.o
In file included from main.c:23:0:
src/parser.y:129:17: error: field =E2=80=98handle=E2=80=99 has incomple=
te type
main.c: In function =E2=80=98nft_netlink=E2=80=99:
main.c:188:2: error: dereferencing pointer to incomplete type
main.c:188:2: error: dereferencing pointer to incomplete type
main.c:206:3: error: dereferencing pointer to incomplete type
main.c:206:3: error: dereferencing pointer to incomplete type
main.c: In function =E2=80=98nft_run=E2=80=99:
main.c:232:23: error: dereferencing pointer to incomplete type
main.c:241:2: error: dereferencing pointer to incomplete type
main.c:241:2: error: dereferencing pointer to incomplete type
main.c: In function =E2=80=98main=E2=80=99:
main.c:251:22: error: storage size of =E2=80=98state=E2=80=99 isn=E2=80=
=99t known
main.c:340:3: warning: implicit declaration of function =E2=80=98parser=
_init=E2=80=99
[-Wimplicit-function-declaration]
main.c:341:3: warning: implicit declaration of function =E2=80=98scanne=
r_init=E2=80=99
[-Wimplicit-function-declaration]
main.c:342:3: warning: implicit declaration of function
=E2=80=98scanner_push_buffer=E2=80=99 [-Wimplicit-function-declaration]
main.c:346:3: warning: implicit declaration of function
=E2=80=98scanner_read_file=E2=80=99 [-Wimplicit-function-declaration]
main.c:363:2: warning: implicit declaration of function
=E2=80=98scanner_destroy=E2=80=99 [-Wimplicit-function-declaration]
main.c:251:22: warning: unused variable =E2=80=98state=E2=80=99 [-Wunus=
ed-variable]
Makefile:430: recipe for target 'main.o' failed

regards
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
