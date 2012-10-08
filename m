From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: static build breakage - 1.4.16.2.
Date: Mon, 8 Oct 2012 14:04:55 -0700
Message-ID: <CAHo-Ooy1C9kV2NT=R8vTnaDccHnenkC1Scm+W0NrjgN1iUsvsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:41564 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976Ab2JHVE4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Oct 2012 17:04:56 -0400
Received: by mail-vc0-f174.google.com with SMTP id fo13so5220648vcb.19
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Oct 2012 14:04:55 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Not entirely clear what's breaking, but:

./configure --enable-static --disable-shared --enable-ipv4 --enable-ipv6

make[3]: *** No rule to make target `libxt_NOTRACK.o', needed by
`libext.a'.  Stop.
