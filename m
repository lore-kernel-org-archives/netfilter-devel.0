From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: parser regression: '/' symbol
Date: Tue, 12 Jan 2016 12:09:49 +0100
Message-ID: <CAOkSjBjytRTvdri+g-EGutvrFWsNuRAK5qgffWDVpm-3-X34mA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:37474 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759723AbcALLKK convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Jan 2016 06:10:10 -0500
Received: by mail-wm0-f45.google.com with SMTP id f206so314139006wmf.0
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Jan 2016 03:10:09 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I've detected a regression using defines in a file:

define network =3D 1.1.1.1/24

and then loading it with `nft -f'.

The error is:
'Error: syntax error, unexpected /, expecting newline or semicolon'

=46lorian suspects of commit 2a5d44d8b3c88018165d736c9582cebbf40e6362
(parser: get rid of multiton_expr from lhs relational expression).

regards.
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
